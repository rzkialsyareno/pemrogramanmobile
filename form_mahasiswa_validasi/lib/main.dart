import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Mahasiswa Validasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const FormMahasiswaPage(),
    );
  }
}

class FormMahasiswaPage extends StatefulWidget {
  const FormMahasiswaPage({super.key});

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1: Personal Information
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHPController = TextEditingController();

  // Step 2: Academic Information
  String? _selectedJurusan;
  double _semester = 1;

  final List<String> _jurusanList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Mesin',
    'Teknik Sipil',
  ];

  // Step 3: Preferences & Agreement
  final Map<String, bool> _hobi = {
    'Membaca': false,
    'Olahraga': false,
    'Musik': false,
    'Traveling': false,
    'Gaming': false,
  };
  bool _persetujuan = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nomorHPController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama harus diisi';
    }
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf dan spasi';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validateNomorHP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP harus diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor HP hanya boleh berisi angka';
    }
    if (value.length < 10 || value.length > 13) {
      return 'Nomor HP harus 10-13 digit';
    }
    return null;
  }

  String? _validateJurusan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jurusan harus dipilih';
    }
    return null;
  }

  bool _validateHobi() {
    return _hobi.values.any((selected) => selected);
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      // Validate Step 1: Personal Information only
      if (_namaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nama harus diisi'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      if (_validateNama(_namaController.text) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_validateNama(_namaController.text)!),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      if (_emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email harus diisi'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      if (_validateEmail(_emailController.text) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_validateEmail(_emailController.text)!),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      if (_nomorHPController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nomor HP harus diisi'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      if (_validateNomorHP(_nomorHPController.text) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_validateNomorHP(_nomorHPController.text)!),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      return true;
    } else if (_currentStep == 1) {
      // Validate Step 2: Academic Information
      if (_selectedJurusan == null || _selectedJurusan!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jurusan harus dipilih'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      return true;
    } else if (_currentStep == 2) {
      // Validate Step 3: Preferences
      if (!_validateHobi()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih minimal satu hobi'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      if (!_persetujuan) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus menyetujui syarat dan ketentuan'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      return true;
    }
    return false;
  }

  void _onStepContinue() {
    if (_validateCurrentStep()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        // Submit form
        _submitForm();
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _submitForm() {
    // Get selected hobbies
    List<String> selectedHobi = _hobi.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Navigate to result page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          nama: _namaController.text,
          email: _emailController.text,
          nomorHP: _nomorHPController.text,
          jurusan: _selectedJurusan!,
          semester: _semester.toInt(),
          hobi: selectedHobi,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentStep == 2 ? 'Submit' : 'Lanjut'),
                  ),
                  const SizedBox(width: 8),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Kembali'),
                    ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Personal Information
            Step(
              title: const Text('Informasi Pribadi'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      hintText: 'Masukkan nama lengkap',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: _validateNama,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'contoh@email.com',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomorHPController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      hintText: '08xxxxxxxxxx',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validateNomorHP,
                  ),
                ],
              ),
            ),
            // Step 2: Academic Information
            Step(
              title: const Text('Informasi Akademik'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedJurusan,
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: _jurusanList.map((String jurusan) {
                      return DropdownMenuItem<String>(
                        value: jurusan,
                        child: Text(jurusan),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedJurusan = newValue;
                      });
                    },
                    validator: _validateJurusan,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Semester: ${_semester.toInt()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: _semester,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: _semester.toInt().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _semester = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '8',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Step 3: Preferences & Agreement
            Step(
              title: const Text('Preferensi'),
              isActive: _currentStep >= 2,
              state: StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hobi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ..._hobi.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: _hobi[key],
                      onChanged: (bool? value) {
                        setState(() {
                          _hobi[key] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  const Divider(height: 32),
                  SwitchListTile(
                    title: const Text('Saya menyetujui syarat dan ketentuan'),
                    subtitle: const Text(
                      'Dengan mengaktifkan ini, Anda menyetujui semua syarat dan ketentuan yang berlaku',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _persetujuan,
                    onChanged: (bool value) {
                      setState(() {
                        _persetujuan = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
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

class ResultPage extends StatelessWidget {
  final String nama;
  final String email;
  final String nomorHP;
  final String jurusan;
  final int semester;
  final List<String> hobi;

  const ResultPage({
    super.key,
    required this.nama,
    required this.email,
    required this.nomorHP,
    required this.jurusan,
    required this.semester,
    required this.hobi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Data Berhasil Disimpan!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                ),
                const Divider(height: 32),
                _buildInfoSection(context, 'Informasi Pribadi', [
                  _buildInfoRow(context, 'Nama', nama),
                  _buildInfoRow(context, 'Email', email),
                  _buildInfoRow(context, 'Nomor HP', nomorHP),
                ]),
                const Divider(height: 32),
                _buildInfoSection(context, 'Informasi Akademik', [
                  _buildInfoRow(context, 'Jurusan', jurusan),
                  _buildInfoRow(context, 'Semester', semester.toString()),
                ]),
                const Divider(height: 32),
                _buildInfoSection(context, 'Preferensi', [
                  _buildInfoRow(context, 'Hobi', hobi.join(', ')),
                ]),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FormMahasiswaPage(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Isi Form Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
