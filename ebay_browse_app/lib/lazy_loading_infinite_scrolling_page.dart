//// <https://inducesmile.com/google-flutter/how-to-create-an-infinite-scroll-with-listview-in-flutter/>
//
//import 'package:flutter/material.dart';
//
//class InfiniteScrollListView extends StatefulWidget {
//  _InfiniteScrollListViewState createState() => _InfiniteScrollListViewState();
//}
//
//class _InfiniteScrollListViewState extends State<InfiniteScrollListView> {
//  ScrollController _scrollController = ScrollController();
//  List<String> _listViewData = [
//    "Inducesmile.com",
//    "Flutter Dev",
//    "Android Dev",
//    "iOS Dev!",
//    "React Native Dev!",
//    "React Dev!",
//    "express Dev!",
//    "Laravel Dev!",
//    "Angular Dev!",
//    "Adonis Dev!",
//    "Next.js Dev!",
//    "Node.js Dev!",
//    "Vue.js Dev!",
//    "Java Dev!",
//    "C# Dev!",
//    "C++ Dev!",
//  ];
//
//  @override
//  void initState() {
//    super.initState();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _loadMore();
//      }
//    });
//  }
//
//  _loadMore() {
//    setState(() {
//      print('loading more, ...');
//
//      // if we are at the end fo the list, add more items
//      _listViewData.addAll(List<String>.from(_listViewData));
//    });
//  }
//
//  @override
//  void dispose() {
//    _scrollController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Infinite Scroll in ListView Example'),
//      ),
//      body: ListView.builder(
//        itemCount: _listViewData.length,
//        controller: _scrollController,
//        itemBuilder: (context, index) {
//          return ListTile(
//            title: Text(_listViewData[index]),
//          );
//        },
//      ),
//    );
//  }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////// this file is a modified version of code from infinite-scrolling
////// tutorial made by user "iampawan"
////// Github link: <https://github.com/iampawan/FlutterUtilsCollection/blob/master/lib/lazy_loading_page.dart>
////
////import 'package:flutter/material.dart';
////import 'package:flutter/cupertino.dart';
////
////class LazyLoadingPage extends StatefulWidget {
////  @override
////  _LazyLoadingPageState createstate() => _LazyLoadingPageState();
////}
////
////class _LazyLoadingPageState extends State<LazyLoadingPage> {
////  List myList;
////  ScrollController _scrollController = ScrollController();
////  int _currentMax = 10;
////
////  @override
////  void initState() {
////    super.initState();
////    myList = ["1", "22", "333"];
////    _scrollController.addListener(() {
////      if (_scrollController.position.pixels ==
////          _scrollController.position.maxScrollExtent) {
////        _getMoreData();
////      }
////    });
////  }
////
////  _getMoreData() {
////    for (int i = _currentMax; i < _currentMax + 10; i++) {
////      myList.add("")
////    }
////
////  }
////
////  @override
////  Widget build(BuildContext context)
////}