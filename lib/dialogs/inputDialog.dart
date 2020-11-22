import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';


import '../AppEngine.dart';
import '../Assets.dart';

class inputDialog extends StatefulWidget {
  String title;
  String message;
  String hint;
  String okText;
  TextEditingController editingController;
  int clickBack = 0;
  TextInputType inputType;
  int maxLength;
  bool allowEmpty = false;

  inputDialog(this.title,
      {this.message, this.hint, this.okText, this.inputType, this.maxLength = 10000, this.allowEmpty=false}); /*{
    this.title = title;
    this.message = message;
    this.hint = hint;
    this.okText = okText;
    this.inputType = inputType;
    this.maxLength = maxLength;
    this.allowEmpty = allowEmpty;
  }*/

  @override
  _inputDialogState createState() => _inputDialogState();
}

class _inputDialogState extends State<inputDialog> {
  String title;
  String message;
  String hint;
  String okText;
  TextEditingController editingController;
  int clickBack = 0;
  TextInputType inputType;
  int maxLength;
  bool allowEmpty = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message= widget.message;
    editingController = new TextEditingController(text: message);
    title= widget.title;
    hint= widget.hint;
    okText= widget.okText;
    inputType= widget.inputType;
    maxLength= widget.maxLength;
    allowEmpty= widget.allowEmpty;
  }

  @override
  Widget build(BuildContext c) {

    return Scaffold(backgroundColor: transparent,
      body: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: black.withOpacity(.7),
              )),
        ),
        page()
      ]),
    );
  }


  page() {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
        height: 300,
        child: Card(
          color: white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20,10,20,10),
                child: Text(
                  title,
                  style: textStyle(true, 18, black),
                ),
              ),
              AnimatedContainer(duration: Duration(milliseconds: 500),
                width: double.infinity,
                height: errorText.isEmpty?0:40,
                color: red0,
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child:Center(child: Text(errorText,style: textStyle(true, 16, white),)),
              ),
              new Expanded(
                flex: 1,
                child: Container(
                  color: default_white,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(0),
                    child: new TextField(
                      //textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: true,
                      maxLength: null,
                      decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: textStyle(
                            false,
                            30,
                            black.withOpacity(.5),
                          ),
                          border: InputBorder.none),
                      style: textStyle(false, 30, black),
                      controller: editingController,
                      cursorColor: black,
                      cursorWidth: 1,
                      maxLines: null,
                      keyboardType:
                      inputType == null ? TextInputType.multiline : inputType,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.all(15),
                child:FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: app_color,
                    onPressed: () {
                      String text = editingController.text.trim();
                      if (text.isEmpty && !allowEmpty) {
                        showError( "Nothing to update");
                        return;
                      }
                      if (text.length > maxLength) {
                        showError(
                            "Text should not be more than $maxLength characters");
                        return;
                      }
                      Navigator.pop(context, text);
                    },
                    child: Text(
                      okText == null ? "OK" : okText,
                      style: textStyle(true, 16, white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  String errorText ="";
  showError(String text){
    errorText=text;
    setState(() {

    });
    Future.delayed(Duration(seconds: 1),(){
      errorText="";
      setState(() {

      });
    });
  }
}