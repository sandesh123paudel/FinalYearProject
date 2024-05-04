

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/services/my_date_utitl.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../api/apis.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {

  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid ==widget.message.fromId?_greenMessage():_greenShadeMessage();
  }



  Widget _greenShadeMessage()
  {
    if (widget.message.read.isEmpty) {
       APIs.updateMessageReadStatus(widget.message);
      log("Message read updated");

    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type==Type.image?kHorizontalMargin:kHorizontalMargin*2),
            margin: EdgeInsets.symmetric(horizontal: kHorizontalMargin,vertical: kVerticalMargin),
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomRight: Radius.circular(32),
          
              )
          
            ),
            child: widget.message.type==Type.text?
            ResponsiveText(widget.message.msg,fontSize: 16,)
                :

            ClipRRect(
              borderRadius: BorderRadius.circular(height * 0.03),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: widget.message.msg,
                errorWidget: (context, url, error) =>
                const CircleAvatar(child: Icon(Icons.image,size: 70,)),
              ),
            ),
          ),
        ),
        
        Padding(
          padding:  EdgeInsets.only(right: kHorizontalMargin*1.5),
          child:ResponsiveText(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),textColor: Colors.black38,),

        )
      ],
    );
  }

  Widget _greenMessage()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            SizedBox(width: kHorizontalMargin),
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            SizedBox(width: kHorizontalMargin/2),
            ResponsiveText(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),textColor: Colors.black38,),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type==Type.image?kHorizontalMargin:kHorizontalMargin*2),
            margin: EdgeInsets.symmetric(horizontal: kHorizontalMargin,vertical: kVerticalMargin),
            decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),

                )

            ),
            child:widget.message.type==Type.text?
            ResponsiveText(widget.message.msg,fontSize: 16,)
                :

            ClipRRect(
              borderRadius: BorderRadius.circular(height * 0.01),
              child: CachedNetworkImage(
                placeholder:(context,url)=>Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const CircularProgressIndicator(strokeWidth:2 ,color: kPrimaryColor,),
                ) ,
                fit: BoxFit.fill,
                imageUrl: widget.message.msg,
                errorWidget: (context, url, error) =>
                const CircleAvatar(child: Icon(Icons.image,size: 70,)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
