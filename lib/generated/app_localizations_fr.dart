// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonWarning => 'Attention !';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get statusToRead => 'À lire';

  @override
  String get statusReading => 'En cours';

  @override
  String get statusFinished => 'Terminé';

  @override
  String get statusDropped => 'Abandonné';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navStatistics => 'Statistiques';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get libTitle => 'Ma bibliothèque';

  @override
  String get libEmpty => 'Votre bibliothèque est vide';

  @override
  String get libEmptyHint => 'Appuyez sur + pour ajouter un manga';

  @override
  String get libSearch => 'Rechercher un manga...';

  @override
  String libSelectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get libNoResult => 'Aucun manga trouvé';

  @override
  String get libDeleteContent =>
      'Cette action est irréversible.\nLes mangas seront définitivement supprimés.';

  @override
  String get libDeleteSuccess => 'Manga(s) supprimé(s)';

  @override
  String get libViewChange => 'Changer de vue';

  @override
  String get libFilterTitle => 'Filtres & Tri';

  @override
  String get libFilterReset => 'Réinitialiser';

  @override
  String get libFilterSortBy => 'Trier par';

  @override
  String get libFilterAlpha => 'Alphabétique';

  @override
  String get libFilterRating => 'Note';

  @override
  String get libFilterChapters => 'Chapitres';

  @override
  String get libFilterStatus => 'Statut';

  @override
  String get libFilterType => 'Type';

  @override
  String get libFilterFavorites => 'Favoris';

  @override
  String get libFilterFavoritesOnly => 'Favoris uniquement';

  @override
  String get libFilterChaptersRead => 'Chapitres lus';

  @override
  String get libChaptersPlus => '1000+';

  @override
  String get addCustomGenre => 'Ajouter un genre';

  @override
  String get addCustomType => 'Ajouter un type';

  @override
  String get addCustomDeleteTitle => 'Supprimer ce type ?';

  @override
  String get addTitle => 'Ajouter un manga';

  @override
  String get addMangaTitle => 'Titre du manga';

  @override
  String get addChaptersRead => 'Chapitres lus';

  @override
  String get addRating => 'Note';

  @override
  String get addType => 'Type';

  @override
  String get addStatus => 'Statut';

  @override
  String get addGenres => 'Genres';

  @override
  String addGenresCount(int count) {
    return 'Genres ($count)';
  }

  @override
  String get addSearchGenre => 'Rechercher un genre...';

  @override
  String get addFavoriteAdd => 'Ajouter aux favoris';

  @override
  String get addFavoriteIn => 'Dans vos favoris';

  @override
  String get addLinks => 'Liens d\'accès';

  @override
  String addLinksCount(int count) {
    return 'Liens d\'accès ($count)';
  }

  @override
  String get addRequired => 'Champ requis';

  @override
  String get addInvalidNumber => 'Nombre invalide';

  @override
  String get detailDescription => 'Description';

  @override
  String get detailNoDescription => 'Aucune description';

  @override
  String get detailGenres => 'Genres';

  @override
  String detailSelectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get detailNoGenre => 'Aucun genre renseigné';

  @override
  String get detailSearchGenre => 'Rechercher un genre...';

  @override
  String get detailInfo => 'Informations';

  @override
  String get detailType => 'Type';

  @override
  String get detailStatus => 'Statut';

  @override
  String get detailChaptersRead => 'Chapitres lus';

  @override
  String get detailRating => 'Note';

  @override
  String get detailLinks => 'Liens d\'accès';

  @override
  String get detailNoLink => 'Aucun lien renseigné';

  @override
  String get detailAddLink => 'Ajouter un lien';

  @override
  String get detailLinkCopied => 'Lien copié';

  @override
  String get detailSyncSection => 'Synchronisation AniList';

  @override
  String detailLinked(int id) {
    return 'Lié à AniList (#$id)';
  }

  @override
  String get detailNotLinked => 'Non lié à AniList';

  @override
  String detailLastSync(String date) {
    return 'Dernière synchro : $date';
  }

  @override
  String get detailNeverSynced => 'Jamais synchronisé';

  @override
  String get detailLink => 'Lier';

  @override
  String get detailUnlink => 'Délier';

  @override
  String get detailSyncNow => 'Synchroniser maintenant';

  @override
  String get detailSyncing => 'Synchronisation…';

  @override
  String get detailSyncSuccess => 'Fiche synchronisée';

  @override
  String get detailSyncNoMatch => 'Aucune fiche AniList trouvée pour ce titre';

  @override
  String detailSyncRateLimit(int seconds) {
    return 'AniList est saturé — réessaie dans $seconds s';
  }

  @override
  String get detailSyncError =>
      'Synchronisation impossible. Vérifie ta connexion.';

  @override
  String get detailSyncCover => 'Image de couverture';

  @override
  String get detailSyncCoverCustom =>
      'Image personnalisée — jamais écrasée par la synchro';

  @override
  String get detailSyncDescription => 'Description';

  @override
  String get detailSyncGenres => 'Genres';

  @override
  String get detailSyncType => 'Type';

  @override
  String get detailSyncGlobalOff => 'Désactivé globalement (Paramètres)';

  @override
  String get detailDeleteContent =>
      'Cette action est irréversible.\nLe manga sera définitivement supprimé.';

  @override
  String get detailDeleteSuccess => 'Manga supprimé';

  @override
  String get detailImageImport => 'Importer une image';

  @override
  String get detailImageGallery => 'Choisir depuis la galerie';

  @override
  String get detailImageDelete => 'Supprimer l\'image';

  @override
  String get detailImageCustomInfo =>
      'Image personnalisée — la synchro de la cover est désactivée pour ce manga';

  @override
  String get detailImageError => 'Impossible d\'importer cette image';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get statsMangas => 'Mangas';

  @override
  String get statsAvgRating => 'Note moy.';

  @override
  String get statsChapters => 'Chapitres';

  @override
  String get statsByStatus => 'Par statut';

  @override
  String get statsByType => 'Par type';

  @override
  String get statsTopGenres => 'Top genres';

  @override
  String get statsNoGenre => 'Aucun genre renseigné';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionGeneral => 'Général';

  @override
  String get settingsSectionData => 'Données';

  @override
  String get settingsSectionSync => 'Synchronisation';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsStartTab => 'Onglet de démarrage';

  @override
  String get settingsReplayIntro => 'Revoir l\'introduction';

  @override
  String get settingsReplayIntroSub => 'Rejouer les écrans de bienvenue';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsExport => 'Exporter la bibliothèque';

  @override
  String get settingsExportSub => 'Partager un fichier JSON';

  @override
  String get settingsExportEmpty => 'Aucun manga à exporter';

  @override
  String get settingsExportError => 'Erreur lors de l\'export';

  @override
  String get settingsImport => 'Importer la bibliothèque';

  @override
  String get settingsImportSub => 'Remplace les données existantes';

  @override
  String get settingsImportWarning =>
      'Cette action est irréversible.\nLes mangas déjà présents seront définitivement supprimés.';

  @override
  String get settingsImportWarningTags =>
      'Les genres et types personnalisés du fichier seront également ajoutés à votre liste.';

  @override
  String get settingsImportContinue => 'Continuer';

  @override
  String settingsImportSuccess(int count) {
    return '$count manga(s) importé(s)';
  }

  @override
  String get settingsImportError => 'Fichier invalide ou corrompu';

  @override
  String get settingsClear => 'Tout effacer';

  @override
  String get settingsClearSub => 'Supprime définitivement la bibliothèque';

  @override
  String get settingsClearContent =>
      'Toute votre bibliothèque sera définitivement supprimée.\n\nPensez à exporter vos données avant !';

  @override
  String get settingsClearSuccess => 'Bibliothèque effacée';

  @override
  String get settingsSyncAnilist => 'Synchronisation AniList';

  @override
  String get settingsSyncAnilistSub =>
      'Uniquement à la demande, jamais automatique';

  @override
  String get settingsSyncCovers => 'Images de couverture';

  @override
  String get settingsSyncDescriptions => 'Descriptions';

  @override
  String get settingsSyncGenres => 'Genres';

  @override
  String get settingsSyncTypes => 'Types (Manga, Manhwa…)';

  @override
  String get settingsSyncStop => 'Arrêter la synchronisation';

  @override
  String get settingsSyncStopSub => 'Une synchronisation est en cours';

  @override
  String get settingsSyncLinkAll => 'Tout lier';

  @override
  String get settingsSyncLinkAllSub =>
      'Lie automatiquement les mangas non liés';

  @override
  String get settingsSyncAll => 'Tout synchroniser';

  @override
  String get settingsSyncAllSub => 'Lie et met à jour toute la bibliothèque';

  @override
  String get settingsSyncNote =>
      'Chaque manga peut aussi désactiver ces champs individuellement dans sa fiche. Données fournies par AniList (anilist.co).';

  @override
  String settingsSyncLinkDialog(int count, String estimate) {
    return '$count manga(s) non lié(s) — environ $estimate.\n\nChaque manga sera lié à la fiche AniList correspondant le mieux à son titre, puis synchronisé. Tu pourras corriger une liaison depuis la fiche (mode édition).';
  }

  @override
  String settingsSyncAllDialog(int count, String estimate) {
    return '$count manga(s) — environ $estimate.\n\nLes mangas non liés seront d\'abord liés à AniList. La synchronisation tournera en arrière-plan, tu peux continuer à utiliser l\'application.';
  }

  @override
  String get settingsSyncLaunch => 'Lancer';

  @override
  String get settingsSyncAlreadyLinked => 'Tous les mangas sont déjà liés';

  @override
  String get settingsSyncLibraryEmpty => 'La bibliothèque est vide';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeAuto => 'Automatique';

  @override
  String get settingsThemeTitle => 'Apparence';

  @override
  String get settingsCheckUpdate => 'Vérifier les mises à jour';

  @override
  String get settingsCheckUpdateSub => 'Rechercher une nouvelle version';

  @override
  String get settingsUpToDate => 'Folio est à jour';

  @override
  String settingsUpdateAvailable(String version) {
    return 'Version $version disponible';
  }

  @override
  String get settingsUpdateDownload => 'Télécharger';

  @override
  String get settingsUpdateError => 'Vérification impossible (hors ligne ?)';

  @override
  String get settingsSourceCode => 'Code source';

  @override
  String get settingsSourceCodeSub => 'Folio est open source (GitHub)';

  @override
  String get settingsStartTabTitle => 'Onglet de démarrage';

  @override
  String get settingsCopyright => 'Contenus & droits d\'auteur';

  @override
  String get settingsCopyrightSub => 'Images, données et mentions légales';

  @override
  String get copyrightTitle => 'Contenus & droits d\'auteur';

  @override
  String get copyrightBody =>
      'Les images de couverture et les informations bibliographiques sont fournies par AniList (anilist.co), une base de données communautaire gérée par ses utilisateurs.\n\nFolio n\'héberge aucun contenu. Toutes les images restent la propriété de leurs auteurs et éditeurs respectifs.\n\nSi vous êtes auteur, éditeur ou titulaire de droits et souhaitez signaler un contenu, ouvrez une issue sur le dépôt GitHub du projet :';

  @override
  String get copyrightContact => 'github.com/SamuelDelabranche/folio/issues';

  @override
  String get updateDialogTitle => 'Mise à jour disponible';

  @override
  String updateDialogContent(String version) {
    return 'La version $version est disponible.\n\nTélécharge le nouvel APK depuis GitHub et installe-le pour mettre à jour.';
  }

  @override
  String get updateDialogLater => 'Plus tard';

  @override
  String get updateDialogDownload => 'Télécharger';

  @override
  String get anilistSheetTitle => 'Lier à AniList';

  @override
  String get anilistSheetHint => 'Titre du manga…';

  @override
  String get anilistSheetNoResult => 'Aucun résultat';

  @override
  String anilistSheetRateLimit(int seconds) {
    return 'Trop de requêtes — réessaie dans $seconds s';
  }

  @override
  String get anilistSheetNetworkError =>
      'Recherche impossible. Vérifie ta connexion.';

  @override
  String get anilistSheetRetry => 'Réessayer';

  @override
  String get anilistSheetPoweredBy => 'Données fournies par AniList';

  @override
  String get lienDialogTitle => 'Ajouter un lien';

  @override
  String get lienDialogNom => 'Nom';

  @override
  String get lienDialogNomHint => 'ex: Scan VF';

  @override
  String get lienDialogUrl => 'URL';

  @override
  String get lienDialogUrlHint => 'https://...';

  @override
  String get lienDialogUrlError => 'URL invalide (http/https requis)';

  @override
  String get genreAction => 'Action';

  @override
  String get genreAdventure => 'Aventure';

  @override
  String get genreMartialArts => 'Arts martiaux';

  @override
  String get genreSports => 'Sports';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreComedy => 'Comédie';

  @override
  String get genreDrama => 'Drame';

  @override
  String get genreSliceOfLife => 'Tranche de vie';

  @override
  String get genreMystery => 'Mystère';

  @override
  String get genreThriller => 'Thriller';

  @override
  String get genreHorror => 'Horreur';

  @override
  String get genrePsychological => 'Psychologique';

  @override
  String get genreFantasy => 'Fantaisie';

  @override
  String get genreSciFi => 'Science-fiction';

  @override
  String get genreIsekai => 'Isekai';

  @override
  String get genreSupernatural => 'Surnaturel';

  @override
  String get genreMecha => 'Mecha';

  @override
  String get genreMagic => 'Magie';

  @override
  String get genreHistorical => 'Historique';

  @override
  String get genreMusic => 'Musique';

  @override
  String get genreCooking => 'Cuisine';

  @override
  String get genreGame => 'Jeux';

  @override
  String get genreEcchi => 'Ecchi';

  @override
  String get genreHarem => 'Harem';

  @override
  String get genreShonen => 'Shonen';

  @override
  String get genreShojo => 'Shojo';

  @override
  String get genreSeinen => 'Seinen';

  @override
  String get genreJosei => 'Josei';

  @override
  String get genreKodomomuke => 'Kodomomuke';

  @override
  String get genreYaoi => 'Yaoi';

  @override
  String get genreYuri => 'Yuri';

  @override
  String get genreGore => 'Gore';

  @override
  String get genreMilitary => 'Militaire';

  @override
  String get genrePolitics => 'Politique';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get onboardingSlide1Tag => 'Bienvenue';

  @override
  String get onboardingSlide1Title => 'Ta bibliothèque manga\nen un endroit';

  @override
  String get onboardingSlide1Desc =>
      'Ajoute, organise et retrouve\ntous tes mangas facilement.';

  @override
  String get onboardingSlide2Tag => 'Statistiques';

  @override
  String get onboardingSlide2Title => 'Note et analyse\nta progression';

  @override
  String get onboardingSlide2Desc =>
      'Suis tes chapitres lus, tes notes\net tes genres préférés.';

  @override
  String get onboardingSlide3Tag => 'Prêt !';

  @override
  String get onboardingSlide3Title => 'Lance-toi dans\nta collection';

  @override
  String get onboardingSlide3Desc =>
      'Importe ta liste existante ou\ncommence une nouvelle bibliothèque.';
}
