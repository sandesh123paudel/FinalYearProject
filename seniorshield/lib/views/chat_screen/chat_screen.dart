import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seniorshield/api/apis.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/models/user_model.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../../widgets/chat_user_card.dart';
import '../../widgets/dialogs.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<UserModel> _list = [];
  final List<UserModel> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message!.contains('pause')) {
          APIs.updateActiveStatus(false);
        }
        if (message.contains('resume')) {
          APIs.updateActiveStatus(true);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name,Email,....",
                        hintStyle: TextStyle(
                            color: kDefaultIconLightColor.withOpacity(0.7))),
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 18,
                        color: kDefaultIconLightColor.withOpacity(0.7),
                        letterSpacing: 0.9),
                    onChanged: (value) {
                      //search logic
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.fullName!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : ResponsiveText(
                    "Senior Sheild Chat",
                    textColor: kDefaultIconLightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            backgroundColor: kPrimaryColor,
            leading: Icon(
              Icons.chat_bubble_outlined,
              color: kDefaultIconLightColor,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                    _isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search,
                    color: kDefaultIconLightColor,
                  ))
            ],
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              foregroundColor: kDefaultIconLightColor,
              onPressed: () {
                _showMessageUpdateDialog();
              },
              child: const Icon(Icons.add_comment_rounded)),
          body: StreamBuilder(
              stream: APIs.getMyUsersId(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor,),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(color: kPrimaryColor,),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => UserModel.fromJson(e.data()))
                                    .toList() ??
                                [];
                            if (_list.isNotEmpty) {
                              return ListView.builder(

                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  padding:
                                      EdgeInsets.only(top: kVerticalMargin / 2),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index],
                                    );
                                    // return Text("Name: ${list[index]}");
                                  });
                            } else {
                              return const Center(
                                  child: ResponsiveText(
                                "No Connections Found",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ));
                            }
                        }
                      },
                      stream: APIs.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                    );
                }
              }),
        ),
      ),
    );
  }

  void _showMessageUpdateDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: kPrimaryColor,
                    size: 28,
                  ),
                  Text(' Add Email')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Add Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: kPrimaryColor, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User Cannot Be Added');
                          }
                          else {
                            setState(() {

                            });
                            Dialogs.showSnackbar(
                                context, 'User Added Successfully');
                          }
                        });

                      }

                    },
                    child: const Text(
                      'Add User',
                      style: TextStyle(color: kPrimaryColor, fontSize: 16),
                    ))
              ],
            ));
  }
}
