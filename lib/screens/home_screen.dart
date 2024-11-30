import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Untuk request HTTP
import 'dart:convert'; // Untuk memproses JSON
import 'package:rakbuku/screens/detail_books.dart';
import 'package:rakbuku/screens/book_screen.dart';
import 'package:rakbuku/screens/bookmark_screen.dart';
import 'package:rakbuku/screens/account_screen.dart';

var menus = [
  'assets/icons/home-ijo.svg',
  'assets/icons/book-abu.svg',
  'assets/icons/bookmark-abu.svg',
  'assets/icons/account-abu.svg'
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> recommendedBooks = [];
  List<dynamic> popularBooks = [];
  bool isLoadingRecommended = true;
  bool isLoadingPopular = true;

  // API details
  final String apiUrl = 'https://hapi-books.p.rapidapi.com/book/';
  final String apiKey = 'cac3f68df9msh8a279cafa70d3a9p15a98fjsn918b581ef240';

  @override
  void initState() {
    super.initState();
    fetchRecommendedBooks(); // Fetch recommended books
    fetchPopularBooks(); // Fetch popular books
  }

  // Fetch recommended books
  Future<void> fetchRecommendedBooks() async {
    try {
      final List<String> bookIds = ['56597885', '2', '3', '10']; // ID untuk recommended books
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
        recommendedBooks = fetchedBooks;
        isLoadingRecommended = false;
      });
    } catch (e) {
      setState(() {
        isLoadingRecommended = false;
      });
      print('Error fetching recommended books: $e');
    }
  }

  // Fetch popular books
  Future<void> fetchPopularBooks() async {
    try {
      final List<String> bookIds = ['4', '5', '6', '90']; // ID untuk popular books
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
        popularBooks = fetchedBooks;
        isLoadingPopular = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPopular = false;
      });
      print('Error fetching popular books: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi berdasarkan index yang dipilih
    switch (index) {
      case 0:
        // Navigasi ke halaman Home
        break;
      case 1:
        // Navigasi ke halaman Buku
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookScreen()));
        break;
      case 2:
        // Navigasi ke halaman Bookmark
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkScreen()));
        break;
      case 3:
        // Navigasi ke halaman Akun
        Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
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
              _card(),
              const SizedBox(height: 13),
              _carousel(),
              const SizedBox(height: 13),
              _textRecommended(),
              const SizedBox(height: 13),
              _recommendedBooks(),
              const SizedBox(height: 13),
              _textPopular(),
              const SizedBox(height: 13),
              _popularBooks(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _textPopular() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Popular Books',
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget for popular books
  Widget _popularBooks() {
    if (isLoadingPopular) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularBooks.length,
        itemBuilder: (context, index) {
          final book = popularBooks[index];
          return _buildBookCard(context, book);
        },
      ),
    );
  }

  // Card widget for books
  Widget _buildBookCard(BuildContext context, dynamic book) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBooks(
          bookId: book['id']?.toString() ?? 'Unknown ID',
          title: book['name'] ?? 'No Title',
          author: (book['authors'] != null && book['authors'] is List)
            ? (book['authors'] as List<dynamic>).join(', ')
            : 'No Author',
          cover: book['cover'] ?? 'https://via.placeholder.com/150',
          overviewText: book['synopsis'] ?? 'No synopsis available',
          discussionText: "Discussion about ${book['name']}",
          pages: book['pages']?.toString() ?? 'Unknown Pages', // Tambahkan ini
          rating: book['rating']?.toString() ?? 'Unknown Rating', // Tambahkan ini
        ),
      ),
    );
    },
    child: Container(
      width: 120,
      margin: const EdgeInsets.only(left: 16, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 155,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(book['cover'] ?? 'https://via.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8), // Spasi antara gambar dan teks
          Flexible(
            child: Text(
              book['name'] ?? 'No Title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4), // Spasi antara judul dan penulis
          Flexible(
            child: Text(
              (book['authors'] as List<dynamic>).join(', ') ?? 'Unknown Author',
              maxLines: 1, // Batasi maksimal 1 baris
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // Text widgets
  Padding _textRecommended() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Recommended Books',
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget for recommended books
  Widget _recommendedBooks() {
    if (isLoadingRecommended) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendedBooks.length,
        itemBuilder: (context, index) {
          final book = recommendedBooks[index];
          return _buildBookCard(context, book);
        },
      ),
    );
  }

  // Widget untuk setiap card buku
//   Widget _buildBookCard1(BuildContext context, Map<String, String> book) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailBooks(
//             title: book['title']!,
//             author: book['author']!,
//             cover: book['cover']!,
//             overviewText: book['overviewText']!,
//             discussionText: book['discussionText']!,
//           ),
//         ),
//       );
//     },
//     child: Container(
//       width: 120, // Lebar card
//       margin: const EdgeInsets.only(left: 16, right: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Gambar cover buku
//           Container(
//             height: 150,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 image: AssetImage(book['cover']!),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Judul buku
//           Text(
//             book['title']!,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           // Penulis buku
//           Text(
//             book['author']!,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

  Container _carousel() {
    return Container(
      child: Center(
       child: Image.asset(
        'assets/images/carousel.png',
        // height: double.maxFinite,
        // width: double.maxFinite,
       ),
      ),
    );
  }

  AspectRatio _card() {
    return AspectRatio(
              aspectRatio: 374 / 174,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8E1EA),
                  borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(children: [
                      Image.asset(
                        'assets/images/card.png',
                        height: double.maxFinite,
                        width: double.maxFinite,
                        // fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
            );
  }

  // Dummy greeting widget
  Row _greetings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/rakbuku.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/notification.svg',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 16),
            SvgPicture.asset(
              'assets/icons/account.svg',
              height: 47,
              width: 47,
            ),
          ],
        ),
      ],
    );
  }

  // Bottom navigation bar
  Container _bottomNavigationBar() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 30,
            offset: const Offset(0, -10),
          )
        ],
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
                    ? const Color(0xFF4BABB8)
                    : Colors.grey,
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
                  prefixIcon:
                      const Icon(Icons.search, color: Color.fromARGB(255, 211, 210, 210)),
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