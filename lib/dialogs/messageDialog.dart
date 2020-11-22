import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Hunga/AppEngine.dart';
import 'package:Hunga/assets.dart';


class messageDialog extends StatefulWidget {
  var icon;
  Color iconColor;
  String title;
  String message;
  String yesText;
  String noText;
  bool cancellable;
  double iconPadding;

  messageDialog(
      this.icon, this.iconColor, this.title, this.message, this.yesText,
      {this.noText,
        bool this.cancellable = false,
        double this.iconPadding = 0});
  @override
  _messageDialogState createState() => _messageDialogState();
}

class _messageDialogState extends State<messageDialog> {
  var icon;
  Color iconColor;
  String title;
  String message;
  String yesText;
  String noText;
  bool cancellable;
  double iconPadding;
  bool showBack=false;
  bool hideUI=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icon = widget.icon;
    iconColor = widget.iconColor;
    title = widget.title;
    message = widget.message;
    yesText = widget.yesText;
    noText = widget.noText;
    cancellable = widget.cancellable;
    iconPadding = widget.iconPadding;

    Future.delayed(Duration(milliseconds: 200),(){
      hideUI=false;
      setState(() {});
    });
    Future.delayed(Duration(milliseconds: 500),(){
      showBack=true;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (cancellable)closePage((){ Navigator.pop(context);});
      },
      child: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            if (cancellable) closePage((){ Navigator.pop(context);});
          },
          child: AnimatedOpacity(
            opacity: showBack?1:0,duration: Duration(milliseconds: 300),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  color: black.withOpacity(.7),
                )),
          ),
        ),
        page()
      ]),
    );
  }

  page() {
    return OrientationBuilder(
      builder: (c,o){
        return AnimatedOpacity(
          opacity: hideUI?0:1,duration: Duration(milliseconds: 400),
          child: Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              constraints: BoxConstraints(
                maxWidth: getScreenWidth(context)>500?getScreenWidth(context)/2.5:double.infinity
              ),
              child: new Card(
                clipBehavior: Clip.antiAlias,
                color: white,elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Stack(
                        children: [
                              Center(
                                child: Container(
                                width: 60,
                                height: 60,
                                padding: EdgeInsets.all(
                                    iconPadding == null ? 0 : iconPadding),
                                decoration: BoxDecoration(
                                  border: Border.all(color: iconColor,width: 4),
                                  shape: BoxShape.circle,
                                ),
                                child: (icon is String)
                                    ? (Image.asset(
                                  icon,
                                  color: iconColor,
                                  width: 35,
                                  height: 35,
                                ))
                                    : Icon(
                                  icon,
                                  color: iconColor,
                                  size: 35,
                                )),
                              ),
                          Align(alignment: Alignment.topRight,
                            child: Opacity(
                              opacity: 1,
                              child: Image.asset(getMyAsset("ic_plain"),color: black.withOpacity(.3),
                                height: 12,),
                            ),)
                            ],
                      ),
                      addSpace(10),
                      Text(
                        title,
                        style: textStyle(true, 20, black),
                        textAlign: TextAlign.center,
                      ),
                      // if(message.isNotEmpty)addSpace(5),
                      if(message.isNotEmpty)Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            "$message",
                            style: textStyle(false, 16, black.withOpacity(.5)),
                            textAlign: TextAlign.center,
//                                    maxLines: 1,
                          ),
                        ),
                      ),
                      addSpace(15),
                      Row(mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
//                              height: 50,
                            child: FlatButton(
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                color: app_color,
                                onPressed: () {
                                  closePage((){ Navigator.pop(context,true);});
                                },
                                child: Text(
                                  yesText,
                                  style: textStyle(true, 14, white,height: 1.4),
                                )),
                          ),
                          if(noText!=null)addSpaceWidth(10),
                          if(noText!=null)Container(
//                          width: double.infinity,
//                              height: 50,
//                              margin: EdgeInsets.only(top: 5),
                            child: FlatButton(
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: app_color,width: 2)),
//                                    color: blue3,
                                onPressed: () {
                                  closePage((){ Navigator.pop(context,false);});
                                },
                                child: Text(
                                  noText,
                                  style: textStyle(true, 14, app_color,height: 1.4),
                                )),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  closePage(onClosed){
    showBack=false;
    setState(() {

    });
    Future.delayed(Duration(milliseconds: 100),(){
      Future.delayed(Duration(milliseconds: 100),(){
        hideUI=true;
        setState(() {});
      });
      onClosed();
    });
  }
}

