import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @commonWarning.
  ///
  /// In fr, this message translates to:
  /// **'Attention !'**
  String get commonWarning;

  /// No description provided for @commonAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get commonAdd;

  /// No description provided for @statusToRead.
  ///
  /// In fr, this message translates to:
  /// **'À lire'**
  String get statusToRead;

  /// No description provided for @statusReading.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get statusReading;

  /// No description provided for @statusFinished.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get statusFinished;

  /// No description provided for @statusDropped.
  ///
  /// In fr, this message translates to:
  /// **'Abandonné'**
  String get statusDropped;

  /// No description provided for @navLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque'**
  String get navLibrary;

  /// No description provided for @navStatistics.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get navStatistics;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get navSettings;

  /// No description provided for @libTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma bibliothèque'**
  String get libTitle;

  /// No description provided for @libEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Votre bibliothèque est vide'**
  String get libEmpty;

  /// No description provided for @libEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur + pour ajouter un manga'**
  String get libEmptyHint;

  /// No description provided for @libSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un manga...'**
  String get libSearch;

  /// No description provided for @libSelectedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} sélectionné(s)'**
  String libSelectedCount(int count);

  /// No description provided for @libNoResult.
  ///
  /// In fr, this message translates to:
  /// **'Aucun manga trouvé'**
  String get libNoResult;

  /// No description provided for @libDeleteContent.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.\nLes mangas seront définitivement supprimés.'**
  String get libDeleteContent;

  /// No description provided for @libDeleteSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Manga(s) supprimé(s)'**
  String get libDeleteSuccess;

  /// No description provided for @libViewChange.
  ///
  /// In fr, this message translates to:
  /// **'Changer de vue'**
  String get libViewChange;

  /// No description provided for @libFilterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres & Tri'**
  String get libFilterTitle;

  /// No description provided for @libFilterReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get libFilterReset;

  /// No description provided for @libFilterSortBy.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get libFilterSortBy;

  /// No description provided for @libFilterAlpha.
  ///
  /// In fr, this message translates to:
  /// **'Alphabétique'**
  String get libFilterAlpha;

  /// No description provided for @libFilterRating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get libFilterRating;

  /// No description provided for @libFilterChapters.
  ///
  /// In fr, this message translates to:
  /// **'Chapitres'**
  String get libFilterChapters;

  /// No description provided for @libFilterStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get libFilterStatus;

  /// No description provided for @libFilterType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get libFilterType;

  /// No description provided for @libFilterFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get libFilterFavorites;

  /// No description provided for @libFilterFavoritesOnly.
  ///
  /// In fr, this message translates to:
  /// **'Favoris uniquement'**
  String get libFilterFavoritesOnly;

  /// No description provided for @libFilterChaptersRead.
  ///
  /// In fr, this message translates to:
  /// **'Chapitres lus'**
  String get libFilterChaptersRead;

  /// No description provided for @libChaptersPlus.
  ///
  /// In fr, this message translates to:
  /// **'1000+'**
  String get libChaptersPlus;

  /// No description provided for @addTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un manga'**
  String get addTitle;

  /// No description provided for @addMangaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre du manga'**
  String get addMangaTitle;

  /// No description provided for @addChaptersRead.
  ///
  /// In fr, this message translates to:
  /// **'Chapitres lus'**
  String get addChaptersRead;

  /// No description provided for @addRating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get addRating;

  /// No description provided for @addType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get addType;

  /// No description provided for @addStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get addStatus;

  /// No description provided for @addGenres.
  ///
  /// In fr, this message translates to:
  /// **'Genres'**
  String get addGenres;

  /// No description provided for @addGenresCount.
  ///
  /// In fr, this message translates to:
  /// **'Genres ({count})'**
  String addGenresCount(int count);

  /// No description provided for @addSearchGenre.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un genre...'**
  String get addSearchGenre;

  /// No description provided for @addFavoriteAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get addFavoriteAdd;

  /// No description provided for @addFavoriteIn.
  ///
  /// In fr, this message translates to:
  /// **'Dans vos favoris'**
  String get addFavoriteIn;

  /// No description provided for @addLinks.
  ///
  /// In fr, this message translates to:
  /// **'Liens d\'accès'**
  String get addLinks;

  /// No description provided for @addLinksCount.
  ///
  /// In fr, this message translates to:
  /// **'Liens d\'accès ({count})'**
  String addLinksCount(int count);

  /// No description provided for @addRequired.
  ///
  /// In fr, this message translates to:
  /// **'Champ requis'**
  String get addRequired;

  /// No description provided for @addInvalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Nombre invalide'**
  String get addInvalidNumber;

  /// No description provided for @detailDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get detailDescription;

  /// No description provided for @detailNoDescription.
  ///
  /// In fr, this message translates to:
  /// **'Aucune description'**
  String get detailNoDescription;

  /// No description provided for @detailGenres.
  ///
  /// In fr, this message translates to:
  /// **'Genres'**
  String get detailGenres;

  /// No description provided for @detailSelectedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} sélectionné(s)'**
  String detailSelectedCount(int count);

  /// No description provided for @detailNoGenre.
  ///
  /// In fr, this message translates to:
  /// **'Aucun genre renseigné'**
  String get detailNoGenre;

  /// No description provided for @detailSearchGenre.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un genre...'**
  String get detailSearchGenre;

  /// No description provided for @detailInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get detailInfo;

  /// No description provided for @detailType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get detailType;

  /// No description provided for @detailStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get detailStatus;

  /// No description provided for @detailChaptersRead.
  ///
  /// In fr, this message translates to:
  /// **'Chapitres lus'**
  String get detailChaptersRead;

  /// No description provided for @detailRating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get detailRating;

  /// No description provided for @detailLinks.
  ///
  /// In fr, this message translates to:
  /// **'Liens d\'accès'**
  String get detailLinks;

  /// No description provided for @detailNoLink.
  ///
  /// In fr, this message translates to:
  /// **'Aucun lien renseigné'**
  String get detailNoLink;

  /// No description provided for @detailAddLink.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un lien'**
  String get detailAddLink;

  /// No description provided for @detailLinkCopied.
  ///
  /// In fr, this message translates to:
  /// **'Lien copié'**
  String get detailLinkCopied;

  /// No description provided for @detailSyncSection.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation AniList'**
  String get detailSyncSection;

  /// No description provided for @detailLinked.
  ///
  /// In fr, this message translates to:
  /// **'Lié à AniList (#{id})'**
  String detailLinked(int id);

  /// No description provided for @detailNotLinked.
  ///
  /// In fr, this message translates to:
  /// **'Non lié à AniList'**
  String get detailNotLinked;

  /// No description provided for @detailLastSync.
  ///
  /// In fr, this message translates to:
  /// **'Dernière synchro : {date}'**
  String detailLastSync(String date);

  /// No description provided for @detailNeverSynced.
  ///
  /// In fr, this message translates to:
  /// **'Jamais synchronisé'**
  String get detailNeverSynced;

  /// No description provided for @detailLink.
  ///
  /// In fr, this message translates to:
  /// **'Lier'**
  String get detailLink;

  /// No description provided for @detailUnlink.
  ///
  /// In fr, this message translates to:
  /// **'Délier'**
  String get detailUnlink;

  /// No description provided for @detailSyncNow.
  ///
  /// In fr, this message translates to:
  /// **'Synchroniser maintenant'**
  String get detailSyncNow;

  /// No description provided for @detailSyncing.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation…'**
  String get detailSyncing;

  /// No description provided for @detailSyncSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Fiche synchronisée'**
  String get detailSyncSuccess;

  /// No description provided for @detailSyncNoMatch.
  ///
  /// In fr, this message translates to:
  /// **'Aucune fiche AniList trouvée pour ce titre'**
  String get detailSyncNoMatch;

  /// No description provided for @detailSyncRateLimit.
  ///
  /// In fr, this message translates to:
  /// **'AniList est saturé — réessaie dans {seconds} s'**
  String detailSyncRateLimit(int seconds);

  /// No description provided for @detailSyncError.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation impossible. Vérifie ta connexion.'**
  String get detailSyncError;

  /// No description provided for @detailSyncCover.
  ///
  /// In fr, this message translates to:
  /// **'Image de couverture'**
  String get detailSyncCover;

  /// No description provided for @detailSyncCoverCustom.
  ///
  /// In fr, this message translates to:
  /// **'Image personnalisée — jamais écrasée par la synchro'**
  String get detailSyncCoverCustom;

  /// No description provided for @detailSyncDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get detailSyncDescription;

  /// No description provided for @detailSyncGenres.
  ///
  /// In fr, this message translates to:
  /// **'Genres'**
  String get detailSyncGenres;

  /// No description provided for @detailSyncType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get detailSyncType;

  /// No description provided for @detailSyncGlobalOff.
  ///
  /// In fr, this message translates to:
  /// **'Désactivé globalement (Paramètres)'**
  String get detailSyncGlobalOff;

  /// No description provided for @detailDeleteContent.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.\nLe manga sera définitivement supprimé.'**
  String get detailDeleteContent;

  /// No description provided for @detailDeleteSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Manga supprimé'**
  String get detailDeleteSuccess;

  /// No description provided for @detailImageImport.
  ///
  /// In fr, this message translates to:
  /// **'Importer une image'**
  String get detailImageImport;

  /// No description provided for @detailImageGallery.
  ///
  /// In fr, this message translates to:
  /// **'Choisir depuis la galerie'**
  String get detailImageGallery;

  /// No description provided for @detailImageDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'image'**
  String get detailImageDelete;

  /// No description provided for @detailImageCustomInfo.
  ///
  /// In fr, this message translates to:
  /// **'Image personnalisée — la synchro de la cover est désactivée pour ce manga'**
  String get detailImageCustomInfo;

  /// No description provided for @detailImageError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'importer cette image'**
  String get detailImageError;

  /// No description provided for @statsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get statsTitle;

  /// No description provided for @statsMangas.
  ///
  /// In fr, this message translates to:
  /// **'Mangas'**
  String get statsMangas;

  /// No description provided for @statsAvgRating.
  ///
  /// In fr, this message translates to:
  /// **'Note moy.'**
  String get statsAvgRating;

  /// No description provided for @statsChapters.
  ///
  /// In fr, this message translates to:
  /// **'Chapitres'**
  String get statsChapters;

  /// No description provided for @statsByStatus.
  ///
  /// In fr, this message translates to:
  /// **'Par statut'**
  String get statsByStatus;

  /// No description provided for @statsByType.
  ///
  /// In fr, this message translates to:
  /// **'Par type'**
  String get statsByType;

  /// No description provided for @statsTopGenres.
  ///
  /// In fr, this message translates to:
  /// **'Top genres'**
  String get statsTopGenres;

  /// No description provided for @statsNoGenre.
  ///
  /// In fr, this message translates to:
  /// **'Aucun genre renseigné'**
  String get statsNoGenre;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In fr, this message translates to:
  /// **'Général'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsSectionData.
  ///
  /// In fr, this message translates to:
  /// **'Données'**
  String get settingsSectionData;

  /// No description provided for @settingsSectionSync.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation'**
  String get settingsSectionSync;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsSectionAbout;

  /// No description provided for @settingsStartTab.
  ///
  /// In fr, this message translates to:
  /// **'Onglet de démarrage'**
  String get settingsStartTab;

  /// No description provided for @settingsReplayIntro.
  ///
  /// In fr, this message translates to:
  /// **'Revoir l\'introduction'**
  String get settingsReplayIntro;

  /// No description provided for @settingsReplayIntroSub.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer les écrans de bienvenue'**
  String get settingsReplayIntroSub;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsExport.
  ///
  /// In fr, this message translates to:
  /// **'Exporter la bibliothèque'**
  String get settingsExport;

  /// No description provided for @settingsExportSub.
  ///
  /// In fr, this message translates to:
  /// **'Partager un fichier JSON'**
  String get settingsExportSub;

  /// No description provided for @settingsExportEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun manga à exporter'**
  String get settingsExportEmpty;

  /// No description provided for @settingsExportError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'export'**
  String get settingsExportError;

  /// No description provided for @settingsImport.
  ///
  /// In fr, this message translates to:
  /// **'Importer la bibliothèque'**
  String get settingsImport;

  /// No description provided for @settingsImportSub.
  ///
  /// In fr, this message translates to:
  /// **'Remplace les données existantes'**
  String get settingsImportSub;

  /// No description provided for @settingsImportWarning.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.\nLes mangas déjà présents seront définitivement supprimés.'**
  String get settingsImportWarning;

  /// No description provided for @settingsImportContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get settingsImportContinue;

  /// No description provided for @settingsImportSuccess.
  ///
  /// In fr, this message translates to:
  /// **'{count} manga(s) importé(s)'**
  String settingsImportSuccess(int count);

  /// No description provided for @settingsImportError.
  ///
  /// In fr, this message translates to:
  /// **'Fichier invalide ou corrompu'**
  String get settingsImportError;

  /// No description provided for @settingsClear.
  ///
  /// In fr, this message translates to:
  /// **'Tout effacer'**
  String get settingsClear;

  /// No description provided for @settingsClearSub.
  ///
  /// In fr, this message translates to:
  /// **'Supprime définitivement la bibliothèque'**
  String get settingsClearSub;

  /// No description provided for @settingsClearContent.
  ///
  /// In fr, this message translates to:
  /// **'Toute votre bibliothèque sera définitivement supprimée.\n\nPensez à exporter vos données avant !'**
  String get settingsClearContent;

  /// No description provided for @settingsClearSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque effacée'**
  String get settingsClearSuccess;

  /// No description provided for @settingsSyncAnilist.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation AniList'**
  String get settingsSyncAnilist;

  /// No description provided for @settingsSyncAnilistSub.
  ///
  /// In fr, this message translates to:
  /// **'Uniquement à la demande, jamais automatique'**
  String get settingsSyncAnilistSub;

  /// No description provided for @settingsSyncCovers.
  ///
  /// In fr, this message translates to:
  /// **'Images de couverture'**
  String get settingsSyncCovers;

  /// No description provided for @settingsSyncDescriptions.
  ///
  /// In fr, this message translates to:
  /// **'Descriptions'**
  String get settingsSyncDescriptions;

  /// No description provided for @settingsSyncGenres.
  ///
  /// In fr, this message translates to:
  /// **'Genres'**
  String get settingsSyncGenres;

  /// No description provided for @settingsSyncTypes.
  ///
  /// In fr, this message translates to:
  /// **'Types (Manga, Manhwa…)'**
  String get settingsSyncTypes;

  /// No description provided for @settingsSyncStop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter la synchronisation'**
  String get settingsSyncStop;

  /// No description provided for @settingsSyncStopSub.
  ///
  /// In fr, this message translates to:
  /// **'Une synchronisation est en cours'**
  String get settingsSyncStopSub;

  /// No description provided for @settingsSyncLinkAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout lier'**
  String get settingsSyncLinkAll;

  /// No description provided for @settingsSyncLinkAllSub.
  ///
  /// In fr, this message translates to:
  /// **'Lie automatiquement les mangas non liés'**
  String get settingsSyncLinkAllSub;

  /// No description provided for @settingsSyncAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout synchroniser'**
  String get settingsSyncAll;

  /// No description provided for @settingsSyncAllSub.
  ///
  /// In fr, this message translates to:
  /// **'Lie et met à jour toute la bibliothèque'**
  String get settingsSyncAllSub;

  /// No description provided for @settingsSyncNote.
  ///
  /// In fr, this message translates to:
  /// **'Chaque manga peut aussi désactiver ces champs individuellement dans sa fiche. Données fournies par AniList (anilist.co).'**
  String get settingsSyncNote;

  /// No description provided for @settingsSyncLinkDialog.
  ///
  /// In fr, this message translates to:
  /// **'{count} manga(s) non lié(s) — environ {estimate}.\n\nChaque manga sera lié à la fiche AniList correspondant le mieux à son titre, puis synchronisé. Tu pourras corriger une liaison depuis la fiche (mode édition).'**
  String settingsSyncLinkDialog(int count, String estimate);

  /// No description provided for @settingsSyncAllDialog.
  ///
  /// In fr, this message translates to:
  /// **'{count} manga(s) — environ {estimate}.\n\nLes mangas non liés seront d\'abord liés à AniList. La synchronisation tournera en arrière-plan, tu peux continuer à utiliser l\'application.'**
  String settingsSyncAllDialog(int count, String estimate);

  /// No description provided for @settingsSyncLaunch.
  ///
  /// In fr, this message translates to:
  /// **'Lancer'**
  String get settingsSyncLaunch;

  /// No description provided for @settingsSyncAlreadyLinked.
  ///
  /// In fr, this message translates to:
  /// **'Tous les mangas sont déjà liés'**
  String get settingsSyncAlreadyLinked;

  /// No description provided for @settingsSyncLibraryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'La bibliothèque est vide'**
  String get settingsSyncLibraryEmpty;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeAuto.
  ///
  /// In fr, this message translates to:
  /// **'Automatique'**
  String get settingsThemeAuto;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsThemeTitle;

  /// No description provided for @settingsCheckUpdate.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier les mises à jour'**
  String get settingsCheckUpdate;

  /// No description provided for @settingsCheckUpdateSub.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une nouvelle version'**
  String get settingsCheckUpdateSub;

  /// No description provided for @settingsUpToDate.
  ///
  /// In fr, this message translates to:
  /// **'Folio est à jour'**
  String get settingsUpToDate;

  /// No description provided for @settingsUpdateAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Version {version} disponible'**
  String settingsUpdateAvailable(String version);

  /// No description provided for @settingsUpdateDownload.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get settingsUpdateDownload;

  /// No description provided for @settingsUpdateError.
  ///
  /// In fr, this message translates to:
  /// **'Vérification impossible (hors ligne ?)'**
  String get settingsUpdateError;

  /// No description provided for @settingsSourceCode.
  ///
  /// In fr, this message translates to:
  /// **'Code source'**
  String get settingsSourceCode;

  /// No description provided for @settingsSourceCodeSub.
  ///
  /// In fr, this message translates to:
  /// **'Folio est open source (GitHub)'**
  String get settingsSourceCodeSub;

  /// No description provided for @settingsStartTabTitle.
  ///
  /// In fr, this message translates to:
  /// **'Onglet de démarrage'**
  String get settingsStartTabTitle;

  /// No description provided for @settingsCopyright.
  ///
  /// In fr, this message translates to:
  /// **'Contenus & droits d\'auteur'**
  String get settingsCopyright;

  /// No description provided for @settingsCopyrightSub.
  ///
  /// In fr, this message translates to:
  /// **'Images, données et mentions légales'**
  String get settingsCopyrightSub;

  /// No description provided for @copyrightTitle.
  ///
  /// In fr, this message translates to:
  /// **'Contenus & droits d\'auteur'**
  String get copyrightTitle;

  /// No description provided for @copyrightBody.
  ///
  /// In fr, this message translates to:
  /// **'Les images de couverture et les informations bibliographiques sont fournies par AniList (anilist.co), une base de données communautaire gérée par ses utilisateurs.\n\nFolio n\'héberge aucun contenu. Toutes les images restent la propriété de leurs auteurs et éditeurs respectifs.\n\nSi vous êtes auteur, éditeur ou titulaire de droits et souhaitez retirer une image, contactez :'**
  String get copyrightBody;

  /// No description provided for @copyrightContact.
  ///
  /// In fr, this message translates to:
  /// **'samuel.delabranche0@gmail.com'**
  String get copyrightContact;

  /// No description provided for @updateDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour disponible'**
  String get updateDialogTitle;

  /// No description provided for @updateDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'La version {version} est disponible.\n\nTélécharge le nouvel APK depuis GitHub et installe-le pour mettre à jour.'**
  String updateDialogContent(String version);

  /// No description provided for @updateDialogLater.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get updateDialogLater;

  /// No description provided for @updateDialogDownload.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get updateDialogDownload;

  /// No description provided for @anilistSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lier à AniList'**
  String get anilistSheetTitle;

  /// No description provided for @anilistSheetHint.
  ///
  /// In fr, this message translates to:
  /// **'Titre du manga…'**
  String get anilistSheetHint;

  /// No description provided for @anilistSheetNoResult.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get anilistSheetNoResult;

  /// No description provided for @anilistSheetRateLimit.
  ///
  /// In fr, this message translates to:
  /// **'Trop de requêtes — réessaie dans {seconds} s'**
  String anilistSheetRateLimit(int seconds);

  /// No description provided for @anilistSheetNetworkError.
  ///
  /// In fr, this message translates to:
  /// **'Recherche impossible. Vérifie ta connexion.'**
  String get anilistSheetNetworkError;

  /// No description provided for @anilistSheetRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get anilistSheetRetry;

  /// No description provided for @anilistSheetPoweredBy.
  ///
  /// In fr, this message translates to:
  /// **'Données fournies par AniList'**
  String get anilistSheetPoweredBy;

  /// No description provided for @lienDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un lien'**
  String get lienDialogTitle;

  /// No description provided for @lienDialogNom.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lienDialogNom;

  /// No description provided for @lienDialogNomHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Scan VF'**
  String get lienDialogNomHint;

  /// No description provided for @lienDialogUrl.
  ///
  /// In fr, this message translates to:
  /// **'URL'**
  String get lienDialogUrl;

  /// No description provided for @lienDialogUrlHint.
  ///
  /// In fr, this message translates to:
  /// **'https://...'**
  String get lienDialogUrlHint;

  /// No description provided for @lienDialogUrlError.
  ///
  /// In fr, this message translates to:
  /// **'URL invalide (http/https requis)'**
  String get lienDialogUrlError;

  /// No description provided for @onboardingSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingStart;

  /// No description provided for @onboardingSlide1Tag.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get onboardingSlide1Tag;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In fr, this message translates to:
  /// **'Ta bibliothèque manga\nen un endroit'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Desc.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute, organise et retrouve\ntous tes mangas facilement.'**
  String get onboardingSlide1Desc;

  /// No description provided for @onboardingSlide2Tag.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get onboardingSlide2Tag;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In fr, this message translates to:
  /// **'Note et analyse\nta progression'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Desc.
  ///
  /// In fr, this message translates to:
  /// **'Suis tes chapitres lus, tes notes\net tes genres préférés.'**
  String get onboardingSlide2Desc;

  /// No description provided for @onboardingSlide3Tag.
  ///
  /// In fr, this message translates to:
  /// **'Prêt !'**
  String get onboardingSlide3Tag;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In fr, this message translates to:
  /// **'Lance-toi dans\nta collection'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Desc.
  ///
  /// In fr, this message translates to:
  /// **'Importe ta liste existante ou\ncommence une nouvelle bibliothèque.'**
  String get onboardingSlide3Desc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
