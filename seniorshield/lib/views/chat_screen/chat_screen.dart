import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/images.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/services/database.dart';
import 'package:seniorshield/views/chat_screen/individual_chat_screen.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSearch = false;

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) async {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      isSearch = true;
    });
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      QuerySnapshot docs = await DatabaseMethods().Search(value);
      for (int i = 0; i < docs.docs.length; i++) {
        queryResultSet.add(docs.docs[i].data());
      }
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['username'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: kHorizontalMargin * 2,
                    top: kVerticalMargin,
                    right: kHorizontalMargin * 2,
                    bottom: kVerticalMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isSearch
                        ? Expanded(
                            child: TextField(
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search People",
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: kDefaultIconLightColor,
                                  fontFamily: 'Roboto Mono'),
                            ),
                            style: TextStyle(color: Colors.white),
                          ))
                        : ResponsiveText(
                            "Senior Shield Chat",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            textColor: kDefaultIconLightColor,
                          ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        isSearch = true;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: kGreenShadowColor,
                            borderRadius: BorderRadius.circular(32)),
                        child: Icon(
                          Icons.search,
                          size: 20,
                          color: kDefaultIconLightColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: kVerticalMargin * 1.5,
                        horizontal: kHorizontalMargin * 1.5),
                    width: width,
                    decoration: BoxDecoration(
                        color: kDefaultIconLightColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(32),
                          topLeft: Radius.circular(32),
                        )),
                    child: Column(
                      children: [
                        isSearch
                            ? ListView(
                                padding: EdgeInsets.only(
                                    left: kHorizontalMargin,
                                    right: kHorizontalMargin),
                                primary: false,
                                shrinkWrap: true,
                                children: tempSearchStore.map((element) {
                                  return buildResultCard(element);
                                }).toList())
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndiChatScreen()));
                                    },
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          child: Image.asset(
                                            human,
                                            height: 50,
                                            width: 50,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(60),
                                        ),
                                        SizedBox(
                                          width: kHorizontalMargin,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ResponsiveText(
                                              "Sandesh Paudel",
                                              textColor: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              fontFamily: '',
                                            ),
                                            ResponsiveText("Hello Dear!!",
                                                textColor: Colors.grey),
                                          ],
                                        ),
                                        Spacer(),
                                        ResponsiveText(
                                          "04:30 PM",
                                          textColor: kBlack600,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: kVerticalMargin),
                                ],
                              ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kVerticalMargin),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              ClipRRect(
                child: Image.asset(human,height: 50,),
                borderRadius: BorderRadius.circular(8),
              ),
              SizedBox(width: kHorizontalMargin),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText(
                    data["fullName"],
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  SizedBox(height: kVerticalMargin/4),
                  ResponsiveText(data["username"],
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
