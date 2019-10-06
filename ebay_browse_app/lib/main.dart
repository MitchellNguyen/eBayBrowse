import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:xml2json/xml2json.dart';
import 'package:xml/xml.dart' as xml;

void main() => runApp(new MaterialApp(
  home: new HomePage(),
));

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  // 1. Do i need to make another method that does "construct https url" depending on specific given keywords?
  // 2. headers -- key???


//  var url = "https://svcs.sandbox.ebay.com/services/search/FindingService/v1";
//  final String url = "https://swapi.co/api/people";

//  var url = "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-PRD-292e4f543-1891531a&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=harry%20potter%20phoenix";
  var url = "https://svcs.sandbox.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-SBX-592e4f49b-0de7be50&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=harry";

  // Todo: SOMETHING WRONG HERE WITH THE BODY format.... maybe needs to be in XML form..
  Map body = { "findItemsByKeywordsRequest": {"xmlns": "https://www.ebay.com/marketplace/search/v1/services","keywords": "harry potter phoenix","paginationInput": { "entriesPerPage": "2" }}};
  var data;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
//    this.makePostRequest();
  }

//  // for Finding API, we use HTTP POST to submit JSON requests
//  Future<String> makePostRequest() async {
//    // set up POST request arguments
//    String url = 'https://svcs.sandbox.ebay.com/services/search/FindingService/v1';
//    Map<String, String> headers = {"Content-type": "application/json"};
//    String json =
//
//  }

  Future<http.Response> getJsonData() async {
    var response = await http.get( // OR POSTT AHHH
      Uri.encodeFull(url),
      headers: {  // DO I NEED "content-type" to be json (or do i need it at all??)
//        "Content-type": "text/xml",
//        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-PRD-292e4f543-1891531a",
        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-SBX-592e4f49b-0de7be50",
        "X-EBAY-SOA-OPERATION-NAME": "findItemsByKeywords",
      },
      // do i need to insert body: body (when i use post -- to make findByKeyWord request...)
//      body: jsonEncode(body),
    );

    var status = response.statusCode;
    print("hi:  $status");

    print(response.body);

    print("----");

//    // transform response.body from XML into JSON (more manageable data format)
//    final Xml2Json fileTransformer = Xml2Json(); // create a client transformer
//    fileTransformer.parse(response.body);
//
//    print(response.body);

    // parse through xml
    var document = xml.parse(response.body);
    var titles = document.findAllElements('title');

    titles
      .map((node) => node.text)
      .forEach(print);


    // to print out titles of items, possibly do:
    //    result["searchResult"]["item"]["title"].......

  }

//  Future<String> getJsonData() async {
//
//    var response = await http.get(
//      Uri.encodeFull(url),
//      headers: {"Accept": "application/json"}
//    );
//
//    print(response.body);
//
//    setState(() {
//      var convertDataToJson = jsonDecode(response.body);
//      data = convertDataToJson['results'];
//    });
//
//    return "Success";
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("hi"),
      ),
    );



//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Hello World"),
//      ),
//      body: new ListView.builder(
//        itemCount: data == null ? 0 : data.length,
//        itemBuilder: (BuildContext context, int index) {
//          return new Container(
//            child: new Center(
//              child: new Column(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: <Widget>[
//                  new Card(
//                    child: new Container(
//                      child: new Text(data[index]['name']),
//                      padding: const EdgeInsets.all(20.0)),
//                  )
//                ],
//              )
//            )
//          );
//        },
//      ),
//    );
  }
}