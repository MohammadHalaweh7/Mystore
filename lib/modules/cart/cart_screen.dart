import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udemy_flutter/API/fetchData.dart';
import 'package:udemy_flutter/layout/shop_layout/shop_layout.dart';
import 'package:udemy_flutter/models/product/product_model.dart';
import 'package:udemy_flutter/models/user/user_model.dart';
import 'package:udemy_flutter/modules/join/joinApp_screen.dart';
import 'package:udemy_flutter/modules/language/language_screen.dart';
import 'package:udemy_flutter/modules/login/login_screen.dart';
import 'package:udemy_flutter/modules/order/order_screen.dart';
//import 'package:udemy_flutter/modules/order/order_screen.dart';
import 'package:udemy_flutter/modules/password/password_screen.dart';
import 'package:udemy_flutter/modules/phone/phone_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/modules/signup/signUp_screen.dart';
import "package:url_launcher/url_launcher.dart";
import '../../src/my_app.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var counter;
  var i = 0;
  int total = 0;
  var prod;
  int tot = 0;
  int toNumbrs = 0;
  fetchData fetch = fetchData();

  Future<UserModel> removeFromCart(id) async {
    var ID = id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');

    print(token);

    var result = await http.patch(
        Uri.parse(fetchData.baseURL + "/users/removeProductFromCart/" + ID),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token.toString()
        });

    UserModel userModel = UserModel.fromJson(jsonDecode(result.body));
    setState(() {});

    return userModel;
  }

  Widget cartProducts() {
    return FutureBuilder(
        future: fetch.getProductsOnCart(),
        builder: (contxt, snapchot) {
          var products = snapchot.data as List<ProductModel>;
          prod = products;
          return snapchot.data == null
              ? CircularProgressIndicator(
                  value: 1,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: products == null ? 0 : products.length,
                  itemBuilder: (context, index) {
                    counter = products.length;
                    toNumbrs = int.parse(products[index]
                        .price
                        .replaceAll(new RegExp(r'[^0-9]'), ''));
                    //   print(toNumbrs);
                    //print(int.parse(toNumbrs));
                    i++;
                    tot = tot + toNumbrs;
                    total = tot;
                    if (i == products.length) {
                      tot = 0;
                      i = 0;
                    }

                    return myCartProducts(
                      products[index].name,
                      products[index].description,
                      products[index].id,
                      products[index].price,
                      products[index].owner,
                    );
                  });
        });
  }

  Widget myCartProducts(name, description, id, price, owner) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          //هون ديزاين الكونتينر
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 1.0), //(x,y)
                blurRadius: 5.0,
              ),
            ],
          ),
          child:
              //هاد البادينغ يحتوي على الصورة والاسم والسعر وسلة الزبالة
              Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                //هاد الكونتينر للصورة
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://mystoreapii.herokuapp.com/product/' +
                                  id +
                                  '/avatar'),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 20,
                ),
                //هاد للاسم والسعر والسلة
                Expanded(
                  child: Container(
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                        Row(
                          children: [
                            Text(
                              'السعر : ',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              price,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  removeFromCart(id);

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                },
                                icon: CircleAvatar(
                                    radius: 17,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    )))
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: onNotification,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
              size: 35,
            )),
        title: Text(
          "السلة",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              onNotification;
            },
            icon: Icon(
              Icons.add_alert_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              onNotification;
            },
            icon: Icon(
              Icons.menu_book,
              color: Colors.grey,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              onNotification;
            },
            icon: Icon(
              Icons.shopping_basket_sharp,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: cartProducts()),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 1.0), //(x,y)
                    blurRadius: 5.0,
                  ),
                ],
              ),
              width: double.infinity,
              height: 125,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'مجموع السعر : ',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        total.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'عدد العناصر : ',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        counter.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.blueAccent, // width: double.infinity,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderScreen(prod)));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "استكمال الطلب",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.border_color,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  //Pub up Function--------------------------------------------------------------------------------------------
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
              radius: 17,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.check,
                color: Colors.white,
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("تمت ازالته من السلة "),
              Icon(
                Icons.remove_shopping_cart,
                color: Colors.blue,
              )
            ],
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();

            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => ShopLayout()));
          },
          textColor: Colors.blue,
          child: const Text('موافق'),
        ),
      ],
    );
  }
  //-----------------------------------------------------------------------------------------------------------

  void onNotification() {
    var ScaffoldKey;
    ScaffoldKey.currentState?.openDrawer();
  }
}



//--------------------------------------------------------------------------

