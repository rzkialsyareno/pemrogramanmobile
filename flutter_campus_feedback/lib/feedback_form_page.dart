import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_list_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();
  final _pesanCtrl = TextEditingController();

  String? _fakultas;
  final List<String> _fakultasOpts = const [
    'Sains & Teknologi',
    'Ekonomi & Bisnis Islam',
    'Syariah',
    'Tarbiyah & Keguruan',
    'Ushuluddin',
  ];

  final List<String> _fasilitasOpts = const [
    'Perpustakaan',
    'Laboratorium',
    'Kantin',
    'WiFi',
    'Ruang Kelas'
  ];
  final Set<String> _fasilitasDipilih = {};

  double _nilai = 3;
  FeedbackType _jenis = FeedbackType.saran;
  bool _setuju = false;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _pesanCtrl.dispose();
    super.dispose();
  }

  void _simpan() async {
    final validInputs = _formKey.currentState?.validate() ?? false;

    if (!validInputs || _fakultas == null || _fasilitasDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Harap lengkapi semua data yang diperlukan.')),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (!_setuju) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.info_outline, size: 48, color: Theme.of(ctx).colorScheme.primary),
          title: const Text('Konfirmasi Diperlukan'),
          content: const Text('Anda harus menyetujui Syarat & Ketentuan untuk melanjutkan.'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
      return;
    }

    final item = FeedbackItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: _namaCtrl.text.trim(),
      nim: _nimCtrl.text.trim(),
      fakultas: _fakultas!,
      fasilitasDipilih: _fasilitasDipilih.toList(),
      nilaiKepuasan: _nilai,
      jenis: _jenis,
      pesanTambahan: _pesanCtrl.text.trim(),
      setujuSk: _setuju,
    );

    FeedbackStore.items.add(item);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => FeedbackListPage(data: item)),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('Terima kasih, feedback Anda telah tersimpan!')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.primary.withOpacity(0.05),
              cs.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Formulir Feedback',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Isi data dengan lengkap',
                            style: textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Data Diri Section
                        _buildSectionHeader(
                          context: context,
                          icon: Icons.person_outline,
                          title: 'Data Diri',
                        ),
                        const SizedBox(height: 16),
                        _buildModernCard(
                          context: context,
                          children: [
                            TextFormField(
                              controller: _namaCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Nama Lengkap',
                                hintText: 'Masukkan nama lengkap Anda',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Nama wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nimCtrl,
                              decoration: const InputDecoration(
                                labelText: 'NIM',
                                hintText: 'Masukkan NIM Anda',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'NIM wajib diisi';
                                }
                                if (int.tryParse(v.trim()) == null) {
                                  return 'NIM harus berupa angka';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _fakultas,
                              items: _fakultasOpts
                                  .map((f) => DropdownMenuItem(
                                value: f,
                                child: Text(f),
                              ))
                                  .toList(),
                              decoration: const InputDecoration(
                                labelText: 'Fakultas',
                                hintText: 'Pilih fakultas Anda',
                                prefixIcon: Icon(Icons.school_outlined),
                              ),
                              onChanged: (v) => setState(() => _fakultas = v),
                              validator: (v) => v == null ? 'Pilih fakultas' : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Fasilitas Section
                        _buildSectionHeader(
                          context: context,
                          icon: Icons.domain_verification_outlined,
                          title: 'Fasilitas yang Dinilai',
                        ),
                        const SizedBox(height: 16),
                        _buildModernCard(
                          context: context,
                          children: _fasilitasOpts
                              .map((f) => _buildCheckboxTile(
                            context: context,
                            title: f,
                            value: _fasilitasDipilih.contains(f),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  _fasilitasDipilih.add(f);
                                } else {
                                  _fasilitasDipilih.remove(f);
                                }
                              });
                            },
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 32),

                        // Penilaian Section
                        _buildSectionHeader(
                          context: context,
                          icon: Icons.star_outline,
                          title: 'Penilaian & Masukan',
                        ),
                        const SizedBox(height: 16),
                        _buildModernCard(
                          context: context,
                          children: [
                            Text(
                              'Nilai Kepuasan',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    label: _nilai.toStringAsFixed(0),
                                    value: _nilai,
                                    onChanged: (v) => setState(() => _nilai = v),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: cs.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _nilai.toStringAsFixed(0),
                                      style: textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: cs.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Jenis Feedback',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildRadioTile(
                              context: context,
                              value: FeedbackType.apresiasi,
                              groupValue: _jenis,
                              title: 'Apresiasi',
                              icon: Icons.thumb_up_alt_outlined,
                              color: Colors.green,
                              onChanged: (v) => setState(() => _jenis = v!),
                            ),
                            _buildRadioTile(
                              context: context,
                              value: FeedbackType.saran,
                              groupValue: _jenis,
                              title: 'Saran',
                              icon: Icons.lightbulb_outline,
                              color: Colors.amber,
                              onChanged: (v) => setState(() => _jenis = v!),
                            ),
                            _buildRadioTile(
                              context: context,
                              value: FeedbackType.keluhan,
                              groupValue: _jenis,
                              title: 'Keluhan',
                              icon: Icons.report_problem_outlined,
                              color: Colors.red,
                              onChanged: (v) => setState(() => _jenis = v!),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _pesanCtrl,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Pesan Tambahan (Opsional)',
                                hintText: 'Tulis pesan atau saran Anda di sini...',
                                alignLabelWithHint: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Agreement Section
                        Container(
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _setuju
                                  ? cs.primary.withOpacity(0.3)
                                  : cs.outline.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            title: const Text('Saya menyetujui Syarat & Ketentuan'),
                            subtitle: const Text(
                              'Data yang saya berikan adalah benar',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: _setuju,
                            onChanged: (v) => setState(() => _setuju = v),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        FilledButton.icon(
                          onPressed: _simpan,
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Kirim Feedback'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 16),
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

  Widget _buildSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: cs.onPrimaryContainer),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard({
    required BuildContext context,
    required List<Widget> children,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildCheckboxTile({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      title: Text(title),
      onChanged: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildRadioTile({
    required BuildContext context,
    required FeedbackType value,
    required FeedbackType groupValue,
    required String title,
    required IconData icon,
    required Color color,
    required ValueChanged<FeedbackType?> onChanged,
  }) {
    final isSelected = value == groupValue;
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : cs.outline.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<FeedbackType>(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? color : cs.onSurface),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? color : cs.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        activeColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}