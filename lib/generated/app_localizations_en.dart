// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonWarning => 'Warning!';

  @override
  String get commonAdd => 'Add';

  @override
  String get statusToRead => 'To read';

  @override
  String get statusReading => 'Reading';

  @override
  String get statusFinished => 'Finished';

  @override
  String get statusDropped => 'Dropped';

  @override
  String get navLibrary => 'Library';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get navSettings => 'Settings';

  @override
  String get libTitle => 'My library';

  @override
  String get libEmpty => 'Your library is empty';

  @override
  String get libEmptyHint => 'Tap + to add a manga';

  @override
  String get libSearch => 'Search a manga...';

  @override
  String libSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get libNoResult => 'No manga found';

  @override
  String get libDeleteContent =>
      'This action cannot be undone.\nThe mangas will be permanently deleted.';

  @override
  String get libDeleteSuccess => 'Manga(s) deleted';

  @override
  String get libViewChange => 'Change view';

  @override
  String get libFilterTitle => 'Filters & Sort';

  @override
  String get libFilterReset => 'Reset';

  @override
  String get libFilterSortBy => 'Sort by';

  @override
  String get libFilterAlpha => 'Alphabetical';

  @override
  String get libFilterRating => 'Rating';

  @override
  String get libFilterChapters => 'Chapters';

  @override
  String get libFilterStatus => 'Status';

  @override
  String get libFilterType => 'Type';

  @override
  String get libFilterFavorites => 'Favorites';

  @override
  String get libFilterFavoritesOnly => 'Favorites only';

  @override
  String get libFilterChaptersRead => 'Chapters read';

  @override
  String get libChaptersPlus => '1000+';

  @override
  String get addCustomGenre => 'Add a genre';

  @override
  String get addCustomType => 'Add a type';

  @override
  String get addCustomDeleteTitle => 'Delete this type?';

  @override
  String get addTitle => 'Add a manga';

  @override
  String get addMangaTitle => 'Manga title';

  @override
  String get addChaptersRead => 'Chapters read';

  @override
  String get addRating => 'Rating';

  @override
  String get addType => 'Type';

  @override
  String get addStatus => 'Status';

  @override
  String get addGenres => 'Genres';

  @override
  String addGenresCount(int count) {
    return 'Genres ($count)';
  }

  @override
  String get addSearchGenre => 'Search a genre...';

  @override
  String get addFavoriteAdd => 'Add to favorites';

  @override
  String get addFavoriteIn => 'In your favorites';

  @override
  String get addLinks => 'Access links';

  @override
  String addLinksCount(int count) {
    return 'Access links ($count)';
  }

  @override
  String get addRequired => 'Required field';

  @override
  String get addInvalidNumber => 'Invalid number';

  @override
  String get detailDescription => 'Description';

  @override
  String get detailNoDescription => 'No description';

  @override
  String get detailGenres => 'Genres';

  @override
  String detailSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get detailNoGenre => 'No genre added';

  @override
  String get detailSearchGenre => 'Search a genre...';

  @override
  String get detailInfo => 'Information';

  @override
  String get detailType => 'Type';

  @override
  String get detailStatus => 'Status';

  @override
  String get detailChaptersRead => 'Chapters read';

  @override
  String get detailRating => 'Rating';

  @override
  String get detailLinks => 'Access links';

  @override
  String get detailNoLink => 'No links added';

  @override
  String get detailAddLink => 'Add a link';

  @override
  String get detailLinkCopied => 'Link copied';

  @override
  String get detailSyncSection => 'AniList Sync';

  @override
  String detailLinked(int id) {
    return 'Linked to AniList (#$id)';
  }

  @override
  String get detailNotLinked => 'Not linked to AniList';

  @override
  String detailLastSync(String date) {
    return 'Last sync: $date';
  }

  @override
  String get detailNeverSynced => 'Never synced';

  @override
  String get detailLink => 'Link';

  @override
  String get detailUnlink => 'Unlink';

  @override
  String get detailSyncNow => 'Sync now';

  @override
  String get detailSyncing => 'Syncing…';

  @override
  String get detailSyncSuccess => 'Entry synced';

  @override
  String get detailSyncNoMatch => 'No AniList entry found for this title';

  @override
  String detailSyncRateLimit(int seconds) {
    return 'AniList is rate-limited — retry in $seconds s';
  }

  @override
  String get detailSyncError => 'Sync failed. Check your connection.';

  @override
  String get detailSyncCover => 'Cover image';

  @override
  String get detailSyncCoverCustom =>
      'Custom image — never overwritten by sync';

  @override
  String get detailSyncDescription => 'Description';

  @override
  String get detailSyncGenres => 'Genres';

  @override
  String get detailSyncType => 'Type';

  @override
  String get detailSyncGlobalOff => 'Disabled globally (Settings)';

  @override
  String get detailDeleteContent =>
      'This action cannot be undone.\nThe manga will be permanently deleted.';

  @override
  String get detailDeleteSuccess => 'Manga deleted';

  @override
  String get detailImageImport => 'Import an image';

  @override
  String get detailImageGallery => 'Choose from gallery';

  @override
  String get detailImageDelete => 'Delete image';

  @override
  String get detailImageCustomInfo =>
      'Custom image — cover sync disabled for this manga';

  @override
  String get detailImageError => 'Unable to import this image';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsMangas => 'Mangas';

  @override
  String get statsAvgRating => 'Avg. rating';

  @override
  String get statsChapters => 'Chapters';

  @override
  String get statsByStatus => 'By status';

  @override
  String get statsByType => 'By type';

  @override
  String get statsTopGenres => 'Top genres';

  @override
  String get statsNoGenre => 'No genre added';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsSectionSync => 'Sync';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsStartTab => 'Start tab';

  @override
  String get settingsReplayIntro => 'Replay introduction';

  @override
  String get settingsReplayIntroSub => 'Replay the welcome screens';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsExport => 'Export library';

  @override
  String get settingsExportSub => 'Share a JSON file';

  @override
  String get settingsExportEmpty => 'No manga to export';

  @override
  String get settingsExportError => 'Export failed';

  @override
  String get settingsImport => 'Import library';

  @override
  String get settingsImportSub => 'Replaces existing data';

  @override
  String get settingsImportWarning =>
      'This action cannot be undone.\nExisting mangas will be permanently deleted.';

  @override
  String get settingsImportWarningTags =>
      'Custom genres and types from the file will also be added to your list.';

  @override
  String get settingsImportContinue => 'Continue';

  @override
  String settingsImportSuccess(int count) {
    return '$count manga(s) imported';
  }

  @override
  String get settingsImportError => 'Invalid or corrupted file';

  @override
  String get settingsClear => 'Clear all';

  @override
  String get settingsClearSub => 'Permanently deletes the library';

  @override
  String get settingsClearContent =>
      'Your entire library will be permanently deleted.\n\nMake sure to export your data first!';

  @override
  String get settingsClearSuccess => 'Library cleared';

  @override
  String get settingsSyncAnilist => 'AniList Sync';

  @override
  String get settingsSyncAnilistSub => 'On demand only, never automatic';

  @override
  String get settingsSyncCovers => 'Cover images';

  @override
  String get settingsSyncDescriptions => 'Descriptions';

  @override
  String get settingsSyncGenres => 'Genres';

  @override
  String get settingsSyncTypes => 'Types (Manga, Manhwa…)';

  @override
  String get settingsSyncStop => 'Stop sync';

  @override
  String get settingsSyncStopSub => 'A sync is currently running';

  @override
  String get settingsSyncLinkAll => 'Link all';

  @override
  String get settingsSyncLinkAllSub => 'Automatically link unlinked mangas';

  @override
  String get settingsSyncAll => 'Sync all';

  @override
  String get settingsSyncAllSub => 'Link and update the entire library';

  @override
  String get settingsSyncNote =>
      'Each manga can also disable these fields individually in its entry. Data provided by AniList (anilist.co).';

  @override
  String settingsSyncLinkDialog(int count, String estimate) {
    return '$count unlinked manga(s) — about $estimate.\n\nEach manga will be matched to the best AniList entry. You can correct a link from the manga entry (edit mode).';
  }

  @override
  String settingsSyncAllDialog(int count, String estimate) {
    return '$count manga(s) — about $estimate.\n\nUnlinked mangas will be linked to AniList first. The sync runs in the background, you can keep using the app.';
  }

  @override
  String get settingsSyncLaunch => 'Start';

  @override
  String get settingsSyncAlreadyLinked => 'All mangas are already linked';

  @override
  String get settingsSyncLibraryEmpty => 'The library is empty';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeAuto => 'Automatic';

  @override
  String get settingsThemeTitle => 'Appearance';

  @override
  String get settingsCheckUpdate => 'Check for updates';

  @override
  String get settingsCheckUpdateSub => 'Look for a new version';

  @override
  String get settingsUpToDate => 'Folio is up to date';

  @override
  String settingsUpdateAvailable(String version) {
    return 'Version $version available';
  }

  @override
  String get settingsUpdateDownload => 'Download';

  @override
  String get settingsUpdateError => 'Check failed (offline?)';

  @override
  String get settingsSourceCode => 'Source code';

  @override
  String get settingsSourceCodeSub => 'Folio is open source (GitHub)';

  @override
  String get settingsStartTabTitle => 'Start tab';

  @override
  String get settingsCopyright => 'Content & copyright';

  @override
  String get settingsCopyrightSub => 'Images, data and legal notices';

  @override
  String get copyrightTitle => 'Content & copyright';

  @override
  String get copyrightBody =>
      'Cover images and bibliographic information are provided by AniList (anilist.co), a community database managed by its users.\n\nFolio does not host any content. All images remain the property of their respective authors and publishers.\n\nIf you are an author, publisher, or rights holder and wish to report content, please open an issue on the project\'s GitHub repository:';

  @override
  String get copyrightContact => 'github.com/SamuelDelabranche/folio/issues';

  @override
  String get updateDialogTitle => 'Update available';

  @override
  String updateDialogContent(String version) {
    return 'Version $version is available.\n\nDownload the new APK from GitHub and install it to update.';
  }

  @override
  String get updateDialogLater => 'Later';

  @override
  String get updateDialogDownload => 'Download';

  @override
  String get anilistSheetTitle => 'Link to AniList';

  @override
  String get anilistSheetHint => 'Manga title…';

  @override
  String get anilistSheetNoResult => 'No results';

  @override
  String anilistSheetRateLimit(int seconds) {
    return 'Too many requests — retry in $seconds s';
  }

  @override
  String get anilistSheetNetworkError =>
      'Search failed. Check your connection.';

  @override
  String get anilistSheetRetry => 'Retry';

  @override
  String get anilistSheetPoweredBy => 'Data provided by AniList';

  @override
  String get lienDialogTitle => 'Add a link';

  @override
  String get lienDialogNom => 'Name';

  @override
  String get lienDialogNomHint => 'e.g. Read online';

  @override
  String get lienDialogUrl => 'URL';

  @override
  String get lienDialogUrlHint => 'https://...';

  @override
  String get lienDialogUrlError => 'Invalid URL (http/https required)';

  @override
  String get genreAction => 'Action';

  @override
  String get genreAdventure => 'Adventure';

  @override
  String get genreMartialArts => 'Martial Arts';

  @override
  String get genreSports => 'Sports';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreComedy => 'Comedy';

  @override
  String get genreDrama => 'Drama';

  @override
  String get genreSliceOfLife => 'Slice of Life';

  @override
  String get genreMystery => 'Mystery';

  @override
  String get genreThriller => 'Thriller';

  @override
  String get genreHorror => 'Horror';

  @override
  String get genrePsychological => 'Psychological';

  @override
  String get genreFantasy => 'Fantasy';

  @override
  String get genreSciFi => 'Sci-Fi';

  @override
  String get genreIsekai => 'Isekai';

  @override
  String get genreSupernatural => 'Supernatural';

  @override
  String get genreMecha => 'Mecha';

  @override
  String get genreMagic => 'Magic';

  @override
  String get genreHistorical => 'Historical';

  @override
  String get genreMusic => 'Music';

  @override
  String get genreCooking => 'Cooking';

  @override
  String get genreGame => 'Game';

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
  String get genreMilitary => 'Military';

  @override
  String get genrePolitics => 'Politics';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingSlide1Tag => 'Welcome';

  @override
  String get onboardingSlide1Title => 'Your manga library\nin one place';

  @override
  String get onboardingSlide1Desc =>
      'Add, organize and find\nall your mangas easily.';

  @override
  String get onboardingSlide2Tag => 'Statistics';

  @override
  String get onboardingSlide2Title => 'Rate and track\nyour progress';

  @override
  String get onboardingSlide2Desc =>
      'Track chapters read, ratings\nand your favorite genres.';

  @override
  String get onboardingSlide3Tag => 'Ready!';

  @override
  String get onboardingSlide3Title => 'Dive into\nyour collection';

  @override
  String get onboardingSlide3Desc =>
      'Import your existing list or\nstart a new library.';
}
