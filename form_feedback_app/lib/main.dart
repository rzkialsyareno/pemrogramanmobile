import 'package:flutter/material.dart';

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FeedbackFormPage(),
    );
  }
}

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _komentarController = TextEditingController();
  int _rating = 3;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _namaController.dispose();
    _komentarController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackResultPage(
            nama: _namaController.text,
            komentar: _komentarController.text,
            rating: _rating,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Feedback'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Berikan Feedback Anda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _komentarController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  hintText: 'Tulis komentar Anda di sini',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Komentar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              const Text(
                'Rating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  );
                }),
              ),
              const SizedBox(height: 10),

              Slider(
                value: _rating.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _rating.toString(),
                onChanged: (double value) {
                  setState(() {
                    _rating = value.toInt();
                  });
                },
              ),

              Center(
                child: Text(
                  'Rating: $_rating/5',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Kirim Feedback',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackResultPage extends StatefulWidget {
  final String nama;
  final String komentar;
  final int rating;

  const FeedbackResultPage({
    super.key,
    required this.nama,
    required this.komentar,
    required this.rating,
  });

  @override
  State<FeedbackResultPage> createState() => _FeedbackResultPageState();
}

class _FeedbackResultPageState extends State<FeedbackResultPage> {
  bool _isLiked = false;

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Cukup';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat Baik';
      default:
        return 'Tidak Diketahui';
    }
  }

  MaterialColor _getRatingColor(int rating) {
    if (rating <= 2) return Colors.red;
    if (rating == 3) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: Colors.green.shade50,
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Feedback Berhasil Dikirim!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Terima kasih atas feedback Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blue),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nama',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              SizedBox(width: 10),
                              Text(
                                'Rating',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < widget.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 32,
                              );
                            }),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getRatingColor(widget.rating).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${widget.rating}/5 - ${_getRatingText(widget.rating)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getRatingColor(widget.rating).shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.comment, color: Colors.blue),
                              SizedBox(width: 10),
                              Text(
                                'Komentar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.komentar,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Apakah feedback ini membantu?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isLiked = true;
                                });
                              },
                              icon: Icon(
                                _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                color: _isLiked ? Colors.blue : Colors.grey,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isLiked = false;
                                });
                              },
                              icon: Icon(
                                !_isLiked ? Icons.thumb_down : Icons.thumb_down_outlined,
                                color: !_isLiked ? Colors.red : Colors.grey,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        if (_isLiked)
                          const Text(
                            '✓ Terima kasih atas tanggapan Anda!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        'Kembali ke Form',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}