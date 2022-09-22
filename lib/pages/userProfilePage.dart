import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:student_shopping_v1/models/sellerItemModel.dart';
import 'package:provider/provider.dart';
import '../models/itemModel.dart';
import 'itemDetailPage.dart';





class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  XFile?  _pickedImage;
  ScrollController _controller = new ScrollController();
  bool isBottom = false;
  bool loading = false, allLoaded = false;

  mockFetch(SellerItemModel sellerList) async{
    if(allLoaded){
      print("ALL LOADED");
      return;
    }
    setState(() {
      loading = true;
    });
    if(sellerList.currentPage != 0){
      await sellerList.init1(sellerList.currentPage);
    }
    if(sellerList.currentPage <= sellerList.totalPages-1){
      sellerList.currentPage++;
    }

    setState(() {
      loading = false;
      allLoaded = sellerList.currentPage == sellerList.totalPages;
    });
  }

  Future<User?> isSignedIn() async {
    await Future.delayed(Duration(seconds: 1));
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SellerItemModel>(context, listen: false).getProfileIdAndItems();
    _controller.addListener((){
      // reached bottom
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = true);
      }

      // IS SCROLLING
      if (_controller.offset >= _controller.position.minScrollExtent &&
          _controller.offset < _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
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
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sellerItemList = context.watch<SellerItemModel>();
    var totalPages = sellerItemList.totalPages;
    return Column(
      children: [
        new FutureBuilder<User?>(
          future: isSignedIn(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if(snapshot.hasData){
              String? dname = snapshot.data!.displayName;
              String? email = snapshot.data!.email;;
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.exit_to_app_outlined),color: Colors.black,
                        onPressed: (){
                          Navigator.pushNamed(context, '/');
                          FirebaseAuth.instance.signOut();
                        },
                      )
                    ],
                  ),
                  body: ListView(children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag:
                          'https://images.unsplash.com/photo-1598369685311-a22ca3406009?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80',
                          child: InkWell(
                              onTap: (){
                                _showPickOptionsDialog(context);
                                print("HIT ME");
                              },
                              child: CircleAvatar(
                                radius: 80,
                                // child: _pickedImage == null ? Text("Picture") : null,
                                backgroundImage: _pickedImage != null ? FileImage(File(_pickedImage!.path)) : AssetImage('assets/images/defaultPic.png') as ImageProvider,
                              )
                            // child: Container(
                            //   height: 125.0,
                            //   width: 125.0,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(62.5),
                            //       image: DecorationImage(
                            //           fit: BoxFit.cover,
                            //           image: profilePic == null ? AssetImage('assets/images/defaultPic.png') : Image.file(profilePic!) as ImageProvider )),
                            // ),
                          ),
                        ),
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
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: <Widget>[
                              //     Text(
                              //       '24K',
                              //       style: TextStyle(
                              //           fontFamily: 'Montserrat',
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //     SizedBox(height: 5.0),
                              //     Text(
                              //       'FOLLOWERS',
                              //       style: TextStyle(
                              //           fontFamily: 'Montserrat', color: Colors.grey),
                              //     )
                              //   ],
                              // ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: <Widget>[
                              //     Text(
                              //       '31',
                              //       style: TextStyle(
                              //           fontFamily: 'Montserrat',
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //     SizedBox(height: 5.0),
                              //     Text(
                              //       'FOLLOWING',
                              //       style: TextStyle(
                              //           fontFamily: 'Montserrat', color: Colors.grey),
                              //     ),
                              //   ],
                              // ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // Text(
                                  //   '21',
                                  //   style: TextStyle(
                                  //       fontFamily: 'Montserrat',
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'LISTINGS',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat', color: Colors.black),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                        ),
                sellerItemList.items.length != 0 ?
                Column(
                  children: [
                    Column(
                      // margin: EdgeInsets.only(top: 10),
                      // width: MediaQuery.of(context).size.width,
                      // // height: double.,
                      // height: MediaQuery.of(context).size.height - 452,
                      children: [
                      Container(
                        // width: MediaQuery.of(context).size.width,
                        // height: double.,
                        // height: MediaQuery.of(context).size.height - 452,
                        height: double.infinity,
                        width: double.infinity,
                        child: GridView.builder(
                          controller: _controller,
                          itemCount: sellerItemList.items.length == null ? 0 : sellerItemList.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleItem(
                                item: sellerItemList.items[index]
                            );
                            // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,),
                        ),
                      ),
                        if(loading)(spinkit),
                        (isBottom && !allLoaded && !loading) ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black
                          ),
                          child: Center(
                            // child: Expanded(
                              child: Text("Show More")
                            //),
                          ),
                          onPressed: (){
                            setState(() {
                              if(sellerItemList.currentPage <= totalPages-1 && !loading){
                                mockFetch(sellerItemList);
                              }
                              //recentList.getNextPage(1);
                            });
                          },
                        ) : Container(),
                      ]
                    ),
                  ],
                ) : Container(child: Padding(
                  padding: const EdgeInsets.all(100),
                  child: Center(child: Text("No Listings Yet!")),
                ),)

                        // buildImages(),
                        // buildInfoDetail(),
                        // buildImages(),
                        // buildInfoDetail(),
                      ],
                    )
                  ]));
          } else {
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: spinkit,
                );
              }
          }
        ),
      ],
    );
  }
  void _loadPicker(ImageSource source) async{
    XFile? picked = await ImagePicker().pickImage(source: source);
    if(picked != null){
      setState(() {
        _pickedImage = picked;
      });

    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _showPickOptionsDialog(BuildContext context){
    BuildContext dialogContext;
    showDialog(context: context,
        builder: (context) => AlertDialog(
          // dialogContext = context;
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Pick from Gallery"),
                onTap: (){
                  _loadPicker(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text("Take a picture"),
                onTap: (){
                  _loadPicker(ImageSource.camera);
                },
              )
            ],
          ),
        ) );
  }
}






  // Widget buildImages() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
  //     child: Container(
  //         height: 200.0,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(15.0),
  //             image: DecorationImage(
  //                 image: NetworkImage(
  //                     'https://images.unsplash.com/photo-1576797371181-97b48d7f6550?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1620&q=80'),
  //                 fit: BoxFit.cover))
  //     ),
  //   );
  // }
class SingleItem extends StatelessWidget {
  ItemWithImages item;

  SingleItem({
    required this.item
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ItemDetails(
                  item
              ))),
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 150,
            height: 100,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                image: DecorationImage(image: MemoryImage(item.imageDataList[0]), fit: BoxFit.cover),
                color: Colors.white,
                borderRadius: BorderRadius.circular(18)),
            child: Container(
              margin: EdgeInsets.only(right: 10, top: 5),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 150,
          margin: EdgeInsets.only(top: 5, left: 15),
          height: 30,
          child: Text((' \$${NumberFormat('#,##0.00', 'en_US').format(item.price)}'),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
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

  // Widget buildInfoDetail() {
  //   return Padding(
  //     padding:
  //         EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 15.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Text(
  //               'Spanish Text Books',
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: 'Montserrat',
  //                   fontSize: 15.0),
  //             ),
  //             SizedBox(height: 7.0),
  //             Row(
  //               children: <Widget>[
  //                 Text(
  //                   'John Smith',
  //                   style: TextStyle(
  //                       color: Colors.grey.shade700,
  //                       fontFamily: 'Montserrat',
  //                       fontSize: 11.0),
  //                 ),
  //                 SizedBox(width: 4.0),
  //                 Icon(
  //                   Icons.timer,
  //                   size: 4.0,
  //                   color: Colors.black,
  //                 ),
  //                 SizedBox(width: 4.0),
  //                 Text(
  //                   'University of Florida',
  //                   style: TextStyle(
  //                       color: Colors.grey.shade500,
  //                       fontFamily: 'Montserrat',
  //                       fontSize: 11.0),
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             SizedBox(width: 7.0),
  //             InkWell(
  //               onTap: () {},
  //               child: Container(
  //                 height: 20.0,
  //                 width: 20.0,
  //                 child: Image.network(
  //                     'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/navarrow.png?raw=true'),
  //               ),
  //             ),
  //             SizedBox(width: 7.0),
  //             InkWell(
  //               onTap: () {},
  //               child: Container(
  //                 height: 20.0,
  //                 width: 20.0,
  //                 child: Image.network(
  //                     'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/speechbubble.png?raw=true'),
  //               ),
  //             ),
  //             SizedBox(width: 7.0),
  //             InkWell(
  //               onTap: () {},
  //               child: Container(
  //                 height: 22.0,
  //                 width: 22.0,
  //                 child: Image.network(
  //                     'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/fav.png?raw=true'),
  //               ),
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  //
  // }
