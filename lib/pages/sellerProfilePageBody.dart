import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:student_shopping_v1/applicationState.dart';
import 'package:student_shopping_v1/pages/itemDetailPageSellerView.dart';
import '../models/itemModel.dart';
import '../models/sellerItemModel.dart';
final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.black : Colors.black,
      ),
    );
  },
);

class SellerProfilePageBody extends StatefulWidget {
  const SellerProfilePageBody({Key? key}) : super(key: key);

  @override
  State<SellerProfilePageBody> createState() => _SellerProfilePageBodyState();
}

class _SellerProfilePageBodyState extends State<SellerProfilePageBody> {
  XFile? _pickedImage;
  Future<User?> isSignedIn() async {
    await Future.delayed(Duration(seconds: 1));
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  ScrollController _controller = new ScrollController();
  bool isBottom = false;
  bool loading = false, allLoaded = false;

  @override
  mockFetch(SellerItemModel sellerList) async {
    if (allLoaded) {
      print("ALL LOADED");
      return;
    }
    setState(() {
      loading = true;
    });
    if (sellerList.currentPage != 0) {
      await sellerList.init1(sellerList.currentPage);
    }
    if (sellerList.currentPage <= sellerList.totalPages - 1) {
      sellerList.currentPage++;
    }

    setState(() {
      loading = false;
      allLoaded = sellerList.currentPage == sellerList.totalPages;
    });
  }

  void initState() {
    super.initState();
    Provider.of<SellerItemModel>(context, listen: false).getProfileIdAndItems();
    _controller.addListener(() {
      // reached bottom
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = true);
      }

      // IS SCROLLING
      if (_controller.offset >= _controller.position.minScrollExtent &&
          _controller.offset < _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() {
          isBottom = false;
        });
      }

      // REACHED TOP
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() {
          isBottom = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userItemList = context.watch<SellerItemModel>();
    var totalPages = userItemList.totalPages;
    return WillPopScope(
      onWillPop: () async => false,
      child: new FutureBuilder<User?>(
        future: isSignedIn(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            String? dname = snapshot.data!.displayName;
            String? email = snapshot.data!.email;
            return Column(
              children: [
                AppBar(
                  iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
                  backgroundColor: Colors.grey[300],
                  elevation: .1,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.exit_to_app_outlined),
                      color: Colors.black,
                      onPressed: () {
                        // Navigator.of(context).push(new MaterialPageRoute(
                        //     builder: (context) => new HomePage()));
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new HomePage(), fullscreenDialog: true));
                      },
                    )
                  ],
                ),
                SizedBox(height: 25),
                Container(
                    height: 100,
                    // width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag:
                          'https://images.unsplash.com/photo-1598369685311-a22ca3406009?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80',
                      // child: InkWell(
                      // onTap: (){
                      //   // _showPickOptionsDialog(context);
                      //   print("HIT ME");
                      // },
                      child: CircleAvatar(
                        radius: 50,
                        // child: _pickedImage == null ? Text("Picture") : null,
                        backgroundImage: _pickedImage != null
                            ? FileImage(File(_pickedImage!.path))
                            : AssetImage('assets/images/defaultPic.png')
                                as ImageProvider,
                      )
                      // )
                      ,
                    )),
                SizedBox(height: 25.0),
                Text(
                  dname.toString(),
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  email.toString(),
                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                ),
                SizedBox(height: 20.0),
                Text(
                  'LISTINGS',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black),
                ),
                userItemList.items.length != 0 ? Container(
                    height: MediaQuery.of(context).size.height - 442,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      controller: _controller,
                      itemCount: userItemList.items.length == null
                          ? 0
                          : userItemList.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleItem(item: userItemList.items[index]);
                        // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                      ),
                    )
                    ) : Container(
                    height: MediaQuery.of(context).size.height - 442,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("No Listings!"))
                ),
                // if(loading)(spinkit),
                // (isBottom && !allLoaded && !loading) ? ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       primary: Colors.black
                //   ),
                //   child: Center(
                //     // child: Expanded(
                //       child: Text("Show More")
                //     //),
                //   ),
                //   onPressed: (){
                //     setState(() {
                //       if(userItemList.currentPage <= totalPages-1 && !loading){
                //         mockFetch(userItemList);
                //       }
                //       //recentList.getNextPage(1);
                //     });
                //   },
                // ) : Container(),
              ],
            );
          } else {
            return Container(
              color: Colors.grey[300],
              height: 350,
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,

              child: spinkit,
            );
          }
        },
      ),
    );
  }
}

class SingleItem extends StatelessWidget {
  ItemWithImages item;

  SingleItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ItemDetailPageSellerView(item))),
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 150,
            height: 100,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: item.imageDataList.length > 0 ?
    MemoryImage(item.imageDataList[0]) : AssetImage('assets/images/no-picture-available-icon.png') as ImageProvider, fit: BoxFit.contain),
                color: Colors.white,
                borderRadius: BorderRadius.circular(18)),
            child: Container(
              margin: EdgeInsets.only(right: 10, top: 5),
            ),
          ),
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 80,
              margin: EdgeInsets.only(top: 5, left: 30),
              height: 30,
              child: Text("\$${item.price}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            item.isSold
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 60,
                      height: 20,
                      // color: Colors.black,
                      child: Center(
                        child: Text("SOLD!"
                            // margin: EdgeInsets.all(8),
                            // color: Colors.blue,
                            ),
                      ),
                      color: Colors.green,
                    ),
                  )
                : Expanded(child: Container()),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          width: 150,
          margin: EdgeInsets.only(top: 0, left: 15),
          height: 30,
          child: Text("${item.name}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
