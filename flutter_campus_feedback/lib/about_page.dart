import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.primary.withOpacity(0.08),
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
                    Text(
                      'Tentang Aplikasi',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
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
                    children: [
                      // Logo Section
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: cs.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/uin_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.school_rounded,
                            size: 60,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'UIN Sulthan Thaha Saifuddin Jambi',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Info Cards
                      _buildModernInfoCard(
                        context: context,
                        icon: Icons.book_outlined,
                        title: 'Mata Kuliah',
                        subtitle: 'Pemrograman Mobile',
                      ),
                      const SizedBox(height: 16),

                      _buildModernInfoCard(
                        context: context,
                        icon: Icons.person_outline,
                        title: 'Dosen Pengampu',
                        subtitle: 'Ahmad Nasukha, S.Hum., M.S.I',
                      ),
                      const SizedBox(height: 16),

                      _buildModernInfoCard(
                        context: context,
                        icon: Icons.code_outlined,
                        title: 'Pengembang',
                        subtitle: 'Rizki Alsyareno (701230063)',
                        highlight: true,
                      ),
                      const SizedBox(height: 16),

                      _buildModernInfoCard(
                        context: context,
                        icon: Icons.calendar_today_outlined,
                        title: 'Tahun Akademik',
                        subtitle: '2025/2026',
                      ),
                      const SizedBox(height: 32),

                      // Back Button
                      FilledButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.home_outlined),
                        label: const Text('Kembali ke Beranda'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
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

  Widget _buildModernInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    bool highlight = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: highlight ? cs.primaryContainer.withOpacity(0.5) : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: highlight
            ? Border.all(color: cs.primary.withOpacity(0.3), width: 1.5)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: highlight
                ? cs.primary.withOpacity(0.1)
                : cs.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: highlight ? cs.primary : cs.onSurface,
          ),
        ),
        title: Text(
          title,
          style: textTheme.labelLarge?.copyWith(
            color: cs.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}