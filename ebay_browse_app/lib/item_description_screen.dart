import 'package:flutter/material.dart';
import 'package:ebay_browse_app/search_list_screen.dart';

class ItemDescriptionScreen extends StatelessWidget {
  ItemDescriptionScreen(this.item, this.itemNum);

  final SearchItem item;
  final int itemNum;

  /// ///////////////////////////////////////////////////////////////////////////////////////////////////
  /// The following build() function will display the following descriptors (in the following order):
  /// #1. Image
  /// #2. Title
  /// #3. Subtitle
  /// #4. Category
  /// #5. Price
  /// #6. Payment Methods
  /// #7. Item ID
  /// #8. Product ID
  /// #9. Location
  /// #10. Shipping Service Cost
  /// #11. Shipping Type
  /// #12. Shipping To Locations
  /// /// ///////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    // wrap nicely around long texts
    double textWidth = MediaQuery.of(context).size.width*0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text("Description for Item #" + itemNum.toString()),
      ),
      body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            /** #1: Image **/
            Container(
              height: 250,
              child: FittedBox(
                child: Center(child: Image.network(item.imageUrl)),
              ),
            ),
            Container(
              height: 20, //spacing
            ),
            /** #2: Title **/
            Container(
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
              height: 20, //spacing
            ),
            /** #3: Subtitle **/
            Container(
              width: textWidth,
              child: Text(
                item.subtitle,
                style: TextStyle(
                    fontSize: item.subtitle != '' ? 20 : 0,
                    fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Container(
              height: item.subtitle != '' ? 20 : 0, //spacing
            ),
            /** #4: Category **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Category:  ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.categoryName, style: TextStyle(fontSize: 20))
                    ),
                  ]
              )
            ),
            Container(
              height: 10, //spacing
            ),
            Divider(
              color: Colors.blue,
              thickness: 1.3,
            ),
            Container(
              height: 10, //spacing
            ),
            /** #5: Price **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Price:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.price != '' ? ('\$' + item.price) : '(Price not listed)', style: TextStyle(fontSize: 15))
                    )
                  ]
              )
            ),
            Container(
              height: 20, //spacing
            ),
            /** #6: Payment Methods **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Payment Methods:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.paymentMethods != '' ? item.paymentMethods : '(Payment Methods not listed)', style: TextStyle(fontSize: 15))
                    )
                  ]
              )
            ),
            Container(
              height: 10, //spacing
            ),
            Divider(
              color: Colors.blue,
              thickness: 1.3,
            ),
            Container(
              height: 10, //spacing
            ),
            /** #7: Item ID  **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Item ID:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.itemId != '' ? item.itemId : '(Item ID not listed)', style: TextStyle(fontSize: 15))
                    )
                  ]
              )
            ),
            Container(
              height: 20, //spacing
            ),
            /** #8: Product ID **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Product ID:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.productId != '' ? item.productId : '(Product ID not listed)', style: TextStyle(fontSize: 15))
                    )
                  ]
              )
            ),
            Container(
              height: 10, //spacing
            ),
            Divider(
              color: Colors.blue,
              thickness: 1.3,
            ),
            Container(
              height: 10, //spacing
            ),
            /** #9: Location **/
            Container(  // ITEM 6: location
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Location:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.location != '' ? item.location : '(Location not listed)', style: TextStyle(fontSize: 15))
                    )
                  ]
              )
            ),
            Container(
              height: 10, //spacing
            ),
            Divider(
              color: Colors.blue,
              thickness: 1.3,
            ),
            Container(
              height: 10, //spacing
            ),
            /** #10: Shipping Service Cost **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Shipping Service Cost:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.shippingServiceCost != '' ? item.shippingServiceCost : '(Shipping Service Cost not listed)', style: TextStyle(fontSize: 15)),
                    )
                  ]
              )
            ),
            Container(
              height: 20, //spacing
            ),
            /** #11: Shipping Type **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Shipping Type:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.shippingType != '' ? item.shippingType : '(Shipping Type not listed)', style: TextStyle(fontSize: 15))
                    )
                  ]
              )
            ),
            Container(
              height: 20, //spacing
            ),
            /** #12: Shipping To Locations **/
            Container(
              width: textWidth,
              child: new Row(
                  children: <Widget>[
                    Text('Available Shipping To Locations:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Text(item.shippingToLocations != '' ? item.shippingToLocations : '(Available Shipping To Locations not listed)', style: TextStyle(fontSize: 15))
                    )
                  ]
              )
            ),
          ]
      ),
    );
  }
}