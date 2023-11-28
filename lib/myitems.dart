import 'package:flutter/material.dart';
import 'package:kumohbada/main.dart';
import 'package:kumohbada/registitem.dart';

import 'myauth.dart'; // MyAuth 클래스를 import

class MyItemsTabContent extends StatefulWidget {
  const MyItemsTabContent({Key? key}) : super(key: key);

  @override
  _MyItemsTabContentState createState() => _MyItemsTabContentState();
}

class _MyItemsTabContentState extends State<MyItemsTabContent> {
  final MyAuth _myAuth = MyAuth(); // MyAuth 클래스 인스턴스 생성

  void _refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 글 보기'),
      ),
      body: ListView.builder(
        itemCount: _myAuth.item.items.length,
        itemBuilder: (context, index) {
          final Item item = _myAuth.item.items[index];
          final String nickname = item.register!;

          return ListTile(
            leading: Image.network(item.imageUri!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WritingPage(
                    editItem: item,
                  ),
                ),
              ).then((result) {
                if (result == true) {
                  // 화면 refresh
                  _refreshState();
                }
              });
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title!, style: largeText),
                Text(item.price.toString(), style: boldText),
              ],
            ),
            subtitle: Row(
              children: [
                Text(item.location!),
                const Spacer(),
                Text(item.timestamp?.toDate().toString() ?? '대체텍스트'),

              ],
            ),
          );
        },
      ),
    );
  }
}
