// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String _baseUrl = 'https://hapi-books.p.rapidapi.com';
//   static const Map<String, String> _headers = {
//     'X-RapidAPI-Key': '3b91a26c38mshf6827a24fb8a8e3p1ed608jsn7a2bd6074177', // Ganti dengan API Key Anda
//     'X-RapidAPI-Host': 'hapi-books.p.rapidapi.com',
//   };

//   // Fungsi untuk mendapatkan daftar buku
//   Future<List<dynamic>> fetchBooks() async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/week/2023'), // Endpoint untuk buku mingguan tahun 2023
//       headers: _headers,
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to fetch books');
//     }
//   }

//   // Fungsi untuk mendapatkan detail buku berdasarkan ID
//   Future<Map<String, dynamic>> fetchBookDetail(String bookId) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/book/$bookId'),
//       headers: _headers,
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to fetch book details');
//     }
//   }
// }
