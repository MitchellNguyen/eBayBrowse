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

class SecondScreen extends StatelessWidget {
  SecondScreen(this.item);

  final SearchItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: new Text(item.title),
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

      print(data[0].runtimeType);

      for (var i = 0; i < data.length; i++) {
        print("hi");
        _addSearchItem(data[i]);
      }
    } else {
      _onError();
    }

    setState(() {
      _isLoading = false;
    });



    print(_items.length);
    print(_items[0]);
  }

  String reformatText(String text) {
    if (text.contains(" ")) {
      text = text.split(" ").join("%20");
    }

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

  void _addSearchItem(xml.XmlElement item) {

    print("IMAGEEEE: " + removeAllXmlTags(item.findElements("galleryURL").toString()));

    setState(() {
      _items.add(new SearchItem(
          removeAllXmlTags(item.findElements("title").toString()),
          removeAllXmlTags(item.findElements("galleryURL").toString()),
          removeAllXmlTags(item.findElements("location").toString()),
          removeAllXmlTags(item.findElements("currentPrice").toString()),
      ));
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
  String title, imageUrl, location, price;
  SearchItem(String title, String imageUrl, String location, String price) {
    this.title = title;
    this.imageUrl = imageUrl;
    this.location = location;
    this.price = price;
  }
}
