import 'dart:async';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Hunga/AppEngine.dart';
import 'package:Hunga/assets.dart';
import 'package:loading_indicator/loading_indicator.dart';

StreamController<dynamic> progressController = StreamController<dynamic>.broadcast();
bool progressDialogShowing = false;

class progressDialog extends StatefulWidget {
  String message;
  bool cancelable;
  double countDown;
  progressDialog(
      {this.message = "", this.cancelable = false, this.countDown = 0});
  @override
  _progressDialogState createState() => _progressDialogState();
}

class _progressDialogState extends State<progressDialog> {

  String message;
  bool cancelable;
  double countDown;
  StreamSubscription sub;

  bool showBack=false;
  bool hideUI=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message = widget.message ?? "";
    cancelable = widget.cancelable ?? false;
    countDown = widget.countDown ?? 0;
    sub = progressController.stream.listen((_) {
      if(_==false) {
        progressDialogShowing = false;
        closePage((){ Navigator.pop(context);});
      }else{
        if(_ is String){
          message=_;
          setState(() {});
        }
      }
    });

    Future.delayed(Duration(milliseconds: 200),(){
      hideUI=false;
      if(mounted)setState(() {});
    });
    Future.delayed(Duration(milliseconds: 500),(){
      showBack=true;
      if(mounted)setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sub.cancel();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Stack(fit: StackFit.expand, children: <Widget>[
        AnimatedOpacity(
          opacity: hideUI?0:showBack?1:0,duration: Duration(milliseconds: 300),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: black.withOpacity(.7),
              )),
        ),
        Center(
          child: AnimatedOpacity(
            opacity: showBack?0:1,duration: Duration(milliseconds: 300),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: black.withOpacity(.5),
                shape: BoxShape.circle
              ),
            ),
          )
        ),
        page(),

      ]),
      onWillPop: () {
        if (cancelable)closePage((){ Navigator.pop(context);});
      },
    );
  }

  page() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[

       /* Center(child:Container(
            width: 80,height: 80,
            child: LoadingIndicator(indicatorType: Indicator.ballScale, color: white,))),
        Center(
          child: Opacity(
            opacity: 1,
            child: Image.asset(
              ic_plain,
//              width: 40,
              height: 50,color: white,
            ),
          ),
        ),*/
        Center(
          child: Container(width: 50,height:50,child: LoadingIndicator(indicatorType: Indicator.ballRotate, color: white,)),
        ),

        Center(child: Image.asset(getMyAsset("plain_item"),width: 40,color: white.withOpacity(.7),),),


        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: new Container(),
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                countDown > 0
                    ? "$message (in ${countDown.toInt()} secs)"
                    : message.isEmpty?"Please wait":message,
                style: textStyle(false, 16, white),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20,0,20,20),
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Icon(
                        Icons.cancel,
                        color: white.withOpacity(.5),
                        size: 35,
                      )),
                ))
          ],
        ),
      ],
    );
  }

  closePage(onClosed){
    showBack=false;
    if(mounted)setState(() {

    });
    Future.delayed(Duration(milliseconds: 100),(){
      Future.delayed(Duration(milliseconds: 100),(){
        hideUI=true;
        if(mounted)setState(() {});
      });
      onClosed();
    });
  }
}
