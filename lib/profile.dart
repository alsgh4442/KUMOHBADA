import 'package:flutter/material.dart';
import 'package:kumohbada/main.dart';

class ProfileTabContent extends StatefulWidget {
  const ProfileTabContent({Key? key}) : super(key: key);

  @override
  _ProfileTabContentState createState() => _ProfileTabContentState();
}

class _ProfileTabContentState extends State<ProfileTabContent> {
  String? _loggedInUsername;

  // main.dart에서 가져온 _users 리스트
  final List<User> _users = users;

  // 로그인 기능: 아이디와 비밀번호를 확인하여 사용자 정보를 가져옴
  void _login(String username, String password) {
    for (User user in _users) {
      if (user.id == username && user.pw == password) {
        setState(() {
          _loggedInUsername = user.nickname;
        });
        break;
      }
    }
  }

  // 로그아웃 기능: 사용자 정보 초기화
  void _logout() {
    setState(() {
      _loggedInUsername = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loggedInUsername == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 로그인 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (context) => _buildLoginDialog(),
                    );
                  },
                  child: const Text('로그인'),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('안녕하세요, $_loggedInUsername님!'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // 로그아웃
                    _logout();
                  },
                  child: const Text('로그아웃'),
                ),
              ],
            ),
    );
  }

  // 로그인 다이얼로그
  Widget _buildLoginDialog() {
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('로그인'),
      content: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: '아이디'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: '비밀번호'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // 로그인 버튼 클릭
            _login(_usernameController.text, _passwordController.text);
            Navigator.pop(context);
          },
          child: const Text('로그인'),
        ),
        TextButton(
          onPressed: () {
            // 취소 버튼 클릭
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
      ],
    );
  }
}
