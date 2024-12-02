import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  void fetchBooks() async {
    final response = await Supabase.instance.client.from('book').select();

    setState(() {
      books = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        title: const Text('Daftar Buku'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchBooks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        color: Colors.teal.shade200, 
        child: books.isEmpty
            ? Center(
                child: const Text(
                  'Tidak ada buku tersedia',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.book, color: Colors.teal.shade800), // Ikon buku di sini
                        title: Text(
                          book['title'] ?? 'No Title',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['author'] ?? 'No Author',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 14),
                            ),
                            Text(
                              book['description'] ?? 'No Description',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_note_outlined, color: Colors.blue),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  // TextEditingController untuk mengambil input dari TextField
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku'),
        backgroundColor: Colors.teal.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form untuk menambah buku
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Buku'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Pengarang'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final author = _authorController.text;
                final description = _descriptionController.text;
                if (title.isNotEmpty && author.isNotEmpty && description.isNotEmpty) {
                  // Menambahkan buku ke Supabase
                  final response = await Supabase.instance.client
                  .from('book')
                  .insert([
                    {
                      'title': title,
                      'author': author,
                      'description': description,
                    }
                  ]);
                  if (response.error == null) {
                    // Jika berhasil, kembali ke halaman sebelumnya
                    Navigator.pop(context);
                  } else {
                    // Menampilkan pesan error jika gagal menyimpan
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.error!.message)));
                  }
                } else {
                  // Menampilkan pesan jika ada field yang kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')));
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
