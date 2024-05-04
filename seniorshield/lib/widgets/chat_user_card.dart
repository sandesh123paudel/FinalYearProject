import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/models/message.dart';
import 'package:seniorshield/models/user_model.dart';
import 'package:seniorshield/services/my_date_utitl.dart';
import 'package:seniorshield/views/chat_screen/ind_chat_screen.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../api/apis.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(
            horizontal: kHorizontalMargin, vertical: kVerticalMargin / 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0.5,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => IndChatScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context,snapshot) {

            final data=snapshot.data?.docs;
            final list=data?.map((e) => Message.fromJson(e.data())).toList()??[];
            if(list.isNotEmpty)_message=list[0];
            return ListTile(
                tileColor: kDefaultIconLightColor,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: CachedNetworkImage(
                    width: width * 0.09,
                    height: height * 0.045,
                    imageUrl: widget.user.image.toString(),
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                title: ResponsiveText(
                  widget.user.fullName.toString(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: ResponsiveText(
                  _message!=null?
                  _message!.type==Type.image?'Image'
                      :
                  _message!.msg

                      :widget.user.about.toString(),
                  maxLines: 1,
                ),
                trailing:_message==null?null:
                    _message!.read.isEmpty && _message!.fromId!=APIs.user.uid?
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: kGreenShadowColor,
                      borderRadius: BorderRadius.circular(20)),
                ):ResponsiveText(MyDateUtil.getLastMessageTime(context: context, time: _message!.sent,showYear: false),fontSize: 12)
            );
          },
        )
      ),
    );
  }
}
