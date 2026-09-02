---
layout: default
title: Privacy Policy / Politique de confidentialité — Folio
---

# Privacy Policy — Folio

*Last updated: July 8, 2026 — Effective for all versions from 2.1.0*
*[Version française ci-dessous](#politique-de-confidentialité--folio)*

## 1. Who we are

Folio is a free, open-source manga reading tracker published by its individual developer ("we", "the developer"). For the purposes of the EU General Data Protection Regulation (GDPR), the developer is the data controller — although, as explained below, **no personal data is ever collected or processed by us**.

Contact: https://github.com/SamuelDelabranche/folio/issues

## 2. The short version

- We collect **nothing**. Not your name, not your email, not your device ID, not your reading habits.
- Everything you enter in Folio stays **on your device**, in a private local database.
- The app contains **no analytics, no trackers, no advertising SDK, no crash reporting**.
- The only network requests the app ever makes are the ones **you trigger yourself**, and they contain **no personal information**.

## 3. Data stored on your device

Folio stores the following data **locally only**, in the app's private storage that no other app can access:

- your manga library (titles, chapters read, ratings, statuses, genres, favorites, personal links);
- images you import or that are downloaded from AniList at your request;
- your preferences (theme, language, view mode, sync settings, custom genres and types).

This data never leaves your device unless **you** export it or share it. We have no server. We technically **cannot** access, read, sell, or lose your data, because it never reaches us.

## 4. Network access — exhaustive list

The app requests a single Android permission: `INTERNET`. It is used exclusively for:

| Request | When | What is sent | What is received |
|---|---|---|---|
| AniList API (anilist.co) | Only when you manually use the search or sync features | The manga title you typed or stored — nothing else. No account, no token, no device identifier, no IP-based profiling on our side | Public bibliographic data: covers, descriptions, genres |
| AniList image CDN | Only when a cover is fetched at your request | A standard image request | The cover image |

The Play Store version of Folio makes **no other network request of any kind** — no update checks, no telemetry, no "phone home".

When your device contacts AniList, AniList receives your IP address, as with any website you visit. AniList is an independent service with its own privacy policy: https://anilist.co/terms

## 5. Data we receive from Google Play

Google Play provides developers with **aggregated, anonymous statistics** (number of installs, crash rates, Android versions). These statistics contain no personal data and cannot be traced back to you. Google's own collection is governed by Google's Privacy Policy.

## 6. Legal basis (GDPR)

Since Folio processes no personal data on any server, no legal basis for processing is required on our side. The local processing of your library on your own device is performed under your exclusive control and does not fall within the scope of processing by the developer.

## 7. Your rights (GDPR articles 15–22)

You have the rights of access, rectification, erasure, restriction, portability and objection. In Folio's case, you exercise all of them **directly and instantly**, because you are the only holder of your data:

- **Access / portability**: Settings → Export library (JSON file, open format).
- **Rectification**: edit any entry at any time.
- **Erasure**: Settings → Clear all, or uninstall the app. Deletion is immediate and irreversible. There is no copy anywhere else.

If you believe your rights are not respected, you may lodge a complaint with your supervisory authority (in France: CNIL, cnil.fr).

## 8. Data security

Your data is protected by the Android application sandbox: it is stored in the app's private directory, inaccessible to other applications. If you enable Android system backups, your library may be included in your device's encrypted backup managed by Google — this is controlled by your device settings, not by us. Cache files are excluded from backups.

## 9. International transfers

None. We transfer nothing, anywhere.

## 10. Children

Folio does not collect data from anyone, including children. The app displays only bibliographic metadata and cover images provided by AniList.

## 11. Third-party content and copyright

Cover images and bibliographic information are provided by AniList, a community-managed database, and remain the property of their respective authors, publishers and rights holders. Folio hosts no content. Rights holders may request removal of content via the contact address in section 1; legitimate requests are honored promptly.

## 12. Changes to this policy

Material changes will be published on this page with an updated date. Since the app cannot contact you (we don't know who you are), we recommend checking this page occasionally.

---

# Politique de confidentialité — Folio

*Dernière mise à jour : 8 juillet 2026 — Applicable à toutes les versions à partir de la 2.1.0*

## 1. Qui sommes-nous

Folio est un carnet de lecture de mangas gratuit et open source, publié par son développeur individuel (« nous », « le développeur »). Au sens du Règlement général sur la protection des données (RGPD), le développeur est le responsable de traitement — bien que, comme expliqué ci-dessous, **aucune donnée personnelle ne soit jamais collectée ni traitée par nous**.

Contact : https://github.com/SamuelDelabranche/folio/issues

## 2. L'essentiel

- Nous ne collectons **rien**. Ni votre nom, ni votre email, ni l'identifiant de votre appareil, ni vos habitudes de lecture.
- Tout ce que vous saisissez dans Folio reste **sur votre appareil**, dans une base de données locale privée.
- L'application ne contient **ni analytics, ni traceur, ni SDK publicitaire, ni rapport de plantage**.
- Les seules requêtes réseau émises par l'application sont celles que **vous déclenchez vous-même**, et elles ne contiennent **aucune information personnelle**.

## 3. Données stockées sur votre appareil

Folio stocke les données suivantes **localement uniquement**, dans le stockage privé de l'application, inaccessible aux autres applications :

- votre bibliothèque (titres, chapitres lus, notes, statuts, genres, favoris, liens personnels) ;
- les images que vous importez ou qui sont téléchargées depuis AniList à votre demande ;
- vos préférences (thème, langue, mode d'affichage, réglages de synchronisation, genres et types personnalisés).

Ces données ne quittent jamais votre appareil, sauf si **vous** les exportez ou les partagez. Nous n'avons aucun serveur. Il nous est techniquement **impossible** d'accéder à vos données, de les lire, de les vendre ou de les perdre : elles ne nous parviennent jamais.

## 4. Accès réseau — liste exhaustive

L'application ne demande qu'une seule permission Android : `INTERNET`. Elle sert exclusivement à :

| Requête | Quand | Ce qui est envoyé | Ce qui est reçu |
|---|---|---|---|
| API AniList (anilist.co) | Uniquement quand vous utilisez manuellement la recherche ou la synchronisation | Le titre du manga saisi ou enregistré — rien d'autre. Pas de compte, pas de jeton, pas d'identifiant d'appareil, aucun profilage de notre côté | Des données bibliographiques publiques : couvertures, descriptions, genres |
| CDN d'images AniList | Uniquement quand une couverture est récupérée à votre demande | Une requête d'image standard | L'image de couverture |

La version Play Store de Folio n'émet **aucune autre requête réseau** — pas de vérification de mise à jour, pas de télémétrie.

Quand votre appareil contacte AniList, AniList reçoit votre adresse IP, comme n'importe quel site que vous visitez. AniList est un service indépendant doté de sa propre politique : https://anilist.co/terms

## 5. Données reçues de Google Play

Google Play fournit aux développeurs des **statistiques agrégées et anonymes** (nombre d'installations, taux de plantage, versions d'Android). Elles ne contiennent aucune donnée personnelle et ne permettent pas de vous identifier. La collecte propre à Google est régie par la politique de confidentialité de Google.

## 6. Base légale (RGPD)

Folio ne traitant aucune donnée personnelle sur aucun serveur, aucune base légale de traitement n'est requise de notre côté. Le traitement local de votre bibliothèque sur votre propre appareil s'effectue sous votre contrôle exclusif et n'entre pas dans le champ d'un traitement opéré par le développeur.

## 7. Vos droits (articles 15 à 22 du RGPD)

Vous disposez des droits d'accès, de rectification, d'effacement, de limitation, de portabilité et d'opposition. Dans le cas de Folio, vous les exercez tous **directement et instantanément**, car vous êtes l'unique détenteur de vos données :

- **Accès / portabilité** : Paramètres → Exporter la bibliothèque (fichier JSON, format ouvert).
- **Rectification** : modifiez n'importe quelle fiche à tout moment.
- **Effacement** : Paramètres → Tout effacer, ou désinstallation. La suppression est immédiate et irréversible. Il n'existe aucune copie ailleurs.

Si vous estimez que vos droits ne sont pas respectés, vous pouvez saisir votre autorité de contrôle (en France : la CNIL, cnil.fr).

## 8. Sécurité des données

Vos données sont protégées par le bac à sable applicatif d'Android : elles résident dans le répertoire privé de l'application, inaccessible aux autres applications. Si vous activez les sauvegardes système Android, votre bibliothèque peut être incluse dans la sauvegarde chiffrée de votre appareil gérée par Google — cela relève des réglages de votre appareil, pas de nous. Les fichiers de cache sont exclus des sauvegardes.

## 9. Transferts internationaux

Aucun. Nous ne transférons rien, nulle part.

## 10. Enfants

Folio ne collecte de données de personne, y compris des enfants. L'application n'affiche que des métadonnées bibliographiques et des couvertures fournies par AniList.

## 11. Contenus tiers et droits d'auteur

Les images de couverture et les informations bibliographiques sont fournies par AniList, une base de données communautaire, et restent la propriété de leurs auteurs, éditeurs et ayants droit respectifs. Folio n'héberge aucun contenu. Les ayants droit peuvent demander le retrait d'un contenu via le contact indiqué en section 1 ; les demandes légitimes sont traitées rapidement.

## 12. Modifications de cette politique

Toute modification substantielle sera publiée sur cette page avec une date mise à jour. L'application ne pouvant pas vous contacter (nous ne savons pas qui vous êtes), nous vous recommandons de consulter cette page occasionnellement.
