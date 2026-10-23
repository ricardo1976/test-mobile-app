import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';

enum HomeStatus { loading, available, completed, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeStatus _status = HomeStatus.loading;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await widget.dependencies.initialize();
      final completed = widget.dependencies.progressRepository.completedToday();
      if (!mounted) return;
      setState(() {
        _status = completed ? HomeStatus.completed : HomeStatus.available;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = HomeStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildBody(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_status) {
      case HomeStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case HomeStatus.error:
        return Center(child: Text('No se pudo cargar la aplicación.'));
      case HomeStatus.available:
      case HomeStatus.completed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Cuánto recuerdas?',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              _status == HomeStatus.completed
                  ? 'Ya completaste el reto de hoy.'
                  : 'Reto diario disponible.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/quiz'),
              child: const Text('Jugar reto diario'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/history'),
              child: const Text('Ver historial'),
            ),
          ],
        );
    }
  }
}
