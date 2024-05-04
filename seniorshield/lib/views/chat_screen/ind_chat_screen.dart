

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniorshield/api/apis.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/models/user_model.dart';
import 'package:seniorshield/services/my_date_utitl.dart';
import 'package:seniorshield/views/chat_screen/view_profile.dart';
import 'package:seniorshield/widgets/message_card.dart';
import 'package:seniorshield/widgets/responsive_text.dart';


import '../../constants/util/util.dart';
import '../../models/message.dart';

class IndChatScreen extends StatefulWidget {
  final UserModel user;

  const IndChatScreen({super.key, required this.user});

  @override
  State<IndChatScreen> createState() => _IndChatScreenState();
}

class _IndChatScreenState extends State<IndChatScreen> {
  List<Message> _list = [];

  final _textcontroller= TextEditingController();

  bool _showEmoji=false, _isUploading=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: ()
        {
          if(_showEmoji){
            setState(() {
              _showEmoji=!_showEmoji;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.green.shade100,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            flexibleSpace: _appBar(),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(

                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child:SizedBox(),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
        
                          _list =data?.map((e) => Message.fromJson(e.data())).toList()??[];
        
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: kVerticalMargin / 2),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return const Center(
                                child: ResponsiveText(
                              "Say Hi! 👋 To Start Conversation",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ));
                          }
                      }
                    },
                    stream: APIs.getAllMessages(widget.user)),
              ),
              //for uploading
              if(_isUploading)
              Align(
                alignment: Alignment.centerRight,
                  child: Padding(
                    padding:  EdgeInsets.only(right: kHorizontalMargin*2),
                    child: const CircularProgressIndicator(color: kPrimaryColor,strokeWidth: 2,),
                  )),
              _chatInput(),
              if(_showEmoji)
              SizedBox(
                height: height*0.35,
                child: EmojiPicker(
                  textEditingController: _textcontroller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                  config: Config(
                    backspaceColor: kPrimaryColor,
                    bgColor: Colors.green.shade100,
                    columns: 7,
        
                  ),
                ),
              )
        
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: widget.user)));
      },
      child: StreamBuilder(
        stream:APIs.getUserInfo(widget.user),
        builder: (context,snapshot){

          final data=snapshot.data?.docs;
          final list=data?.map((e) => UserModel.fromJson(e.data())).toList()??[];

          return Padding(
            padding: EdgeInsets.only(top: kVerticalMargin * 2),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: kDefaultIconLightColor,
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(height * 0.03),
                  child: CachedNetworkImage(
                    width: width * 0.11,
                    height: height * 0.05,
                    fit: BoxFit.fill,
                    imageUrl:list.isNotEmpty? list[0].image.toString(): widget.user.image.toString(),
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                SizedBox(width: kHorizontalMargin),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      list.isNotEmpty?list[0].fullName.toString():widget.user.fullName.toString(),
                      textColor: kDefaultIconLightColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    ResponsiveText(
                      list.isNotEmpty?
                          list[0].isOnline!?'Online':
                      MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive.toString() ):
          MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive.toString() )
                      ,
                      textColor: kDefaultIconLightColor,
                      fontSize: 12,
                    )
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kHorizontalMargin, vertical: kVerticalMargin),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: kDefaultIconLightColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji=!_showEmoji);

                      },
                      icon: const Icon(
                        Icons.emoji_emotions_rounded,
                        color: kPrimaryColor,
                      )),
                   Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap:()
                        {
                          setState(() {

                            if(_showEmoji)
                            _showEmoji=!_showEmoji;
                          });
                        },
                    controller: _textcontroller,
                    style:const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    decoration:const  InputDecoration(
                      hintText: 'Type your message',
                      hintStyle: TextStyle(color: kPrimaryColor),
                      border: InputBorder.none,
                    ),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 10);
                        if (image != null) {
                          print('ImagePath: ${image.path}');
                          setState(()=>_isUploading=true );

                          await APIs.sendChatImage(widget.user,File(image.path));
                          setState(()=>_isUploading=false );

                        }
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: kPrimaryColor,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //picking multiple images
                        final List<XFile> images = await picker.pickMultiImage(
                            imageQuality:10);
                        for(var i in images){
                          log("Image Path:${i.path}");
                          setState(()=>_isUploading=true );
                          await APIs.sendChatImage(widget.user,File(i.path));
                          setState(()=>_isUploading=false );


                        }
                       
                      },
                      icon: const Icon(
                        Icons.image,
                        color: kPrimaryColor,
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if(_textcontroller.text.isNotEmpty)
                {
                  if(_list.isEmpty)
                  {
                    APIs.sendFirstMessage(widget.user, _textcontroller.text,Type.text);
                  }
                  else{
                    APIs.sendMessage(widget.user, _textcontroller.text,Type.text);

                  }
                  _textcontroller.text='';
                }
            },
            minWidth: 0,
            padding:const EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
            shape:const  CircleBorder(),
            color: kPrimaryColor,
            child: Icon(
              Icons.send,
              color: kDefaultIconLightColor,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
