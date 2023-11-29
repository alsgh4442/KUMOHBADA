import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'myauth.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  final MyAuth _myAuth = MyAuth();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference items =
        FirebaseFirestore.instance.collection('ItemData');

    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: items.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  Item item = Item.fromFirestore(snapshot.data!.docs[index]);
                  DateTime date = (item.timestamp as Timestamp).toDate();
                  String formattedTime = timeago.format(date, locale: 'ko');

                  return Card(
                    elevation: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeTabSub(item: item),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                item.imageUri ?? '대체이미지_URL',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(item.location!),
                                      const SizedBox(width: 5),
                                      const Text('•'),
                                      const SizedBox(width: 5),
                                      Text(formattedTime),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    NumberFormat('#,###', 'ko_KR')
                                            .format(item.price!) +
                                        '원',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  // 각 아이템 사이에 Divider 추가
                  return Divider(
                    height: 1,
                    color: Color.fromARGB(136, 73, 73, 73)!.withOpacity(1),
                    indent: 16, // 시작 부분의 공백
                    endIndent: 16, // 끝 부분의 공백
                  );
                },
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
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
  HomeTabSub({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(item.title!),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Image.network(item.imageUri!);
            } else if (index == 1) {
              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(item.imageUri!),
                    ),
                    SizedBox(width: 8.0),
                    Column(children: [
                      Text(item.register!,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(item.location!),
                    ]),
                    const Spacer(),
                    Column(children: [
                      Row(
                        children: List.generate(
                            5, // 별점을 표시하는 부분은 어떻게 처리할지 알려주셔야 합니다.
                            (index) => Icon(Icons.star, color: Colors.orange)),
                      ),
                      Text(timeago.format(
                          (item.timestamp as Timestamp).toDate(),
                          locale: 'ko')),
                    ]),
                  ]),
                ),
              );
            } else {
              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(item.description!),
                ),
              );
            }
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color.fromARGB(255, 211, 211, 211),
              thickness: 1,
              indent: 20,
              endIndent: 20,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                  '가격 : ${NumberFormat('#,###', 'ko_KR').format(item.price)}원'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: const Text("채팅하기"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
