import 'package:flutter/material.dart';
import 'chat.dart';
import 'home.dart';
import 'category.dart';
import 'registitem.dart';

void main() => runApp(const MyApp());

//////페이지 이동을 위한 상수 및 함수//////////////////////////////////////////////
const String FLOATSUB = "floatsub";
const String CATEGORYSUB = "categorysub";
const String ALERTSUB = "alertsub";
const String SEARCHSUB = "searchsub";

Function gotoSub =
    (BuildContext context, String cls, [String? selectedLocation]) {
  switch (cls) {
    case ALERTSUB:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AlertSub()));
      break;
    case SEARCHSUB:
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchSub(selectedLocation: selectedLocation)),
      );
      break;
    default:
      break;
  }
};
/////데이터/////////////////////////////////////////////////////////////////////
final List<String> _availableLocations = [
  '양호동',
  '선주 원남동',
  '도량동',
  '양포동',
  '상모 사곡동',
  '광평동',
  '칠곡',
  '진미동',
  '인동동',
  '양포동',
  '임오동',
  '도량동',
  '지산동',
  '송정동',
  '형곡동',
  '원평동',
  '신평동',
  '비산동',
  '공단동',
];

class User {
  String nickname;
  String id;
  String pw;
  String location;
  int qi;
// 등록 매물 수
// 판매 중인 매물 수
// 판매 완료 매물 수
// 현재 채팅방 수?

  User(this.nickname, this.id, this.pw, this.location, this.qi);
}

List<User> users = [
  User("감자", "potato", "qwer1234", "양호동", 5),
  User("양파", "onion", "qwer5678", "광평동", 3),
  User("당근", "carrot", "qwer9101", "양호동", 1),
];

class Item {
  //이미지
  String title;
  String category;
  int price;
  String describtion;
  String regiTime;
  User regitUser;
//채팅 로그파일
  Item(this.title, this.category, this.price, this.describtion, this.regiTime,
      this.regitUser);
}

List<Item> items = [
  Item("감자팝니다", "A", 10000, "상태 좋음", "regiTime", users[0]),
  Item("양파팝니다", "B", 20000, "상태 보통", "regiTime", users[1]),
  Item("적양파팝니다", "B", 30000, "상태 보통", "regiTime", users[1]),
];

//서식//////////////////////////////////////////////////////////////////////////
var blackText = const TextStyle(color: Colors.black);
var largeText = const TextStyle(fontSize: 17);
var boldText = const TextStyle(fontWeight: FontWeight.bold);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentBottomIndex = 0;
  String? _selectedLocation = '양호동';

  void _tapBottomTab(int index) {
    setState(() {
      _currentBottomIndex = index;
    });
  }

  final List<Widget> _tabs = [
    const HomeTabContent(),
    const ChatTabContent(),
    const ProfileTabContent(),
  ];

  @override
  Widget build(BuildContext context) {
    //위젯 생성 함수
    List<PopupMenuEntry<dynamic>> buildPopupMenu(BuildContext context) {
      List<PopupMenuEntry<dynamic>> popUpList = [];
      for (var temp in _availableLocations) {
        popUpList.add(PopupMenuItem(value: temp, child: Text(temp)));
      }
      return popUpList;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: PopupMenuButton(
          itemBuilder: buildPopupMenu,
          initialValue: _selectedLocation,
          onSelected: (value) {
            setState(() => _selectedLocation = value);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_selectedLocation!),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              gotoSub(context, SEARCHSUB, _selectedLocation);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              gotoSub(context, ALERTSUB);
            },
          ),
        ],
      ),
      body: _tabs[_currentBottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomIndex,
        onTap: _tapBottomTab,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WritingPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('프로필 탭 내용'),
    );
  }
}

class SearchSub extends StatelessWidget {
  final String? selectedLocation;
  const SearchSub({super.key, required this.selectedLocation});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _controller =
        TextEditingController(text: '$selectedLocation 근처에서 검색');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: TextField(
          controller: _controller,
          onChanged: (value) {
            // 검색 로직을 여기에 구현합니다.
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}

class AlertSub extends StatelessWidget {
  const AlertSub({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          title: const Text(
            '알림',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 편집 버튼을 눌렀을 때 수행할 동작을 추가
              },
              child: const Text(
                '편집',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: '활동 알림'),
              Tab(text: '키워드 알림'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('활동 알림 내용')),
            Center(child: Text('키워드 알림 내용')),
          ],
        ),
      ),
    );
  }
}
