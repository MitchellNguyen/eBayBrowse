import 'dart:async';
import 'dart:convert';

import 'package:ebay_browse_app/search_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import 'another_attempt.dart';

void main() => runApp(new MaterialApp(
//  home: new HomePage(),
//  home: new Example9(),


  home: new MyAppAttempt(),
//  initialRoute: '/',
//  routes: {
//    '/': (context) => MyAppAttemptFirstScreen(),
//    '/second': (context) => SecondScreen(),
//  }
));

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  // 1. Do i need to make another method that does "construct https url" depending on specific given keywords?

//  var url = "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-PRD-292e4f543-1891531a&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=harry%20potter%20phoenix";
  var url = "https://svcs.sandbox.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-SBX-592e4f49b-0de7be50&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=harry";

  List data;

  var titles;

  var itemIndex = 0;



  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this.getJsonData();
//    this.makePostRequest();

//    _scrollController.addListener(() {
//      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//        //if we are the bottom of the page
//      }
//    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<http.Response> getJsonData() async {
    var response = await http.get( // OR POSTT AHHH
      Uri.encodeFull(url),
      headers: {
        // DO I NEED "content-type" to be json (or do i need it at all??)
//        "Content-type": "text/xml",
//        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-PRD-292e4f543-1891531a",
        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-SBX-592e4f49b-0de7be50",
        "X-EBAY-SOA-OPERATION-NAME": "findItemsByKeywords",
      },
      // do i need to insert body: body (when i use post -- to make findByKeyWord request...)
//      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // parse through xml
      var document = xml.parse(response.body);
      titles = document.findAllElements('title');

      setState(() {
        // transform Iterable to a List
        data = titles.toList();
      });
    } else {
      throw Exception('Failed to load search results...');
    }

    print(data);

//    var status = response.statusCode;
//    print("hi:  $status");
//
//    print(response.body);
//
//    print("----");
//
//    // parse through xml
//    var document = xml.parse(response.body);
//    titles = document.findAllElements('title');
//
//    // print out titles of each item
//    titles
//        .map((node) => node.text)
//        .forEach(print);
//
//    // transform Iterable to a List
//    data = titles.toList();
//    print("---");
//    print(data.length);
//    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("hi"),
      ),
      body: new Text(data.toString()),
    );
  }




  // USE THE STUFF BELOW TO MAKE A LIST.....

//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("henloooo"),
//      ),
//      body: ListView.builder(
////        controller: _scrollController,
////        itemCount: data.length,
//        itemBuilder: (BuildContext context, int index) {
//          return Container(
//            constraints: BoxConstraints.tightFor(height: 150.0),
//            child: new Text(index.toString() + data[index].toString()),
//          );
//        },
//      ),
//    );
//  }



//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Infinite List"),
//      ),
//      body: ListView.builder(
//        itemBuilder:(context, index) {
//          if (index < data.length) {
//            // show your info
//            Text("$index");
//          } else {
//            getMoreData();
//            return Center(child: CircularProgressIndicator());
//          }
//        },
//        itemCount: data.length + 1,
//      ),
//    );
//  }
//
//  getMoreData() {
//
//  }

  //todo: need to make an INFINITE SCROLLING LIST (of items)

//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Hello World"),
//      ),
//      body: new ListView.builder(
//        itemCount: data == null ? 0 : data.length,
//        itemBuilder: (BuildContext context, int index) {
//          return new Container(
//              child: new Center(
//                  child: new Column(
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      new Card(
//                        child: new Container(
//                            child: new Text(/*data[index]['name']*/
//                                titles[index]),
//                            padding: const EdgeInsets.all(20.0)),
//                      )
//                    ],
//                  )
//              )
//          );
//        },
//      ),
//    );
//  }
}