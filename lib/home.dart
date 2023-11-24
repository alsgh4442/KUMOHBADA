import 'package:flutter/material.dart';
import 'package:kumohbada/main.dart';

class HomeTabContent extends StatefulWidget {
  final String selectedCategory;
  const HomeTabContent({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    //위젯 빌드 함수
    List<Widget> buildListView() {
      // 필터링된 아이템 리스트
      List<Widget> filteredItems = [];

      // 선택된 카테고리가 "전체"인 경우 모든 아이템을 보여줍니다.
      if (widget.selectedCategory == '전체') {
        for (var index = 0; index < items.length; index++) {
          filteredItems.add(
            ListTile(
              leading: Image.asset("assets/images/baby_book.png"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeTabSub(item: items[index]),
                  ),
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
                Text(items[index].regiTime),
              ]),
            ),
          );
        }
      } else {
        // 선택된 카테고리에 맞는 아이템만 필터링하여 보여줍니다.
        for (var index = 0; index < items.length; index++) {
          if (items[index].category == widget.selectedCategory) {
            filteredItems.add(
              ListTile(
                leading: Image.asset("assets/images/baby_book.png"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeTabSub(item: items[index]),
                    ),
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
                  Text(items[index].regiTime),
                ]),
              ),
            );
          }
        }
      }
      return filteredItems;
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: refreshData,
      child: ListView.separated(
        itemCount: buildListView().length,
        itemBuilder: (context, index) => buildListView()[index],
        separatorBuilder: (context, index) {
          return const Divider(color: Colors.black);
        },
      ),
    );
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _refreshIndicatorKey.currentState?.show(atTop: false);
    });
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
        Image.asset("assets/images/baby_book.png"),
        Card(
          child: Row(children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset("assets/images/baby_book.png"),
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
