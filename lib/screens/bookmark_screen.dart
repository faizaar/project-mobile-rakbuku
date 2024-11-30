import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakbuku/screens/home_screen.dart';
import 'package:rakbuku/screens/account_screen.dart';
import 'package:rakbuku/screens/book_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


var menus = [
  'assets/icons/home-ijo.svg',
  'assets/icons/book-abu.svg',
  'assets/icons/bookmark-abu.svg',
  'assets/icons/account-abu.svg'
];

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  int _selectedIndex = 2; // Bookmark sebagai halaman default
  List<Map<String, String>> bookmarkedBooks = []; // Variabel untuk menampung daftar buku

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil daftar string dari SharedPreferences
    List<String> savedBooks = prefs.getStringList('bookmarked_books') ?? [];

    // Decode setiap JSON String menjadi Map<String, String>
    setState(() {
      bookmarkedBooks = savedBooks.map((book) {
        final decodedBook = jsonDecode(book) as Map<String, dynamic>;
        return decodedBook.map((key, value) => MapEntry(key, value.toString()));
      }).toList();
    });
  }

  Future<void> _removeBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();

    // Hapus buku dari daftar
    setState(() {
      bookmarkedBooks.removeAt(index);
    });

    // Simpan kembali daftar yang diperbarui ke SharedPreferences
    List<String> updatedBooks = bookmarkedBooks.map((book) => jsonEncode(book)).toList();
    await prefs.setStringList('bookmarked_books', updatedBooks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bookmark removed!')),
    );
  }

@override
void initState() {
  super.initState();
  _loadBookmarks(); // Muat data bookmark saat layar dibuat
}

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
            Expanded(child: _buildBookList()),
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

  // Widget ListView untuk menampilkan daftar buku
  Widget _buildBookList() {
    return ListView.builder(
      itemCount: bookmarkedBooks.length,
      itemBuilder: (context, index) {
        final book = bookmarkedBooks[index];
        return _buildBookItem(book, index);
      },
    );
  }

  // Widget untuk setiap item buku
  Widget _buildBookItem(Map<String, String> book, int index) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar buku
            Container(
              height: 100,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(book['cover']!), // Cover dari bookmark
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title']!,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "by ${book['author']!}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 5),
                      Text(book['rating']!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // Ikon bookmark di pojok kanan atas
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _removeBookmark(index), // Panggil fungsi hapus
            child: SvgPicture.asset(
              'assets/icons/bookmark-abu.svg', // Ikon bookmark
              height: 20,
              width: 20,
              color: const Color(0xFF4BABB8), // Warna ikon
            ),
          ),
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
