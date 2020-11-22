

 import 'package:Hunga/AppEngine.dart';
import 'package:Hunga/FoodMain.dart';
import 'package:Hunga/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListFoods extends StatefulWidget {
   @override
   _ListFoodsState createState() => _ListFoodsState();
 }

 class _ListFoodsState extends State<ListFoods> {


  List allItems = [
    {"name":"Veggie tomato mix",
    "image":getMyAsset("food1"),
    "price":1900},
    {"name":"Egg and cucumber",
    "image":getMyAsset("food2"),
    "price":1000},
    {"name":"Fried chicken mix",
    "image":getMyAsset("food3"),
    "price":1200},
    {"name":"Moi-moi and ekpa",
    "image":getMyAsset("food4"),
    "price":2900},
  ];

  List allFoodList = [];
  List foodList = [];

  TextEditingController searchController = TextEditingController();
  bool showCancel = false;
  FocusNode focusSearch = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusSearch.addListener(() {setState(() {});});

    for(int i=0;i<5;i++){allFoodList.addAll(allItems);}

    reload();
  }

  reload()async{
    String search = searchController.text.trim();
    foodList.clear();
    for(Map item in allFoodList){
      String name = item["name"]??"";
      if(search.isNotEmpty){
        if(name.toLowerCase().contains(search.toLowerCase())){
            int index = foodList.indexWhere((element) => element[name]==name);
            if(index==-1)foodList.add(item);
          }
      }else{
      foodList.add(item);
    }
    }
    setState(() {});
  }


  @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: default_white,
       body: page(),
     );
   }

   page(){

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
                child: Text("Available Meals",style: textStyle(true, 18,Colors.black),maxLines: 1,),
              ),
              // Image.asset(banner, width: 50, height: 50),
              addSpaceWidth(20)
            ],
          ),
        ),
        // addSpace(5),
        Container(
          height: 45,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
          decoration: BoxDecoration(
              color: white.withOpacity(.8),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: focusSearch.hasFocus?app_color: black.withOpacity(.1),width: focusSearch.hasFocus?2:1)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              addSpaceWidth(10),
              Icon(
                Icons.search,
                color: app_color.withOpacity(.5),
                size: 17,
              ),
              addSpaceWidth(10),
              new Flexible(
                flex: 1,
                child: new TextField(
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: false,
                  onSubmitted: (_) {
                    //reload();
                  },
                  decoration: InputDecoration(
                      hintText: "Search meals",
                      hintStyle: textStyle(
                        false,
                        15,
                        app_color.withOpacity(.5),
                      ),
                      border: InputBorder.none,isDense: true),
                  style: textStyle(false, 16, black),
                  controller: searchController,
                  cursorColor: black,
                  cursorWidth: 1,
                  focusNode: focusSearch,
                  keyboardType: TextInputType.text,
                  onChanged: (s) {
                    showCancel = s.trim().isNotEmpty;
                    setState(() {});
                    reload();
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    focusSearch.unfocus();
                    showCancel = false;
                    searchController.text = "";
                  });
                  reload();
                },
                child: showCancel
                    ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Icon(
                    Icons.close,
                    color: black,
                    size: 20,
                  ),
                )
                    : new Container(),
              )
            ],
          ),
        ),
        Expanded(
          child: StaggeredGridView.countBuilder(
            crossAxisCount:2,
            itemCount: foodList.length,
            itemBuilder: (BuildContext context, int index) {
              Map item = foodList[index];
              String name = item["name"];
              String image = item["image"];
              int price = item["price"];

              return GestureDetector(
                onTap: (){
                  pushAndResult(context, FoodMain(item,"$index"));
                },
                child: Container(
                  margin: EdgeInsets.only(top: index==1?50:0),
                  child: Stack(
                    children: [
                      Container(
                         margin: EdgeInsets.only(top: 30,),
                        width: double.infinity,
                        height: 300,
                        child: Card(
                          margin: EdgeInsets.all(0),
                          color: white,
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
//                          side: BorderSide(color: bm.isMale()?blue0:pink0,width: 3)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            child: Column(
                              children: [
                                addSpace(70),
                                Text(name,style: textStyle(true, 16, black),textAlign: TextAlign.center,),
                                addSpace(10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(getMyAsset("naira"),color: app_color,height: 10,),
                                    addSpaceWidth(3),
                                    Text(formatAmount(price.toString()),style: textStyle(true, 14, app_color),)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Hero(tag: "$index",child: Image.asset(image))
                    ],
                  ),
                ),
              );
            },
            padding: EdgeInsets.fromLTRB(20,0,20,0),
            staggeredTileBuilder: (int index) =>
            new StaggeredTile.extent(1, (index == 1) ? 250: 200),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
        )
      ],
    );
   }
 }
