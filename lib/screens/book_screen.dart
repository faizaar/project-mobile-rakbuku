import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rakbuku/screens/detail_books.dart';
import 'package:rakbuku/screens/bookmark_screen.dart';
import 'package:rakbuku/screens/home_screen.dart';
import 'package:rakbuku/screens/account_screen.dart';

// API Configuration
const String apiUrl = 'https://hapi-books.p.rapidapi.com/book/';
const String apiKey = 'cac3f68df9msh8a279cafa70d3a9p15a98fjsn918b581ef240';

var menus = [
  'assets/icons/home-ijo.svg',
  'assets/icons/book-abu.svg',
  'assets/icons/bookmark-abu.svg',
  'assets/icons/account-abu.svg'
];

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreen();
}

class _BookScreen extends State<BookScreen> {
  int _selectedIndex = 1;
  List<dynamic> books = []; // List untuk menyimpan data buku dari API
  bool isLoading = true;

  // Fetch books data from API
  Future<void> fetchBooks() async {
    try {
      // Contoh untuk mengambil beberapa buku berdasarkan ID berbeda
      final List<String> bookIds = ['56597885', '2', '3', '4', '5', '6', '7']; // Tambahkan ID lain di sini
      final List<dynamic> fetchedBooks = [];

      for (String id in bookIds) {
        final response = await http.get(
          Uri.parse('$apiUrl$id'),
          headers: {
            'x-rapidapi-host': 'hapi-books.p.rapidapi.com',
            'x-rapidapi-key': apiKey,
          },
        );

        if (response.statusCode == 200) {
          fetchedBooks.add(json.decode(response.body));
        }
      }

      setState(() {
        books = fetchedBooks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching books: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Memuat data API saat layar dibuka
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 19),
              _greetings(),
              const SizedBox(height: 24),
              _search(),
              const SizedBox(height: 24),
              _buildBookGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Grid untuk menampilkan daftar buku
  Widget _buildBookGrid() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.65,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _buildBookCard(context, book);
        },
      ),
    );
  }

  // Widget untuk setiap buku
  Widget _buildBookCard(BuildContext context, dynamic book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBooks(
              bookId: book['id']?.toString() ?? 'Unknown ID', // Tambahkan ini
              title: book['name'] ?? 'No title',
              author: (book['authors'] as List<dynamic>).join(', '),
              cover: book['cover'] ?? 'https://via.placeholder.com/150',
              overviewText: book['synopsis'] ?? 'No synopsis available',
              discussionText: 'Discussion about ${book['name']}',
              pages: book['pages']?.toString() ?? 'Unknown Pages', // Tambahkan ini
              rating: book['rating']?.toString() ?? 'Unknown Rating', // Tambahkan ini
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Buku
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: book['cover'] != null
                    ? DecorationImage(
                        image: NetworkImage(book['cover']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Buku
                  Text(
                    book['name'] ?? 'No title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Pengarang
                  Text(
                    (book['authors'] as List<dynamic>).join(', ') ?? 'Unknown Author',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Container _bottomNavigationBar() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 30, offset: const Offset(0, -10))],
        color: Colors.white,
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
}
