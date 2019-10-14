import 'package:ebay_browse_app/item_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:xml/xml.dart' as xml;
import 'main.dart';



import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyAppAttempt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'eBay Browse App',
      theme: new ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: new MyHomePage(title: 'eBay Browse'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  // todo: what is "key"??
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SearchItem> _items = new List();

  final subject = new PublishSubject<String>();

  bool _isLoading = false;

  String url = "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-PRD-292e4f543-1891531a&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=";
//  String url = "https://svcs.sandbox.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-SBX-592e4f49b-0de7be50&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=";

  void _textChanged(String text) {
    if(text.isEmpty) {
      setState((){_isLoading = false;});
      _clearList();
      return;
    }

    setState((){_isLoading = true;});
    _clearList();

    getSearchResults(text);
  }

  Future<http.Response> getSearchResults(String endingUrlText) async {
    var response = await http.get(
      Uri.encodeFull(url + reformatText(endingUrlText)),
      headers: {
        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-PRD-292e4f543-1891531a",
//        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-SBX-592e4f49b-0de7be50",
        "X-EBAY-SOA-OPERATION-NAME": "findItemsByKeywords",
      },
    );

    if (response.statusCode == 200) {
      // parse through xml
      var document = xml.parse(response.body);

      // gather search-results from the current page
      var results = document.findAllElements('item');
      var data = results.toList(); // transform Iterable to a List



//      print(data[0].runtimeType);
//      print(document.toXmlString(pretty: true, indent: '\t'));
//      print(response.body);



      print(document.findAllElements('paginationOutput'));

      for (var i = 0; i < data.length; i++) {
//        print("hi");
        _addSearchItem(data[i]);
      }
    } else {
      print('error occurred');
      _onError();
    }

    setState(() {
      _isLoading = false;
    });



//    print(_items.length);
//    print(_items[0]);
  }

  String reformatText(String text) {
    if (text.contains(" ")) {
      text = text.split(" ").join("%20");
    }
//    print('textttt ' + text);
    return text;
  }

  void _onError() {
    setState(() {
      _isLoading = false;
    });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }

  // REFERENCE:
  // <https://stackoverflow.com/questions/57186404/how-to-get-substring-between-two-strings-in-dart>
  String _getNestedTagContent(String text, String startTag, String endTag) {
    final startIndex = text.indexOf(startTag);
    final endIndex = text.indexOf(endTag, startIndex + startTag.length);

//    print('start idx: ' + startIndex.toString());
//    print('end idx: ' + endIndex.toString());

    // in the case that we don't find the particular tag in the item's XML description
    if (startIndex == -1 || endIndex == -1) {
      return '';
    }

    return text.substring(startIndex + startTag.length, endIndex);
  }

  void _addSearchItem(xml.XmlElement item) {

    // extract nested-tag for "currentPrice"
    var sellingStatusText = item.findElements("sellingStatus").toString();
    var currentPrice = _getNestedTagContent(
        sellingStatusText,
        '\<currentPrice currencyId=\"USD\"\>',
        '\<\/currentPrice\>'
    );

    // extract nested-tag for "categoryName"
    var primaryCategoryText = item.findElements("primaryCategory").toString();
    var categoryName = _getNestedTagContent(
        primaryCategoryText,
        '\<categoryName\>',
        '\<\/categoryName\>'
    );

    // extract nested-tag for "shippingServiceCost"
    var shippingInfoText = item.findElements("shippingInfo").toString();
    var shippingServiceCost = _getNestedTagContent(
        shippingInfoText,
        '\<shippingServiceCost currencyId=\"USD\"\>',
        '\<\/shippingServiceCost\>'
    );

    // extract nested-tag for "shippingType"
    var shippingType = _getNestedTagContent(
        shippingInfoText,
        '\<shippingType\>',
        '\<\/shippingType\>'
    );

    // extract nested-tag for "shippingToLocations"
    var shippingToLocations = _getNestedTagContent(
        shippingInfoText,
        '\<shipToLocations\>',
        '\<\/shipToLocations\>'
    );

    setState(() {
      _items.add(new SearchItem(
          removeAllXmlTags(item.findElements("title").toString()),
          removeAllXmlTags(item.findElements("subtitle").toString()),
          removeAllXmlTags(item.findElements("galleryURL").toString()),
          removeAllXmlTags(item.findElements("location").toString()),
          currentPrice + ' USD',
          removeAllXmlTags(item.findElements("itemId").toString()),
          removeAllXmlTags(item.findElements("productId").toString()),
          categoryName,
          shippingServiceCost,
          shippingType,
          shippingToLocations,
          removeAllXmlTags(item.findElements("paymentMethod").toString()),
      ));

//      print('payment methods: ' + removeAllXmlTags(item.findElements("paymentMethod").toString()));

//      print(item.findElements("sellingStatus").toList());

    });
  }

  /*
   * https://stackoverflow.com/questions/51593790/remove-html-tags-from-a-string-in-dart
   */
  String removeAllXmlTags(String xmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    // remove outside parentheses
    xmlText = xmlText.substring(1, xmlText.length - 1);

    return xmlText.replaceAll(exp, '');
  }


  @override
  void initState() {
    super.initState();
    subject.stream.debounceTime(new Duration(milliseconds: 600)).listen(_textChanged);
  }

  /*
   * REFERENCE:
   * https://proandroiddev.com/flutter-how-i-built-a-simple-app-in-under-an-hour-from-scratch-and-how-you-can-do-it-too-6d8e7fe6c91b
   * https://github.com/Norbert515/BookSearch/tree/master
   */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(
                hintText: 'Search for an item',
              ),
              onChanged: (string) => (subject.add(string)),
            ),
            _isLoading? new CircularProgressIndicator(): new Container(),
            new Expanded(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItemDescriptionScreen(_items[index]))
                      );
                    },
                    child: new Card(
                      child: new Padding(
                          padding: new EdgeInsets.all(8.0),
                          child: new Row(
                            children: <Widget>[
                              _items[index].imageUrl != null? new Image.network(_items[index].imageUrl): new Container(),
                              new Flexible(
                                child: new Text(/* index.toString() + */ _items[index].title, maxLines: 10),
                              ),
                            ],
                          )
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchItem {
  String title,
      subtitle,
      imageUrl,
      location,
      price,
      itemId,
      productId,
      categoryName,
      shippingServiceCost,
      shippingType,
      shippingToLocations,
      paymentMethods
  ;

  SearchItem(String title,
      String subtitle,
      String imageUrl,
      String location,
      String price,
      String itemId,
      String productId,
      String categoryName,
      String shippingServiceCost,
      String shippingType,
      String shippingToLocations,
      String paymentMethods) {
    this.title = title;
    this.subtitle = subtitle;
    this.imageUrl = imageUrl;
    this.location = location;
    this.price = price;
    this.itemId = itemId;
    this.productId = productId;
    this.categoryName = categoryName;
    this.shippingServiceCost = shippingServiceCost;
    this.shippingType = shippingType;
    this.shippingToLocations = shippingToLocations;
    this.paymentMethods = paymentMethods;
  }
}

/*
 * REFERENCE for creating an infinite-list of search items (with caching)
 * <https://proandroiddev.com/flutter-lazy-loading-data-from-network-with-caching-b7486de57f11>
 */
class SearchItems {
  final List<SearchItem> searchItems;
  final int totalSearchItems;
  final int pageNumber;
  final int pageSize;

  SearchItems({this.searchItems, this.totalSearchItems, this.pageNumber, this.pageSize});
}

abstract class Repository {
  Future<SearchItem> getSearchItem(int index);
}

abstract class Cache<T> {
  Future<T> get(int index);
  put(int index, T object);
}

//class CachingRepsoitory extends Repository {
//  final int pageSize;
//  final Cache<SearchItem> cache;
//  final
//}