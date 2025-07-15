// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MUsersTable extends MUsers with TableInfo<$MUsersTable, MUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _useridMeta = const VerificationMeta('userid');
  @override
  late final GeneratedColumn<String> userid = GeneratedColumn<String>(
    'userid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isactiveMeta = const VerificationMeta(
    'isactive',
  );
  @override
  late final GeneratedColumn<String> isactive = GeneratedColumn<String>(
    'isactive',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 1,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userid,
    username,
    password,
    role,
    isactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'm_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<MUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('userid')) {
      context.handle(
        _useridMeta,
        userid.isAcceptableOrUnknown(data['userid']!, _useridMeta),
      );
    } else if (isInserting) {
      context.missing(_useridMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('isactive')) {
      context.handle(
        _isactiveMeta,
        isactive.isAcceptableOrUnknown(data['isactive']!, _isactiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isactiveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userid};
  @override
  MUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MUser(
      userid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}userid'],
          )!,
      username:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}username'],
          )!,
      password:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}password'],
          )!,
      role:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}role'],
          )!,
      isactive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}isactive'],
          )!,
    );
  }

  @override
  $MUsersTable createAlias(String alias) {
    return $MUsersTable(attachedDatabase, alias);
  }
}

class MUser extends DataClass implements Insertable<MUser> {
  final String userid;
  final String username;
  final String password;
  final String role;
  final String isactive;
  const MUser({
    required this.userid,
    required this.username,
    required this.password,
    required this.role,
    required this.isactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['userid'] = Variable<String>(userid);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    map['isactive'] = Variable<String>(isactive);
    return map;
  }

  MUsersCompanion toCompanion(bool nullToAbsent) {
    return MUsersCompanion(
      userid: Value(userid),
      username: Value(username),
      password: Value(password),
      role: Value(role),
      isactive: Value(isactive),
    );
  }

  factory MUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MUser(
      userid: serializer.fromJson<String>(json['userid']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      isactive: serializer.fromJson<String>(json['isactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userid': serializer.toJson<String>(userid),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'isactive': serializer.toJson<String>(isactive),
    };
  }

  MUser copyWith({
    String? userid,
    String? username,
    String? password,
    String? role,
    String? isactive,
  }) => MUser(
    userid: userid ?? this.userid,
    username: username ?? this.username,
    password: password ?? this.password,
    role: role ?? this.role,
    isactive: isactive ?? this.isactive,
  );
  MUser copyWithCompanion(MUsersCompanion data) {
    return MUser(
      userid: data.userid.present ? data.userid.value : this.userid,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      isactive: data.isactive.present ? data.isactive.value : this.isactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MUser(')
          ..write('userid: $userid, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('isactive: $isactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userid, username, password, role, isactive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MUser &&
          other.userid == this.userid &&
          other.username == this.username &&
          other.password == this.password &&
          other.role == this.role &&
          other.isactive == this.isactive);
}

class MUsersCompanion extends UpdateCompanion<MUser> {
  final Value<String> userid;
  final Value<String> username;
  final Value<String> password;
  final Value<String> role;
  final Value<String> isactive;
  final Value<int> rowid;
  const MUsersCompanion({
    this.userid = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.isactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MUsersCompanion.insert({
    required String userid,
    required String username,
    required String password,
    required String role,
    required String isactive,
    this.rowid = const Value.absent(),
  }) : userid = Value(userid),
       username = Value(username),
       password = Value(password),
       role = Value(role),
       isactive = Value(isactive);
  static Insertable<MUser> custom({
    Expression<String>? userid,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? isactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userid != null) 'userid': userid,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (isactive != null) 'isactive': isactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MUsersCompanion copyWith({
    Value<String>? userid,
    Value<String>? username,
    Value<String>? password,
    Value<String>? role,
    Value<String>? isactive,
    Value<int>? rowid,
  }) {
    return MUsersCompanion(
      userid: userid ?? this.userid,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      isactive: isactive ?? this.isactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userid.present) {
      map['userid'] = Variable<String>(userid.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isactive.present) {
      map['isactive'] = Variable<String>(isactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MUsersCompanion(')
          ..write('userid: $userid, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('isactive: $isactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MBusinessUnitTable extends MBusinessUnit
    with TableInfo<$MBusinessUnitTable, MBusinessUnitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MBusinessUnitTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyCodeMeta = const VerificationMeta(
    'companyCode',
  );
  @override
  late final GeneratedColumn<String> companyCode = GeneratedColumn<String>(
    'company_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 5,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantCodeMeta = const VerificationMeta(
    'plantCode',
  );
  @override
  late final GeneratedColumn<String> plantCode = GeneratedColumn<String>(
    'plant_code',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 5),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plantNameMeta = const VerificationMeta(
    'plantName',
  );
  @override
  late final GeneratedColumn<String> plantName = GeneratedColumn<String>(
    'plant_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isactiveMeta = const VerificationMeta(
    'isactive',
  );
  @override
  late final GeneratedColumn<String> isactive = GeneratedColumn<String>(
    'isactive',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 1,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryByMeta = const VerificationMeta(
    'entryBy',
  );
  @override
  late final GeneratedColumn<String> entryBy = GeneratedColumn<String>(
    'entry_by',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> entryDate =
      GeneratedColumn<String>(
        'entry_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($MBusinessUnitTable.$converterentryDate);
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
    'parent',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 1,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyCode,
    companyName,
    plantCode,
    plantName,
    isactive,
    entryBy,
    entryDate,
    parent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'm_business_unit';
  @override
  VerificationContext validateIntegrity(
    Insertable<MBusinessUnitData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('company_code')) {
      context.handle(
        _companyCodeMeta,
        companyCode.isAcceptableOrUnknown(
          data['company_code']!,
          _companyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyCodeMeta);
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('plant_code')) {
      context.handle(
        _plantCodeMeta,
        plantCode.isAcceptableOrUnknown(data['plant_code']!, _plantCodeMeta),
      );
    }
    if (data.containsKey('plant_name')) {
      context.handle(
        _plantNameMeta,
        plantName.isAcceptableOrUnknown(data['plant_name']!, _plantNameMeta),
      );
    }
    if (data.containsKey('isactive')) {
      context.handle(
        _isactiveMeta,
        isactive.isAcceptableOrUnknown(data['isactive']!, _isactiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isactiveMeta);
    }
    if (data.containsKey('entry_by')) {
      context.handle(
        _entryByMeta,
        entryBy.isAcceptableOrUnknown(data['entry_by']!, _entryByMeta),
      );
    } else if (isInserting) {
      context.missing(_entryByMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(
        _parentMeta,
        parent.isAcceptableOrUnknown(data['parent']!, _parentMeta),
      );
    } else if (isInserting) {
      context.missing(_parentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MBusinessUnitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MBusinessUnitData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      companyCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}company_code'],
          )!,
      companyName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}company_name'],
          )!,
      plantCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant_code'],
      ),
      plantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant_name'],
      ),
      isactive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}isactive'],
          )!,
      entryBy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entry_by'],
          )!,
      entryDate: $MBusinessUnitTable.$converterentryDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entry_date'],
        )!,
      ),
      parent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}parent'],
          )!,
    );
  }

  @override
  $MBusinessUnitTable createAlias(String alias) {
    return $MBusinessUnitTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterentryDate =
      const DateTimeTextConverter();
}

class MBusinessUnitData extends DataClass
    implements Insertable<MBusinessUnitData> {
  final String id;
  final String companyCode;
  final String companyName;
  final String? plantCode;
  final String? plantName;
  final String isactive;
  final String entryBy;
  final DateTime entryDate;
  final String parent;
  const MBusinessUnitData({
    required this.id,
    required this.companyCode,
    required this.companyName,
    this.plantCode,
    this.plantName,
    required this.isactive,
    required this.entryBy,
    required this.entryDate,
    required this.parent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['company_code'] = Variable<String>(companyCode);
    map['company_name'] = Variable<String>(companyName);
    if (!nullToAbsent || plantCode != null) {
      map['plant_code'] = Variable<String>(plantCode);
    }
    if (!nullToAbsent || plantName != null) {
      map['plant_name'] = Variable<String>(plantName);
    }
    map['isactive'] = Variable<String>(isactive);
    map['entry_by'] = Variable<String>(entryBy);
    {
      map['entry_date'] = Variable<String>(
        $MBusinessUnitTable.$converterentryDate.toSql(entryDate),
      );
    }
    map['parent'] = Variable<String>(parent);
    return map;
  }

  MBusinessUnitCompanion toCompanion(bool nullToAbsent) {
    return MBusinessUnitCompanion(
      id: Value(id),
      companyCode: Value(companyCode),
      companyName: Value(companyName),
      plantCode:
          plantCode == null && nullToAbsent
              ? const Value.absent()
              : Value(plantCode),
      plantName:
          plantName == null && nullToAbsent
              ? const Value.absent()
              : Value(plantName),
      isactive: Value(isactive),
      entryBy: Value(entryBy),
      entryDate: Value(entryDate),
      parent: Value(parent),
    );
  }

  factory MBusinessUnitData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MBusinessUnitData(
      id: serializer.fromJson<String>(json['id']),
      companyCode: serializer.fromJson<String>(json['companyCode']),
      companyName: serializer.fromJson<String>(json['companyName']),
      plantCode: serializer.fromJson<String?>(json['plantCode']),
      plantName: serializer.fromJson<String?>(json['plantName']),
      isactive: serializer.fromJson<String>(json['isactive']),
      entryBy: serializer.fromJson<String>(json['entryBy']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      parent: serializer.fromJson<String>(json['parent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'companyCode': serializer.toJson<String>(companyCode),
      'companyName': serializer.toJson<String>(companyName),
      'plantCode': serializer.toJson<String?>(plantCode),
      'plantName': serializer.toJson<String?>(plantName),
      'isactive': serializer.toJson<String>(isactive),
      'entryBy': serializer.toJson<String>(entryBy),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'parent': serializer.toJson<String>(parent),
    };
  }

  MBusinessUnitData copyWith({
    String? id,
    String? companyCode,
    String? companyName,
    Value<String?> plantCode = const Value.absent(),
    Value<String?> plantName = const Value.absent(),
    String? isactive,
    String? entryBy,
    DateTime? entryDate,
    String? parent,
  }) => MBusinessUnitData(
    id: id ?? this.id,
    companyCode: companyCode ?? this.companyCode,
    companyName: companyName ?? this.companyName,
    plantCode: plantCode.present ? plantCode.value : this.plantCode,
    plantName: plantName.present ? plantName.value : this.plantName,
    isactive: isactive ?? this.isactive,
    entryBy: entryBy ?? this.entryBy,
    entryDate: entryDate ?? this.entryDate,
    parent: parent ?? this.parent,
  );
  MBusinessUnitData copyWithCompanion(MBusinessUnitCompanion data) {
    return MBusinessUnitData(
      id: data.id.present ? data.id.value : this.id,
      companyCode:
          data.companyCode.present ? data.companyCode.value : this.companyCode,
      companyName:
          data.companyName.present ? data.companyName.value : this.companyName,
      plantCode: data.plantCode.present ? data.plantCode.value : this.plantCode,
      plantName: data.plantName.present ? data.plantName.value : this.plantName,
      isactive: data.isactive.present ? data.isactive.value : this.isactive,
      entryBy: data.entryBy.present ? data.entryBy.value : this.entryBy,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      parent: data.parent.present ? data.parent.value : this.parent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MBusinessUnitData(')
          ..write('id: $id, ')
          ..write('companyCode: $companyCode, ')
          ..write('companyName: $companyName, ')
          ..write('plantCode: $plantCode, ')
          ..write('plantName: $plantName, ')
          ..write('isactive: $isactive, ')
          ..write('entryBy: $entryBy, ')
          ..write('entryDate: $entryDate, ')
          ..write('parent: $parent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyCode,
    companyName,
    plantCode,
    plantName,
    isactive,
    entryBy,
    entryDate,
    parent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MBusinessUnitData &&
          other.id == this.id &&
          other.companyCode == this.companyCode &&
          other.companyName == this.companyName &&
          other.plantCode == this.plantCode &&
          other.plantName == this.plantName &&
          other.isactive == this.isactive &&
          other.entryBy == this.entryBy &&
          other.entryDate == this.entryDate &&
          other.parent == this.parent);
}

class MBusinessUnitCompanion extends UpdateCompanion<MBusinessUnitData> {
  final Value<String> id;
  final Value<String> companyCode;
  final Value<String> companyName;
  final Value<String?> plantCode;
  final Value<String?> plantName;
  final Value<String> isactive;
  final Value<String> entryBy;
  final Value<DateTime> entryDate;
  final Value<String> parent;
  final Value<int> rowid;
  const MBusinessUnitCompanion({
    this.id = const Value.absent(),
    this.companyCode = const Value.absent(),
    this.companyName = const Value.absent(),
    this.plantCode = const Value.absent(),
    this.plantName = const Value.absent(),
    this.isactive = const Value.absent(),
    this.entryBy = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.parent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MBusinessUnitCompanion.insert({
    required String id,
    required String companyCode,
    required String companyName,
    this.plantCode = const Value.absent(),
    this.plantName = const Value.absent(),
    required String isactive,
    required String entryBy,
    required DateTime entryDate,
    required String parent,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       companyCode = Value(companyCode),
       companyName = Value(companyName),
       isactive = Value(isactive),
       entryBy = Value(entryBy),
       entryDate = Value(entryDate),
       parent = Value(parent);
  static Insertable<MBusinessUnitData> custom({
    Expression<String>? id,
    Expression<String>? companyCode,
    Expression<String>? companyName,
    Expression<String>? plantCode,
    Expression<String>? plantName,
    Expression<String>? isactive,
    Expression<String>? entryBy,
    Expression<String>? entryDate,
    Expression<String>? parent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyCode != null) 'company_code': companyCode,
      if (companyName != null) 'company_name': companyName,
      if (plantCode != null) 'plant_code': plantCode,
      if (plantName != null) 'plant_name': plantName,
      if (isactive != null) 'isactive': isactive,
      if (entryBy != null) 'entry_by': entryBy,
      if (entryDate != null) 'entry_date': entryDate,
      if (parent != null) 'parent': parent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MBusinessUnitCompanion copyWith({
    Value<String>? id,
    Value<String>? companyCode,
    Value<String>? companyName,
    Value<String?>? plantCode,
    Value<String?>? plantName,
    Value<String>? isactive,
    Value<String>? entryBy,
    Value<DateTime>? entryDate,
    Value<String>? parent,
    Value<int>? rowid,
  }) {
    return MBusinessUnitCompanion(
      id: id ?? this.id,
      companyCode: companyCode ?? this.companyCode,
      companyName: companyName ?? this.companyName,
      plantCode: plantCode ?? this.plantCode,
      plantName: plantName ?? this.plantName,
      isactive: isactive ?? this.isactive,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      parent: parent ?? this.parent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (companyCode.present) {
      map['company_code'] = Variable<String>(companyCode.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (plantCode.present) {
      map['plant_code'] = Variable<String>(plantCode.value);
    }
    if (plantName.present) {
      map['plant_name'] = Variable<String>(plantName.value);
    }
    if (isactive.present) {
      map['isactive'] = Variable<String>(isactive.value);
    }
    if (entryBy.present) {
      map['entry_by'] = Variable<String>(entryBy.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<String>(
        $MBusinessUnitTable.$converterentryDate.toSql(entryDate.value),
      );
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MBusinessUnitCompanion(')
          ..write('id: $id, ')
          ..write('companyCode: $companyCode, ')
          ..write('companyName: $companyName, ')
          ..write('plantCode: $plantCode, ')
          ..write('plantName: $plantName, ')
          ..write('isactive: $isactive, ')
          ..write('entryBy: $entryBy, ')
          ..write('entryDate: $entryDate, ')
          ..write('parent: $parent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MMastervaluesTable extends MMastervalues
    with TableInfo<$MMastervaluesTable, MMastervalue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MMastervaluesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupMeta = const VerificationMeta('group');
  @override
  late final GeneratedColumn<String> group = GeneratedColumn<String>(
    'group',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isactiveMeta = const VerificationMeta(
    'isactive',
  );
  @override
  late final GeneratedColumn<String> isactive = GeneratedColumn<String>(
    'isactive',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 1,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryByMeta = const VerificationMeta(
    'entryBy',
  );
  @override
  late final GeneratedColumn<String> entryBy = GeneratedColumn<String>(
    'entry_by',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> entryDate =
      GeneratedColumn<String>(
        'entry_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($MMastervaluesTable.$converterentryDate);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    group,
    number,
    isactive,
    entryBy,
    entryDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'm_mastervalues';
  @override
  VerificationContext validateIntegrity(
    Insertable<MMastervalue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('group')) {
      context.handle(
        _groupMeta,
        group.isAcceptableOrUnknown(data['group']!, _groupMeta),
      );
    } else if (isInserting) {
      context.missing(_groupMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('isactive')) {
      context.handle(
        _isactiveMeta,
        isactive.isAcceptableOrUnknown(data['isactive']!, _isactiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isactiveMeta);
    }
    if (data.containsKey('entry_by')) {
      context.handle(
        _entryByMeta,
        entryBy.isAcceptableOrUnknown(data['entry_by']!, _entryByMeta),
      );
    } else if (isInserting) {
      context.missing(_entryByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MMastervalue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MMastervalue(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      code:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}code'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      group:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}group'],
          )!,
      number:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}number'],
          )!,
      isactive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}isactive'],
          )!,
      entryBy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entry_by'],
          )!,
      entryDate: $MMastervaluesTable.$converterentryDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entry_date'],
        )!,
      ),
    );
  }

  @override
  $MMastervaluesTable createAlias(String alias) {
    return $MMastervaluesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterentryDate =
      const DateTimeTextConverter();
}

class MMastervalue extends DataClass implements Insertable<MMastervalue> {
  final String id;
  final String code;
  final String name;
  final String group;
  final int number;
  final String isactive;
  final String entryBy;
  final DateTime entryDate;
  const MMastervalue({
    required this.id,
    required this.code,
    required this.name,
    required this.group,
    required this.number,
    required this.isactive,
    required this.entryBy,
    required this.entryDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['group'] = Variable<String>(group);
    map['number'] = Variable<int>(number);
    map['isactive'] = Variable<String>(isactive);
    map['entry_by'] = Variable<String>(entryBy);
    {
      map['entry_date'] = Variable<String>(
        $MMastervaluesTable.$converterentryDate.toSql(entryDate),
      );
    }
    return map;
  }

  MMastervaluesCompanion toCompanion(bool nullToAbsent) {
    return MMastervaluesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      group: Value(group),
      number: Value(number),
      isactive: Value(isactive),
      entryBy: Value(entryBy),
      entryDate: Value(entryDate),
    );
  }

  factory MMastervalue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MMastervalue(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      group: serializer.fromJson<String>(json['group']),
      number: serializer.fromJson<int>(json['number']),
      isactive: serializer.fromJson<String>(json['isactive']),
      entryBy: serializer.fromJson<String>(json['entryBy']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'group': serializer.toJson<String>(group),
      'number': serializer.toJson<int>(number),
      'isactive': serializer.toJson<String>(isactive),
      'entryBy': serializer.toJson<String>(entryBy),
      'entryDate': serializer.toJson<DateTime>(entryDate),
    };
  }

  MMastervalue copyWith({
    String? id,
    String? code,
    String? name,
    String? group,
    int? number,
    String? isactive,
    String? entryBy,
    DateTime? entryDate,
  }) => MMastervalue(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    group: group ?? this.group,
    number: number ?? this.number,
    isactive: isactive ?? this.isactive,
    entryBy: entryBy ?? this.entryBy,
    entryDate: entryDate ?? this.entryDate,
  );
  MMastervalue copyWithCompanion(MMastervaluesCompanion data) {
    return MMastervalue(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      group: data.group.present ? data.group.value : this.group,
      number: data.number.present ? data.number.value : this.number,
      isactive: data.isactive.present ? data.isactive.value : this.isactive,
      entryBy: data.entryBy.present ? data.entryBy.value : this.entryBy,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MMastervalue(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('group: $group, ')
          ..write('number: $number, ')
          ..write('isactive: $isactive, ')
          ..write('entryBy: $entryBy, ')
          ..write('entryDate: $entryDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, group, number, isactive, entryBy, entryDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MMastervalue &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.group == this.group &&
          other.number == this.number &&
          other.isactive == this.isactive &&
          other.entryBy == this.entryBy &&
          other.entryDate == this.entryDate);
}

class MMastervaluesCompanion extends UpdateCompanion<MMastervalue> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> group;
  final Value<int> number;
  final Value<String> isactive;
  final Value<String> entryBy;
  final Value<DateTime> entryDate;
  final Value<int> rowid;
  const MMastervaluesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.group = const Value.absent(),
    this.number = const Value.absent(),
    this.isactive = const Value.absent(),
    this.entryBy = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MMastervaluesCompanion.insert({
    required String id,
    required String code,
    required String name,
    required String group,
    required int number,
    required String isactive,
    required String entryBy,
    required DateTime entryDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       group = Value(group),
       number = Value(number),
       isactive = Value(isactive),
       entryBy = Value(entryBy),
       entryDate = Value(entryDate);
  static Insertable<MMastervalue> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? group,
    Expression<int>? number,
    Expression<String>? isactive,
    Expression<String>? entryBy,
    Expression<String>? entryDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (group != null) 'group': group,
      if (number != null) 'number': number,
      if (isactive != null) 'isactive': isactive,
      if (entryBy != null) 'entry_by': entryBy,
      if (entryDate != null) 'entry_date': entryDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MMastervaluesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? group,
    Value<int>? number,
    Value<String>? isactive,
    Value<String>? entryBy,
    Value<DateTime>? entryDate,
    Value<int>? rowid,
  }) {
    return MMastervaluesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      group: group ?? this.group,
      number: number ?? this.number,
      isactive: isactive ?? this.isactive,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (group.present) {
      map['group'] = Variable<String>(group.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (isactive.present) {
      map['isactive'] = Variable<String>(isactive.value);
    }
    if (entryBy.present) {
      map['entry_by'] = Variable<String>(entryBy.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<String>(
        $MMastervaluesTable.$converterentryDate.toSql(entryDate.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MMastervaluesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('group: $group, ')
          ..write('number: $number, ')
          ..write('isactive: $isactive, ')
          ..write('entryBy: $entryBy, ')
          ..write('entryDate: $entryDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TQualityReportRefineryTable extends TQualityReportRefinery
    with TableInfo<$TQualityReportRefineryTable, TQualityReportRefineryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TQualityReportRefineryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> report_date =
      GeneratedColumn<String>(
        'report_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(
        $TQualityReportRefineryTable.$converterreport_date,
      );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_catMeta = const VerificationMeta('p_cat');
  @override
  late final GeneratedColumn<String> p_cat = GeneratedColumn<String>(
    'p_cat',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_tank_sourceMeta = const VerificationMeta(
    'p_tank_source',
  );
  @override
  late final GeneratedColumn<double> p_tank_source = GeneratedColumn<double>(
    'p_tank_source',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_flowrateMeta = const VerificationMeta(
    'p_flowrate',
  );
  @override
  late final GeneratedColumn<double> p_flowrate = GeneratedColumn<double>(
    'p_flowrate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_ffaMeta = const VerificationMeta('p_ffa');
  @override
  late final GeneratedColumn<double> p_ffa = GeneratedColumn<double>(
    'p_ffa',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_ivMeta = const VerificationMeta('p_iv');
  @override
  late final GeneratedColumn<double> p_iv = GeneratedColumn<double>(
    'p_iv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_pvMeta = const VerificationMeta('p_pv');
  @override
  late final GeneratedColumn<double> p_pv = GeneratedColumn<double>(
    'p_pv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_anvMeta = const VerificationMeta('p_anv');
  @override
  late final GeneratedColumn<double> p_anv = GeneratedColumn<double>(
    'p_anv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_dobiMeta = const VerificationMeta('p_dobi');
  @override
  late final GeneratedColumn<double> p_dobi = GeneratedColumn<double>(
    'p_dobi',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_caroteneMeta = const VerificationMeta(
    'p_carotene',
  );
  @override
  late final GeneratedColumn<double> p_carotene = GeneratedColumn<double>(
    'p_carotene',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_m_iMeta = const VerificationMeta('p_m_i');
  @override
  late final GeneratedColumn<double> p_m_i = GeneratedColumn<double>(
    'p_m&i',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _p_colorMeta = const VerificationMeta(
    'p_color',
  );
  @override
  late final GeneratedColumn<String> p_color = GeneratedColumn<String>(
    'p_color',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _c_catMeta = const VerificationMeta('c_cat');
  @override
  late final GeneratedColumn<String> c_cat = GeneratedColumn<String>(
    'c_cat',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _c_paMeta = const VerificationMeta('c_pa');
  @override
  late final GeneratedColumn<double> c_pa = GeneratedColumn<double>(
    'c_pa',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _c_beMeta = const VerificationMeta('c_be');
  @override
  late final GeneratedColumn<double> c_be = GeneratedColumn<double>(
    'c_be',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _b_catMeta = const VerificationMeta('b_cat');
  @override
  late final GeneratedColumn<String> b_cat = GeneratedColumn<String>(
    'b_cat',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _b_color_rMeta = const VerificationMeta(
    'b_color_r',
  );
  @override
  late final GeneratedColumn<int> b_color_r = GeneratedColumn<int>(
    'b_color_r',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _b_color_yMeta = const VerificationMeta(
    'b_color_y',
  );
  @override
  late final GeneratedColumn<int> b_color_y = GeneratedColumn<int>(
    'b_color_y',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _b_break_testMeta = const VerificationMeta(
    'b_break_test',
  );
  @override
  late final GeneratedColumn<String> b_break_test = GeneratedColumn<String>(
    'b_break_test',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_catMeta = const VerificationMeta('r_cat');
  @override
  late final GeneratedColumn<String> r_cat = GeneratedColumn<String>(
    'r_cat',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_ffaMeta = const VerificationMeta('r_ffa');
  @override
  late final GeneratedColumn<double> r_ffa = GeneratedColumn<double>(
    'r_ffa',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_color_rMeta = const VerificationMeta(
    'r_color_r',
  );
  @override
  late final GeneratedColumn<int> r_color_r = GeneratedColumn<int>(
    'r_color_r',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_color_yMeta = const VerificationMeta(
    'r_color_y',
  );
  @override
  late final GeneratedColumn<int> r_color_y = GeneratedColumn<int>(
    'r_color_y',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_color_bMeta = const VerificationMeta(
    'r_color_b',
  );
  @override
  late final GeneratedColumn<int> r_color_b = GeneratedColumn<int>(
    'r_color_b',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_pvMeta = const VerificationMeta('r_pv');
  @override
  late final GeneratedColumn<int> r_pv = GeneratedColumn<int>(
    'r_pv',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_m_iMeta = const VerificationMeta('r_m_i');
  @override
  late final GeneratedColumn<int> r_m_i = GeneratedColumn<int>(
    'r_m&i',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _r_product_tank_noMeta = const VerificationMeta(
    'r_product_tank_no',
  );
  @override
  late final GeneratedColumn<double> r_product_tank_no =
      GeneratedColumn<double>(
        'r_product_tank_no',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fp_catMeta = const VerificationMeta('fp_cat');
  @override
  late final GeneratedColumn<String> fp_cat = GeneratedColumn<String>(
    'fp_cat',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fp_purityMeta = const VerificationMeta(
    'fp_purity',
  );
  @override
  late final GeneratedColumn<double> fp_purity = GeneratedColumn<double>(
    'fp_purity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fp_product_tank_noMeta =
      const VerificationMeta('fp_product_tank_no');
  @override
  late final GeneratedColumn<double> fp_product_tank_no =
      GeneratedColumn<double>(
        'fp_product_tank_no',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _spent_earth_oicMeta = const VerificationMeta(
    'spent_earth_oic',
  );
  @override
  late final GeneratedColumn<double> spent_earth_oic = GeneratedColumn<double>(
    'spent_earth_oic',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _picMeta = const VerificationMeta('pic');
  @override
  late final GeneratedColumn<String> pic = GeneratedColumn<String>(
    'pic',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checked_byMeta = const VerificationMeta(
    'checked_by',
  );
  @override
  late final GeneratedColumn<String> checked_by = GeneratedColumn<String>(
    'checked_by',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checked_dateMeta = const VerificationMeta(
    'checked_date',
  );
  @override
  late final GeneratedColumn<DateTime> checked_date = GeneratedColumn<DateTime>(
    'checked_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checked_timeMeta = const VerificationMeta(
    'checked_time',
  );
  @override
  late final GeneratedColumn<String> checked_time = GeneratedColumn<String>(
    'checked_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approved_byMeta = const VerificationMeta(
    'approved_by',
  );
  @override
  late final GeneratedColumn<String> approved_by = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approved_dateMeta = const VerificationMeta(
    'approved_date',
  );
  @override
  late final GeneratedColumn<DateTime> approved_date =
      GeneratedColumn<DateTime>(
        'approved_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _approved_timeMeta = const VerificationMeta(
    'approved_time',
  );
  @override
  late final GeneratedColumn<String> approved_time = GeneratedColumn<String>(
    'approved_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flagMeta = const VerificationMeta('flag');
  @override
  late final GeneratedColumn<String> flag = GeneratedColumn<String>(
    'flag',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 1,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plantMeta = const VerificationMeta('plant');
  @override
  late final GeneratedColumn<String> plant = GeneratedColumn<String>(
    'plant',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entry_byMeta = const VerificationMeta(
    'entry_by',
  );
  @override
  late final GeneratedColumn<String> entry_by = GeneratedColumn<String>(
    'entry_by',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> entry_date =
      GeneratedColumn<String>(
        'entry_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => getCurrentDateTimeFormatted(),
      ).withConverter<DateTime>(
        $TQualityReportRefineryTable.$converterentry_date,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    report_date,
    time,
    p_cat,
    p_tank_source,
    p_flowrate,
    p_ffa,
    p_iv,
    p_pv,
    p_anv,
    p_dobi,
    p_carotene,
    p_m_i,
    p_color,
    c_cat,
    c_pa,
    c_be,
    b_cat,
    b_color_r,
    b_color_y,
    b_break_test,
    r_cat,
    r_ffa,
    r_color_r,
    r_color_y,
    r_color_b,
    r_pv,
    r_m_i,
    r_product_tank_no,
    fp_cat,
    fp_purity,
    fp_product_tank_no,
    spent_earth_oic,
    pic,
    remarks,
    checked_by,
    checked_date,
    checked_time,
    approved_by,
    approved_date,
    approved_time,
    flag,
    company,
    plant,
    entry_by,
    entry_date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_quality_report_refinery';
  @override
  VerificationContext validateIntegrity(
    Insertable<TQualityReportRefineryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('p_cat')) {
      context.handle(
        _p_catMeta,
        p_cat.isAcceptableOrUnknown(data['p_cat']!, _p_catMeta),
      );
    }
    if (data.containsKey('p_tank_source')) {
      context.handle(
        _p_tank_sourceMeta,
        p_tank_source.isAcceptableOrUnknown(
          data['p_tank_source']!,
          _p_tank_sourceMeta,
        ),
      );
    }
    if (data.containsKey('p_flowrate')) {
      context.handle(
        _p_flowrateMeta,
        p_flowrate.isAcceptableOrUnknown(data['p_flowrate']!, _p_flowrateMeta),
      );
    }
    if (data.containsKey('p_ffa')) {
      context.handle(
        _p_ffaMeta,
        p_ffa.isAcceptableOrUnknown(data['p_ffa']!, _p_ffaMeta),
      );
    }
    if (data.containsKey('p_iv')) {
      context.handle(
        _p_ivMeta,
        p_iv.isAcceptableOrUnknown(data['p_iv']!, _p_ivMeta),
      );
    }
    if (data.containsKey('p_pv')) {
      context.handle(
        _p_pvMeta,
        p_pv.isAcceptableOrUnknown(data['p_pv']!, _p_pvMeta),
      );
    }
    if (data.containsKey('p_anv')) {
      context.handle(
        _p_anvMeta,
        p_anv.isAcceptableOrUnknown(data['p_anv']!, _p_anvMeta),
      );
    }
    if (data.containsKey('p_dobi')) {
      context.handle(
        _p_dobiMeta,
        p_dobi.isAcceptableOrUnknown(data['p_dobi']!, _p_dobiMeta),
      );
    }
    if (data.containsKey('p_carotene')) {
      context.handle(
        _p_caroteneMeta,
        p_carotene.isAcceptableOrUnknown(data['p_carotene']!, _p_caroteneMeta),
      );
    }
    if (data.containsKey('p_m&i')) {
      context.handle(
        _p_m_iMeta,
        p_m_i.isAcceptableOrUnknown(data['p_m&i']!, _p_m_iMeta),
      );
    }
    if (data.containsKey('p_color')) {
      context.handle(
        _p_colorMeta,
        p_color.isAcceptableOrUnknown(data['p_color']!, _p_colorMeta),
      );
    }
    if (data.containsKey('c_cat')) {
      context.handle(
        _c_catMeta,
        c_cat.isAcceptableOrUnknown(data['c_cat']!, _c_catMeta),
      );
    }
    if (data.containsKey('c_pa')) {
      context.handle(
        _c_paMeta,
        c_pa.isAcceptableOrUnknown(data['c_pa']!, _c_paMeta),
      );
    }
    if (data.containsKey('c_be')) {
      context.handle(
        _c_beMeta,
        c_be.isAcceptableOrUnknown(data['c_be']!, _c_beMeta),
      );
    }
    if (data.containsKey('b_cat')) {
      context.handle(
        _b_catMeta,
        b_cat.isAcceptableOrUnknown(data['b_cat']!, _b_catMeta),
      );
    }
    if (data.containsKey('b_color_r')) {
      context.handle(
        _b_color_rMeta,
        b_color_r.isAcceptableOrUnknown(data['b_color_r']!, _b_color_rMeta),
      );
    }
    if (data.containsKey('b_color_y')) {
      context.handle(
        _b_color_yMeta,
        b_color_y.isAcceptableOrUnknown(data['b_color_y']!, _b_color_yMeta),
      );
    }
    if (data.containsKey('b_break_test')) {
      context.handle(
        _b_break_testMeta,
        b_break_test.isAcceptableOrUnknown(
          data['b_break_test']!,
          _b_break_testMeta,
        ),
      );
    }
    if (data.containsKey('r_cat')) {
      context.handle(
        _r_catMeta,
        r_cat.isAcceptableOrUnknown(data['r_cat']!, _r_catMeta),
      );
    }
    if (data.containsKey('r_ffa')) {
      context.handle(
        _r_ffaMeta,
        r_ffa.isAcceptableOrUnknown(data['r_ffa']!, _r_ffaMeta),
      );
    }
    if (data.containsKey('r_color_r')) {
      context.handle(
        _r_color_rMeta,
        r_color_r.isAcceptableOrUnknown(data['r_color_r']!, _r_color_rMeta),
      );
    }
    if (data.containsKey('r_color_y')) {
      context.handle(
        _r_color_yMeta,
        r_color_y.isAcceptableOrUnknown(data['r_color_y']!, _r_color_yMeta),
      );
    }
    if (data.containsKey('r_color_b')) {
      context.handle(
        _r_color_bMeta,
        r_color_b.isAcceptableOrUnknown(data['r_color_b']!, _r_color_bMeta),
      );
    }
    if (data.containsKey('r_pv')) {
      context.handle(
        _r_pvMeta,
        r_pv.isAcceptableOrUnknown(data['r_pv']!, _r_pvMeta),
      );
    }
    if (data.containsKey('r_m&i')) {
      context.handle(
        _r_m_iMeta,
        r_m_i.isAcceptableOrUnknown(data['r_m&i']!, _r_m_iMeta),
      );
    }
    if (data.containsKey('r_product_tank_no')) {
      context.handle(
        _r_product_tank_noMeta,
        r_product_tank_no.isAcceptableOrUnknown(
          data['r_product_tank_no']!,
          _r_product_tank_noMeta,
        ),
      );
    }
    if (data.containsKey('fp_cat')) {
      context.handle(
        _fp_catMeta,
        fp_cat.isAcceptableOrUnknown(data['fp_cat']!, _fp_catMeta),
      );
    }
    if (data.containsKey('fp_purity')) {
      context.handle(
        _fp_purityMeta,
        fp_purity.isAcceptableOrUnknown(data['fp_purity']!, _fp_purityMeta),
      );
    }
    if (data.containsKey('fp_product_tank_no')) {
      context.handle(
        _fp_product_tank_noMeta,
        fp_product_tank_no.isAcceptableOrUnknown(
          data['fp_product_tank_no']!,
          _fp_product_tank_noMeta,
        ),
      );
    }
    if (data.containsKey('spent_earth_oic')) {
      context.handle(
        _spent_earth_oicMeta,
        spent_earth_oic.isAcceptableOrUnknown(
          data['spent_earth_oic']!,
          _spent_earth_oicMeta,
        ),
      );
    }
    if (data.containsKey('pic')) {
      context.handle(
        _picMeta,
        pic.isAcceptableOrUnknown(data['pic']!, _picMeta),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('checked_by')) {
      context.handle(
        _checked_byMeta,
        checked_by.isAcceptableOrUnknown(data['checked_by']!, _checked_byMeta),
      );
    }
    if (data.containsKey('checked_date')) {
      context.handle(
        _checked_dateMeta,
        checked_date.isAcceptableOrUnknown(
          data['checked_date']!,
          _checked_dateMeta,
        ),
      );
    }
    if (data.containsKey('checked_time')) {
      context.handle(
        _checked_timeMeta,
        checked_time.isAcceptableOrUnknown(
          data['checked_time']!,
          _checked_timeMeta,
        ),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approved_byMeta,
        approved_by.isAcceptableOrUnknown(
          data['approved_by']!,
          _approved_byMeta,
        ),
      );
    }
    if (data.containsKey('approved_date')) {
      context.handle(
        _approved_dateMeta,
        approved_date.isAcceptableOrUnknown(
          data['approved_date']!,
          _approved_dateMeta,
        ),
      );
    }
    if (data.containsKey('approved_time')) {
      context.handle(
        _approved_timeMeta,
        approved_time.isAcceptableOrUnknown(
          data['approved_time']!,
          _approved_timeMeta,
        ),
      );
    }
    if (data.containsKey('flag')) {
      context.handle(
        _flagMeta,
        flag.isAcceptableOrUnknown(data['flag']!, _flagMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('plant')) {
      context.handle(
        _plantMeta,
        plant.isAcceptableOrUnknown(data['plant']!, _plantMeta),
      );
    }
    if (data.containsKey('entry_by')) {
      context.handle(
        _entry_byMeta,
        entry_by.isAcceptableOrUnknown(data['entry_by']!, _entry_byMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TQualityReportRefineryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TQualityReportRefineryData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      report_date: $TQualityReportRefineryTable.$converterreport_date.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}report_date'],
        )!,
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      p_cat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}p_cat'],
      ),
      p_tank_source: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_tank_source'],
      ),
      p_flowrate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_flowrate'],
      ),
      p_ffa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_ffa'],
      ),
      p_iv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_iv'],
      ),
      p_pv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_pv'],
      ),
      p_anv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_anv'],
      ),
      p_dobi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_dobi'],
      ),
      p_carotene: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_carotene'],
      ),
      p_m_i: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_m&i'],
      ),
      p_color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}p_color'],
      ),
      c_cat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}c_cat'],
      ),
      c_pa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}c_pa'],
      ),
      c_be: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}c_be'],
      ),
      b_cat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}b_cat'],
      ),
      b_color_r: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}b_color_r'],
      ),
      b_color_y: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}b_color_y'],
      ),
      b_break_test: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}b_break_test'],
      ),
      r_cat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}r_cat'],
      ),
      r_ffa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}r_ffa'],
      ),
      r_color_r: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}r_color_r'],
      ),
      r_color_y: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}r_color_y'],
      ),
      r_color_b: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}r_color_b'],
      ),
      r_pv: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}r_pv'],
      ),
      r_m_i: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}r_m&i'],
      ),
      r_product_tank_no: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}r_product_tank_no'],
      ),
      fp_cat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fp_cat'],
      ),
      fp_purity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fp_purity'],
      ),
      fp_product_tank_no: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fp_product_tank_no'],
      ),
      spent_earth_oic: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent_earth_oic'],
      ),
      pic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pic'],
      ),
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      checked_by: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checked_by'],
      ),
      checked_date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_date'],
      ),
      checked_time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checked_time'],
      ),
      approved_by: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      approved_date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}approved_date'],
      ),
      approved_time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_time'],
      ),
      flag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag'],
      ),
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      plant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant'],
      ),
      entry_by: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_by'],
      ),
      entry_date: $TQualityReportRefineryTable.$converterentry_date.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entry_date'],
        )!,
      ),
    );
  }

  @override
  $TQualityReportRefineryTable createAlias(String alias) {
    return $TQualityReportRefineryTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterreport_date =
      const DateTimeTextConverter();
  static TypeConverter<DateTime, String> $converterentry_date =
      const DateTimeFullTextConverter();
}

class TQualityReportRefineryData extends DataClass
    implements Insertable<TQualityReportRefineryData> {
  final String id;
  final DateTime report_date;
  final String? time;
  final String? p_cat;
  final double? p_tank_source;
  final double? p_flowrate;
  final double? p_ffa;
  final double? p_iv;
  final double? p_pv;
  final double? p_anv;
  final double? p_dobi;
  final double? p_carotene;
  final double? p_m_i;
  final String? p_color;
  final String? c_cat;
  final double? c_pa;
  final double? c_be;
  final String? b_cat;
  final int? b_color_r;
  final int? b_color_y;
  final String? b_break_test;
  final String? r_cat;
  final double? r_ffa;
  final int? r_color_r;
  final int? r_color_y;
  final int? r_color_b;
  final int? r_pv;
  final int? r_m_i;
  final double? r_product_tank_no;
  final String? fp_cat;
  final double? fp_purity;
  final double? fp_product_tank_no;
  final double? spent_earth_oic;
  final String? pic;
  final String? remarks;
  final String? checked_by;
  final DateTime? checked_date;
  final String? checked_time;
  final String? approved_by;
  final DateTime? approved_date;
  final String? approved_time;
  final String? flag;
  final String? company;
  final String? plant;
  final String? entry_by;
  final DateTime entry_date;
  const TQualityReportRefineryData({
    required this.id,
    required this.report_date,
    this.time,
    this.p_cat,
    this.p_tank_source,
    this.p_flowrate,
    this.p_ffa,
    this.p_iv,
    this.p_pv,
    this.p_anv,
    this.p_dobi,
    this.p_carotene,
    this.p_m_i,
    this.p_color,
    this.c_cat,
    this.c_pa,
    this.c_be,
    this.b_cat,
    this.b_color_r,
    this.b_color_y,
    this.b_break_test,
    this.r_cat,
    this.r_ffa,
    this.r_color_r,
    this.r_color_y,
    this.r_color_b,
    this.r_pv,
    this.r_m_i,
    this.r_product_tank_no,
    this.fp_cat,
    this.fp_purity,
    this.fp_product_tank_no,
    this.spent_earth_oic,
    this.pic,
    this.remarks,
    this.checked_by,
    this.checked_date,
    this.checked_time,
    this.approved_by,
    this.approved_date,
    this.approved_time,
    this.flag,
    this.company,
    this.plant,
    this.entry_by,
    required this.entry_date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['report_date'] = Variable<String>(
        $TQualityReportRefineryTable.$converterreport_date.toSql(report_date),
      );
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    if (!nullToAbsent || p_cat != null) {
      map['p_cat'] = Variable<String>(p_cat);
    }
    if (!nullToAbsent || p_tank_source != null) {
      map['p_tank_source'] = Variable<double>(p_tank_source);
    }
    if (!nullToAbsent || p_flowrate != null) {
      map['p_flowrate'] = Variable<double>(p_flowrate);
    }
    if (!nullToAbsent || p_ffa != null) {
      map['p_ffa'] = Variable<double>(p_ffa);
    }
    if (!nullToAbsent || p_iv != null) {
      map['p_iv'] = Variable<double>(p_iv);
    }
    if (!nullToAbsent || p_pv != null) {
      map['p_pv'] = Variable<double>(p_pv);
    }
    if (!nullToAbsent || p_anv != null) {
      map['p_anv'] = Variable<double>(p_anv);
    }
    if (!nullToAbsent || p_dobi != null) {
      map['p_dobi'] = Variable<double>(p_dobi);
    }
    if (!nullToAbsent || p_carotene != null) {
      map['p_carotene'] = Variable<double>(p_carotene);
    }
    if (!nullToAbsent || p_m_i != null) {
      map['p_m&i'] = Variable<double>(p_m_i);
    }
    if (!nullToAbsent || p_color != null) {
      map['p_color'] = Variable<String>(p_color);
    }
    if (!nullToAbsent || c_cat != null) {
      map['c_cat'] = Variable<String>(c_cat);
    }
    if (!nullToAbsent || c_pa != null) {
      map['c_pa'] = Variable<double>(c_pa);
    }
    if (!nullToAbsent || c_be != null) {
      map['c_be'] = Variable<double>(c_be);
    }
    if (!nullToAbsent || b_cat != null) {
      map['b_cat'] = Variable<String>(b_cat);
    }
    if (!nullToAbsent || b_color_r != null) {
      map['b_color_r'] = Variable<int>(b_color_r);
    }
    if (!nullToAbsent || b_color_y != null) {
      map['b_color_y'] = Variable<int>(b_color_y);
    }
    if (!nullToAbsent || b_break_test != null) {
      map['b_break_test'] = Variable<String>(b_break_test);
    }
    if (!nullToAbsent || r_cat != null) {
      map['r_cat'] = Variable<String>(r_cat);
    }
    if (!nullToAbsent || r_ffa != null) {
      map['r_ffa'] = Variable<double>(r_ffa);
    }
    if (!nullToAbsent || r_color_r != null) {
      map['r_color_r'] = Variable<int>(r_color_r);
    }
    if (!nullToAbsent || r_color_y != null) {
      map['r_color_y'] = Variable<int>(r_color_y);
    }
    if (!nullToAbsent || r_color_b != null) {
      map['r_color_b'] = Variable<int>(r_color_b);
    }
    if (!nullToAbsent || r_pv != null) {
      map['r_pv'] = Variable<int>(r_pv);
    }
    if (!nullToAbsent || r_m_i != null) {
      map['r_m&i'] = Variable<int>(r_m_i);
    }
    if (!nullToAbsent || r_product_tank_no != null) {
      map['r_product_tank_no'] = Variable<double>(r_product_tank_no);
    }
    if (!nullToAbsent || fp_cat != null) {
      map['fp_cat'] = Variable<String>(fp_cat);
    }
    if (!nullToAbsent || fp_purity != null) {
      map['fp_purity'] = Variable<double>(fp_purity);
    }
    if (!nullToAbsent || fp_product_tank_no != null) {
      map['fp_product_tank_no'] = Variable<double>(fp_product_tank_no);
    }
    if (!nullToAbsent || spent_earth_oic != null) {
      map['spent_earth_oic'] = Variable<double>(spent_earth_oic);
    }
    if (!nullToAbsent || pic != null) {
      map['pic'] = Variable<String>(pic);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    if (!nullToAbsent || checked_by != null) {
      map['checked_by'] = Variable<String>(checked_by);
    }
    if (!nullToAbsent || checked_date != null) {
      map['checked_date'] = Variable<DateTime>(checked_date);
    }
    if (!nullToAbsent || checked_time != null) {
      map['checked_time'] = Variable<String>(checked_time);
    }
    if (!nullToAbsent || approved_by != null) {
      map['approved_by'] = Variable<String>(approved_by);
    }
    if (!nullToAbsent || approved_date != null) {
      map['approved_date'] = Variable<DateTime>(approved_date);
    }
    if (!nullToAbsent || approved_time != null) {
      map['approved_time'] = Variable<String>(approved_time);
    }
    if (!nullToAbsent || flag != null) {
      map['flag'] = Variable<String>(flag);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || plant != null) {
      map['plant'] = Variable<String>(plant);
    }
    if (!nullToAbsent || entry_by != null) {
      map['entry_by'] = Variable<String>(entry_by);
    }
    {
      map['entry_date'] = Variable<String>(
        $TQualityReportRefineryTable.$converterentry_date.toSql(entry_date),
      );
    }
    return map;
  }

  TQualityReportRefineryCompanion toCompanion(bool nullToAbsent) {
    return TQualityReportRefineryCompanion(
      id: Value(id),
      report_date: Value(report_date),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      p_cat:
          p_cat == null && nullToAbsent ? const Value.absent() : Value(p_cat),
      p_tank_source:
          p_tank_source == null && nullToAbsent
              ? const Value.absent()
              : Value(p_tank_source),
      p_flowrate:
          p_flowrate == null && nullToAbsent
              ? const Value.absent()
              : Value(p_flowrate),
      p_ffa:
          p_ffa == null && nullToAbsent ? const Value.absent() : Value(p_ffa),
      p_iv: p_iv == null && nullToAbsent ? const Value.absent() : Value(p_iv),
      p_pv: p_pv == null && nullToAbsent ? const Value.absent() : Value(p_pv),
      p_anv:
          p_anv == null && nullToAbsent ? const Value.absent() : Value(p_anv),
      p_dobi:
          p_dobi == null && nullToAbsent ? const Value.absent() : Value(p_dobi),
      p_carotene:
          p_carotene == null && nullToAbsent
              ? const Value.absent()
              : Value(p_carotene),
      p_m_i:
          p_m_i == null && nullToAbsent ? const Value.absent() : Value(p_m_i),
      p_color:
          p_color == null && nullToAbsent
              ? const Value.absent()
              : Value(p_color),
      c_cat:
          c_cat == null && nullToAbsent ? const Value.absent() : Value(c_cat),
      c_pa: c_pa == null && nullToAbsent ? const Value.absent() : Value(c_pa),
      c_be: c_be == null && nullToAbsent ? const Value.absent() : Value(c_be),
      b_cat:
          b_cat == null && nullToAbsent ? const Value.absent() : Value(b_cat),
      b_color_r:
          b_color_r == null && nullToAbsent
              ? const Value.absent()
              : Value(b_color_r),
      b_color_y:
          b_color_y == null && nullToAbsent
              ? const Value.absent()
              : Value(b_color_y),
      b_break_test:
          b_break_test == null && nullToAbsent
              ? const Value.absent()
              : Value(b_break_test),
      r_cat:
          r_cat == null && nullToAbsent ? const Value.absent() : Value(r_cat),
      r_ffa:
          r_ffa == null && nullToAbsent ? const Value.absent() : Value(r_ffa),
      r_color_r:
          r_color_r == null && nullToAbsent
              ? const Value.absent()
              : Value(r_color_r),
      r_color_y:
          r_color_y == null && nullToAbsent
              ? const Value.absent()
              : Value(r_color_y),
      r_color_b:
          r_color_b == null && nullToAbsent
              ? const Value.absent()
              : Value(r_color_b),
      r_pv: r_pv == null && nullToAbsent ? const Value.absent() : Value(r_pv),
      r_m_i:
          r_m_i == null && nullToAbsent ? const Value.absent() : Value(r_m_i),
      r_product_tank_no:
          r_product_tank_no == null && nullToAbsent
              ? const Value.absent()
              : Value(r_product_tank_no),
      fp_cat:
          fp_cat == null && nullToAbsent ? const Value.absent() : Value(fp_cat),
      fp_purity:
          fp_purity == null && nullToAbsent
              ? const Value.absent()
              : Value(fp_purity),
      fp_product_tank_no:
          fp_product_tank_no == null && nullToAbsent
              ? const Value.absent()
              : Value(fp_product_tank_no),
      spent_earth_oic:
          spent_earth_oic == null && nullToAbsent
              ? const Value.absent()
              : Value(spent_earth_oic),
      pic: pic == null && nullToAbsent ? const Value.absent() : Value(pic),
      remarks:
          remarks == null && nullToAbsent
              ? const Value.absent()
              : Value(remarks),
      checked_by:
          checked_by == null && nullToAbsent
              ? const Value.absent()
              : Value(checked_by),
      checked_date:
          checked_date == null && nullToAbsent
              ? const Value.absent()
              : Value(checked_date),
      checked_time:
          checked_time == null && nullToAbsent
              ? const Value.absent()
              : Value(checked_time),
      approved_by:
          approved_by == null && nullToAbsent
              ? const Value.absent()
              : Value(approved_by),
      approved_date:
          approved_date == null && nullToAbsent
              ? const Value.absent()
              : Value(approved_date),
      approved_time:
          approved_time == null && nullToAbsent
              ? const Value.absent()
              : Value(approved_time),
      flag: flag == null && nullToAbsent ? const Value.absent() : Value(flag),
      company:
          company == null && nullToAbsent
              ? const Value.absent()
              : Value(company),
      plant:
          plant == null && nullToAbsent ? const Value.absent() : Value(plant),
      entry_by:
          entry_by == null && nullToAbsent
              ? const Value.absent()
              : Value(entry_by),
      entry_date: Value(entry_date),
    );
  }

  factory TQualityReportRefineryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TQualityReportRefineryData(
      id: serializer.fromJson<String>(json['id']),
      report_date: serializer.fromJson<DateTime>(json['report_date']),
      time: serializer.fromJson<String?>(json['time']),
      p_cat: serializer.fromJson<String?>(json['p_cat']),
      p_tank_source: serializer.fromJson<double?>(json['p_tank_source']),
      p_flowrate: serializer.fromJson<double?>(json['p_flowrate']),
      p_ffa: serializer.fromJson<double?>(json['p_ffa']),
      p_iv: serializer.fromJson<double?>(json['p_iv']),
      p_pv: serializer.fromJson<double?>(json['p_pv']),
      p_anv: serializer.fromJson<double?>(json['p_anv']),
      p_dobi: serializer.fromJson<double?>(json['p_dobi']),
      p_carotene: serializer.fromJson<double?>(json['p_carotene']),
      p_m_i: serializer.fromJson<double?>(json['p_m_i']),
      p_color: serializer.fromJson<String?>(json['p_color']),
      c_cat: serializer.fromJson<String?>(json['c_cat']),
      c_pa: serializer.fromJson<double?>(json['c_pa']),
      c_be: serializer.fromJson<double?>(json['c_be']),
      b_cat: serializer.fromJson<String?>(json['b_cat']),
      b_color_r: serializer.fromJson<int?>(json['b_color_r']),
      b_color_y: serializer.fromJson<int?>(json['b_color_y']),
      b_break_test: serializer.fromJson<String?>(json['b_break_test']),
      r_cat: serializer.fromJson<String?>(json['r_cat']),
      r_ffa: serializer.fromJson<double?>(json['r_ffa']),
      r_color_r: serializer.fromJson<int?>(json['r_color_r']),
      r_color_y: serializer.fromJson<int?>(json['r_color_y']),
      r_color_b: serializer.fromJson<int?>(json['r_color_b']),
      r_pv: serializer.fromJson<int?>(json['r_pv']),
      r_m_i: serializer.fromJson<int?>(json['r_m_i']),
      r_product_tank_no: serializer.fromJson<double?>(
        json['r_product_tank_no'],
      ),
      fp_cat: serializer.fromJson<String?>(json['fp_cat']),
      fp_purity: serializer.fromJson<double?>(json['fp_purity']),
      fp_product_tank_no: serializer.fromJson<double?>(
        json['fp_product_tank_no'],
      ),
      spent_earth_oic: serializer.fromJson<double?>(json['spent_earth_oic']),
      pic: serializer.fromJson<String?>(json['pic']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      checked_by: serializer.fromJson<String?>(json['checked_by']),
      checked_date: serializer.fromJson<DateTime?>(json['checked_date']),
      checked_time: serializer.fromJson<String?>(json['checked_time']),
      approved_by: serializer.fromJson<String?>(json['approved_by']),
      approved_date: serializer.fromJson<DateTime?>(json['approved_date']),
      approved_time: serializer.fromJson<String?>(json['approved_time']),
      flag: serializer.fromJson<String?>(json['flag']),
      company: serializer.fromJson<String?>(json['company']),
      plant: serializer.fromJson<String?>(json['plant']),
      entry_by: serializer.fromJson<String?>(json['entry_by']),
      entry_date: serializer.fromJson<DateTime>(json['entry_date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'report_date': serializer.toJson<DateTime>(report_date),
      'time': serializer.toJson<String?>(time),
      'p_cat': serializer.toJson<String?>(p_cat),
      'p_tank_source': serializer.toJson<double?>(p_tank_source),
      'p_flowrate': serializer.toJson<double?>(p_flowrate),
      'p_ffa': serializer.toJson<double?>(p_ffa),
      'p_iv': serializer.toJson<double?>(p_iv),
      'p_pv': serializer.toJson<double?>(p_pv),
      'p_anv': serializer.toJson<double?>(p_anv),
      'p_dobi': serializer.toJson<double?>(p_dobi),
      'p_carotene': serializer.toJson<double?>(p_carotene),
      'p_m_i': serializer.toJson<double?>(p_m_i),
      'p_color': serializer.toJson<String?>(p_color),
      'c_cat': serializer.toJson<String?>(c_cat),
      'c_pa': serializer.toJson<double?>(c_pa),
      'c_be': serializer.toJson<double?>(c_be),
      'b_cat': serializer.toJson<String?>(b_cat),
      'b_color_r': serializer.toJson<int?>(b_color_r),
      'b_color_y': serializer.toJson<int?>(b_color_y),
      'b_break_test': serializer.toJson<String?>(b_break_test),
      'r_cat': serializer.toJson<String?>(r_cat),
      'r_ffa': serializer.toJson<double?>(r_ffa),
      'r_color_r': serializer.toJson<int?>(r_color_r),
      'r_color_y': serializer.toJson<int?>(r_color_y),
      'r_color_b': serializer.toJson<int?>(r_color_b),
      'r_pv': serializer.toJson<int?>(r_pv),
      'r_m_i': serializer.toJson<int?>(r_m_i),
      'r_product_tank_no': serializer.toJson<double?>(r_product_tank_no),
      'fp_cat': serializer.toJson<String?>(fp_cat),
      'fp_purity': serializer.toJson<double?>(fp_purity),
      'fp_product_tank_no': serializer.toJson<double?>(fp_product_tank_no),
      'spent_earth_oic': serializer.toJson<double?>(spent_earth_oic),
      'pic': serializer.toJson<String?>(pic),
      'remarks': serializer.toJson<String?>(remarks),
      'checked_by': serializer.toJson<String?>(checked_by),
      'checked_date': serializer.toJson<DateTime?>(checked_date),
      'checked_time': serializer.toJson<String?>(checked_time),
      'approved_by': serializer.toJson<String?>(approved_by),
      'approved_date': serializer.toJson<DateTime?>(approved_date),
      'approved_time': serializer.toJson<String?>(approved_time),
      'flag': serializer.toJson<String?>(flag),
      'company': serializer.toJson<String?>(company),
      'plant': serializer.toJson<String?>(plant),
      'entry_by': serializer.toJson<String?>(entry_by),
      'entry_date': serializer.toJson<DateTime>(entry_date),
    };
  }

  TQualityReportRefineryData copyWith({
    String? id,
    DateTime? report_date,
    Value<String?> time = const Value.absent(),
    Value<String?> p_cat = const Value.absent(),
    Value<double?> p_tank_source = const Value.absent(),
    Value<double?> p_flowrate = const Value.absent(),
    Value<double?> p_ffa = const Value.absent(),
    Value<double?> p_iv = const Value.absent(),
    Value<double?> p_pv = const Value.absent(),
    Value<double?> p_anv = const Value.absent(),
    Value<double?> p_dobi = const Value.absent(),
    Value<double?> p_carotene = const Value.absent(),
    Value<double?> p_m_i = const Value.absent(),
    Value<String?> p_color = const Value.absent(),
    Value<String?> c_cat = const Value.absent(),
    Value<double?> c_pa = const Value.absent(),
    Value<double?> c_be = const Value.absent(),
    Value<String?> b_cat = const Value.absent(),
    Value<int?> b_color_r = const Value.absent(),
    Value<int?> b_color_y = const Value.absent(),
    Value<String?> b_break_test = const Value.absent(),
    Value<String?> r_cat = const Value.absent(),
    Value<double?> r_ffa = const Value.absent(),
    Value<int?> r_color_r = const Value.absent(),
    Value<int?> r_color_y = const Value.absent(),
    Value<int?> r_color_b = const Value.absent(),
    Value<int?> r_pv = const Value.absent(),
    Value<int?> r_m_i = const Value.absent(),
    Value<double?> r_product_tank_no = const Value.absent(),
    Value<String?> fp_cat = const Value.absent(),
    Value<double?> fp_purity = const Value.absent(),
    Value<double?> fp_product_tank_no = const Value.absent(),
    Value<double?> spent_earth_oic = const Value.absent(),
    Value<String?> pic = const Value.absent(),
    Value<String?> remarks = const Value.absent(),
    Value<String?> checked_by = const Value.absent(),
    Value<DateTime?> checked_date = const Value.absent(),
    Value<String?> checked_time = const Value.absent(),
    Value<String?> approved_by = const Value.absent(),
    Value<DateTime?> approved_date = const Value.absent(),
    Value<String?> approved_time = const Value.absent(),
    Value<String?> flag = const Value.absent(),
    Value<String?> company = const Value.absent(),
    Value<String?> plant = const Value.absent(),
    Value<String?> entry_by = const Value.absent(),
    DateTime? entry_date,
  }) => TQualityReportRefineryData(
    id: id ?? this.id,
    report_date: report_date ?? this.report_date,
    time: time.present ? time.value : this.time,
    p_cat: p_cat.present ? p_cat.value : this.p_cat,
    p_tank_source:
        p_tank_source.present ? p_tank_source.value : this.p_tank_source,
    p_flowrate: p_flowrate.present ? p_flowrate.value : this.p_flowrate,
    p_ffa: p_ffa.present ? p_ffa.value : this.p_ffa,
    p_iv: p_iv.present ? p_iv.value : this.p_iv,
    p_pv: p_pv.present ? p_pv.value : this.p_pv,
    p_anv: p_anv.present ? p_anv.value : this.p_anv,
    p_dobi: p_dobi.present ? p_dobi.value : this.p_dobi,
    p_carotene: p_carotene.present ? p_carotene.value : this.p_carotene,
    p_m_i: p_m_i.present ? p_m_i.value : this.p_m_i,
    p_color: p_color.present ? p_color.value : this.p_color,
    c_cat: c_cat.present ? c_cat.value : this.c_cat,
    c_pa: c_pa.present ? c_pa.value : this.c_pa,
    c_be: c_be.present ? c_be.value : this.c_be,
    b_cat: b_cat.present ? b_cat.value : this.b_cat,
    b_color_r: b_color_r.present ? b_color_r.value : this.b_color_r,
    b_color_y: b_color_y.present ? b_color_y.value : this.b_color_y,
    b_break_test: b_break_test.present ? b_break_test.value : this.b_break_test,
    r_cat: r_cat.present ? r_cat.value : this.r_cat,
    r_ffa: r_ffa.present ? r_ffa.value : this.r_ffa,
    r_color_r: r_color_r.present ? r_color_r.value : this.r_color_r,
    r_color_y: r_color_y.present ? r_color_y.value : this.r_color_y,
    r_color_b: r_color_b.present ? r_color_b.value : this.r_color_b,
    r_pv: r_pv.present ? r_pv.value : this.r_pv,
    r_m_i: r_m_i.present ? r_m_i.value : this.r_m_i,
    r_product_tank_no:
        r_product_tank_no.present
            ? r_product_tank_no.value
            : this.r_product_tank_no,
    fp_cat: fp_cat.present ? fp_cat.value : this.fp_cat,
    fp_purity: fp_purity.present ? fp_purity.value : this.fp_purity,
    fp_product_tank_no:
        fp_product_tank_no.present
            ? fp_product_tank_no.value
            : this.fp_product_tank_no,
    spent_earth_oic:
        spent_earth_oic.present ? spent_earth_oic.value : this.spent_earth_oic,
    pic: pic.present ? pic.value : this.pic,
    remarks: remarks.present ? remarks.value : this.remarks,
    checked_by: checked_by.present ? checked_by.value : this.checked_by,
    checked_date: checked_date.present ? checked_date.value : this.checked_date,
    checked_time: checked_time.present ? checked_time.value : this.checked_time,
    approved_by: approved_by.present ? approved_by.value : this.approved_by,
    approved_date:
        approved_date.present ? approved_date.value : this.approved_date,
    approved_time:
        approved_time.present ? approved_time.value : this.approved_time,
    flag: flag.present ? flag.value : this.flag,
    company: company.present ? company.value : this.company,
    plant: plant.present ? plant.value : this.plant,
    entry_by: entry_by.present ? entry_by.value : this.entry_by,
    entry_date: entry_date ?? this.entry_date,
  );
  TQualityReportRefineryData copyWithCompanion(
    TQualityReportRefineryCompanion data,
  ) {
    return TQualityReportRefineryData(
      id: data.id.present ? data.id.value : this.id,
      report_date:
          data.report_date.present ? data.report_date.value : this.report_date,
      time: data.time.present ? data.time.value : this.time,
      p_cat: data.p_cat.present ? data.p_cat.value : this.p_cat,
      p_tank_source:
          data.p_tank_source.present
              ? data.p_tank_source.value
              : this.p_tank_source,
      p_flowrate:
          data.p_flowrate.present ? data.p_flowrate.value : this.p_flowrate,
      p_ffa: data.p_ffa.present ? data.p_ffa.value : this.p_ffa,
      p_iv: data.p_iv.present ? data.p_iv.value : this.p_iv,
      p_pv: data.p_pv.present ? data.p_pv.value : this.p_pv,
      p_anv: data.p_anv.present ? data.p_anv.value : this.p_anv,
      p_dobi: data.p_dobi.present ? data.p_dobi.value : this.p_dobi,
      p_carotene:
          data.p_carotene.present ? data.p_carotene.value : this.p_carotene,
      p_m_i: data.p_m_i.present ? data.p_m_i.value : this.p_m_i,
      p_color: data.p_color.present ? data.p_color.value : this.p_color,
      c_cat: data.c_cat.present ? data.c_cat.value : this.c_cat,
      c_pa: data.c_pa.present ? data.c_pa.value : this.c_pa,
      c_be: data.c_be.present ? data.c_be.value : this.c_be,
      b_cat: data.b_cat.present ? data.b_cat.value : this.b_cat,
      b_color_r: data.b_color_r.present ? data.b_color_r.value : this.b_color_r,
      b_color_y: data.b_color_y.present ? data.b_color_y.value : this.b_color_y,
      b_break_test:
          data.b_break_test.present
              ? data.b_break_test.value
              : this.b_break_test,
      r_cat: data.r_cat.present ? data.r_cat.value : this.r_cat,
      r_ffa: data.r_ffa.present ? data.r_ffa.value : this.r_ffa,
      r_color_r: data.r_color_r.present ? data.r_color_r.value : this.r_color_r,
      r_color_y: data.r_color_y.present ? data.r_color_y.value : this.r_color_y,
      r_color_b: data.r_color_b.present ? data.r_color_b.value : this.r_color_b,
      r_pv: data.r_pv.present ? data.r_pv.value : this.r_pv,
      r_m_i: data.r_m_i.present ? data.r_m_i.value : this.r_m_i,
      r_product_tank_no:
          data.r_product_tank_no.present
              ? data.r_product_tank_no.value
              : this.r_product_tank_no,
      fp_cat: data.fp_cat.present ? data.fp_cat.value : this.fp_cat,
      fp_purity: data.fp_purity.present ? data.fp_purity.value : this.fp_purity,
      fp_product_tank_no:
          data.fp_product_tank_no.present
              ? data.fp_product_tank_no.value
              : this.fp_product_tank_no,
      spent_earth_oic:
          data.spent_earth_oic.present
              ? data.spent_earth_oic.value
              : this.spent_earth_oic,
      pic: data.pic.present ? data.pic.value : this.pic,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      checked_by:
          data.checked_by.present ? data.checked_by.value : this.checked_by,
      checked_date:
          data.checked_date.present
              ? data.checked_date.value
              : this.checked_date,
      checked_time:
          data.checked_time.present
              ? data.checked_time.value
              : this.checked_time,
      approved_by:
          data.approved_by.present ? data.approved_by.value : this.approved_by,
      approved_date:
          data.approved_date.present
              ? data.approved_date.value
              : this.approved_date,
      approved_time:
          data.approved_time.present
              ? data.approved_time.value
              : this.approved_time,
      flag: data.flag.present ? data.flag.value : this.flag,
      company: data.company.present ? data.company.value : this.company,
      plant: data.plant.present ? data.plant.value : this.plant,
      entry_by: data.entry_by.present ? data.entry_by.value : this.entry_by,
      entry_date:
          data.entry_date.present ? data.entry_date.value : this.entry_date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TQualityReportRefineryData(')
          ..write('id: $id, ')
          ..write('report_date: $report_date, ')
          ..write('time: $time, ')
          ..write('p_cat: $p_cat, ')
          ..write('p_tank_source: $p_tank_source, ')
          ..write('p_flowrate: $p_flowrate, ')
          ..write('p_ffa: $p_ffa, ')
          ..write('p_iv: $p_iv, ')
          ..write('p_pv: $p_pv, ')
          ..write('p_anv: $p_anv, ')
          ..write('p_dobi: $p_dobi, ')
          ..write('p_carotene: $p_carotene, ')
          ..write('p_m_i: $p_m_i, ')
          ..write('p_color: $p_color, ')
          ..write('c_cat: $c_cat, ')
          ..write('c_pa: $c_pa, ')
          ..write('c_be: $c_be, ')
          ..write('b_cat: $b_cat, ')
          ..write('b_color_r: $b_color_r, ')
          ..write('b_color_y: $b_color_y, ')
          ..write('b_break_test: $b_break_test, ')
          ..write('r_cat: $r_cat, ')
          ..write('r_ffa: $r_ffa, ')
          ..write('r_color_r: $r_color_r, ')
          ..write('r_color_y: $r_color_y, ')
          ..write('r_color_b: $r_color_b, ')
          ..write('r_pv: $r_pv, ')
          ..write('r_m_i: $r_m_i, ')
          ..write('r_product_tank_no: $r_product_tank_no, ')
          ..write('fp_cat: $fp_cat, ')
          ..write('fp_purity: $fp_purity, ')
          ..write('fp_product_tank_no: $fp_product_tank_no, ')
          ..write('spent_earth_oic: $spent_earth_oic, ')
          ..write('pic: $pic, ')
          ..write('remarks: $remarks, ')
          ..write('checked_by: $checked_by, ')
          ..write('checked_date: $checked_date, ')
          ..write('checked_time: $checked_time, ')
          ..write('approved_by: $approved_by, ')
          ..write('approved_date: $approved_date, ')
          ..write('approved_time: $approved_time, ')
          ..write('flag: $flag, ')
          ..write('company: $company, ')
          ..write('plant: $plant, ')
          ..write('entry_by: $entry_by, ')
          ..write('entry_date: $entry_date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    report_date,
    time,
    p_cat,
    p_tank_source,
    p_flowrate,
    p_ffa,
    p_iv,
    p_pv,
    p_anv,
    p_dobi,
    p_carotene,
    p_m_i,
    p_color,
    c_cat,
    c_pa,
    c_be,
    b_cat,
    b_color_r,
    b_color_y,
    b_break_test,
    r_cat,
    r_ffa,
    r_color_r,
    r_color_y,
    r_color_b,
    r_pv,
    r_m_i,
    r_product_tank_no,
    fp_cat,
    fp_purity,
    fp_product_tank_no,
    spent_earth_oic,
    pic,
    remarks,
    checked_by,
    checked_date,
    checked_time,
    approved_by,
    approved_date,
    approved_time,
    flag,
    company,
    plant,
    entry_by,
    entry_date,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TQualityReportRefineryData &&
          other.id == this.id &&
          other.report_date == this.report_date &&
          other.time == this.time &&
          other.p_cat == this.p_cat &&
          other.p_tank_source == this.p_tank_source &&
          other.p_flowrate == this.p_flowrate &&
          other.p_ffa == this.p_ffa &&
          other.p_iv == this.p_iv &&
          other.p_pv == this.p_pv &&
          other.p_anv == this.p_anv &&
          other.p_dobi == this.p_dobi &&
          other.p_carotene == this.p_carotene &&
          other.p_m_i == this.p_m_i &&
          other.p_color == this.p_color &&
          other.c_cat == this.c_cat &&
          other.c_pa == this.c_pa &&
          other.c_be == this.c_be &&
          other.b_cat == this.b_cat &&
          other.b_color_r == this.b_color_r &&
          other.b_color_y == this.b_color_y &&
          other.b_break_test == this.b_break_test &&
          other.r_cat == this.r_cat &&
          other.r_ffa == this.r_ffa &&
          other.r_color_r == this.r_color_r &&
          other.r_color_y == this.r_color_y &&
          other.r_color_b == this.r_color_b &&
          other.r_pv == this.r_pv &&
          other.r_m_i == this.r_m_i &&
          other.r_product_tank_no == this.r_product_tank_no &&
          other.fp_cat == this.fp_cat &&
          other.fp_purity == this.fp_purity &&
          other.fp_product_tank_no == this.fp_product_tank_no &&
          other.spent_earth_oic == this.spent_earth_oic &&
          other.pic == this.pic &&
          other.remarks == this.remarks &&
          other.checked_by == this.checked_by &&
          other.checked_date == this.checked_date &&
          other.checked_time == this.checked_time &&
          other.approved_by == this.approved_by &&
          other.approved_date == this.approved_date &&
          other.approved_time == this.approved_time &&
          other.flag == this.flag &&
          other.company == this.company &&
          other.plant == this.plant &&
          other.entry_by == this.entry_by &&
          other.entry_date == this.entry_date);
}

class TQualityReportRefineryCompanion
    extends UpdateCompanion<TQualityReportRefineryData> {
  final Value<String> id;
  final Value<DateTime> report_date;
  final Value<String?> time;
  final Value<String?> p_cat;
  final Value<double?> p_tank_source;
  final Value<double?> p_flowrate;
  final Value<double?> p_ffa;
  final Value<double?> p_iv;
  final Value<double?> p_pv;
  final Value<double?> p_anv;
  final Value<double?> p_dobi;
  final Value<double?> p_carotene;
  final Value<double?> p_m_i;
  final Value<String?> p_color;
  final Value<String?> c_cat;
  final Value<double?> c_pa;
  final Value<double?> c_be;
  final Value<String?> b_cat;
  final Value<int?> b_color_r;
  final Value<int?> b_color_y;
  final Value<String?> b_break_test;
  final Value<String?> r_cat;
  final Value<double?> r_ffa;
  final Value<int?> r_color_r;
  final Value<int?> r_color_y;
  final Value<int?> r_color_b;
  final Value<int?> r_pv;
  final Value<int?> r_m_i;
  final Value<double?> r_product_tank_no;
  final Value<String?> fp_cat;
  final Value<double?> fp_purity;
  final Value<double?> fp_product_tank_no;
  final Value<double?> spent_earth_oic;
  final Value<String?> pic;
  final Value<String?> remarks;
  final Value<String?> checked_by;
  final Value<DateTime?> checked_date;
  final Value<String?> checked_time;
  final Value<String?> approved_by;
  final Value<DateTime?> approved_date;
  final Value<String?> approved_time;
  final Value<String?> flag;
  final Value<String?> company;
  final Value<String?> plant;
  final Value<String?> entry_by;
  final Value<DateTime> entry_date;
  final Value<int> rowid;
  const TQualityReportRefineryCompanion({
    this.id = const Value.absent(),
    this.report_date = const Value.absent(),
    this.time = const Value.absent(),
    this.p_cat = const Value.absent(),
    this.p_tank_source = const Value.absent(),
    this.p_flowrate = const Value.absent(),
    this.p_ffa = const Value.absent(),
    this.p_iv = const Value.absent(),
    this.p_pv = const Value.absent(),
    this.p_anv = const Value.absent(),
    this.p_dobi = const Value.absent(),
    this.p_carotene = const Value.absent(),
    this.p_m_i = const Value.absent(),
    this.p_color = const Value.absent(),
    this.c_cat = const Value.absent(),
    this.c_pa = const Value.absent(),
    this.c_be = const Value.absent(),
    this.b_cat = const Value.absent(),
    this.b_color_r = const Value.absent(),
    this.b_color_y = const Value.absent(),
    this.b_break_test = const Value.absent(),
    this.r_cat = const Value.absent(),
    this.r_ffa = const Value.absent(),
    this.r_color_r = const Value.absent(),
    this.r_color_y = const Value.absent(),
    this.r_color_b = const Value.absent(),
    this.r_pv = const Value.absent(),
    this.r_m_i = const Value.absent(),
    this.r_product_tank_no = const Value.absent(),
    this.fp_cat = const Value.absent(),
    this.fp_purity = const Value.absent(),
    this.fp_product_tank_no = const Value.absent(),
    this.spent_earth_oic = const Value.absent(),
    this.pic = const Value.absent(),
    this.remarks = const Value.absent(),
    this.checked_by = const Value.absent(),
    this.checked_date = const Value.absent(),
    this.checked_time = const Value.absent(),
    this.approved_by = const Value.absent(),
    this.approved_date = const Value.absent(),
    this.approved_time = const Value.absent(),
    this.flag = const Value.absent(),
    this.company = const Value.absent(),
    this.plant = const Value.absent(),
    this.entry_by = const Value.absent(),
    this.entry_date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TQualityReportRefineryCompanion.insert({
    required String id,
    required DateTime report_date,
    this.time = const Value.absent(),
    this.p_cat = const Value.absent(),
    this.p_tank_source = const Value.absent(),
    this.p_flowrate = const Value.absent(),
    this.p_ffa = const Value.absent(),
    this.p_iv = const Value.absent(),
    this.p_pv = const Value.absent(),
    this.p_anv = const Value.absent(),
    this.p_dobi = const Value.absent(),
    this.p_carotene = const Value.absent(),
    this.p_m_i = const Value.absent(),
    this.p_color = const Value.absent(),
    this.c_cat = const Value.absent(),
    this.c_pa = const Value.absent(),
    this.c_be = const Value.absent(),
    this.b_cat = const Value.absent(),
    this.b_color_r = const Value.absent(),
    this.b_color_y = const Value.absent(),
    this.b_break_test = const Value.absent(),
    this.r_cat = const Value.absent(),
    this.r_ffa = const Value.absent(),
    this.r_color_r = const Value.absent(),
    this.r_color_y = const Value.absent(),
    this.r_color_b = const Value.absent(),
    this.r_pv = const Value.absent(),
    this.r_m_i = const Value.absent(),
    this.r_product_tank_no = const Value.absent(),
    this.fp_cat = const Value.absent(),
    this.fp_purity = const Value.absent(),
    this.fp_product_tank_no = const Value.absent(),
    this.spent_earth_oic = const Value.absent(),
    this.pic = const Value.absent(),
    this.remarks = const Value.absent(),
    this.checked_by = const Value.absent(),
    this.checked_date = const Value.absent(),
    this.checked_time = const Value.absent(),
    this.approved_by = const Value.absent(),
    this.approved_date = const Value.absent(),
    this.approved_time = const Value.absent(),
    this.flag = const Value.absent(),
    this.company = const Value.absent(),
    this.plant = const Value.absent(),
    this.entry_by = const Value.absent(),
    this.entry_date = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       report_date = Value(report_date);
  static Insertable<TQualityReportRefineryData> custom({
    Expression<String>? id,
    Expression<String>? report_date,
    Expression<String>? time,
    Expression<String>? p_cat,
    Expression<double>? p_tank_source,
    Expression<double>? p_flowrate,
    Expression<double>? p_ffa,
    Expression<double>? p_iv,
    Expression<double>? p_pv,
    Expression<double>? p_anv,
    Expression<double>? p_dobi,
    Expression<double>? p_carotene,
    Expression<double>? p_m_i,
    Expression<String>? p_color,
    Expression<String>? c_cat,
    Expression<double>? c_pa,
    Expression<double>? c_be,
    Expression<String>? b_cat,
    Expression<int>? b_color_r,
    Expression<int>? b_color_y,
    Expression<String>? b_break_test,
    Expression<String>? r_cat,
    Expression<double>? r_ffa,
    Expression<int>? r_color_r,
    Expression<int>? r_color_y,
    Expression<int>? r_color_b,
    Expression<int>? r_pv,
    Expression<int>? r_m_i,
    Expression<double>? r_product_tank_no,
    Expression<String>? fp_cat,
    Expression<double>? fp_purity,
    Expression<double>? fp_product_tank_no,
    Expression<double>? spent_earth_oic,
    Expression<String>? pic,
    Expression<String>? remarks,
    Expression<String>? checked_by,
    Expression<DateTime>? checked_date,
    Expression<String>? checked_time,
    Expression<String>? approved_by,
    Expression<DateTime>? approved_date,
    Expression<String>? approved_time,
    Expression<String>? flag,
    Expression<String>? company,
    Expression<String>? plant,
    Expression<String>? entry_by,
    Expression<String>? entry_date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (report_date != null) 'report_date': report_date,
      if (time != null) 'time': time,
      if (p_cat != null) 'p_cat': p_cat,
      if (p_tank_source != null) 'p_tank_source': p_tank_source,
      if (p_flowrate != null) 'p_flowrate': p_flowrate,
      if (p_ffa != null) 'p_ffa': p_ffa,
      if (p_iv != null) 'p_iv': p_iv,
      if (p_pv != null) 'p_pv': p_pv,
      if (p_anv != null) 'p_anv': p_anv,
      if (p_dobi != null) 'p_dobi': p_dobi,
      if (p_carotene != null) 'p_carotene': p_carotene,
      if (p_m_i != null) 'p_m&i': p_m_i,
      if (p_color != null) 'p_color': p_color,
      if (c_cat != null) 'c_cat': c_cat,
      if (c_pa != null) 'c_pa': c_pa,
      if (c_be != null) 'c_be': c_be,
      if (b_cat != null) 'b_cat': b_cat,
      if (b_color_r != null) 'b_color_r': b_color_r,
      if (b_color_y != null) 'b_color_y': b_color_y,
      if (b_break_test != null) 'b_break_test': b_break_test,
      if (r_cat != null) 'r_cat': r_cat,
      if (r_ffa != null) 'r_ffa': r_ffa,
      if (r_color_r != null) 'r_color_r': r_color_r,
      if (r_color_y != null) 'r_color_y': r_color_y,
      if (r_color_b != null) 'r_color_b': r_color_b,
      if (r_pv != null) 'r_pv': r_pv,
      if (r_m_i != null) 'r_m&i': r_m_i,
      if (r_product_tank_no != null) 'r_product_tank_no': r_product_tank_no,
      if (fp_cat != null) 'fp_cat': fp_cat,
      if (fp_purity != null) 'fp_purity': fp_purity,
      if (fp_product_tank_no != null) 'fp_product_tank_no': fp_product_tank_no,
      if (spent_earth_oic != null) 'spent_earth_oic': spent_earth_oic,
      if (pic != null) 'pic': pic,
      if (remarks != null) 'remarks': remarks,
      if (checked_by != null) 'checked_by': checked_by,
      if (checked_date != null) 'checked_date': checked_date,
      if (checked_time != null) 'checked_time': checked_time,
      if (approved_by != null) 'approved_by': approved_by,
      if (approved_date != null) 'approved_date': approved_date,
      if (approved_time != null) 'approved_time': approved_time,
      if (flag != null) 'flag': flag,
      if (company != null) 'company': company,
      if (plant != null) 'plant': plant,
      if (entry_by != null) 'entry_by': entry_by,
      if (entry_date != null) 'entry_date': entry_date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TQualityReportRefineryCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? report_date,
    Value<String?>? time,
    Value<String?>? p_cat,
    Value<double?>? p_tank_source,
    Value<double?>? p_flowrate,
    Value<double?>? p_ffa,
    Value<double?>? p_iv,
    Value<double?>? p_pv,
    Value<double?>? p_anv,
    Value<double?>? p_dobi,
    Value<double?>? p_carotene,
    Value<double?>? p_m_i,
    Value<String?>? p_color,
    Value<String?>? c_cat,
    Value<double?>? c_pa,
    Value<double?>? c_be,
    Value<String?>? b_cat,
    Value<int?>? b_color_r,
    Value<int?>? b_color_y,
    Value<String?>? b_break_test,
    Value<String?>? r_cat,
    Value<double?>? r_ffa,
    Value<int?>? r_color_r,
    Value<int?>? r_color_y,
    Value<int?>? r_color_b,
    Value<int?>? r_pv,
    Value<int?>? r_m_i,
    Value<double?>? r_product_tank_no,
    Value<String?>? fp_cat,
    Value<double?>? fp_purity,
    Value<double?>? fp_product_tank_no,
    Value<double?>? spent_earth_oic,
    Value<String?>? pic,
    Value<String?>? remarks,
    Value<String?>? checked_by,
    Value<DateTime?>? checked_date,
    Value<String?>? checked_time,
    Value<String?>? approved_by,
    Value<DateTime?>? approved_date,
    Value<String?>? approved_time,
    Value<String?>? flag,
    Value<String?>? company,
    Value<String?>? plant,
    Value<String?>? entry_by,
    Value<DateTime>? entry_date,
    Value<int>? rowid,
  }) {
    return TQualityReportRefineryCompanion(
      id: id ?? this.id,
      report_date: report_date ?? this.report_date,
      time: time ?? this.time,
      p_cat: p_cat ?? this.p_cat,
      p_tank_source: p_tank_source ?? this.p_tank_source,
      p_flowrate: p_flowrate ?? this.p_flowrate,
      p_ffa: p_ffa ?? this.p_ffa,
      p_iv: p_iv ?? this.p_iv,
      p_pv: p_pv ?? this.p_pv,
      p_anv: p_anv ?? this.p_anv,
      p_dobi: p_dobi ?? this.p_dobi,
      p_carotene: p_carotene ?? this.p_carotene,
      p_m_i: p_m_i ?? this.p_m_i,
      p_color: p_color ?? this.p_color,
      c_cat: c_cat ?? this.c_cat,
      c_pa: c_pa ?? this.c_pa,
      c_be: c_be ?? this.c_be,
      b_cat: b_cat ?? this.b_cat,
      b_color_r: b_color_r ?? this.b_color_r,
      b_color_y: b_color_y ?? this.b_color_y,
      b_break_test: b_break_test ?? this.b_break_test,
      r_cat: r_cat ?? this.r_cat,
      r_ffa: r_ffa ?? this.r_ffa,
      r_color_r: r_color_r ?? this.r_color_r,
      r_color_y: r_color_y ?? this.r_color_y,
      r_color_b: r_color_b ?? this.r_color_b,
      r_pv: r_pv ?? this.r_pv,
      r_m_i: r_m_i ?? this.r_m_i,
      r_product_tank_no: r_product_tank_no ?? this.r_product_tank_no,
      fp_cat: fp_cat ?? this.fp_cat,
      fp_purity: fp_purity ?? this.fp_purity,
      fp_product_tank_no: fp_product_tank_no ?? this.fp_product_tank_no,
      spent_earth_oic: spent_earth_oic ?? this.spent_earth_oic,
      pic: pic ?? this.pic,
      remarks: remarks ?? this.remarks,
      checked_by: checked_by ?? this.checked_by,
      checked_date: checked_date ?? this.checked_date,
      checked_time: checked_time ?? this.checked_time,
      approved_by: approved_by ?? this.approved_by,
      approved_date: approved_date ?? this.approved_date,
      approved_time: approved_time ?? this.approved_time,
      flag: flag ?? this.flag,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      entry_by: entry_by ?? this.entry_by,
      entry_date: entry_date ?? this.entry_date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (report_date.present) {
      map['report_date'] = Variable<String>(
        $TQualityReportRefineryTable.$converterreport_date.toSql(
          report_date.value,
        ),
      );
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (p_cat.present) {
      map['p_cat'] = Variable<String>(p_cat.value);
    }
    if (p_tank_source.present) {
      map['p_tank_source'] = Variable<double>(p_tank_source.value);
    }
    if (p_flowrate.present) {
      map['p_flowrate'] = Variable<double>(p_flowrate.value);
    }
    if (p_ffa.present) {
      map['p_ffa'] = Variable<double>(p_ffa.value);
    }
    if (p_iv.present) {
      map['p_iv'] = Variable<double>(p_iv.value);
    }
    if (p_pv.present) {
      map['p_pv'] = Variable<double>(p_pv.value);
    }
    if (p_anv.present) {
      map['p_anv'] = Variable<double>(p_anv.value);
    }
    if (p_dobi.present) {
      map['p_dobi'] = Variable<double>(p_dobi.value);
    }
    if (p_carotene.present) {
      map['p_carotene'] = Variable<double>(p_carotene.value);
    }
    if (p_m_i.present) {
      map['p_m&i'] = Variable<double>(p_m_i.value);
    }
    if (p_color.present) {
      map['p_color'] = Variable<String>(p_color.value);
    }
    if (c_cat.present) {
      map['c_cat'] = Variable<String>(c_cat.value);
    }
    if (c_pa.present) {
      map['c_pa'] = Variable<double>(c_pa.value);
    }
    if (c_be.present) {
      map['c_be'] = Variable<double>(c_be.value);
    }
    if (b_cat.present) {
      map['b_cat'] = Variable<String>(b_cat.value);
    }
    if (b_color_r.present) {
      map['b_color_r'] = Variable<int>(b_color_r.value);
    }
    if (b_color_y.present) {
      map['b_color_y'] = Variable<int>(b_color_y.value);
    }
    if (b_break_test.present) {
      map['b_break_test'] = Variable<String>(b_break_test.value);
    }
    if (r_cat.present) {
      map['r_cat'] = Variable<String>(r_cat.value);
    }
    if (r_ffa.present) {
      map['r_ffa'] = Variable<double>(r_ffa.value);
    }
    if (r_color_r.present) {
      map['r_color_r'] = Variable<int>(r_color_r.value);
    }
    if (r_color_y.present) {
      map['r_color_y'] = Variable<int>(r_color_y.value);
    }
    if (r_color_b.present) {
      map['r_color_b'] = Variable<int>(r_color_b.value);
    }
    if (r_pv.present) {
      map['r_pv'] = Variable<int>(r_pv.value);
    }
    if (r_m_i.present) {
      map['r_m&i'] = Variable<int>(r_m_i.value);
    }
    if (r_product_tank_no.present) {
      map['r_product_tank_no'] = Variable<double>(r_product_tank_no.value);
    }
    if (fp_cat.present) {
      map['fp_cat'] = Variable<String>(fp_cat.value);
    }
    if (fp_purity.present) {
      map['fp_purity'] = Variable<double>(fp_purity.value);
    }
    if (fp_product_tank_no.present) {
      map['fp_product_tank_no'] = Variable<double>(fp_product_tank_no.value);
    }
    if (spent_earth_oic.present) {
      map['spent_earth_oic'] = Variable<double>(spent_earth_oic.value);
    }
    if (pic.present) {
      map['pic'] = Variable<String>(pic.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (checked_by.present) {
      map['checked_by'] = Variable<String>(checked_by.value);
    }
    if (checked_date.present) {
      map['checked_date'] = Variable<DateTime>(checked_date.value);
    }
    if (checked_time.present) {
      map['checked_time'] = Variable<String>(checked_time.value);
    }
    if (approved_by.present) {
      map['approved_by'] = Variable<String>(approved_by.value);
    }
    if (approved_date.present) {
      map['approved_date'] = Variable<DateTime>(approved_date.value);
    }
    if (approved_time.present) {
      map['approved_time'] = Variable<String>(approved_time.value);
    }
    if (flag.present) {
      map['flag'] = Variable<String>(flag.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (plant.present) {
      map['plant'] = Variable<String>(plant.value);
    }
    if (entry_by.present) {
      map['entry_by'] = Variable<String>(entry_by.value);
    }
    if (entry_date.present) {
      map['entry_date'] = Variable<String>(
        $TQualityReportRefineryTable.$converterentry_date.toSql(
          entry_date.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TQualityReportRefineryCompanion(')
          ..write('id: $id, ')
          ..write('report_date: $report_date, ')
          ..write('time: $time, ')
          ..write('p_cat: $p_cat, ')
          ..write('p_tank_source: $p_tank_source, ')
          ..write('p_flowrate: $p_flowrate, ')
          ..write('p_ffa: $p_ffa, ')
          ..write('p_iv: $p_iv, ')
          ..write('p_pv: $p_pv, ')
          ..write('p_anv: $p_anv, ')
          ..write('p_dobi: $p_dobi, ')
          ..write('p_carotene: $p_carotene, ')
          ..write('p_m_i: $p_m_i, ')
          ..write('p_color: $p_color, ')
          ..write('c_cat: $c_cat, ')
          ..write('c_pa: $c_pa, ')
          ..write('c_be: $c_be, ')
          ..write('b_cat: $b_cat, ')
          ..write('b_color_r: $b_color_r, ')
          ..write('b_color_y: $b_color_y, ')
          ..write('b_break_test: $b_break_test, ')
          ..write('r_cat: $r_cat, ')
          ..write('r_ffa: $r_ffa, ')
          ..write('r_color_r: $r_color_r, ')
          ..write('r_color_y: $r_color_y, ')
          ..write('r_color_b: $r_color_b, ')
          ..write('r_pv: $r_pv, ')
          ..write('r_m_i: $r_m_i, ')
          ..write('r_product_tank_no: $r_product_tank_no, ')
          ..write('fp_cat: $fp_cat, ')
          ..write('fp_purity: $fp_purity, ')
          ..write('fp_product_tank_no: $fp_product_tank_no, ')
          ..write('spent_earth_oic: $spent_earth_oic, ')
          ..write('pic: $pic, ')
          ..write('remarks: $remarks, ')
          ..write('checked_by: $checked_by, ')
          ..write('checked_date: $checked_date, ')
          ..write('checked_time: $checked_time, ')
          ..write('approved_by: $approved_by, ')
          ..write('approved_date: $approved_date, ')
          ..write('approved_time: $approved_time, ')
          ..write('flag: $flag, ')
          ..write('company: $company, ')
          ..write('plant: $plant, ')
          ..write('entry_by: $entry_by, ')
          ..write('entry_date: $entry_date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MUsersTable mUsers = $MUsersTable(this);
  late final $MBusinessUnitTable mBusinessUnit = $MBusinessUnitTable(this);
  late final $MMastervaluesTable mMastervalues = $MMastervaluesTable(this);
  late final $TQualityReportRefineryTable tQualityReportRefinery =
      $TQualityReportRefineryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    mUsers,
    mBusinessUnit,
    mMastervalues,
    tQualityReportRefinery,
  ];
}

typedef $$MUsersTableCreateCompanionBuilder =
    MUsersCompanion Function({
      required String userid,
      required String username,
      required String password,
      required String role,
      required String isactive,
      Value<int> rowid,
    });
typedef $$MUsersTableUpdateCompanionBuilder =
    MUsersCompanion Function({
      Value<String> userid,
      Value<String> username,
      Value<String> password,
      Value<String> role,
      Value<String> isactive,
      Value<int> rowid,
    });

class $$MUsersTableFilterComposer
    extends Composer<_$AppDatabase, $MUsersTable> {
  $$MUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userid => $composableBuilder(
    column: $table.userid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isactive => $composableBuilder(
    column: $table.isactive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $MUsersTable> {
  $$MUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userid => $composableBuilder(
    column: $table.userid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isactive => $composableBuilder(
    column: $table.isactive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MUsersTable> {
  $$MUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userid =>
      $composableBuilder(column: $table.userid, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get isactive =>
      $composableBuilder(column: $table.isactive, builder: (column) => column);
}

class $$MUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MUsersTable,
          MUser,
          $$MUsersTableFilterComposer,
          $$MUsersTableOrderingComposer,
          $$MUsersTableAnnotationComposer,
          $$MUsersTableCreateCompanionBuilder,
          $$MUsersTableUpdateCompanionBuilder,
          (MUser, BaseReferences<_$AppDatabase, $MUsersTable, MUser>),
          MUser,
          PrefetchHooks Function()
        > {
  $$MUsersTableTableManager(_$AppDatabase db, $MUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userid = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> isactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MUsersCompanion(
                userid: userid,
                username: username,
                password: password,
                role: role,
                isactive: isactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userid,
                required String username,
                required String password,
                required String role,
                required String isactive,
                Value<int> rowid = const Value.absent(),
              }) => MUsersCompanion.insert(
                userid: userid,
                username: username,
                password: password,
                role: role,
                isactive: isactive,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MUsersTable,
      MUser,
      $$MUsersTableFilterComposer,
      $$MUsersTableOrderingComposer,
      $$MUsersTableAnnotationComposer,
      $$MUsersTableCreateCompanionBuilder,
      $$MUsersTableUpdateCompanionBuilder,
      (MUser, BaseReferences<_$AppDatabase, $MUsersTable, MUser>),
      MUser,
      PrefetchHooks Function()
    >;
typedef $$MBusinessUnitTableCreateCompanionBuilder =
    MBusinessUnitCompanion Function({
      required String id,
      required String companyCode,
      required String companyName,
      Value<String?> plantCode,
      Value<String?> plantName,
      required String isactive,
      required String entryBy,
      required DateTime entryDate,
      required String parent,
      Value<int> rowid,
    });
typedef $$MBusinessUnitTableUpdateCompanionBuilder =
    MBusinessUnitCompanion Function({
      Value<String> id,
      Value<String> companyCode,
      Value<String> companyName,
      Value<String?> plantCode,
      Value<String?> plantName,
      Value<String> isactive,
      Value<String> entryBy,
      Value<DateTime> entryDate,
      Value<String> parent,
      Value<int> rowid,
    });

class $$MBusinessUnitTableFilterComposer
    extends Composer<_$AppDatabase, $MBusinessUnitTable> {
  $$MBusinessUnitTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plantCode => $composableBuilder(
    column: $table.plantCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plantName => $composableBuilder(
    column: $table.plantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isactive => $composableBuilder(
    column: $table.isactive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryBy => $composableBuilder(
    column: $table.entryBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get entryDate =>
      $composableBuilder(
        column: $table.entryDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get parent => $composableBuilder(
    column: $table.parent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MBusinessUnitTableOrderingComposer
    extends Composer<_$AppDatabase, $MBusinessUnitTable> {
  $$MBusinessUnitTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plantCode => $composableBuilder(
    column: $table.plantCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plantName => $composableBuilder(
    column: $table.plantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isactive => $composableBuilder(
    column: $table.isactive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryBy => $composableBuilder(
    column: $table.entryBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parent => $composableBuilder(
    column: $table.parent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MBusinessUnitTableAnnotationComposer
    extends Composer<_$AppDatabase, $MBusinessUnitTable> {
  $$MBusinessUnitTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plantCode =>
      $composableBuilder(column: $table.plantCode, builder: (column) => column);

  GeneratedColumn<String> get plantName =>
      $composableBuilder(column: $table.plantName, builder: (column) => column);

  GeneratedColumn<String> get isactive =>
      $composableBuilder(column: $table.isactive, builder: (column) => column);

  GeneratedColumn<String> get entryBy =>
      $composableBuilder(column: $table.entryBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<String> get parent =>
      $composableBuilder(column: $table.parent, builder: (column) => column);
}

class $$MBusinessUnitTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MBusinessUnitTable,
          MBusinessUnitData,
          $$MBusinessUnitTableFilterComposer,
          $$MBusinessUnitTableOrderingComposer,
          $$MBusinessUnitTableAnnotationComposer,
          $$MBusinessUnitTableCreateCompanionBuilder,
          $$MBusinessUnitTableUpdateCompanionBuilder,
          (
            MBusinessUnitData,
            BaseReferences<
              _$AppDatabase,
              $MBusinessUnitTable,
              MBusinessUnitData
            >,
          ),
          MBusinessUnitData,
          PrefetchHooks Function()
        > {
  $$MBusinessUnitTableTableManager(_$AppDatabase db, $MBusinessUnitTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MBusinessUnitTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$MBusinessUnitTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MBusinessUnitTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> companyCode = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String?> plantCode = const Value.absent(),
                Value<String?> plantName = const Value.absent(),
                Value<String> isactive = const Value.absent(),
                Value<String> entryBy = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<String> parent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MBusinessUnitCompanion(
                id: id,
                companyCode: companyCode,
                companyName: companyName,
                plantCode: plantCode,
                plantName: plantName,
                isactive: isactive,
                entryBy: entryBy,
                entryDate: entryDate,
                parent: parent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String companyCode,
                required String companyName,
                Value<String?> plantCode = const Value.absent(),
                Value<String?> plantName = const Value.absent(),
                required String isactive,
                required String entryBy,
                required DateTime entryDate,
                required String parent,
                Value<int> rowid = const Value.absent(),
              }) => MBusinessUnitCompanion.insert(
                id: id,
                companyCode: companyCode,
                companyName: companyName,
                plantCode: plantCode,
                plantName: plantName,
                isactive: isactive,
                entryBy: entryBy,
                entryDate: entryDate,
                parent: parent,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MBusinessUnitTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MBusinessUnitTable,
      MBusinessUnitData,
      $$MBusinessUnitTableFilterComposer,
      $$MBusinessUnitTableOrderingComposer,
      $$MBusinessUnitTableAnnotationComposer,
      $$MBusinessUnitTableCreateCompanionBuilder,
      $$MBusinessUnitTableUpdateCompanionBuilder,
      (
        MBusinessUnitData,
        BaseReferences<_$AppDatabase, $MBusinessUnitTable, MBusinessUnitData>,
      ),
      MBusinessUnitData,
      PrefetchHooks Function()
    >;
typedef $$MMastervaluesTableCreateCompanionBuilder =
    MMastervaluesCompanion Function({
      required String id,
      required String code,
      required String name,
      required String group,
      required int number,
      required String isactive,
      required String entryBy,
      required DateTime entryDate,
      Value<int> rowid,
    });
typedef $$MMastervaluesTableUpdateCompanionBuilder =
    MMastervaluesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String> group,
      Value<int> number,
      Value<String> isactive,
      Value<String> entryBy,
      Value<DateTime> entryDate,
      Value<int> rowid,
    });

class $$MMastervaluesTableFilterComposer
    extends Composer<_$AppDatabase, $MMastervaluesTable> {
  $$MMastervaluesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get group => $composableBuilder(
    column: $table.group,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isactive => $composableBuilder(
    column: $table.isactive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryBy => $composableBuilder(
    column: $table.entryBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get entryDate =>
      $composableBuilder(
        column: $table.entryDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$MMastervaluesTableOrderingComposer
    extends Composer<_$AppDatabase, $MMastervaluesTable> {
  $$MMastervaluesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get group => $composableBuilder(
    column: $table.group,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isactive => $composableBuilder(
    column: $table.isactive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryBy => $composableBuilder(
    column: $table.entryBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MMastervaluesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MMastervaluesTable> {
  $$MMastervaluesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get group =>
      $composableBuilder(column: $table.group, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get isactive =>
      $composableBuilder(column: $table.isactive, builder: (column) => column);

  GeneratedColumn<String> get entryBy =>
      $composableBuilder(column: $table.entryBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);
}

class $$MMastervaluesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MMastervaluesTable,
          MMastervalue,
          $$MMastervaluesTableFilterComposer,
          $$MMastervaluesTableOrderingComposer,
          $$MMastervaluesTableAnnotationComposer,
          $$MMastervaluesTableCreateCompanionBuilder,
          $$MMastervaluesTableUpdateCompanionBuilder,
          (
            MMastervalue,
            BaseReferences<_$AppDatabase, $MMastervaluesTable, MMastervalue>,
          ),
          MMastervalue,
          PrefetchHooks Function()
        > {
  $$MMastervaluesTableTableManager(_$AppDatabase db, $MMastervaluesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MMastervaluesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$MMastervaluesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MMastervaluesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> group = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> isactive = const Value.absent(),
                Value<String> entryBy = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MMastervaluesCompanion(
                id: id,
                code: code,
                name: name,
                group: group,
                number: number,
                isactive: isactive,
                entryBy: entryBy,
                entryDate: entryDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required String group,
                required int number,
                required String isactive,
                required String entryBy,
                required DateTime entryDate,
                Value<int> rowid = const Value.absent(),
              }) => MMastervaluesCompanion.insert(
                id: id,
                code: code,
                name: name,
                group: group,
                number: number,
                isactive: isactive,
                entryBy: entryBy,
                entryDate: entryDate,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MMastervaluesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MMastervaluesTable,
      MMastervalue,
      $$MMastervaluesTableFilterComposer,
      $$MMastervaluesTableOrderingComposer,
      $$MMastervaluesTableAnnotationComposer,
      $$MMastervaluesTableCreateCompanionBuilder,
      $$MMastervaluesTableUpdateCompanionBuilder,
      (
        MMastervalue,
        BaseReferences<_$AppDatabase, $MMastervaluesTable, MMastervalue>,
      ),
      MMastervalue,
      PrefetchHooks Function()
    >;
typedef $$TQualityReportRefineryTableCreateCompanionBuilder =
    TQualityReportRefineryCompanion Function({
      required String id,
      required DateTime report_date,
      Value<String?> time,
      Value<String?> p_cat,
      Value<double?> p_tank_source,
      Value<double?> p_flowrate,
      Value<double?> p_ffa,
      Value<double?> p_iv,
      Value<double?> p_pv,
      Value<double?> p_anv,
      Value<double?> p_dobi,
      Value<double?> p_carotene,
      Value<double?> p_m_i,
      Value<String?> p_color,
      Value<String?> c_cat,
      Value<double?> c_pa,
      Value<double?> c_be,
      Value<String?> b_cat,
      Value<int?> b_color_r,
      Value<int?> b_color_y,
      Value<String?> b_break_test,
      Value<String?> r_cat,
      Value<double?> r_ffa,
      Value<int?> r_color_r,
      Value<int?> r_color_y,
      Value<int?> r_color_b,
      Value<int?> r_pv,
      Value<int?> r_m_i,
      Value<double?> r_product_tank_no,
      Value<String?> fp_cat,
      Value<double?> fp_purity,
      Value<double?> fp_product_tank_no,
      Value<double?> spent_earth_oic,
      Value<String?> pic,
      Value<String?> remarks,
      Value<String?> checked_by,
      Value<DateTime?> checked_date,
      Value<String?> checked_time,
      Value<String?> approved_by,
      Value<DateTime?> approved_date,
      Value<String?> approved_time,
      Value<String?> flag,
      Value<String?> company,
      Value<String?> plant,
      Value<String?> entry_by,
      Value<DateTime> entry_date,
      Value<int> rowid,
    });
typedef $$TQualityReportRefineryTableUpdateCompanionBuilder =
    TQualityReportRefineryCompanion Function({
      Value<String> id,
      Value<DateTime> report_date,
      Value<String?> time,
      Value<String?> p_cat,
      Value<double?> p_tank_source,
      Value<double?> p_flowrate,
      Value<double?> p_ffa,
      Value<double?> p_iv,
      Value<double?> p_pv,
      Value<double?> p_anv,
      Value<double?> p_dobi,
      Value<double?> p_carotene,
      Value<double?> p_m_i,
      Value<String?> p_color,
      Value<String?> c_cat,
      Value<double?> c_pa,
      Value<double?> c_be,
      Value<String?> b_cat,
      Value<int?> b_color_r,
      Value<int?> b_color_y,
      Value<String?> b_break_test,
      Value<String?> r_cat,
      Value<double?> r_ffa,
      Value<int?> r_color_r,
      Value<int?> r_color_y,
      Value<int?> r_color_b,
      Value<int?> r_pv,
      Value<int?> r_m_i,
      Value<double?> r_product_tank_no,
      Value<String?> fp_cat,
      Value<double?> fp_purity,
      Value<double?> fp_product_tank_no,
      Value<double?> spent_earth_oic,
      Value<String?> pic,
      Value<String?> remarks,
      Value<String?> checked_by,
      Value<DateTime?> checked_date,
      Value<String?> checked_time,
      Value<String?> approved_by,
      Value<DateTime?> approved_date,
      Value<String?> approved_time,
      Value<String?> flag,
      Value<String?> company,
      Value<String?> plant,
      Value<String?> entry_by,
      Value<DateTime> entry_date,
      Value<int> rowid,
    });

class $$TQualityReportRefineryTableFilterComposer
    extends Composer<_$AppDatabase, $TQualityReportRefineryTable> {
  $$TQualityReportRefineryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get report_date =>
      $composableBuilder(
        column: $table.report_date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get p_cat => $composableBuilder(
    column: $table.p_cat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_tank_source => $composableBuilder(
    column: $table.p_tank_source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_flowrate => $composableBuilder(
    column: $table.p_flowrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_ffa => $composableBuilder(
    column: $table.p_ffa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_iv => $composableBuilder(
    column: $table.p_iv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_pv => $composableBuilder(
    column: $table.p_pv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_anv => $composableBuilder(
    column: $table.p_anv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_dobi => $composableBuilder(
    column: $table.p_dobi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_carotene => $composableBuilder(
    column: $table.p_carotene,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get p_m_i => $composableBuilder(
    column: $table.p_m_i,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get p_color => $composableBuilder(
    column: $table.p_color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get c_cat => $composableBuilder(
    column: $table.c_cat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get c_pa => $composableBuilder(
    column: $table.c_pa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get c_be => $composableBuilder(
    column: $table.c_be,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get b_cat => $composableBuilder(
    column: $table.b_cat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get b_color_r => $composableBuilder(
    column: $table.b_color_r,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get b_color_y => $composableBuilder(
    column: $table.b_color_y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get b_break_test => $composableBuilder(
    column: $table.b_break_test,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get r_cat => $composableBuilder(
    column: $table.r_cat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get r_ffa => $composableBuilder(
    column: $table.r_ffa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get r_color_r => $composableBuilder(
    column: $table.r_color_r,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get r_color_y => $composableBuilder(
    column: $table.r_color_y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get r_color_b => $composableBuilder(
    column: $table.r_color_b,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get r_pv => $composableBuilder(
    column: $table.r_pv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get r_m_i => $composableBuilder(
    column: $table.r_m_i,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get r_product_tank_no => $composableBuilder(
    column: $table.r_product_tank_no,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fp_cat => $composableBuilder(
    column: $table.fp_cat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fp_purity => $composableBuilder(
    column: $table.fp_purity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fp_product_tank_no => $composableBuilder(
    column: $table.fp_product_tank_no,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spent_earth_oic => $composableBuilder(
    column: $table.spent_earth_oic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pic => $composableBuilder(
    column: $table.pic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checked_by => $composableBuilder(
    column: $table.checked_by,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checked_date => $composableBuilder(
    column: $table.checked_date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checked_time => $composableBuilder(
    column: $table.checked_time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approved_by => $composableBuilder(
    column: $table.approved_by,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get approved_date => $composableBuilder(
    column: $table.approved_date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approved_time => $composableBuilder(
    column: $table.approved_time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plant => $composableBuilder(
    column: $table.plant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entry_by => $composableBuilder(
    column: $table.entry_by,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get entry_date =>
      $composableBuilder(
        column: $table.entry_date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$TQualityReportRefineryTableOrderingComposer
    extends Composer<_$AppDatabase, $TQualityReportRefineryTable> {
  $$TQualityReportRefineryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get report_date => $composableBuilder(
    column: $table.report_date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get p_cat => $composableBuilder(
    column: $table.p_cat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_tank_source => $composableBuilder(
    column: $table.p_tank_source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_flowrate => $composableBuilder(
    column: $table.p_flowrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_ffa => $composableBuilder(
    column: $table.p_ffa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_iv => $composableBuilder(
    column: $table.p_iv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_pv => $composableBuilder(
    column: $table.p_pv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_anv => $composableBuilder(
    column: $table.p_anv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_dobi => $composableBuilder(
    column: $table.p_dobi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_carotene => $composableBuilder(
    column: $table.p_carotene,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get p_m_i => $composableBuilder(
    column: $table.p_m_i,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get p_color => $composableBuilder(
    column: $table.p_color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get c_cat => $composableBuilder(
    column: $table.c_cat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get c_pa => $composableBuilder(
    column: $table.c_pa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get c_be => $composableBuilder(
    column: $table.c_be,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get b_cat => $composableBuilder(
    column: $table.b_cat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get b_color_r => $composableBuilder(
    column: $table.b_color_r,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get b_color_y => $composableBuilder(
    column: $table.b_color_y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get b_break_test => $composableBuilder(
    column: $table.b_break_test,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get r_cat => $composableBuilder(
    column: $table.r_cat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get r_ffa => $composableBuilder(
    column: $table.r_ffa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get r_color_r => $composableBuilder(
    column: $table.r_color_r,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get r_color_y => $composableBuilder(
    column: $table.r_color_y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get r_color_b => $composableBuilder(
    column: $table.r_color_b,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get r_pv => $composableBuilder(
    column: $table.r_pv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get r_m_i => $composableBuilder(
    column: $table.r_m_i,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get r_product_tank_no => $composableBuilder(
    column: $table.r_product_tank_no,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fp_cat => $composableBuilder(
    column: $table.fp_cat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fp_purity => $composableBuilder(
    column: $table.fp_purity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fp_product_tank_no => $composableBuilder(
    column: $table.fp_product_tank_no,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spent_earth_oic => $composableBuilder(
    column: $table.spent_earth_oic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pic => $composableBuilder(
    column: $table.pic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checked_by => $composableBuilder(
    column: $table.checked_by,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checked_date => $composableBuilder(
    column: $table.checked_date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checked_time => $composableBuilder(
    column: $table.checked_time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approved_by => $composableBuilder(
    column: $table.approved_by,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get approved_date => $composableBuilder(
    column: $table.approved_date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approved_time => $composableBuilder(
    column: $table.approved_time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plant => $composableBuilder(
    column: $table.plant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entry_by => $composableBuilder(
    column: $table.entry_by,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entry_date => $composableBuilder(
    column: $table.entry_date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TQualityReportRefineryTableAnnotationComposer
    extends Composer<_$AppDatabase, $TQualityReportRefineryTable> {
  $$TQualityReportRefineryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get report_date =>
      $composableBuilder(
        column: $table.report_date,
        builder: (column) => column,
      );

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get p_cat =>
      $composableBuilder(column: $table.p_cat, builder: (column) => column);

  GeneratedColumn<double> get p_tank_source => $composableBuilder(
    column: $table.p_tank_source,
    builder: (column) => column,
  );

  GeneratedColumn<double> get p_flowrate => $composableBuilder(
    column: $table.p_flowrate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get p_ffa =>
      $composableBuilder(column: $table.p_ffa, builder: (column) => column);

  GeneratedColumn<double> get p_iv =>
      $composableBuilder(column: $table.p_iv, builder: (column) => column);

  GeneratedColumn<double> get p_pv =>
      $composableBuilder(column: $table.p_pv, builder: (column) => column);

  GeneratedColumn<double> get p_anv =>
      $composableBuilder(column: $table.p_anv, builder: (column) => column);

  GeneratedColumn<double> get p_dobi =>
      $composableBuilder(column: $table.p_dobi, builder: (column) => column);

  GeneratedColumn<double> get p_carotene => $composableBuilder(
    column: $table.p_carotene,
    builder: (column) => column,
  );

  GeneratedColumn<double> get p_m_i =>
      $composableBuilder(column: $table.p_m_i, builder: (column) => column);

  GeneratedColumn<String> get p_color =>
      $composableBuilder(column: $table.p_color, builder: (column) => column);

  GeneratedColumn<String> get c_cat =>
      $composableBuilder(column: $table.c_cat, builder: (column) => column);

  GeneratedColumn<double> get c_pa =>
      $composableBuilder(column: $table.c_pa, builder: (column) => column);

  GeneratedColumn<double> get c_be =>
      $composableBuilder(column: $table.c_be, builder: (column) => column);

  GeneratedColumn<String> get b_cat =>
      $composableBuilder(column: $table.b_cat, builder: (column) => column);

  GeneratedColumn<int> get b_color_r =>
      $composableBuilder(column: $table.b_color_r, builder: (column) => column);

  GeneratedColumn<int> get b_color_y =>
      $composableBuilder(column: $table.b_color_y, builder: (column) => column);

  GeneratedColumn<String> get b_break_test => $composableBuilder(
    column: $table.b_break_test,
    builder: (column) => column,
  );

  GeneratedColumn<String> get r_cat =>
      $composableBuilder(column: $table.r_cat, builder: (column) => column);

  GeneratedColumn<double> get r_ffa =>
      $composableBuilder(column: $table.r_ffa, builder: (column) => column);

  GeneratedColumn<int> get r_color_r =>
      $composableBuilder(column: $table.r_color_r, builder: (column) => column);

  GeneratedColumn<int> get r_color_y =>
      $composableBuilder(column: $table.r_color_y, builder: (column) => column);

  GeneratedColumn<int> get r_color_b =>
      $composableBuilder(column: $table.r_color_b, builder: (column) => column);

  GeneratedColumn<int> get r_pv =>
      $composableBuilder(column: $table.r_pv, builder: (column) => column);

  GeneratedColumn<int> get r_m_i =>
      $composableBuilder(column: $table.r_m_i, builder: (column) => column);

  GeneratedColumn<double> get r_product_tank_no => $composableBuilder(
    column: $table.r_product_tank_no,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fp_cat =>
      $composableBuilder(column: $table.fp_cat, builder: (column) => column);

  GeneratedColumn<double> get fp_purity =>
      $composableBuilder(column: $table.fp_purity, builder: (column) => column);

  GeneratedColumn<double> get fp_product_tank_no => $composableBuilder(
    column: $table.fp_product_tank_no,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spent_earth_oic => $composableBuilder(
    column: $table.spent_earth_oic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pic =>
      $composableBuilder(column: $table.pic, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get checked_by => $composableBuilder(
    column: $table.checked_by,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get checked_date => $composableBuilder(
    column: $table.checked_date,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checked_time => $composableBuilder(
    column: $table.checked_time,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approved_by => $composableBuilder(
    column: $table.approved_by,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get approved_date => $composableBuilder(
    column: $table.approved_date,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approved_time => $composableBuilder(
    column: $table.approved_time,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flag =>
      $composableBuilder(column: $table.flag, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get plant =>
      $composableBuilder(column: $table.plant, builder: (column) => column);

  GeneratedColumn<String> get entry_by =>
      $composableBuilder(column: $table.entry_by, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get entry_date =>
      $composableBuilder(
        column: $table.entry_date,
        builder: (column) => column,
      );
}

class $$TQualityReportRefineryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TQualityReportRefineryTable,
          TQualityReportRefineryData,
          $$TQualityReportRefineryTableFilterComposer,
          $$TQualityReportRefineryTableOrderingComposer,
          $$TQualityReportRefineryTableAnnotationComposer,
          $$TQualityReportRefineryTableCreateCompanionBuilder,
          $$TQualityReportRefineryTableUpdateCompanionBuilder,
          (
            TQualityReportRefineryData,
            BaseReferences<
              _$AppDatabase,
              $TQualityReportRefineryTable,
              TQualityReportRefineryData
            >,
          ),
          TQualityReportRefineryData,
          PrefetchHooks Function()
        > {
  $$TQualityReportRefineryTableTableManager(
    _$AppDatabase db,
    $TQualityReportRefineryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TQualityReportRefineryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TQualityReportRefineryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TQualityReportRefineryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> report_date = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String?> p_cat = const Value.absent(),
                Value<double?> p_tank_source = const Value.absent(),
                Value<double?> p_flowrate = const Value.absent(),
                Value<double?> p_ffa = const Value.absent(),
                Value<double?> p_iv = const Value.absent(),
                Value<double?> p_pv = const Value.absent(),
                Value<double?> p_anv = const Value.absent(),
                Value<double?> p_dobi = const Value.absent(),
                Value<double?> p_carotene = const Value.absent(),
                Value<double?> p_m_i = const Value.absent(),
                Value<String?> p_color = const Value.absent(),
                Value<String?> c_cat = const Value.absent(),
                Value<double?> c_pa = const Value.absent(),
                Value<double?> c_be = const Value.absent(),
                Value<String?> b_cat = const Value.absent(),
                Value<int?> b_color_r = const Value.absent(),
                Value<int?> b_color_y = const Value.absent(),
                Value<String?> b_break_test = const Value.absent(),
                Value<String?> r_cat = const Value.absent(),
                Value<double?> r_ffa = const Value.absent(),
                Value<int?> r_color_r = const Value.absent(),
                Value<int?> r_color_y = const Value.absent(),
                Value<int?> r_color_b = const Value.absent(),
                Value<int?> r_pv = const Value.absent(),
                Value<int?> r_m_i = const Value.absent(),
                Value<double?> r_product_tank_no = const Value.absent(),
                Value<String?> fp_cat = const Value.absent(),
                Value<double?> fp_purity = const Value.absent(),
                Value<double?> fp_product_tank_no = const Value.absent(),
                Value<double?> spent_earth_oic = const Value.absent(),
                Value<String?> pic = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String?> checked_by = const Value.absent(),
                Value<DateTime?> checked_date = const Value.absent(),
                Value<String?> checked_time = const Value.absent(),
                Value<String?> approved_by = const Value.absent(),
                Value<DateTime?> approved_date = const Value.absent(),
                Value<String?> approved_time = const Value.absent(),
                Value<String?> flag = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> plant = const Value.absent(),
                Value<String?> entry_by = const Value.absent(),
                Value<DateTime> entry_date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TQualityReportRefineryCompanion(
                id: id,
                report_date: report_date,
                time: time,
                p_cat: p_cat,
                p_tank_source: p_tank_source,
                p_flowrate: p_flowrate,
                p_ffa: p_ffa,
                p_iv: p_iv,
                p_pv: p_pv,
                p_anv: p_anv,
                p_dobi: p_dobi,
                p_carotene: p_carotene,
                p_m_i: p_m_i,
                p_color: p_color,
                c_cat: c_cat,
                c_pa: c_pa,
                c_be: c_be,
                b_cat: b_cat,
                b_color_r: b_color_r,
                b_color_y: b_color_y,
                b_break_test: b_break_test,
                r_cat: r_cat,
                r_ffa: r_ffa,
                r_color_r: r_color_r,
                r_color_y: r_color_y,
                r_color_b: r_color_b,
                r_pv: r_pv,
                r_m_i: r_m_i,
                r_product_tank_no: r_product_tank_no,
                fp_cat: fp_cat,
                fp_purity: fp_purity,
                fp_product_tank_no: fp_product_tank_no,
                spent_earth_oic: spent_earth_oic,
                pic: pic,
                remarks: remarks,
                checked_by: checked_by,
                checked_date: checked_date,
                checked_time: checked_time,
                approved_by: approved_by,
                approved_date: approved_date,
                approved_time: approved_time,
                flag: flag,
                company: company,
                plant: plant,
                entry_by: entry_by,
                entry_date: entry_date,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime report_date,
                Value<String?> time = const Value.absent(),
                Value<String?> p_cat = const Value.absent(),
                Value<double?> p_tank_source = const Value.absent(),
                Value<double?> p_flowrate = const Value.absent(),
                Value<double?> p_ffa = const Value.absent(),
                Value<double?> p_iv = const Value.absent(),
                Value<double?> p_pv = const Value.absent(),
                Value<double?> p_anv = const Value.absent(),
                Value<double?> p_dobi = const Value.absent(),
                Value<double?> p_carotene = const Value.absent(),
                Value<double?> p_m_i = const Value.absent(),
                Value<String?> p_color = const Value.absent(),
                Value<String?> c_cat = const Value.absent(),
                Value<double?> c_pa = const Value.absent(),
                Value<double?> c_be = const Value.absent(),
                Value<String?> b_cat = const Value.absent(),
                Value<int?> b_color_r = const Value.absent(),
                Value<int?> b_color_y = const Value.absent(),
                Value<String?> b_break_test = const Value.absent(),
                Value<String?> r_cat = const Value.absent(),
                Value<double?> r_ffa = const Value.absent(),
                Value<int?> r_color_r = const Value.absent(),
                Value<int?> r_color_y = const Value.absent(),
                Value<int?> r_color_b = const Value.absent(),
                Value<int?> r_pv = const Value.absent(),
                Value<int?> r_m_i = const Value.absent(),
                Value<double?> r_product_tank_no = const Value.absent(),
                Value<String?> fp_cat = const Value.absent(),
                Value<double?> fp_purity = const Value.absent(),
                Value<double?> fp_product_tank_no = const Value.absent(),
                Value<double?> spent_earth_oic = const Value.absent(),
                Value<String?> pic = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String?> checked_by = const Value.absent(),
                Value<DateTime?> checked_date = const Value.absent(),
                Value<String?> checked_time = const Value.absent(),
                Value<String?> approved_by = const Value.absent(),
                Value<DateTime?> approved_date = const Value.absent(),
                Value<String?> approved_time = const Value.absent(),
                Value<String?> flag = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> plant = const Value.absent(),
                Value<String?> entry_by = const Value.absent(),
                Value<DateTime> entry_date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TQualityReportRefineryCompanion.insert(
                id: id,
                report_date: report_date,
                time: time,
                p_cat: p_cat,
                p_tank_source: p_tank_source,
                p_flowrate: p_flowrate,
                p_ffa: p_ffa,
                p_iv: p_iv,
                p_pv: p_pv,
                p_anv: p_anv,
                p_dobi: p_dobi,
                p_carotene: p_carotene,
                p_m_i: p_m_i,
                p_color: p_color,
                c_cat: c_cat,
                c_pa: c_pa,
                c_be: c_be,
                b_cat: b_cat,
                b_color_r: b_color_r,
                b_color_y: b_color_y,
                b_break_test: b_break_test,
                r_cat: r_cat,
                r_ffa: r_ffa,
                r_color_r: r_color_r,
                r_color_y: r_color_y,
                r_color_b: r_color_b,
                r_pv: r_pv,
                r_m_i: r_m_i,
                r_product_tank_no: r_product_tank_no,
                fp_cat: fp_cat,
                fp_purity: fp_purity,
                fp_product_tank_no: fp_product_tank_no,
                spent_earth_oic: spent_earth_oic,
                pic: pic,
                remarks: remarks,
                checked_by: checked_by,
                checked_date: checked_date,
                checked_time: checked_time,
                approved_by: approved_by,
                approved_date: approved_date,
                approved_time: approved_time,
                flag: flag,
                company: company,
                plant: plant,
                entry_by: entry_by,
                entry_date: entry_date,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TQualityReportRefineryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TQualityReportRefineryTable,
      TQualityReportRefineryData,
      $$TQualityReportRefineryTableFilterComposer,
      $$TQualityReportRefineryTableOrderingComposer,
      $$TQualityReportRefineryTableAnnotationComposer,
      $$TQualityReportRefineryTableCreateCompanionBuilder,
      $$TQualityReportRefineryTableUpdateCompanionBuilder,
      (
        TQualityReportRefineryData,
        BaseReferences<
          _$AppDatabase,
          $TQualityReportRefineryTable,
          TQualityReportRefineryData
        >,
      ),
      TQualityReportRefineryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MUsersTableTableManager get mUsers =>
      $$MUsersTableTableManager(_db, _db.mUsers);
  $$MBusinessUnitTableTableManager get mBusinessUnit =>
      $$MBusinessUnitTableTableManager(_db, _db.mBusinessUnit);
  $$MMastervaluesTableTableManager get mMastervalues =>
      $$MMastervaluesTableTableManager(_db, _db.mMastervalues);
  $$TQualityReportRefineryTableTableManager get tQualityReportRefinery =>
      $$TQualityReportRefineryTableTableManager(
        _db,
        _db.tQualityReportRefinery,
      );
}
