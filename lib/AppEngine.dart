

import 'dart:math';

import 'package:Hunga/assets.dart';
import 'package:Hunga/dialogs/listDialog.dart';
import 'package:Hunga/dialogs/messageDialog.dart';
import 'package:Hunga/dialogs/progressDialog.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

getScreenHeight(context){
  return MediaQuery.of(context).size.height;
}
getScreenWidth(context){
  return MediaQuery.of(context).size.width;
}

String getMyAsset(String name,{String ext="png"}){
  return 'assets/icons/$name.$ext';
}

imageItem(icon,double size,color,{bool ignoreWidth=false}){
  return icon is IconData?Icon(icon,size: size,color: color,)
      :Image.asset(icon,width: ignoreWidth?null:size,height: size,color: color,);
}


String formatAmount(var text,{int decimal=2}) {
  if (text == null) return "0.00";
  text = text.toString();
  if (text.toString().trim().isEmpty) return "0.00";
  text = text.replaceAll(",", "");
  try {
    text = double.parse(text).toStringAsFixed(decimal);
  } catch (e) {}
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  return text.replaceAllMapped(reg, mathFunc);
}

textStyle(bool bold, double size, color,
    {underlined = false, double shadowRadius=0, bool love = false,double height=1.4}) {
  return TextStyle(
      color: color,height:height,
      fontWeight: FontWeight.normal,
      fontFamily:
      love ? (!bold ? "curve" : "curveB") : bold ? "PoppinsB" : "Poppins",
      fontSize: size,
      shadows: shadowRadius==0
          ? null
          : (<Shadow>[
        Shadow(offset: Offset(shadowRadius,shadowRadius), blurRadius: 6.0, color: black.withOpacity(.5)),
      ]),
      decoration: underlined ? TextDecoration.underline : TextDecoration.none);
}

SizedBox addSpace(double size) {
  return SizedBox(
    height: size,
  );
}

addSpaceWidth(double size) {
  return SizedBox(
    width: size,
  );
}

checkBox(bool selected, {double size: 13, checkColor = app_color}) {
  return new Container(
    //padding: EdgeInsets.all(2),
    child: Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: blue09,
          border: Border.all(color: black.withOpacity(.4), width: 1.5)),
      child: Container(
        width: size,
        height: size,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? checkColor : transparent,
        ),
        child: Icon(
          Icons.check,
          size: size <= 16 ? 8 : null,
          color: !selected ? transparent : white,
        ),
      ),
    ),
  );
}

showListDialog(context,List items, onSelected,
    {title, images, bool useTint = true,selections,bool returnIndex=false,
      bool singleSelection=false}){
  pushAndResult(context,
      listDialog(items,
        title: title, images: images,useTint: useTint,selections: selections,
        singleSelection: singleSelection,),result: (_){
        if(_ is List){
          onSelected(_);
        }else{
          onSelected(returnIndex?items.indexOf(_):_);
        }
      },opaque: false,
      transitionBuilder:scaleTransition,
      transitionDuration: Duration(milliseconds: 800));
}

Container addLine(
    double size, color, double left, double top, double right, double bottom) {
  return Container(
    height: size,
    width: double.infinity,
    color: color,
    margin: EdgeInsets.fromLTRB(left, top, right, bottom),
  );
}


pushAndResult(context, item, {result,opaque=false,bool replace=false,
  transitionBuilder,transitionDuration}) {
  if(replace){
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionsBuilder: transitionBuilder??slideTransition,
            transitionDuration: transitionDuration??Duration(milliseconds: 300),
            opaque: opaque,
            pageBuilder: (context, _, __) {
              return item;
            })).then((_) {
      if (_ != null) {
        if (result != null) result(_);
      }
    });
    return;
  }
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: transitionBuilder??slideTransition,
          transitionDuration: transitionDuration??Duration(milliseconds: 300),
          opaque: opaque,
          pageBuilder: (context, _, __) {
            return item;
          })).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });

}


Widget slideTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  var begin = Offset(1.0, 0.0);
  var end = Offset.zero;
  var tween = Tween(begin: begin, end: end);
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );;
}
Widget fadeTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}


void showProgress(bool show, BuildContext context,
    {String msg, bool cancellable = true}) {
  if (!show) {
    progressDialogShowing = false;
    progressController.add(false);
    return;
  }
  progressDialogShowing = true;
  pushAndResult(
      context,
      progressDialog(
        message: msg,
        cancelable: cancellable,
      ),
      transitionBuilder:scaleTransition,
      transitionDuration: Duration(milliseconds: 800));
}
void showMessage(context, icon, iconColor, title, message,
    {int delayInMilli = 0,
      clickYesText = "OK",
      onClicked,
      clickNoText,
      bool cancellable = true,
      double iconPadding,
      bool = true}) {
  Future.delayed(Duration(milliseconds: delayInMilli), () {
    pushAndResult(
        context,
        messageDialog(
          icon,
          iconColor,
          title,
          message,
          clickYesText,
          noText: clickNoText,
          cancellable: cancellable,
          iconPadding: iconPadding,
        ),
        result: onClicked,opaque: false,
        transitionBuilder:scaleTransition,
        transitionDuration: Duration(milliseconds: 800)
    );
  });
}

Widget scaleTransition (
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    ){

  return
    ScaleTransition(
      scale: Tween<double>(
        begin: 1.5,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: child,
    );
}

showErrorDialog(context,String message,{onOkClicked,bool cancellable=true}){
  showMessage(context, Icons.error, red0, "Oops!",
      makeFirstUpper(message),delayInMilli: 500,cancellable: cancellable,onClicked: (_){
        if(_==true){
          if(onOkClicked!=null)onOkClicked();
        }
      });
}

showSuccessDialog(context,String message,{onOkClicked,bool cancellable=true}){
  showMessage(context, Icons.check, app_color, "Successful",
      message,delayInMilli: 500,cancellable: cancellable,onClicked: (_){
        if(_==true){
          if(onOkClicked!=null)onOkClicked();
        }
      });
}


makeFirstUpper(String text){
  if(text.trim().isEmpty || text.trim().length==2)return text;

  return text.substring(0,1).toUpperCase()+text.substring(1);
}

generateNumber() {
  String policyNumber = '';
  String possibleRef = 'ABCDE01FGHIJLLKDNKLMLSML890908497439HHKKVFTDRTQU23KLMNO45PGRST67UVWX89YX';
  for (int i = 0; i < 5; i++) {
    policyNumber += possibleRef[Random().nextInt(possibleRef.length)];
  }
  return policyNumber;
}