import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class DetailBooks extends StatefulWidget {
  final String bookId;
  final String title;
  final String author;
  final String cover;
  final String overviewText;
  final String discussionText;
  final String pages;
  final String rating;

  const DetailBooks({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.cover,
    required this.overviewText,
    required this.discussionText,
    required this.pages,
    required this.rating,
  });

  @override
  _DetailBooksState createState() => _DetailBooksState();
}

class _DetailBooksState extends State<DetailBooks> {
  int likes = 0; // Jumlah likes awal, misalnya 1.3M

  @override
  void initState() {
    super.initState();
    _loadLikes(); // Load jumlah likes dari SharedPreferences saat widget dibuat
  }

  // Fungsi untuk memuat jumlah likes dari SharedPreferences
  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      likes = prefs.getInt('${widget.title}_likes') ?? likes; // Default ke likes awal jika belum ada data
    });
  }

  // Fungsi untuk menyimpan jumlah likes ke SharedPreferences
  Future<void> _saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.title}_likes', likes);
  }

  Future<void> _markAsRead() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil daftar buku yang sudah disimpan
    List<String> bookmarkedBooks = prefs.getStringList('bookmarked_books') ?? [];

    // Buat data buku dalam format JSON
    Map<String, String> bookDetails = {
      "bookId": widget.bookId,
      "title": widget.title,
      "author": widget.author,
      "cover": widget.cover,
      "rating": widget.rating,
    };

    // Tambahkan data buku ke dalam daftar sebagai JSON String
    bookmarkedBooks.add(jsonEncode(bookDetails)); // Encode ke JSON String

    // Simpan kembali ke SharedPreferences
    await prefs.setStringList('bookmarked_books', bookmarkedBooks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.title} has been added to bookmarks!')),
    );
  }

  void _incrementLikes() {
    setState(() {
      likes++;
    });
    _saveLikes(); // Simpan perubahan likes ke SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab (Overview dan Discussion)
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _cardbuku(context),
                    const SizedBox(height: 27),
                    _buildBookTitleAndAuthor(),
                    const SizedBox(height: 5),
                    _rl(), // Reads dan Likes
                    _buildTabs(), // TabBar
                    _buildTabContent(), // TabBarView
                    // const SizedBox(height: 180),
                    _bookmark(),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              _backButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _backButton(BuildContext context) {
    return Positioned(
      top: 23,
      left: 23,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Fungsi kembali ke layar sebelumnya
        },
        child: SvgPicture.asset(
          'assets/icons/back-home.svg', // Gambar tombol pop
          width: 32, // Sesuaikan ukuran gambar
          height: 32,
        ),
      ),
    );
  }

  Widget _cardbuku(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double cardWidth = constraints.maxWidth;
      return AspectRatio(
        aspectRatio: 414 / 300,
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: const Color(0xFFB8E1EA),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background decoration (unchanged)
              Positioned(
                right: cardWidth * 0.10,
                top: 25,
                child: Image.asset(
                  'assets/images/around.png',
                  fit: BoxFit.contain,
                ),
              ),
              // Buku.png behind the cover
              Positioned(
                left: cardWidth * 0.33, // Adjust to align with cover
                top: 45, // Slightly below the top
                child: Container(
                  width: cardWidth * 0.44,
                  height: cardWidth * 0.54,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/buku.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Buku cover from API
              Positioned(
                left: cardWidth * 0.3,
                top: 45,
                child: Container(
                  width: cardWidth * 0.43,
                  height: cardWidth * 0.542,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.cover), // API cover image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Rating background decoration
              Positioned(
                right: cardWidth * 0.1,
                bottom: -20,
                child: Image.asset(
                  'assets/images/rating.png',
                  width: cardWidth * 0.2,
                  height: cardWidth * 0.1,
                  fit: BoxFit.contain,
                ),
              ),
              // Dynamic rating text from API
              Positioned(
                right: cardWidth * 0.13,
                bottom: -11,
                child: Text(
                  widget.rating, // Rating dari API
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  Widget _buildBookTitleAndAuthor() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              widget.author,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rl() {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF52B4C8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/book-detail-book.svg',
                      width: 25,
                      height: 25,
                      color: const Color(0xFF52B4C8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.pages} Pages', // Menggunakan data API untuk halaman
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          color: Color(0xFF52B4C8),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: _incrementLikes,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/like-detail-book.svg',
                        width: 25,
                        height: 25,
                        color: const Color(0xFF52B4C8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$likes Likes',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: Color(0xFF52B4C8),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildTabs() {
    return TabBar(
      indicatorColor: Colors.teal,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(
          child: Text(
            "Overview",
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Tab(
          child: Text(
            "Discussion",
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return Container(
      height: 250,
      child: TabBarView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Text(
                widget.overviewText,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Text(
                widget.discussionText,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookmark() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _markAsRead, // Panggil fungsi di atas
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF52B4C8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Mark as Read',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF52B4C8),
                borderRadius: BorderRadius.circular(13),
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/share.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
