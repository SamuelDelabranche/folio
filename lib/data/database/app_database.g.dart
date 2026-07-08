// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MangaTableTable extends MangaTable
    with TableInfo<$MangaTableTable, MangaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MangaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titreMeta = const VerificationMeta('titre');
  @override
  late final GeneratedColumn<String> titre = GeneratedColumn<String>(
    'titre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMangaMeta = const VerificationMeta(
    'typeManga',
  );
  @override
  late final GeneratedColumn<String> typeManga = GeneratedColumn<String>(
    'type_manga',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estFavoriMeta = const VerificationMeta(
    'estFavori',
  );
  @override
  late final GeneratedColumn<bool> estFavori = GeneratedColumn<bool>(
    'est_favori',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("est_favori" IN (0, 1))',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<double> note = GeneratedColumn<double>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapitresMeta = const VerificationMeta(
    'chapitres',
  );
  @override
  late final GeneratedColumn<double> chapitres = GeneratedColumn<double>(
    'chapitres',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _liensMeta = const VerificationMeta('liens');
  @override
  late final GeneratedColumn<String> liens = GeneratedColumn<String>(
    'liens',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anilistIdMeta = const VerificationMeta(
    'anilistId',
  );
  @override
  late final GeneratedColumn<int> anilistId = GeneratedColumn<int>(
    'anilist_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncImageMeta = const VerificationMeta(
    'syncImage',
  );
  @override
  late final GeneratedColumn<bool> syncImage = GeneratedColumn<bool>(
    'sync_image',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_image" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncDescriptionMeta = const VerificationMeta(
    'syncDescription',
  );
  @override
  late final GeneratedColumn<bool> syncDescription = GeneratedColumn<bool>(
    'sync_description',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_description" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncGenresMeta = const VerificationMeta(
    'syncGenres',
  );
  @override
  late final GeneratedColumn<bool> syncGenres = GeneratedColumn<bool>(
    'sync_genres',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_genres" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncTypeMeta = const VerificationMeta(
    'syncType',
  );
  @override
  late final GeneratedColumn<bool> syncType = GeneratedColumn<bool>(
    'sync_type',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_type" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _imageSourceMeta = const VerificationMeta(
    'imageSource',
  );
  @override
  late final GeneratedColumn<String> imageSource = GeneratedColumn<String>(
    'image_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('aucune'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titre,
    description,
    imagePath,
    status,
    genre,
    typeManga,
    estFavori,
    note,
    chapitres,
    liens,
    anilistId,
    lastSyncedAt,
    syncImage,
    syncDescription,
    syncGenres,
    syncType,
    imageSource,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manga_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MangaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titre')) {
      context.handle(
        _titreMeta,
        titre.isAcceptableOrUnknown(data['titre']!, _titreMeta),
      );
    } else if (isInserting) {
      context.missing(_titreMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('type_manga')) {
      context.handle(
        _typeMangaMeta,
        typeManga.isAcceptableOrUnknown(data['type_manga']!, _typeMangaMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMangaMeta);
    }
    if (data.containsKey('est_favori')) {
      context.handle(
        _estFavoriMeta,
        estFavori.isAcceptableOrUnknown(data['est_favori']!, _estFavoriMeta),
      );
    } else if (isInserting) {
      context.missing(_estFavoriMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('chapitres')) {
      context.handle(
        _chapitresMeta,
        chapitres.isAcceptableOrUnknown(data['chapitres']!, _chapitresMeta),
      );
    } else if (isInserting) {
      context.missing(_chapitresMeta);
    }
    if (data.containsKey('liens')) {
      context.handle(
        _liensMeta,
        liens.isAcceptableOrUnknown(data['liens']!, _liensMeta),
      );
    }
    if (data.containsKey('anilist_id')) {
      context.handle(
        _anilistIdMeta,
        anilistId.isAcceptableOrUnknown(data['anilist_id']!, _anilistIdMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_image')) {
      context.handle(
        _syncImageMeta,
        syncImage.isAcceptableOrUnknown(data['sync_image']!, _syncImageMeta),
      );
    }
    if (data.containsKey('sync_description')) {
      context.handle(
        _syncDescriptionMeta,
        syncDescription.isAcceptableOrUnknown(
          data['sync_description']!,
          _syncDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('sync_genres')) {
      context.handle(
        _syncGenresMeta,
        syncGenres.isAcceptableOrUnknown(data['sync_genres']!, _syncGenresMeta),
      );
    }
    if (data.containsKey('sync_type')) {
      context.handle(
        _syncTypeMeta,
        syncType.isAcceptableOrUnknown(data['sync_type']!, _syncTypeMeta),
      );
    }
    if (data.containsKey('image_source')) {
      context.handle(
        _imageSourceMeta,
        imageSource.isAcceptableOrUnknown(
          data['image_source']!,
          _imageSourceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MangaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MangaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titre'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      typeManga: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_manga'],
      )!,
      estFavori: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}est_favori'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}note'],
      )!,
      chapitres: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chapitres'],
      )!,
      liens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}liens'],
      ),
      anilistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anilist_id'],
      ),
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      syncImage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_image'],
      )!,
      syncDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_description'],
      )!,
      syncGenres: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_genres'],
      )!,
      syncType: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_type'],
      )!,
      imageSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_source'],
      )!,
    );
  }

  @override
  $MangaTableTable createAlias(String alias) {
    return $MangaTableTable(attachedDatabase, alias);
  }
}

class MangaTableData extends DataClass implements Insertable<MangaTableData> {
  final int id;
  final String titre;
  final String? description;
  final String? imagePath;
  final String status;
  final String? genre;
  final String typeManga;
  final bool estFavori;
  final double note;
  final double chapitres;
  final String? liens;
  final int? anilistId;
  final DateTime? lastSyncedAt;
  final bool syncImage;
  final bool syncDescription;
  final bool syncGenres;
  final bool syncType;
  final String imageSource;
  const MangaTableData({
    required this.id,
    required this.titre,
    this.description,
    this.imagePath,
    required this.status,
    this.genre,
    required this.typeManga,
    required this.estFavori,
    required this.note,
    required this.chapitres,
    this.liens,
    this.anilistId,
    this.lastSyncedAt,
    required this.syncImage,
    required this.syncDescription,
    required this.syncGenres,
    required this.syncType,
    required this.imageSource,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titre'] = Variable<String>(titre);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    map['type_manga'] = Variable<String>(typeManga);
    map['est_favori'] = Variable<bool>(estFavori);
    map['note'] = Variable<double>(note);
    map['chapitres'] = Variable<double>(chapitres);
    if (!nullToAbsent || liens != null) {
      map['liens'] = Variable<String>(liens);
    }
    if (!nullToAbsent || anilistId != null) {
      map['anilist_id'] = Variable<int>(anilistId);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['sync_image'] = Variable<bool>(syncImage);
    map['sync_description'] = Variable<bool>(syncDescription);
    map['sync_genres'] = Variable<bool>(syncGenres);
    map['sync_type'] = Variable<bool>(syncType);
    map['image_source'] = Variable<String>(imageSource);
    return map;
  }

  MangaTableCompanion toCompanion(bool nullToAbsent) {
    return MangaTableCompanion(
      id: Value(id),
      titre: Value(titre),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      status: Value(status),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      typeManga: Value(typeManga),
      estFavori: Value(estFavori),
      note: Value(note),
      chapitres: Value(chapitres),
      liens: liens == null && nullToAbsent
          ? const Value.absent()
          : Value(liens),
      anilistId: anilistId == null && nullToAbsent
          ? const Value.absent()
          : Value(anilistId),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      syncImage: Value(syncImage),
      syncDescription: Value(syncDescription),
      syncGenres: Value(syncGenres),
      syncType: Value(syncType),
      imageSource: Value(imageSource),
    );
  }

  factory MangaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MangaTableData(
      id: serializer.fromJson<int>(json['id']),
      titre: serializer.fromJson<String>(json['titre']),
      description: serializer.fromJson<String?>(json['description']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      status: serializer.fromJson<String>(json['status']),
      genre: serializer.fromJson<String?>(json['genre']),
      typeManga: serializer.fromJson<String>(json['typeManga']),
      estFavori: serializer.fromJson<bool>(json['estFavori']),
      note: serializer.fromJson<double>(json['note']),
      chapitres: serializer.fromJson<double>(json['chapitres']),
      liens: serializer.fromJson<String?>(json['liens']),
      anilistId: serializer.fromJson<int?>(json['anilistId']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      syncImage: serializer.fromJson<bool>(json['syncImage']),
      syncDescription: serializer.fromJson<bool>(json['syncDescription']),
      syncGenres: serializer.fromJson<bool>(json['syncGenres']),
      syncType: serializer.fromJson<bool>(json['syncType']),
      imageSource: serializer.fromJson<String>(json['imageSource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titre': serializer.toJson<String>(titre),
      'description': serializer.toJson<String?>(description),
      'imagePath': serializer.toJson<String?>(imagePath),
      'status': serializer.toJson<String>(status),
      'genre': serializer.toJson<String?>(genre),
      'typeManga': serializer.toJson<String>(typeManga),
      'estFavori': serializer.toJson<bool>(estFavori),
      'note': serializer.toJson<double>(note),
      'chapitres': serializer.toJson<double>(chapitres),
      'liens': serializer.toJson<String?>(liens),
      'anilistId': serializer.toJson<int?>(anilistId),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'syncImage': serializer.toJson<bool>(syncImage),
      'syncDescription': serializer.toJson<bool>(syncDescription),
      'syncGenres': serializer.toJson<bool>(syncGenres),
      'syncType': serializer.toJson<bool>(syncType),
      'imageSource': serializer.toJson<String>(imageSource),
    };
  }

  MangaTableData copyWith({
    int? id,
    String? titre,
    Value<String?> description = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    String? status,
    Value<String?> genre = const Value.absent(),
    String? typeManga,
    bool? estFavori,
    double? note,
    double? chapitres,
    Value<String?> liens = const Value.absent(),
    Value<int?> anilistId = const Value.absent(),
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    bool? syncImage,
    bool? syncDescription,
    bool? syncGenres,
    bool? syncType,
    String? imageSource,
  }) => MangaTableData(
    id: id ?? this.id,
    titre: titre ?? this.titre,
    description: description.present ? description.value : this.description,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    status: status ?? this.status,
    genre: genre.present ? genre.value : this.genre,
    typeManga: typeManga ?? this.typeManga,
    estFavori: estFavori ?? this.estFavori,
    note: note ?? this.note,
    chapitres: chapitres ?? this.chapitres,
    liens: liens.present ? liens.value : this.liens,
    anilistId: anilistId.present ? anilistId.value : this.anilistId,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    syncImage: syncImage ?? this.syncImage,
    syncDescription: syncDescription ?? this.syncDescription,
    syncGenres: syncGenres ?? this.syncGenres,
    syncType: syncType ?? this.syncType,
    imageSource: imageSource ?? this.imageSource,
  );
  MangaTableData copyWithCompanion(MangaTableCompanion data) {
    return MangaTableData(
      id: data.id.present ? data.id.value : this.id,
      titre: data.titre.present ? data.titre.value : this.titre,
      description: data.description.present
          ? data.description.value
          : this.description,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      status: data.status.present ? data.status.value : this.status,
      genre: data.genre.present ? data.genre.value : this.genre,
      typeManga: data.typeManga.present ? data.typeManga.value : this.typeManga,
      estFavori: data.estFavori.present ? data.estFavori.value : this.estFavori,
      note: data.note.present ? data.note.value : this.note,
      chapitres: data.chapitres.present ? data.chapitres.value : this.chapitres,
      liens: data.liens.present ? data.liens.value : this.liens,
      anilistId: data.anilistId.present ? data.anilistId.value : this.anilistId,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      syncImage: data.syncImage.present ? data.syncImage.value : this.syncImage,
      syncDescription: data.syncDescription.present
          ? data.syncDescription.value
          : this.syncDescription,
      syncGenres: data.syncGenres.present
          ? data.syncGenres.value
          : this.syncGenres,
      syncType: data.syncType.present ? data.syncType.value : this.syncType,
      imageSource: data.imageSource.present
          ? data.imageSource.value
          : this.imageSource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MangaTableData(')
          ..write('id: $id, ')
          ..write('titre: $titre, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('status: $status, ')
          ..write('genre: $genre, ')
          ..write('typeManga: $typeManga, ')
          ..write('estFavori: $estFavori, ')
          ..write('note: $note, ')
          ..write('chapitres: $chapitres, ')
          ..write('liens: $liens, ')
          ..write('anilistId: $anilistId, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('syncImage: $syncImage, ')
          ..write('syncDescription: $syncDescription, ')
          ..write('syncGenres: $syncGenres, ')
          ..write('syncType: $syncType, ')
          ..write('imageSource: $imageSource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titre,
    description,
    imagePath,
    status,
    genre,
    typeManga,
    estFavori,
    note,
    chapitres,
    liens,
    anilistId,
    lastSyncedAt,
    syncImage,
    syncDescription,
    syncGenres,
    syncType,
    imageSource,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MangaTableData &&
          other.id == this.id &&
          other.titre == this.titre &&
          other.description == this.description &&
          other.imagePath == this.imagePath &&
          other.status == this.status &&
          other.genre == this.genre &&
          other.typeManga == this.typeManga &&
          other.estFavori == this.estFavori &&
          other.note == this.note &&
          other.chapitres == this.chapitres &&
          other.liens == this.liens &&
          other.anilistId == this.anilistId &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.syncImage == this.syncImage &&
          other.syncDescription == this.syncDescription &&
          other.syncGenres == this.syncGenres &&
          other.syncType == this.syncType &&
          other.imageSource == this.imageSource);
}

class MangaTableCompanion extends UpdateCompanion<MangaTableData> {
  final Value<int> id;
  final Value<String> titre;
  final Value<String?> description;
  final Value<String?> imagePath;
  final Value<String> status;
  final Value<String?> genre;
  final Value<String> typeManga;
  final Value<bool> estFavori;
  final Value<double> note;
  final Value<double> chapitres;
  final Value<String?> liens;
  final Value<int?> anilistId;
  final Value<DateTime?> lastSyncedAt;
  final Value<bool> syncImage;
  final Value<bool> syncDescription;
  final Value<bool> syncGenres;
  final Value<bool> syncType;
  final Value<String> imageSource;
  const MangaTableCompanion({
    this.id = const Value.absent(),
    this.titre = const Value.absent(),
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.status = const Value.absent(),
    this.genre = const Value.absent(),
    this.typeManga = const Value.absent(),
    this.estFavori = const Value.absent(),
    this.note = const Value.absent(),
    this.chapitres = const Value.absent(),
    this.liens = const Value.absent(),
    this.anilistId = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.syncImage = const Value.absent(),
    this.syncDescription = const Value.absent(),
    this.syncGenres = const Value.absent(),
    this.syncType = const Value.absent(),
    this.imageSource = const Value.absent(),
  });
  MangaTableCompanion.insert({
    this.id = const Value.absent(),
    required String titre,
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String status,
    this.genre = const Value.absent(),
    required String typeManga,
    required bool estFavori,
    required double note,
    required double chapitres,
    this.liens = const Value.absent(),
    this.anilistId = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.syncImage = const Value.absent(),
    this.syncDescription = const Value.absent(),
    this.syncGenres = const Value.absent(),
    this.syncType = const Value.absent(),
    this.imageSource = const Value.absent(),
  }) : titre = Value(titre),
       status = Value(status),
       typeManga = Value(typeManga),
       estFavori = Value(estFavori),
       note = Value(note),
       chapitres = Value(chapitres);
  static Insertable<MangaTableData> custom({
    Expression<int>? id,
    Expression<String>? titre,
    Expression<String>? description,
    Expression<String>? imagePath,
    Expression<String>? status,
    Expression<String>? genre,
    Expression<String>? typeManga,
    Expression<bool>? estFavori,
    Expression<double>? note,
    Expression<double>? chapitres,
    Expression<String>? liens,
    Expression<int>? anilistId,
    Expression<DateTime>? lastSyncedAt,
    Expression<bool>? syncImage,
    Expression<bool>? syncDescription,
    Expression<bool>? syncGenres,
    Expression<bool>? syncType,
    Expression<String>? imageSource,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titre != null) 'titre': titre,
      if (description != null) 'description': description,
      if (imagePath != null) 'image_path': imagePath,
      if (status != null) 'status': status,
      if (genre != null) 'genre': genre,
      if (typeManga != null) 'type_manga': typeManga,
      if (estFavori != null) 'est_favori': estFavori,
      if (note != null) 'note': note,
      if (chapitres != null) 'chapitres': chapitres,
      if (liens != null) 'liens': liens,
      if (anilistId != null) 'anilist_id': anilistId,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (syncImage != null) 'sync_image': syncImage,
      if (syncDescription != null) 'sync_description': syncDescription,
      if (syncGenres != null) 'sync_genres': syncGenres,
      if (syncType != null) 'sync_type': syncType,
      if (imageSource != null) 'image_source': imageSource,
    });
  }

  MangaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? titre,
    Value<String?>? description,
    Value<String?>? imagePath,
    Value<String>? status,
    Value<String?>? genre,
    Value<String>? typeManga,
    Value<bool>? estFavori,
    Value<double>? note,
    Value<double>? chapitres,
    Value<String?>? liens,
    Value<int?>? anilistId,
    Value<DateTime?>? lastSyncedAt,
    Value<bool>? syncImage,
    Value<bool>? syncDescription,
    Value<bool>? syncGenres,
    Value<bool>? syncType,
    Value<String>? imageSource,
  }) {
    return MangaTableCompanion(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      genre: genre ?? this.genre,
      typeManga: typeManga ?? this.typeManga,
      estFavori: estFavori ?? this.estFavori,
      note: note ?? this.note,
      chapitres: chapitres ?? this.chapitres,
      liens: liens ?? this.liens,
      anilistId: anilistId ?? this.anilistId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncImage: syncImage ?? this.syncImage,
      syncDescription: syncDescription ?? this.syncDescription,
      syncGenres: syncGenres ?? this.syncGenres,
      syncType: syncType ?? this.syncType,
      imageSource: imageSource ?? this.imageSource,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titre.present) {
      map['titre'] = Variable<String>(titre.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (typeManga.present) {
      map['type_manga'] = Variable<String>(typeManga.value);
    }
    if (estFavori.present) {
      map['est_favori'] = Variable<bool>(estFavori.value);
    }
    if (note.present) {
      map['note'] = Variable<double>(note.value);
    }
    if (chapitres.present) {
      map['chapitres'] = Variable<double>(chapitres.value);
    }
    if (liens.present) {
      map['liens'] = Variable<String>(liens.value);
    }
    if (anilistId.present) {
      map['anilist_id'] = Variable<int>(anilistId.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (syncImage.present) {
      map['sync_image'] = Variable<bool>(syncImage.value);
    }
    if (syncDescription.present) {
      map['sync_description'] = Variable<bool>(syncDescription.value);
    }
    if (syncGenres.present) {
      map['sync_genres'] = Variable<bool>(syncGenres.value);
    }
    if (syncType.present) {
      map['sync_type'] = Variable<bool>(syncType.value);
    }
    if (imageSource.present) {
      map['image_source'] = Variable<String>(imageSource.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MangaTableCompanion(')
          ..write('id: $id, ')
          ..write('titre: $titre, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('status: $status, ')
          ..write('genre: $genre, ')
          ..write('typeManga: $typeManga, ')
          ..write('estFavori: $estFavori, ')
          ..write('note: $note, ')
          ..write('chapitres: $chapitres, ')
          ..write('liens: $liens, ')
          ..write('anilistId: $anilistId, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('syncImage: $syncImage, ')
          ..write('syncDescription: $syncDescription, ')
          ..write('syncGenres: $syncGenres, ')
          ..write('syncType: $syncType, ')
          ..write('imageSource: $imageSource')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MangaTableTable mangaTable = $MangaTableTable(this);
  late final MangaDao mangaDao = MangaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [mangaTable];
}

typedef $$MangaTableTableCreateCompanionBuilder =
    MangaTableCompanion Function({
      Value<int> id,
      required String titre,
      Value<String?> description,
      Value<String?> imagePath,
      required String status,
      Value<String?> genre,
      required String typeManga,
      required bool estFavori,
      required double note,
      required double chapitres,
      Value<String?> liens,
      Value<int?> anilistId,
      Value<DateTime?> lastSyncedAt,
      Value<bool> syncImage,
      Value<bool> syncDescription,
      Value<bool> syncGenres,
      Value<bool> syncType,
      Value<String> imageSource,
    });
typedef $$MangaTableTableUpdateCompanionBuilder =
    MangaTableCompanion Function({
      Value<int> id,
      Value<String> titre,
      Value<String?> description,
      Value<String?> imagePath,
      Value<String> status,
      Value<String?> genre,
      Value<String> typeManga,
      Value<bool> estFavori,
      Value<double> note,
      Value<double> chapitres,
      Value<String?> liens,
      Value<int?> anilistId,
      Value<DateTime?> lastSyncedAt,
      Value<bool> syncImage,
      Value<bool> syncDescription,
      Value<bool> syncGenres,
      Value<bool> syncType,
      Value<String> imageSource,
    });

class $$MangaTableTableFilterComposer
    extends Composer<_$AppDatabase, $MangaTableTable> {
  $$MangaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeManga => $composableBuilder(
    column: $table.typeManga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estFavori => $composableBuilder(
    column: $table.estFavori,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chapitres => $composableBuilder(
    column: $table.chapitres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get liens => $composableBuilder(
    column: $table.liens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anilistId => $composableBuilder(
    column: $table.anilistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncImage => $composableBuilder(
    column: $table.syncImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncDescription => $composableBuilder(
    column: $table.syncDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncGenres => $composableBuilder(
    column: $table.syncGenres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncType => $composableBuilder(
    column: $table.syncType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageSource => $composableBuilder(
    column: $table.imageSource,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MangaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MangaTableTable> {
  $$MangaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeManga => $composableBuilder(
    column: $table.typeManga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estFavori => $composableBuilder(
    column: $table.estFavori,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chapitres => $composableBuilder(
    column: $table.chapitres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get liens => $composableBuilder(
    column: $table.liens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anilistId => $composableBuilder(
    column: $table.anilistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncImage => $composableBuilder(
    column: $table.syncImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncDescription => $composableBuilder(
    column: $table.syncDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncGenres => $composableBuilder(
    column: $table.syncGenres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncType => $composableBuilder(
    column: $table.syncType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageSource => $composableBuilder(
    column: $table.imageSource,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MangaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MangaTableTable> {
  $$MangaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titre =>
      $composableBuilder(column: $table.titre, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get typeManga =>
      $composableBuilder(column: $table.typeManga, builder: (column) => column);

  GeneratedColumn<bool> get estFavori =>
      $composableBuilder(column: $table.estFavori, builder: (column) => column);

  GeneratedColumn<double> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<double> get chapitres =>
      $composableBuilder(column: $table.chapitres, builder: (column) => column);

  GeneratedColumn<String> get liens =>
      $composableBuilder(column: $table.liens, builder: (column) => column);

  GeneratedColumn<int> get anilistId =>
      $composableBuilder(column: $table.anilistId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncImage =>
      $composableBuilder(column: $table.syncImage, builder: (column) => column);

  GeneratedColumn<bool> get syncDescription => $composableBuilder(
    column: $table.syncDescription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncGenres => $composableBuilder(
    column: $table.syncGenres,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncType =>
      $composableBuilder(column: $table.syncType, builder: (column) => column);

  GeneratedColumn<String> get imageSource => $composableBuilder(
    column: $table.imageSource,
    builder: (column) => column,
  );
}

class $$MangaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MangaTableTable,
          MangaTableData,
          $$MangaTableTableFilterComposer,
          $$MangaTableTableOrderingComposer,
          $$MangaTableTableAnnotationComposer,
          $$MangaTableTableCreateCompanionBuilder,
          $$MangaTableTableUpdateCompanionBuilder,
          (
            MangaTableData,
            BaseReferences<_$AppDatabase, $MangaTableTable, MangaTableData>,
          ),
          MangaTableData,
          PrefetchHooks Function()
        > {
  $$MangaTableTableTableManager(_$AppDatabase db, $MangaTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MangaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MangaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MangaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titre = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String> typeManga = const Value.absent(),
                Value<bool> estFavori = const Value.absent(),
                Value<double> note = const Value.absent(),
                Value<double> chapitres = const Value.absent(),
                Value<String?> liens = const Value.absent(),
                Value<int?> anilistId = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<bool> syncImage = const Value.absent(),
                Value<bool> syncDescription = const Value.absent(),
                Value<bool> syncGenres = const Value.absent(),
                Value<bool> syncType = const Value.absent(),
                Value<String> imageSource = const Value.absent(),
              }) => MangaTableCompanion(
                id: id,
                titre: titre,
                description: description,
                imagePath: imagePath,
                status: status,
                genre: genre,
                typeManga: typeManga,
                estFavori: estFavori,
                note: note,
                chapitres: chapitres,
                liens: liens,
                anilistId: anilistId,
                lastSyncedAt: lastSyncedAt,
                syncImage: syncImage,
                syncDescription: syncDescription,
                syncGenres: syncGenres,
                syncType: syncType,
                imageSource: imageSource,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titre,
                Value<String?> description = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String status,
                Value<String?> genre = const Value.absent(),
                required String typeManga,
                required bool estFavori,
                required double note,
                required double chapitres,
                Value<String?> liens = const Value.absent(),
                Value<int?> anilistId = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<bool> syncImage = const Value.absent(),
                Value<bool> syncDescription = const Value.absent(),
                Value<bool> syncGenres = const Value.absent(),
                Value<bool> syncType = const Value.absent(),
                Value<String> imageSource = const Value.absent(),
              }) => MangaTableCompanion.insert(
                id: id,
                titre: titre,
                description: description,
                imagePath: imagePath,
                status: status,
                genre: genre,
                typeManga: typeManga,
                estFavori: estFavori,
                note: note,
                chapitres: chapitres,
                liens: liens,
                anilistId: anilistId,
                lastSyncedAt: lastSyncedAt,
                syncImage: syncImage,
                syncDescription: syncDescription,
                syncGenres: syncGenres,
                syncType: syncType,
                imageSource: imageSource,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MangaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MangaTableTable,
      MangaTableData,
      $$MangaTableTableFilterComposer,
      $$MangaTableTableOrderingComposer,
      $$MangaTableTableAnnotationComposer,
      $$MangaTableTableCreateCompanionBuilder,
      $$MangaTableTableUpdateCompanionBuilder,
      (
        MangaTableData,
        BaseReferences<_$AppDatabase, $MangaTableTable, MangaTableData>,
      ),
      MangaTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MangaTableTableTableManager get mangaTable =>
      $$MangaTableTableTableManager(_db, _db.mangaTable);
}
