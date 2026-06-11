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
  bool _arretDemande = false;
  DateTime? _dernierePasse;

  SyncEngine(this._ref);

  void annuler() => _arretDemande = true;

  bool get _doitContinuer =>
      !_arretDemande && _ref.read(syncPrefsProvider).maitre;

  Future<void> _attendre(Duration duree) async {
    final fin = DateTime.now().add(duree);
    while (DateTime.now().isBefore(fin)) {
      if (!_doitContinuer) return;
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

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
    _arretDemande = false;
    _dernierePasse = maintenant;
    _ref.read(syncEnCoursProvider.notifier).set(true);
    try {
      final dao = _ref.read(mangaDaoProvider);
      final service = _ref.read(syncServiceProvider);
      final tous = await dao.getAllMangas();
      final candidats = tous
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
        if (!_doitContinuer) break;
        try {
          var courant = manga;
          if (courant.anilistId == null) {
            if (!await service.lierAuto(courant)) continue;
            await _attendre(intervalleRequetes);
            if (!_doitContinuer) break;
            final relu = await dao.getManga(courant.id);
            if (relu == null || relu.anilistId == null) continue;
            courant = relu;
          }
          await service.syncOne(courant);
        } on AnilistRateLimitException catch (e) {
          await _attendre(e.retryAfter);
        } on AnilistNetworkException {
          break;
        } catch (_) {
          break;
        }
        await _attendre(intervalleRequetes);
      }
    } finally {
      _enCours = false;
      _ref.read(syncEnCoursProvider.notifier).set(false);
    }
  }

  Future<void> syncManga(int id) async {
    if (_enCours) return;
    if (!_ref.read(syncPrefsProvider).maitre) return;
    _enCours = true;
    _arretDemande = false;
    _ref.read(syncEnCoursProvider.notifier).set(true);
    try {
      final dao = _ref.read(mangaDaoProvider);
      final service = _ref.read(syncServiceProvider);
      var manga = await dao.getManga(id);
      if (manga == null) return;
      if (manga.anilistId == null) {
        if (!await service.lierAuto(manga)) return;
        await _attendre(intervalleRequetes);
        if (!_doitContinuer) return;
        manga = await dao.getManga(id);
        if (manga == null || manga.anilistId == null) return;
      }
      await service.syncOne(manga);
    } catch (_) {
    } finally {
      _enCours = false;
      _ref.read(syncEnCoursProvider.notifier).set(false);
    }
  }

  void dispose() {
    _aboConnectivite?.cancel();
  }
}
