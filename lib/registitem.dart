import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'category.dart'; // 카테고리 스크린을 import

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
  String _selectedCategory = '디지털기기'; // 선택된 카테고리를 저장할 변수

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
    // _selectedCategory 변수에 선택된 카테고리가 있습니다.

    Navigator.pop(context);
  }

  // 카테고리를 선택하는 함수
  Future<void> _selectCategory() async {
    final Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryScreen()),
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result['category'];
      });
    }
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
                      // 제목 입력 필드
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
          // 카테고리 선택 부분
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _selectCategory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0), // 버튼 내부의 내용과의 간격 조절
                  ),
                  child: const Text('카테고리 선택'),
                ),
                const SizedBox(width: 8),
                Text('선택된 카테고리: $_selectedCategory'),
              ],
            ),
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
