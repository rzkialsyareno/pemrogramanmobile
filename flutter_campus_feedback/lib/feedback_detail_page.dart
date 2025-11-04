import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  const FeedbackDetailPage({super.key, required this.item});
  final FeedbackItem item;

  IconData _feedbackIcon(FeedbackType jenis) {
    switch (jenis) {
      case FeedbackType.apresiasi:
        return Icons.thumb_up_alt_rounded;
      case FeedbackType.saran:
        return Icons.lightbulb_rounded;
      case FeedbackType.keluhan:
        return Icons.report_problem_rounded;
    }
  }

  Color _feedbackColor(FeedbackType jenis) {
    switch (jenis) {
      case FeedbackType.apresiasi:
        return Colors.green;
      case FeedbackType.saran:
        return Colors.amber;
      case FeedbackType.keluhan:
        return Colors.red;
    }
  }

  String _feedbackLabel(FeedbackType jenis) {
    switch (jenis) {
      case FeedbackType.apresiasi:
        return 'Apresiasi';
      case FeedbackType.saran:
        return 'Saran';
      case FeedbackType.keluhan:
        return 'Keluhan';
    }
  }

  Future<void> _hapus(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(
          Icons.delete_outline,
          size: 48,
          color: Theme.of(ctx).colorScheme.error,
        ),
        title: const Text('Hapus Feedback'),
        content: const Text(
          'Anda yakin ingin menghapus feedback ini secara permanen? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true) {
      FeedbackStore.items.removeWhere((e) => e.id == item.id);
      if (context.mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Feedback telah dihapus'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final color = _feedbackColor(item.jenis);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.08),
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
                      child: Text(
                        'Detail Feedback',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => _hapus(context),
                      icon: const Icon(Icons.delete_outline),
                      style: IconButton.styleFrom(
                        backgroundColor: cs.errorContainer,
                        foregroundColor: cs.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Card
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.15),
                              color.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: color.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _feedbackIcon(item.jenis),
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _feedbackLabel(item.jenis).toUpperCase(),
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.nilaiKepuasan.toStringAsFixed(1)} / 5.0',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Student Info
                      _buildSectionCard(
                        context: context,
                        title: 'Informasi Mahasiswa',
                        icon: Icons.person_outline,
                        children: [
                          _buildInfoRow(
                            context: context,
                            icon: Icons.badge_outlined,
                            label: 'Nama',
                            value: item.nama,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            context: context,
                            icon: Icons.numbers,
                            label: 'NIM',
                            value: item.nim,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            context: context,
                            icon: Icons.school_outlined,
                            label: 'Fakultas',
                            value: item.fakultas,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Feedback Details
                      _buildSectionCard(
                        context: context,
                        title: 'Detail Penilaian',
                        icon: Icons.assignment_outlined,
                        children: [
                          _buildInfoRow(
                            context: context,
                            icon: Icons.domain_verification_outlined,
                            label: 'Fasilitas',
                            value: item.fasilitasDipilih.join(', '),
                          ),
                          if (item.pesanTambahan.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Pesan Tambahan',
                              style: textTheme.labelLarge?.copyWith(
                                color: cs.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.pesanTambahan,
                                style: textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Agreement Status
                      _buildSectionCard(
                        context: context,
                        title: 'Status Persetujuan',
                        icon: Icons.verified_outlined,
                        children: [
                          Row(
                            children: [
                              Icon(
                                item.setujuSk
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: item.setujuSk ? Colors.green : Colors.red,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Syarat & Ketentuan',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.setujuSk ? 'Disetujui' : 'Tidak Disetujui',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: item.setujuSk ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final textTheme = Theme.of(context).textTheme;
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
        children: [
          Row(
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
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: cs.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: cs.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}