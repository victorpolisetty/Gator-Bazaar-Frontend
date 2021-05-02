import 'package:flutter/material.dart';
import 'package:student_shopping/ProfileFile/sellerShop.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_new_price;
  final product_detail_picture;
  final product_detail_description;
  final product_categoryId;

  ProductDetails({
    this.product_detail_name,
    this.product_detail_new_price,
    this.product_detail_picture,
    this.product_detail_description,
    this.product_categoryId,
  });
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Center(
          child: Text(
            'Student Shop',
            style: TextStyle(color:Colors.black),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.notifications,
              color:Colors.grey[800],
              size: 27,
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sellerShop()),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.shopping_cart,
                color:Colors.grey[800],
                size: 27,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 19, offset: Offset(0, 4), color: Colors.grey[400])],
                image: DecorationImage(image: NetworkImage(widget.product_detail_picture), fit: BoxFit.cover)
              ),

            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 15, top: 15),
              child: Text(widget.product_detail_name,style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.grey[700]),textAlign: TextAlign.left,)
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 15, top: 5),
                child: Text(widget.product_detail_description,style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[700]),textAlign: TextAlign.left,)
            ),
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     margin: EdgeInsets.only(left: 15, top: 35),
            //     child: Text("Colors: ",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[700]),textAlign: TextAlign.left,)
            // ),
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     margin: EdgeInsets.only(left: 15, top: 15),
            //     child: Container(
            //       alignment: Alignment.center,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           Container(
            //             decoration: BoxDecoration(color: Colors.red),
            //             width: 30,
            //               height: 30,
            //           ),
            //           Container(
            //             decoration: BoxDecoration(color: Colors.white),
            //             width: 30,
            //             height: 30,
            //           ),
            //           Container(
            //             decoration: BoxDecoration(color: Colors.blue),
            //             width: 30,
            //             height: 30,
            //           ),
            //           Container(
            //             decoration: BoxDecoration(color: Colors.green),
            //             width: 30,
            //             height: 30,
            //           ),
            //         ],
            //       ),
            //     )
            // )
          ],
        ),
      ),
bottomNavigationBar: Container(
  width: MediaQuery.of(context).size.width,
  height: 100,
  child: Container(
    margin: EdgeInsets.only(left: 10, right:10, bottom: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: Text(
            "Add to Cart",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          child: Icon(Icons.add_shopping_cart)
        ),


      ],
    ),
  ),

),


//           new ListView(
//             children: <Widget>[
//               new Container(
//                 height: 300.0,
//                 child: GridTile(
//                   child: Container(
//                     color: Colors.white,
//                     child: Image.network(widget.product_detail_picture),
//                   ),
//                 ),
//               ),
//
//               // ============ the first buttons ================
//               // ============ the second buttons ================
//
//               Column(
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: MaterialButton(
//                             onPressed: () {},
//                             color: Colors.red,
//                             textColor: Colors.white,
//                             elevation: 0.2,
//                             child: new Text("Buy Now")),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           child: new Text("\$${widget.product_detail_new_price}"),
//                         ),
//                       ),
//                       FavoriteWidget(
//                         product_name: widget.product_detail_name,
//                         product_price: widget.product_detail_new_price,
//                         product_picture: widget.product_detail_picture,
//                       ),
//                       //new IconButton(icon: Icon(Icons.favorite_border), color: Colors.red, onPressed: (){}),
//                     ],
//                   ),
// //              Row(
// //                children: <Widget>[
// //                  Expanded(
// //                    child: MaterialButton(
// //                        onPressed:(){},
// //                        color: Colors.red,
// //                        textColor: Colors.white,
// //                        elevation: 0.2,
// //                        child: new Text("Place Bid")
// //                    ),
// //                  ),
// //                  Padding(
// //                    padding: const EdgeInsets.all(2.0),
// //                    child:Container(
// //                      child:
// //                      new IconButton(icon: Icon(Icons.favorite_border), color: Colors.red, onPressed: (){}),
// //                    )
// //                  )
// //
// //
// //                ],
// //              )
//                 ],
//               ),
//
//               Divider(),
//               new ListTile(
//                   title: new Text("Product details"),
//                   subtitle: new Text(widget.product_detail_description)),
//               Divider(),
//
//               new Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
//                     child: new Text(
//                       "Product Name",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5.0),
//                     child: new Text(widget.product_detail_name),
//                   )
//                 ],
//               ),
//               new Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
//                     child: new Text(
//                       "Product Brand",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5.0),
//                     child: new Text("My Brand HERE"),
//                   )
//                 ],
//               ),
//               new Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
//                     child: new Text(
//                       "Product Condition",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5.0),
//                     child: new Text("My Condition HERE"),
//                     // ==============UNDER HERE ALL FOR SIMILIAR PRODUCTS FEATURE =====================
//                   )
//                 ],
//               ),
//               // Divider(),
//               //Padding(
//               //padding: const EdgeInsets.all(8.0),
//               //child: new Text("Similar Products"),
//               // ),
//               // SIMILAR PRODUCTS SECTION
//               // new Container(
//               // height: 340.0,
//               // child:
//               // Similar_products(),
//               // )
//             ],
//           ),

    );
  }
}
//class Similar_products extends StatefulWidget {
//  @override
//  _Similar_productsState createState() => _Similar_productsState();
//}
//
//class _Similar_productsState extends State<Similar_products> {
//  var product_list;
//  Widget build(BuildContext context) {
//    return GridView.builder(
//        itemCount: product_list.length,
//        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: 2),
//        itemBuilder: (BuildContext context, int index) {
//          return Similar_single_prod(
//            prod_name: product_list[index]['name'],
//            prod_picture: product_list[index]['picture'],
//            prod_price: product_list[index]['price'],
//          );
//        });
//  }
//}
//
//class Similar_single_prod extends StatelessWidget {
//  final prod_name;
//  final prod_picture;
//  final prod_price;
//
//  Similar_single_prod({
//    this.prod_name,
//    this.prod_picture,
//    this.prod_price,
//  }
//      );
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//        child:Hero(
//            tag: new Text("hero 1"),
//            child: Material(
//              child: InkWell(onTap:() => Navigator.of(context).push(new MaterialPageRoute(
//                  builder:(context) => new ProductDetails(
//                    //we are passing the values of the product to the product details page
//                    product_detail_name: prod_name,
//                    product_detail_new_price: prod_price,
//                    product_detail_picture: prod_picture,
//                  ))),
//                child: GridTile(
//                    footer: Container(
//                      color: Colors.white,
//                      child: new Row(
//                        children: <Widget>[
//                          Expanded(
//                              child: new Text(prod_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)
//                          ),
//                          new Text("\$$prod_price", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
//                        ],
//                      ),
//                    ),
//                    child: Image.asset(prod_picture,
//                      fit: BoxFit.cover,)),
//              ),
//            )
//        )
//    );
//  }
//}
//
