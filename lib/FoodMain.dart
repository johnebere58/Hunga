

 import 'package:Hunga/AppEngine.dart';
import 'package:Hunga/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppEngine.dart';
import 'AppEngine.dart';
import 'AppEngine.dart';

class FoodMain extends StatefulWidget {
  Map item;
  String heroKey;
  FoodMain(this.item,this.heroKey);
   @override
   _FoodMainState createState() => _FoodMainState();
 }

 class _FoodMainState extends State<FoodMain> {

  @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: default_white,
       body: page(),
     );
   }

   page(){

     Map item = widget.item;
     String name = item["name"];
     String image = item["image"];
     int price = item["price"];

     return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 40,bottom: 0),
          // color: app_color,
          child: Row(
            children: [
              Container(
                  width: 50,
                  height: 50,padding: EdgeInsets.all(0),
                  child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios,color: black,))),
              Flexible(
                fit: FlexFit.tight,
                child: Text("",style: textStyle(true, 18,Colors.black),maxLines: 1,),
              ),
              // Image.asset(banner, width: 50, height: 50),
              Icon(Icons.star_border,),
              addSpaceWidth(20)
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // color: black,
                  height: 300,
                  child: Stack(children: [
                    Center(
                      child: Hero(tag: widget.heroKey,child: Image.asset(
                        image,
                        fit: BoxFit.cover,)),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name,style: textStyle(true, 20, black),textAlign: TextAlign.center,),
                          addSpace(10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(getMyAsset("naira"),color: app_color,height: 12,),
                              addSpaceWidth(3),
                              Text(formatAmount(price.toString()),style: textStyle(true, 16, app_color),)
                            ],
                          ),
                          addSpace(30)
                        ],
                      ),
                    )
                  ]),
                ),

                Text("Delivery Info",style: textStyle(true, 14, Colors.black),),
                addSpace(5),
                Text("This meal will be delivered to a your billing address",style: textStyle(false, 13, black.withOpacity(.5)),),
                addSpace(20),
                Text("Return Policy",style: textStyle(true, 14, Colors.black),),
                addSpace(5),
                Text("All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.",
                  style: textStyle(false, 13, black.withOpacity(.5)),),
                addSpace(20),

              ],
            ),
          ),
        ),
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: FlatButton(
            onPressed: (){
              // pushAndResult(context, ListFoods(),
              //     transitionBuilder: fadeTransition);
              opay(double.parse(price.toString()));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            color: app_color,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Order Now",style: textStyle(true, 15, white),),
                addSpaceWidth(5),
                Icon(Icons.payment,color: Colors.white,size: 16,)
              ],
            ),
          ),
        )
      ],
    );
   }

   opay(double amount)async{
//    showProgress(true, context);
     MethodChannel _methodChannel = MethodChannel('channel.john');
     bool success = false;
     try {
       success = await _methodChannel.invokeMethod(
           "pay",{
             "amount":amount,
         "id":generateNumber(),
       });
     } on PlatformException catch(e){
//       showProgress(false, context);
       print(e.message);
     }
     print(success);
//    showProgress(false, context);
   }
 }
