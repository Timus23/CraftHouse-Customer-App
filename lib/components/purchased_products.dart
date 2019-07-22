import 'package:flutter/material.dart';
class purchased_products extends StatefulWidget {
  @override
  _purchased_productsState createState() => _purchased_productsState();
}

class _purchased_productsState extends State<purchased_products> {
    var Products_on_the_cart=[
    {
      "name": "Bags",
      "picture":"images/products/bags.jpg",
      "price":4000,
      "madeof":"leather",
      "madeby":"andy",
      "quantity":1,
    },
    {
      "name": "Plates",
      "picture":"images/products/plates.jpg",
      "price":400,
      "madeof":"clay",
      "madeby":"james",
      "quantity":1,
    },
    
  ];
  @override
    Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: Products_on_the_cart.length,
        itemBuilder: (context, index){
          return Single_purchased_product(
            purchased_prod_name: Products_on_the_cart[index]["name"],
            purchased_prod_madeof: Products_on_the_cart[index]["madeof"],
            purchased_prod_quantity: Products_on_the_cart[index]["quantity"],
            purchased_prod_madeby: Products_on_the_cart[index]["madeby"],
            purchased_prod_picture: Products_on_the_cart[index]['picture'],
            purchased_prod_price: Products_on_the_cart[index]["price"],
          );
        }
    );
  }
}

class Single_purchased_product extends StatelessWidget {
  final purchased_prod_name;
  final purchased_prod_picture;
  final purchased_prod_price;
  final purchased_prod_madeby;
  final purchased_prod_quantity;
  final purchased_prod_madeof;

  Single_purchased_product({
    this.purchased_prod_name,
    this.purchased_prod_price,
    this.purchased_prod_madeby,
    this.purchased_prod_madeof,
    this.purchased_prod_picture,
    this.purchased_prod_quantity,
});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //leading section which is a image
        leading: new Image.asset(purchased_prod_picture,width: 60.0,height: 60.0,),
        //title section
        title: new Text(purchased_prod_name),
        //subtitle section
        subtitle: new Column(
          children: <Widget>[
            //row inside column
            new Row(
              children: <Widget>[
                //section for size of product
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text("Made By:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(purchased_prod_madeby,style: TextStyle(color: Colors.red),),
                ),

                //section for the product color
                new Padding(padding: const EdgeInsets.fromLTRB(0.0, 8.0, 5.0,8.0),
                  child: new Text("Made of:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(purchased_prod_madeof,style: TextStyle(color: Colors.red),),
                ),
              ],
            ),
            //section for product price
            new Container(
              alignment:Alignment.topLeft,
              child: new Text("\$${purchased_prod_price}",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: Colors.red),),

            ),

          ],
        ),
         trailing: Container(
          width: 45,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              
              new Text("Qty:$purchased_prod_quantity",),
              
            ],
          ),
        ),
      ),
    );
  }
}