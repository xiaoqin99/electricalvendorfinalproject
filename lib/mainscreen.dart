import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cartpage.dart';
import 'loginscreen.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double screenWidth, screenHeight;
  List _productList = [];
  String _titlecenter = "Loading...";
  late SharedPreferences prefs;
  String email = "";
  int cartitem = 0;
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('MainPage'),
        backgroundColor: Colors.pinkAccent[400],
        actions: [
          TextButton.icon(
              onPressed: () => {_goToCart()},
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              label: Text(
                cartitem.toString(),
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      backgroundColor: Colors.teal[50],
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("MENU",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.pinkAccent[400]),
            ),
            ListTile(
              title: Text("Services", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Products", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("My Account", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
                title: Text("Logout", style: TextStyle(fontSize: 16)),
                onTap: _logout),
          ],
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 5),
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Search product",
                  suffixIcon: IconButton(
                    onPressed: () => _loadProducts(_searchController.text),
                    icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.white24)),
                ),
              ),
              SizedBox(height: 5),
              if (_productList.isEmpty)
                Flexible(child: Center(child: Text(_titlecenter)))
              else
                Flexible(
                    child: OrientationBuilder(builder: (context, orientation) {
                  return StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(10),
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
                      itemCount: _productList.length,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(1),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Column(
                          children: [
                            Container(
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: screenHeight / 5.0,
                                      width: screenWidth / 2.0,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://javathree99.com/s270088/electricalvendor/images/product/${_productList[index]['prid']}.jpg",
                                      ),
                                    ),
                                    Text(
                                      titleSub(_productList[index]['prname']),
                                      style: TextStyle(
                                          fontFamily: 'RobotoMono',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(_productList[index]['prtype'][0]
                                            .toUpperCase() +
                                        _productList[index]['prtype']
                                            .substring(1)),
                                    Text("Qty:" + _productList[index]['prqty']),
                                    Text("RM " +
                                        double.parse(
                                                _productList[index]['prprice'])
                                            .toStringAsFixed(2)),
                                    Container(
                                      child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            minWidth: 120,
                                            height: 40,
                                            child: Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () => {_addtocart(index)},
                                            color: Colors.pink[900]),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }))
            ],
          ),
        ),
      ),
    );
  }

  _loadProducts(String prname) {
    http.post(
        Uri.parse(
            "http://javathree99.com/s270088/electricalvendor/php/loadproduct.php"),
        body: {"productname": prname}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No product";
        _productList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
        _titlecenter = "";
      }
      setState(() {});
    });
  }

  void _logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  String titleSub(String title) {
    if (title.length > 30) {
      return title.substring(0, 30) + "...";
    } else {
      return title;
    }
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") ?? '';
    print(email);
    if (email == '') {
    } else {}
  }

  _addtocart(int index) async {
    if (email == '') {
    } else {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: Text("Add to cart"), title: Text("Progress..."));
      progressDialog.show();
      await Future.delayed(Duration(seconds: 1));
      String prid = _productList[index]['prid'];
      http.post(
          Uri.parse(
              "http://javathree99.com/s270088/electricalvendor/php/insertcart.php"),
          body: {"email": email, "prid": prid}).then((response) {
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0);
          _loadCart();
        }
      });
      progressDialog.dismiss();
    }
  }

  _goToCart(){
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CartPage(user: widget.user, email: email),
        ),
      );
      _loadProducts(_searchController.text);
    }

  void _loadCart() {
    print(email);
    http.post(
        Uri.parse(
            "http://javathree99.com/s270088/electricalvendor/php/loadcartitem.php"),
        body: {"email": email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }

  Future<void> _testasync() async {
    await _loadPref();
    _loadProducts(_searchController.text);
    _loadCart();
  }
}