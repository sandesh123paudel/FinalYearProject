import 'package:flutter/material.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';

import '../../widgets/responsive_text.dart';

class IndiChatScreen extends StatefulWidget {
  const IndiChatScreen({super.key});

  @override
  State<IndiChatScreen> createState() => _IndiChatScreenState();
}

class _IndiChatScreenState extends State<IndiChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: kVerticalMargin*3,left: kHorizontalMargin),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios_new_outlined,color: kDefaultIconLightColor,),
                  SizedBox(width: kHorizontalMargin),
                  ResponsiveText("Sandesh Paudel",textColor: Colors.white,fontWeight: FontWeight.w500,fontSize: 20,fontFamily: '',),

                ],
              ),
            ),
            SizedBox(height: kVerticalMargin),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: kHorizontalMargin*2,right: kHorizontalMargin*2,top: kVerticalMargin*2,bottom: 40.0),
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      topLeft: Radius.circular(32),
                    )
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: width/2),
                      padding:  EdgeInsets.all(kHorizontalMargin),
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                        color: kGreenShadowColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                        )
                      ),
                      child: ResponsiveText("Hello How are you?"),
                    ),
                    SizedBox(height: kVerticalMargin,),
                    Container(
                      margin: EdgeInsets.only(right: width/2),
                      padding:  EdgeInsets.all(kHorizontalMargin),
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                          color: kGreenBorderColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          )
                      ),
                      child: ResponsiveText("I am absolutely fine! What about you?"),
                    ),
                    Spacer(),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: kHorizontalMargin,right: kHorizontalMargin),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          children: [
                             Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(color: kPrimaryColor)
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(kHorizontalMargin/2),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(20)
                              ),
                                child: Center(child: Icon(Icons.send,color: kDefaultIconLightColor,)))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
