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

  void _deleteItem(Item item) {
    // 아이템 삭제
    items.remove(item);
    _refreshState();
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // 수정 기능 호출
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
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // 삭제 기능 호출
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('삭제 확인'),
                          content: Text('이 항목을 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _deleteItem(item);
                                Navigator.of(context).pop();
                              },
                              child: Text('삭제'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('취소'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
