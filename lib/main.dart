import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

//////페이지 이동을 위한 상수 및 함수//////////////////////////////////////////////
const String HOMESUB = "homesub";
const String CHATSUB = "chatsub";
const String FLOATSUB = "floatsub";
const String CATEGORYSUB = "categorysub";
const String ALERTSUB = "alertsub";
const String SEARCHSUB = "searchsub";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyStatefulPage(),
    );
  }
}

class MyStatefulPage extends StatefulWidget {
  const MyStatefulPage({super.key});

  @override
  _MyStatefulPageState createState() => _MyStatefulPageState();
}

class _MyStatefulPageState extends State<MyStatefulPage> {
  int _currentIndex = 0;
  String? selectedLocation = '양호동';

  final List<String> availableLocations = [
    '양호동',
    '서울',
    '부산',
    '대구',
    '인천',
    // 다른 지역을 추가할 수 있습니다.
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _tabs = [
    const HomeTabContent(),
    const ChatTabContent(),
    const ProfileTabContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            _showLocationMenu(context);
          },
          child: Row(
            children: [
              Text(
                selectedLocation!,
                style: const TextStyle(color: Colors.black),
              ),
              const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // 목록 버튼을 눌렀을 때 수행할 동작을 추가
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              gotoSub(context, SEARCHSUB, selectedLocation);
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
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }

  void _showLocationMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + kToolbarHeight + 5.0, // 아래에 여백 추가
        offset.dx + renderBox.size.width,
        offset.dy + kToolbarHeight + 5.0 + renderBox.size.height, // 아래에 여백 추가
      ),
      items: availableLocations.map((location) {
        return PopupMenuItem<String>(
          value: location,
          child: Text(location),
        );
      }).toList(),
    ).then((location) {
      if (location != null) {
        setState(() {
          selectedLocation = location;
        });
      }
    });
  }
}

Function gotoSub =
    (BuildContext context, String cls, [String? selectedLocation]) {
  switch (cls) {
    // case HOMESUB:
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const HomePageSub()));
    //   break;
    // case CHATSUB:
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const ChatPageSub()));
    //   break;
    // case FLOATSUB:
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const FloatingSub()));
    //   break;
    // case CATEGORYSUB:
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const CategorySub()));
    //   break;
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

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('홈 탭 내용'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WritingPage()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // FAB 위치 설정
    );
  }
}

class ChatTabContent extends StatelessWidget {
  const ChatTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('챗 탭 내용'),
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
  const SearchSub({Key? key, required this.selectedLocation}) : super(key: key);

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

class WritingPage extends StatefulWidget {
  const WritingPage({Key? key}) : super(key: key);

  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _image;

  // 이미지를 갤러리에서 선택하는 함수
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 글을 제출하는 함수
  void _submit() {
    // 여기에 글을 제출하는 로직을 추가하세요.
    String title = titleController.text;
    String price = priceController.text;
    String description = descriptionController.text;

    // _image 변수에 선택한 이미지 파일이 있습니다.
    // title, price, description 등을 활용하여 글을 서버에 업로드하거나 다른 작업을 수행할 수 있습니다.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('글 작성'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              // 이미지 선택 버튼
              if (_image == null)
                SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('이미지 선택'),
                    ),
                  ),
                ),
              // 선택한 이미지 표시
              if (_image != null)
                GestureDetector(
                  onTap: _pickImage,
                  child: SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Center(
                      child: Image.file(
                        _image!,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // 제목 입력 필드
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: '제목',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 가격 입력 필드
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: '가격',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 설명 입력 필드
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: descriptionController,
                maxLines: null, // 가변적인 높이를 가지도록 설정
                expands: true, // 입력 내용에 따라 세로로 늘어나도록 설정
                decoration: const InputDecoration(
                  labelText: '설명',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                minimumSize: Size(screenWidth, 0),
              ),
              child: const Text('제출'),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  final Map<String, String> categoryImages = {
    '디지털기기': 'assets/images/digital_device.png', // 0
    '가구/인테리어': 'assets/images/furniture_interior.png', // 1
    '유아동': 'assets/images/baby_product.png', // 2
    '여성의류': 'assets/images/female_clothes.png', // 3
    '여성잡화': 'assets/images/female_goods.png', // 4
    '남성패션/잡화': 'assets/images/male_clothes_goods.png', // 5
    '생활가전': 'assets/images/electric_appliance.png', // 6
    '생활/주방': 'assets/images/kitchenware.png', // 7
    '가공식품': 'assets/images/canned_food.png', // 8
    '스포츠/레저': 'assets/images/sports_leisure.png', // 9
    '취미/게임/음반': 'assets/images/hobby_game_music.png', // 10
    '뷰티/미용': 'assets/images/beauty.png', // 11
    '식물': 'assets/images/plant.png', // 12
    '반려동물용품': 'assets/images/pet_supplies.png', // 13
    '티켓/교환권': 'assets/images/ticket.png', // 14
    '도서': 'assets/images/book.png', // 15
    '유아도서': 'assets/images/baby_book.png', // 16
    '기타 중고물품': 'assets/images/others.png', // 17
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리'),
      ),
      body: ListView.builder(
        itemCount: categoryImages.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categoryImages.keys.elementAt(index);
          final imagePath = categoryImages[category];
          return ListTile(
            leading: imagePath != null
                ? Image.asset(
                    imagePath,
                    height: 24, // Adjust the height as needed
                    width: 24, // Adjust the width as needed
                  )
                : const Icon(Icons
                    .error), // Placeholder icon in case image path is not valid
            title: Text(category),
            onTap: () {
              _handleCategorySelection(context, category, index);
            },
          );
        },
      ),
    );
  }

  void _handleCategorySelection(
      BuildContext context, String selectedCategory, int index) {
    Navigator.pop(context, {'category': selectedCategory, 'index': index});
  }
}
