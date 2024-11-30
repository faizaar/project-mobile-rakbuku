import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakbuku/screens/bookmark_screen.dart';
import 'package:rakbuku/screens/home_screen.dart';
import 'package:rakbuku/screens/book_screen.dart';

var menus = [
  'assets/icons/home-ijo.svg',
  'assets/icons/book-abu.svg',
  'assets/icons/bookmark-abu.svg',
  'assets/icons/account-abu.svg'
];

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 3; // Bookmark sebagai halaman default

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookScreen()),
      );
      break;
    case 2:
      // Halaman Bookmark
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookmarkScreen()),
      );
      break;
    case 3:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreen()),
      );
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 19),
            _greetings(),
            const SizedBox(height: 24),
            _search(),
            const SizedBox(height: 24),
            
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian header/greetings
  Row _greetings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/rakbuku.png', height: 50, fit: BoxFit.contain),
        Row(
          children: [
            SvgPicture.asset('assets/icons/notification.svg', height: 24, width: 24),
            const SizedBox(width: 16),
            SvgPicture.asset('assets/icons/account.svg', height: 47, width: 47),
          ],
        ),
      ],
    );
  }

  // Widget untuk Search Bar
  Padding _search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 43,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 223, 221, 221),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Book..',
                  prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 211, 210, 210)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }


  // Widget Bottom Navigation Bar
  Container _bottomNavigationBar() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 10)],
      ),
      child: Row(
        children: List.generate(menus.length, (index) {
          return Expanded(
            child: InkWell(
              onTap: () => _onItemTapped(index),
              child: SvgPicture.asset(
                menus[index],
                height: 27,
                width: 27,
                color: _selectedIndex == index
                  ? const Color(0xFF4BABB8) // Warna saat item dipilih
                  : Colors.grey, // Warna saat item tidak dipilih
              ),
            ),
          );
        }),
      ),
    );
  }
}
