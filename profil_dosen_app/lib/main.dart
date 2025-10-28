import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Dosen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF262B3E),
      ),
      home: const DosenListPage(),
    );
  }
}

// Model Dosen
class Dosen {
  final String nama;
  final String nip;
  final String email;
  final String telepon;
  final List<String> mataKuliah;

  Dosen({
    required this.nama,
    required this.nip,
    required this.email,
    required this.telepon,
    required this.mataKuliah,
  });
}

// Halaman 1: Daftar Dosen
class DosenListPage extends StatelessWidget {
  const DosenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Dosen> dosenList = [
      Dosen(
        nama: 'WAHYU ANGGORO, M.Kom',
        nip: '1571082309960021',
        email: 'wahyuanggoro@uinjambi.ac.id',
        telepon: '+62 812-3456-7890',
        mataKuliah: ['Manajemen Resiko'],
      ),
      Dosen(
        nama: 'POL METRA, M.Kom',
        nip: '19910615010122045',
        email: 'polmetra@uinjambi.ac.id',
        telepon: '+62 812-3456-7890',
        mataKuliah: ['Multimedia'],
      ),
      Dosen(
        nama: 'AHMAD NASUKHA, S.Hum., M.S.I',
        nip: '1988072220171009',
        email: 'ahmadnasukha@uinjambi.ac.id',
        telepon: '+62 812-3456-7890',
        mataKuliah: ['Pemrograman Mobile'],
      ),
      Dosen(
        nama: 'DILA NURLAILA, M.Kom',
        nip: '1571015201960020',
        email: 'dilanurlaila@uinjambi.ac.id',
        telepon: '+62 812-3456-7890',
        mataKuliah: ['Rekayasa Perangkat Lunak'],
      ),
      Dosen(
        nama: 'M. YUSUF, S.Kom., M.S.I',
        nip: '1988021420191007',
        email: 'myusuf@uinjambi.ac.id',
        telepon: '+62 812-3456-7890',
        mataKuliah: ['Technopreneurship'],
      ),
      Dosen(
        nama: 'FATIMA FELAWATI, S.Kom.,M.Kom',
        nip: '199305112025052004',
        email: 'fatimafelawati@uinjambi.ac.id',
        telepon: '+62 812-3456-7890',
        mataKuliah: ['Testing dan Implementasi System'],
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF262B3E),
              Color(0xFF2D3347),
              Color(0xFF353B52),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profil Dosen',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Program Studi Sistem Informasi',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: dosenList.length,
                  itemBuilder: (context, index) {
                    final dosen = dosenList[index];
                    return DosenCard(
                      dosen: dosen,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DosenDetailPage(dosen: dosen),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Card untuk Dosen
class DosenCard extends StatelessWidget {
  final Dosen dosen;
  final VoidCallback onTap;

  const DosenCard({
    super.key,
    required this.dosen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF3A4058).withOpacity(0.8),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Hero(
                  tag: 'avatar_${dosen.nip}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4A5068),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dosen.nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIP: ${dosen.nip}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dosen.email,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.4),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Halaman 2: Detail Dosen
class DosenDetailPage extends StatelessWidget {
  final Dosen dosen;

  const DosenDetailPage({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF262B3E),
              Color(0xFF2D3347),
              Color(0xFF353B52),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan tombol back
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Detail Dosen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Avatar dan Nama
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'avatar_${dosen.nip}',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4A5068),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          dosen.nama,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Informasi Detail
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            DetailCard(
                              title: 'Informasi Pribadi',
                              children: [
                                DetailItem(
                                  icon: Icons.badge,
                                  label: 'NIP',
                                  value: dosen.nip,
                                ),
                                DetailItem(
                                  icon: Icons.email,
                                  label: 'Email',
                                  value: dosen.email,
                                ),
                                DetailItem(
                                  icon: Icons.phone,
                                  label: 'Telepon',
                                  value: dosen.telepon,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            DetailCard(
                              title: 'Mata Kuliah',
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: dosen.mataKuliah
                                        .map(
                                          (mk) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF505A75).withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          mk,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
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

// Widget Card untuk Detail
class DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const DetailCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF3A4058).withOpacity(0.8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          ...children,
        ],
      ),
    );
  }
}

// Widget Item Detail
class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF505A75).withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}