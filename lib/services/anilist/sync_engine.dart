import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:folio/app/providers.dart';
import 'package:folio/services/anilist/anilist_client.dart';
import 'package:folio/services/anilist/sync_service.dart';

final syncEnCoursProvider =
    NotifierProvider<SyncEnCoursNotifier, bool>(SyncEnCoursNotifier.new);

class SyncEnCoursNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool valeur) => state = valeur;
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(ref);
  ref.onDispose(engine.dispose);
  return engine;
});

class SyncEngine {
  static const intervalleRequetes = Duration(milliseconds: 2500);
  static const fraicheur = Duration(hours: 24);
  static const debounce = Duration(minutes: 15);

  final Ref _ref;
  StreamSubscription<List<ConnectivityResult>>? _aboConnectivite;
  bool _etaitHorsLigne = false;
  bool _enCours = false;
  DateTime? _dernierePasse;

  SyncEngine(this._ref);

  void demarrer() {
    _aboConnectivite ??= Connectivity().onConnectivityChanged.listen((etats) {
      final horsLigne =
          etats.isEmpty || etats.every((e) => e == ConnectivityResult.none);
      if (_etaitHorsLigne && !horsLigne) runAll();
      _etaitHorsLigne = horsLigne;
    });
    runAll();
  }

  Future<void> runAll({bool force = false}) async {
    if (_enCours) return;
    if (!_ref.read(syncPrefsProvider).maitre) return;
    final maintenant = DateTime.now();
    if (!force &&
        _dernierePasse != null &&
        maintenant.difference(_dernierePasse!) < debounce) {
      return;
    }

    _enCours = true;
    _dernierePasse = maintenant;
    _ref.read(syncEnCoursProvider.notifier).set(true);
    try {
      final dao = _ref.read(mangaDaoProvider);
      final service = _ref.read(syncServiceProvider);
      final tous = await dao.getAllMangas();
      final candidats = tous
          .where((m) => m.anilistId != null)
          .where((m) =>
              force ||
              m.lastSyncedAt == null ||
              maintenant.difference(m.lastSyncedAt!) >= fraicheur)
          .toList()
        ..sort((a, b) {
          if (a.lastSyncedAt == null && b.lastSyncedAt == null) return 0;
          if (a.lastSyncedAt == null) return -1;
          if (b.lastSyncedAt == null) return 1;
          return a.lastSyncedAt!.compareTo(b.lastSyncedAt!);
        });

      for (final manga in candidats) {
        if (!_ref.read(syncPrefsProvider).maitre) break;
        try {
          await service.syncOne(manga);
        } on AnilistRateLimitException catch (e) {
          await Future.delayed(e.retryAfter);
        } on AnilistNetworkException {
          break;
        } catch (_) {
          break;
        }
        await Future.delayed(intervalleRequetes);
      }
    } finally {
      _enCours = false;
      _ref.read(syncEnCoursProvider.notifier).set(false);
    }
  }

  void dispose() {
    _aboConnectivite?.cancel();
  }
}
