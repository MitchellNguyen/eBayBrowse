import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:xml/xml.dart' as xml;
import 'main.dart';

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

// 1. picture
// 2. title
// 3. price
// 4. username of person who posted item
// 5. location
// .....
// 5. further (extra) description about item

class SecondScreen extends StatelessWidget {
  SecondScreen(this.item);

  final SearchItem item;

  @override
  Widget build(BuildContext context) {
    double textWidth = MediaQuery.of(context).size.width*0.8;

//    print('price ' + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Container(
            height: 250,
            child: FittedBox(
              child: Center(child: Image.network(item.imageUrl)),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 2: title
//            height: 50,
            width: textWidth,
            child: Center(child: Text(
                item.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                ),
            )),
          ),
          Container(
            height: item.subtitle != '' ? 20 : 0, //spacing
          ),
          Container(  // ITEM 3: SUBTITLE
            width: textWidth,
            child: Text(
              item.subtitle,
              style: TextStyle(fontSize: item.subtitle != '' ? 20 : 0),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 4: CATEGORY-NAME
            width: textWidth,
            child: Text(
              'Category: ' + item.categoryName,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 5: price
            width: textWidth,
            child: Text(
              item.price != '' ? ('Price:  \$' + item.price): ('Price:  (Price not listed)'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 5: Payment methods
            width: textWidth,
            child: Text(
              item.paymentMethods != '' ? ('Payment Methods:  ' + item.paymentMethods): ('Payment Methods:  (Payment Methods not listed)'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 4: itemId
            width: textWidth,
            child: Text(
              item.itemId != '' ? ('Item ID: ' + item.itemId): ('Item ID:  (Item ID not listed)'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 5: productId
            width: textWidth,
            child: Text(
              item.productId != '' ? ('Product ID: ' + item.productId): ('Product ID:  (Product ID not listed)'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 6: location
            width: textWidth,
            child: Text(
              item.location != null ? ('Location:  ' + item.location): ('Location:  (Location not listed).'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 5: Shipping Service Cost
            width: textWidth,
            child: Text(
              item.shippingServiceCost != '' ? ('Shipping Service Cost: ' + item.shippingServiceCost): ('Shipping Service Cost:  (Shipping Service Cost not listed)'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 5: Shipping Type
            width: textWidth,
            child: Text(
              item.shippingType != '' ? ('Shipping Type: ' + item.shippingType): ('Shipping Type:  (Shipping Type not listed)'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 20, //spacing
          ),
          Container(  // ITEM 5: shipping to locations
            width: textWidth,
            child: Text(
              item.shippingToLocations != '' ? ('Available Shipping Locations: ' + item.shippingToLocations): ('Available Shipping Locations:  (Available Shipping Locations not listed)'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ]
      ),
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

  Future<http.Response> getSearchResults(String text) async {
    var response = await http.get(
      Uri.encodeFull(url + reformatText(text)),
      headers: {
        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-PRD-292e4f543-1891531a",
//        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-SBX-592e4f49b-0de7be50",
        "X-EBAY-SOA-OPERATION-NAME": "findItemsByKeywords",
      },
    );

    if (response.statusCode == 200) {
      // parse through xml
      var document = xml.parse(response.body);
      var results = document.findAllElements('item');
      var data = results.toList(); // transform Iterable to a List

//      print(data[0].runtimeType);
//      print(document.toXmlString(pretty: true, indent: '\t'));

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
                hintText: 'Choose a book',
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
                          MaterialPageRoute(builder: (context) => SecondScreen(_items[index]))
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
