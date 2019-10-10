import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class Example9 extends StatelessWidget {
//  @override
//  HomePageState createState() => new HomePageState()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search App"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      drawer: Drawer(),
    );
  }
}


class DataSearch extends SearchDelegate<String> {
  final cities = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
  ];

  final recentCities = [
    "d",
    "e",
    "f",
  ];

  String url = "https://svcs.sandbox.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-SBX-592e4f49b-0de7be50&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=harry";
  List searchResults;

  String createGetUrl(String query) {
    String keywords = query.split(" ").join("%20");
    url = "https://svcs.sandbox.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Mitchell-mitchell-SBX-592e4f49b-0de7be50&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=" + keywords;

    print(url);
  }

  Future<http.Response> getSearchData() async {
    var response = await http.get(
      Uri.encodeFull(createGetUrl(query)),
      headers: {
//        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-PRD-292e4f543-1891531a",
        "X-EBAY-SOA-SECURITY-APPNAME": "Mitchell-mitchell-SBX-592e4f49b-0de7be50",
        "X-EBAY-SOA-OPERATION-NAME": "findItemsByKeywords",
      },
    );

    if (response.statusCode == 200) {
      // parse through xml
      var document = xml.parse(response.body);
      var titles = document.findAllElements('title');

      // transform Iterable to a List
      searchResults = titles.toList();

    } else {
      throw Exception('Failed to load search results...');
    }

    print(searchResults);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection


    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        shape: StadiumBorder(),
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(text: TextSpan(
          text: suggestionList[index].substring(0, query.length),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [TextSpan(
            text: suggestionList[index].substring(query.length),
            style: TextStyle(color: Colors.grey),
          )]
        )),
      ),
      itemCount: suggestionList.length,
    );
  }
}
