import 'package:flutter/material.dart';

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
