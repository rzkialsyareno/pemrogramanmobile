enum FeedbackType { apresiasi, saran, keluhan }

class FeedbackItem {
  final String id;
  final String nama;
  final String nim;
  final String fakultas;
  final List<String> fasilitasDipilih;
  final double nilaiKepuasan;
  final FeedbackType jenis;
  final String pesanTambahan;
  final bool setujuSk;

  FeedbackItem({
    required this.id,
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.fasilitasDipilih,
    required this.nilaiKepuasan,
    required this.jenis,
    required this.pesanTambahan,
    required this.setujuSk,
  });
}

class FeedbackStore {
  static final List<FeedbackItem> items = [];
}