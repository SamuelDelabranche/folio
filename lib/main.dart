import 'package:flutter/material.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/features/splash/splash_page.dart';
import 'app/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(themeModeProvider.notifier).load();
  await container.read(viewModeProvider.notifier).load();
  await container.read(startTabProvider.notifier).load();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Folio',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const SplashPage(),
    );
  }
}
