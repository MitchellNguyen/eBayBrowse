import 'package:flutter/material.dart';
import 'package:ebay_browse_app/another_attempt.dart';

class ItemDescriptionScreen extends StatelessWidget {
  ItemDescriptionScreen(this.item);

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