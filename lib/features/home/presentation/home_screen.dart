import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BrandHeader(),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.mustard.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'FASE DE DEMOSTRACIÓN',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '¿Cuánto\nrecuerdas?',
                    style: textTheme.headlineLarge?.copyWith(fontSize: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Un pequeño viaje por la cultura popular que marcó los '
                    '80, los 90 y los 2000.',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  const _DailyQuizPreview(),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'El juego todavía no está activo.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppPalette.ink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.graphic_eq, color: AppPalette.paper),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '¿Cuánto recuerdas?',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: AppPalette.ink, fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          'V0.1',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppPalette.mutedInk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DailyQuizPreview extends StatelessWidget {
  const _DailyQuizPreview();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.ink.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, color: AppPalette.coral),
              const SizedBox(width: 8),
              Text('EL RETO DIARIO', style: textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '5',
                style: textTheme.displayLarge?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w800,
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'preguntas para despertar recuerdos',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            'Televisión, música, cine y mucho más.',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
