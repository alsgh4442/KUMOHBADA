import 'package:flutter/material.dart';
import 'package:kumohbada/main.dart';
import 'package:kumohbada/registitem.dart';

class MyItemsTabContent extends StatefulWidget {
  const MyItemsTabContent({Key? key}) : super(key: key);

  @override
  _MyItemsTabContentState createState() => _MyItemsTabContentState();
}

class _MyItemsTabContentState extends State<MyItemsTabContent> {
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
        itemCount: items.length,
        itemBuilder: (context, index) {
          final Item item = items[index];
          final User user = item.regitUser;

          return ListTile(
            leading: Image.asset("assets/images/baby_book.png"),
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
                Text(item.title, style: largeText),
                Text(item.price.toString(), style: boldText),
              ],
            ),
            subtitle: Row(
              children: [
                Text(user.location),
                const Spacer(),
                Text(item.regiTime),
              ],
            ),
          );
        },
      ),
    );
  }
}
