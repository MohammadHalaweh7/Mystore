import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter/API/fetchData.dart';
import 'package:udemy_flutter/models/pendingStore/pendingStore_model.dart';
import 'package:udemy_flutter/modules/admin/admin_shops_details_screen.dart';
import 'package:udemy_flutter/modules/login/login_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  fetchData fetch = fetchData();

  Widget fetchPendingStores() {
    return FutureBuilder(
        future: fetch.allPendingStores(),
        builder: (contxt, snapchot) {
          var pendingStores = snapchot.data as List<pendingStoreModel>;
          return snapchot.data == null
              ? CircularProgressIndicator(
                  value: 0.8,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: pendingStores == null ? 0 : pendingStores.length,
                  itemBuilder: (context, index) {
                    print(pendingStores.length);
                    print('hello');
                    return myPendingStores(
                      pendingStores[index].id,
                      pendingStores[index].name,
                      pendingStores[index].description,
                      pendingStores[index].type,
                      pendingStores[index].phoneNumber,
                      pendingStores[index].location,
                      pendingStores[index].detailedLocation,
                      pendingStores[index].facebook,
                      pendingStores[index].instagram,
                      pendingStores[index].snapchat,
                      pendingStores[index].whatsapp,
                      pendingStores[index].locationOnMap,
                    );
                  });
        });
  }

  Widget myPendingStores(
      id,
      name,
      description,
      type,
      phoneNumber,
      location,
      detailedLocation,
      facebook,
      instagram,
      snapchat,
      whatsapp,
      locationOnMap) {
    return GestureDetector(
      //هاد بضم الكونتينر وكل اللي جواتو

      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminShopsDetailsScreen(
                    id,
                    name,
                    description,
                    type,
                    phoneNumber,
                    location,
                    detailedLocation,
                    facebook,
                    instagram,
                    snapchat,
                    whatsapp,
                    locationOnMap)));
      },
      child:
          //هاد الكونتينر بضم كلشي
          Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 1.0), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://www.nicepng.com/png/detail/254-2540580_we-create-a-customized-solution-to-meet-all.png'),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 113,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'اسم المتجر : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        'وصف المتجر : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),

                      Expanded(
                          child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                      // Text('${article['publishedAt']}',style: TextStyle(color: Colors.grey,fontSize: 20),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
              Icons.menu,
              color: Colors.blue,
              size: 35,
            )),
        title: Text(
          "الصفحة الرئيسية",
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
        ],
      ),

      body: fetchPendingStores(),
      //     //هاد بضم الكونتينر وكل اللي جواتو
      //     GestureDetector(
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => AdminShopsDetailsScreen()));
      //   },
      //   child:
      //       //هاد الكونتينر بضم كلشي
      //       Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(15.0),
      //       color: Colors.white,
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.grey,
      //           offset: Offset(0, 1.0), //(x,y)
      //           blurRadius: 5.0,
      //         ),
      //       ],
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.all(15.0),
      //       child: Row(
      //         children: [
      //           Container(
      //             width: 115,
      //             height: 115,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 image: DecorationImage(
      //                     image: NetworkImage(
      //                         'https://www.nicepng.com/png/detail/254-2540580_we-create-a-customized-solution-to-meet-all.png'),
      //                     fit: BoxFit.cover)),
      //           ),
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Expanded(
      //             child: Container(
      //               height: 113,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       Text(
      //                         'اسم المتجر : ',
      //                         style: TextStyle(
      //                             fontWeight: FontWeight.bold,
      //                             color: Colors.blue),
      //                       ),
      //                       Text(
      //                         'تنويرات الشروق',
      //                         maxLines: 2,
      //                         overflow: TextOverflow.ellipsis,
      //                         style: TextStyle(),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(
      //                     height: 3,
      //                   ),
      //                   Text(
      //                     'وصف المتجر : ',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold, color: Colors.blue),
      //                   ),

      //                   Expanded(
      //                       child: Text(
      //                     ' متجر متخصص لبيع كافة انواع التريات والاجهزة الكهربائية والمنزلية والمنزليةوالمنزليةوالمنزلية  ',
      //                     maxLines: 2,
      //                     overflow: TextOverflow.ellipsis,
      //                   )),
      //                   // Text('${article['publishedAt']}',style: TextStyle(color: Colors.grey,fontSize: 20),),
      //                 ],
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  void onNotification() {
    var ScaffoldKey;
    ScaffoldKey.currentState?.openDrawer();
  }
}



//--------------------------------------------------------------------------

