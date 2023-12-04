import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'backend.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Chat _chat = Chat();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _chat.showChatList(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ChatSubPage(
                        snapshot.data[index], snapshot.data[index][SENDER_UID]);
                  }));
                },
                child: ListTile(
                  leading: Icon(Icons.chat), // Add an icon for each chat item
                  title: Text(snapshot.data[index][RECEIVER]),
                  subtitle: Text('Last message...'), // Add a placeholder for the last message
                ),
              );
            },
            separatorBuilder: _buildSeparator,
            itemCount: snapshot.data.length,
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No chat exist"));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildSeparator(BuildContext context, index) {
    return Divider(
      height: 1,
      color: Color.fromARGB(136, 73, 73, 73)!.withOpacity(1),
      indent: 16, // 시작 부분의 공백
      endIndent: 16, // 끝 부분의 공백
    );
  }
}

class ChatSubPage extends StatefulWidget {
  Map<String, dynamic>? _item;
  String? _senderUid;
  ChatSubPage(item, senderUid, {super.key}) {
    _item = item;
    _senderUid = senderUid;
  }

  @override
  State<ChatSubPage> createState() {
    return _ChatSubPageState();
  }
}

class _ChatSubPageState extends State<ChatSubPage> {
  TextEditingController txtcontrollor = TextEditingController();
  final MyUser _myUser = MyUser.instance;
  final Chat _chat = Chat();
  var chatRoom;

  Widget buildChatContent(context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return const Text("err!");
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Text("no data");
    }

    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      reverse: true,
      itemBuilder: (context, index) {
        var doc = snapshot.data!.docs[index];
        var data = doc.data() as Map<String, dynamic>;
        bool isMe = data[SENDER] == _myUser.getUid; // Check if the message is sent by the user

        return Container(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: isMe ? Colors.orange : Colors.grey, // Change the color based on the sender
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              data[CONTENT],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        );
      },
    );
  }

  _initChatRoom() async {
    var result = await _chat.getChattingRoom(
        item: widget._item!, senderUid: widget._senderUid!);
    setState(() {
      chatRoom = result;
    });
  }

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initChatRoom();
    });
  }

  @override
  Widget build(BuildContext context) {
    //navigator push로 정보를 가져온다. 어떤 방식이든 상관없다.
    //아이템 정보 전체이든, 등록자 uid이든 상대방 유저의 uid만 있으면 됨.
    //상대방 uid를 otherUid 파라미터에 넣으면 채팅방 생성 및 로드 가능.

    Future<void> sendMessage() async {
      await chatRoom.add({
        CONTENT: txtcontrollor.text,
        SENDER: _myUser.getUid,
        TIMESTAMP: FieldValue.serverTimestamp(),
      });
      txtcontrollor.clear(); // Clear the text field after sending a message
    }

    return Scaffold(
      appBar: AppBar(title: const Text("chat")),
      body: StreamBuilder(
        stream: chatRoom.orderBy(TIMESTAMP, descending: true).snapshots(),
        builder: buildChatContent,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0), // Add padding around the text field
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: txtcontrollor,
              decoration: const InputDecoration(
                labelText: "텍스트를 입력하세요",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onSubmitted: (text) {
                sendMessage(); // Send the message when the enter key is pressed
              },
            ),
          ),
          SizedBox(
              width: 10.0), // Add space between the text field and the button
          ElevatedButton(
            onPressed: sendMessage,
            child: Icon(Icons.send), // Use arrow icon instead of text
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
