import 'package:flutter/material.dart';
import 'package:kumohbada/main.dart';

class HomeTabContent extends StatefulWidget {
  const HomeTabContent({super.key});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  @override
  Widget build(BuildContext context) {
    //위젯 빌드 함수
    Widget? buildListView(context, index) {
      return ListTile(
        leading: Image.asset("images/EmptyImage.png"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeTabSub(item: items[index])),
          );
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(items[index].title, style: largeText),
            Text(items[index].price.toString(), style: boldText)
          ],
        ),
        subtitle: Row(children: [
          Text(items[index].regitUser.location),
          const Spacer(),
          Text(items[index].regiTime)
        ]),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: buildListView,
      separatorBuilder: (context, index) {
        return const Divider(color: Colors.black);
      },
    );
  }
}

class HomeTabSub extends StatelessWidget {
  Item item;
  HomeTabSub({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(children: [
        Image.asset("images/EmptyImage.png"),
        Card(
          child: Row(children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset("images/EmptyProfileImage.png"),
            ),
            Column(children: [
              Text(item.regitUser.nickname, style: largeText),
              Text(item.regitUser.location),
            ]),
            const Spacer(),
            Column(children: [
              Text('Star : ${item.regitUser.qi.toString()}'),
              Text(item.regiTime),
            ]),
          ]),
        ),
        Card(child: Text(item.describtion)),
      ]),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: [
          Text('가격 : ${item.price.toString()}'),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: const Text("채팅하기"),
          )
        ],
      )),
    );
  }
}
