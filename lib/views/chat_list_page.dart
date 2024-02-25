// chat_list_view.dart

import 'package:weixin/models/chat_room_info.dart';
import 'package:weixin/viewmodels/chat_list_view_model.dart';
import 'package:weixin/views/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late ChatListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChatListViewModel();
    _viewModel.initChatRoomsListener();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: _ChatListView(),
    );
  }
}

class _ChatListView extends StatelessWidget {
  void _showPopupMenu(ChatInfoModel chatInfo, BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 0, 0, 0),
      items: [
        PopupMenuItem(
          child: GestureDetector(
            onTap: () async {
              await Provider.of<ChatListViewModel>(context, listen: false).deleteChatRoom(chatInfo.chatRoomId);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatListViewModel>(
      builder: (context, viewModel, child) {
        return StreamBuilder<List<ChatInfoModel>>(
          stream: viewModel.chatRoomsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3EB575))));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<ChatInfoModel> chatRooms = snapshot.data ?? [];

            if (chatRooms.isEmpty) {
              return Center(child: Text('No chat rooms found for the user.'));
            }

            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ListView.builder(
                          itemCount: chatRooms.length,
                          itemBuilder: (context, index) {
                            ChatInfoModel chatInfo = chatRooms[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomPage(chatRoomId: chatInfo.chatRoomId),
                                  ),
                                );
                              },
                              onLongPress: () {
                                _showPopupMenu(chatInfo, context);
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${chatInfo.otherUsername}',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${chatInfo.lastMessageContent}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: .2,
                                    color: Color.fromRGBO(220, 220, 220, .8),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
