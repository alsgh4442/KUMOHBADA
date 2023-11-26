import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kumohbada/main.dart';
import 'package:intl/intl.dart';
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
            Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeTabSub(item: items[index]),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/baby_book.png",
                        width: 100, // 원하는 너비로 설정하세요.
                        height: 100, // 원하는 높이로 설정하세요.
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[index].title, style: largeText),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].regitUser.location,
                                ),
                                const SizedBox(width: 5), // 원하는 너비로 설정하세요.
                                const Text('•'),
                                const SizedBox(width: 5), // 원하는 너비로 설정하세요.
                                Text(items[index].regiTime),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                                NumberFormat('#,###', 'ko_KR')
                                        .format(items[index].price) +
                                    '원',
                                style: boldText),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        key: _refreshIndicatorKey,
        onRefresh: refreshData,
        child: ListView.separated(
          itemCount: buildListView().length,
          itemBuilder: (context, index) => buildListView()[index],
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color.fromARGB(255, 211, 211, 211), // 색상을 변경하세요.
              thickness: 1, // 선의 두께를 조절하세요.
              indent: 20, // 선이 시작하는 위치를 조절하세요.
              endIndent: 20,
            );
          },
        ),
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
      extendBodyBehindAppBar: true, // Add this line
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // Set the elevation to 0
      ),
      body: Container(
        color: Colors.white, // Set the background color here
        child: ListView.separated(
          itemCount: 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Image.asset("assets/images/baby_book.png");
            } else if (index == 1) {
              return Card(
                elevation: 0, // Set the elevation here
                child: Padding( // Add padding
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset("assets/images/baby_book.png"),
                    ),
                    SizedBox(width: 8.0), // Add space
                    Column(children: [
                      Text(item.regitUser.nickname, style: largeText),
                      Text(item.regitUser.location),
                    ]),
                    const Spacer(),
                    Column(children: [
                      Row(
                        children: List.generate(item.regitUser.qi,
                            (index) => Icon(Icons.star, color: Colors.orange)),
                      ),
                      Text(item.regiTime),
                    ]),
                  ]),
                ),
              );
            } else {
              return Card(
                  elevation: 0, // Set the elevation here
                  child: Padding( // Add padding
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.describtion),
                  ));
            }
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color.fromARGB(255, 211, 211, 211), // 색상을 변경하세요.
              thickness: 1, // 선의 두께를 조절하세요.
              indent: 20, // 선이 시작하는 위치를 조절하세요.
              endIndent: 20,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 0, // Set the elevation here
          child: Padding( // Add padding
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('가격 : ${NumberFormat('#,###', 'ko_KR').format(item.price)}원'), // Use the formatter here
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("채팅하기"),
                )
              ],
            ),
          )),
    );
  }
}
