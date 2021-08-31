import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/offline/centro_integrador_model.dart';
import 'package:siap/models/offline/localidades_model.dart';
import 'package:siap/models/offline/municipios_model.dart';
import 'package:siap/models/offline/parcela_offline.dart';
import 'package:siap/models/offline/principal_producto_model.dart';
import 'package:siap/models/offline/principales_cultivos_especies_model.dart';
import 'package:siap/models/parcelas/parcelas_model.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  /*TABLA ESTADOS*/
  static const String TABLE_FEDERAL_ENTITY = 'federal_entity';
  static const String CODE_FEDERAL_ENTITY = 'code';
  static const String NAME_FEDERAL_ENTITY = 'name';

  /*TABLA MUNICIPIO*/
  static const String TABLE_MUNICIPALITY = 'municipality';
  static const String CODE_MUNICIPALITY = 'code';
  static const String NAME_MUNICIPALITY = 'name';
  static const String FEDERAL_ENTITY_CODE = 'federal_entity_code';

  /*TABLA LOCALIDADE ( OPCIONAL )*/
  static const String TABLE_LOCATION = 'location';
  static const String CODE_LOCATION = 'code';
  static const String NAME_LOCATION = 'name';
  static const String FEDERAL_ENTITY_LOCATION = 'federal_entity_code';
  static const String MUNICIPALITY_CODE = 'municipality_code';

  /*TABLA SECTOR AGROALIMENTARIO*/

  static const String TABLE_FOOD_INDUSTRY = 'food_industry';
  static const String CODE_FOOD_INDUSTRY = 'code';
  static const String NAME_FOOD_INDUSTRY = 'name';
  static const String ALIAS = 'alias';
  static const String CROP_TYPES_VALIDATE = 'crop_types_validate';

  /* TABLA PRINCIPALES CULTIVOS ESPECIES*/

  static const String TABLE_FOOD_INDUSTRY_ESPECIES = 'food_industry_especies';
  static const String CODE_FOOD_INDUSTRY_ESPECIES = 'code';
  static const String NAME_FOOD_INDUSTRY_ESPECIES = 'name';
  static const String FOOD_INDUSTRY_CODE = 'food_industry_code';

  /* TABLA TIPO DIRECCION*/
  static const String TABLE_TYPE_ADDRESS = 'type_address';
  static const String CODE_TYPE_ADDRESS = 'code';
  static const String NAME_TYPE_ADDRESS = 'name';

  /* TIPO DE ASENTAMIENTO*/
  static const String TABLE_TYPE_SETTELEMENT = 'type_settlement';
  static const String CODE_TYPE_SETELEMENT = 'code';
  static const String NAME_TYPE_SETELEMENT = 'name';

  /* TIPO DE VIALBILIDAD */

  static const String TABLE_TYPE_ROAD = 'type_road';
  static const String CODE_TYPE_ROAD = 'code';
  static const String NAME_TYPE_ROAD = 'name';

  /*TIPO DE GENERO*/

  static const String TABLE_GENDER = 'gender';
  static const String CODE_GENDER = 'code';
  static const String NAME_GENDER = 'name';

  /* ACTIVIDAD ECONOMICA */

  static const String TABLE_ECONOMIC_ACTIVITY = 'economic_activity';
  static const String CODE_ECONOMIC_ACTIVITY = 'code';
  static const String NAME_ECONOMIC_ACTIVITY = 'name';

  /* REGIMEN HIDRICO*/

  static const String TABLE_WATER_REGIME = 'water_regime';
  static const String CODE_WATER_REGIME = 'code';
  static const String NAME_WATER_REGIME = 'name';

  /* TABLE DISCAPICADES */

  static const String TABLE_DISABILITY = 'disability';
  static const String CODE_DISABILITY = 'code';
  static const String NAME_DISABILITY = 'name';

  /*TABLA REGIMEN PROPIEDAD*/
  static const String TABLE_PROPERTY_REGIME = 'property_regime';
  static const String CODE_PROPERTY_REGIME = 'code';
  static const String NAME_PROPERTY_REGIME = 'name';

  /* TABLA TIPO TELEFONO */

  static const String TABLE_TYPE_PHONE = 'type_phone';
  static const String CODE_TYPE_PHONE = 'code';
  static const String NAME_TYPE_PHONE = 'name';

  /* TABLA TIPO TELEFONO */

  static const String TABLE_TYPE_CROPS = 'type_crops';
  static const String CODE_TYPE_CROPS = 'code';
  static const String NAME_TYPE_CROPS = 'name';

  /* TABLA CENTRO INTEGRADPOR*/
  static const String TABLE_INTEGRATION_CENTER = 'integration_center';
  static const String CODE_INTEGRATION_CENTER = 'code';
  static const String NAME_INTEGRATION_CENTER = 'name';
  static const String FEDERAL_ENTITY_CODE_CENTER = 'federal_entity_code';
  static const String MUNICIPALITY_CODE_INTEGRATION = 'municipality_code';

  /*TABLA NACIONALIDADES */

  static const String TABLE_NACIONALITY = 'nacionality';
  static const String CODE_NACIONALITY = 'code';
  static const String NAME_NACIONALITY = 'name';

  /*type-identification*/
  static const String TABLE_TYPE_IDENTIFICATION = 'type_identification';
  static const String CODE_TYPE_IDENTIFICATION = 'code';
  static const String NAME_TYPE_IDENTIFICATION = 'name';

  /*marital-status*/
  static const String TABLE_MARITAL_STATUS = 'marital_status';
  static const String CODE_MARITAL = 'code';
  static const String NAME_MARITAL = 'name';

  /*Principal Product*/
  static const String TABLE_PRINCIPAL_PRODUCT = 'principal_product';
  static const String CODE_PRINCIPAL_PRODUCTO = 'code';
  static const String NAME_PRINCIPAL_PRODUCTO = 'name';
  static const String CAT_CROPS_CODE = 'cat_crops_code';
  static const String FOOD_INDUSTRY_PRINCIPAL = 'food_industry_id';
  /*peasant-association*/
  static const String TABLE_PEASANT_ASSOCIATION = 'peasant_association';
  static const String CODE_PEASANT_ASSOCIATION = 'code';
  static const String NAME_PEASANT_ASSOCIATION = 'name';
  /*education-level*/
  static const String TABLE_EDUCATION_LEVEL = 'education_level';
  static const String CODE_EDUCATION = 'code';
  static const String NAME_EDUCATION = 'name';
  /* indigenous-language */
  static const String TABLE_INDIGENOUS_LANGUAJE = 'indigenous_language';
  static const String CODE_INDIGENOUS_LANGUAJE = 'code';
  static const String NAME_INDIGENOUS_LANGUAJE = 'name';
  /*  ethnic-group */
  static const String TABLE_ETHNIC_GROUP = 'ethnic_group';
  static const String CODE_ETHNIC_GROUP = 'code';
  static const String NAME_ETHNIC_GROUP = 'name';
  /*Tabla Sincronizacion */
  static const String TABLE_SYNC = 'sync';
  /*Parcela*/
  static const String TABLE_PARCELA = 'parcela';
  static const String PARCELA_INDEX = 'id_auto';
  static const String PARCELA_USER_ID = 'id';
  static const String PARCELA_ITEM = 'item';
  static const String PARCELA_CATEGORY_ID = 'category_id';
  static const String PARCELA_PLOT_ID = 'plots_id';
  //TYPE_HONEY
  static const String TABLE_TYPE_HONEY_PRODUCER = 'type_honey_producer';
  static const String TYPE_HONEY_PRODUCER_CODE = 'id_auto';
  static const String TYPE_HONEY_PRODUCER_NAME = 'name';
  /*Nombre Base de datos SQ FLITE*/
  static const String DB_NAME = 'catalogues.db';
  DBProvider._();

  
  
  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print("Path " + documentsDirectory.path);
    final path = join(documentsDirectory.path, DB_NAME);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $TABLE_FEDERAL_ENTITY ($CODE_FEDERAL_ENTITY TEXT, $NAME_FEDERAL_ENTITY TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_MUNICIPALITY ($CODE_MUNICIPALITY TEXT, $NAME_MUNICIPALITY TEXT, $FEDERAL_ENTITY_CODE TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_LOCATION ($CODE_LOCATION TEXT, $NAME_LOCATION TEXT, $FEDERAL_ENTITY_LOCATION TEXT , $MUNICIPALITY_CODE TEXT )");
      await db.execute(
          "CREATE TABLE $TABLE_FOOD_INDUSTRY ($CODE_FOOD_INDUSTRY INTEGER PRIMARY KEY, $NAME_FOOD_INDUSTRY TEXT,$ALIAS TEXT, $CROP_TYPES_VALIDATE INTEGER)");
      await db.execute(
          "CREATE TABLE $TABLE_FOOD_INDUSTRY_ESPECIES ($CODE_FOOD_INDUSTRY_ESPECIES TEXT, $NAME_FOOD_INDUSTRY_ESPECIES TEXT,$FOOD_INDUSTRY_CODE INTEGER)");
      await db.execute(
          "CREATE TABLE $TABLE_TYPE_ADDRESS ($CODE_TYPE_ADDRESS TEXT, $NAME_TYPE_ADDRESS TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_TYPE_SETTELEMENT ($CODE_TYPE_SETELEMENT INTEGER PRIMARY KEY, $NAME_TYPE_SETELEMENT TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_TYPE_ROAD ($CODE_TYPE_ROAD INTEGER PRIMARY KEY, $NAME_TYPE_ROAD TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_GENDER ($CODE_GENDER INTEGER PRIMARY KEY, $NAME_GENDER TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_ECONOMIC_ACTIVITY ($CODE_ECONOMIC_ACTIVITY INTEGER PRIMARY KEY, $NAME_ECONOMIC_ACTIVITY TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_WATER_REGIME ($CODE_WATER_REGIME INTEGER PRIMARY KEY, $NAME_WATER_REGIME TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_DISABILITY ($CODE_DISABILITY TEXT, $NAME_DISABILITY TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_PROPERTY_REGIME ($CODE_PROPERTY_REGIME INTEGER PRIMARY KEY, $NAME_PROPERTY_REGIME  TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_TYPE_PHONE ($CODE_TYPE_PHONE INTEGER PRIMARY KEY, $NAME_TYPE_PHONE  TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_INTEGRATION_CENTER ($CODE_INTEGRATION_CENTER TEXT, $NAME_INTEGRATION_CENTER   TEXT,$FEDERAL_ENTITY_CODE_CENTER TEXT, $MUNICIPALITY_CODE_INTEGRATION TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_NACIONALITY ($CODE_NACIONALITY TEXT, $NAME_NACIONALITY TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_TYPE_CROPS ( $CODE_TYPE_CROPS INTEGER, $NAME_TYPE_CROPS  TEXT)");
      await db.execute(
          "CREATE TABLE $TABLE_TYPE_IDENTIFICATION ($CODE_TYPE_IDENTIFICATION INTEGER, $NAME_TYPE_IDENTIFICATION TEXT )");
      await db.execute(
          "CREATE TABLE $TABLE_MARITAL_STATUS ( $CODE_MARITAL INTEGER , $NAME_MARITAL TEXT )");
      await db.execute(
          " CREATE TABLE $TABLE_PRINCIPAL_PRODUCT ($CODE_PRINCIPAL_PRODUCTO TEXT , $NAME_PRINCIPAL_PRODUCTO TEXT,$CAT_CROPS_CODE TEXT, $FOOD_INDUSTRY_PRINCIPAL INTEGER )");
      await db.execute(
          " CREATE TABLE $TABLE_PEASANT_ASSOCIATION ( $CODE_PEASANT_ASSOCIATION TEXT, $NAME_PEASANT_ASSOCIATION TEXT)");
      await db.execute(
          " CREATE TABLE $TABLE_EDUCATION_LEVEL ($CODE_EDUCATION TEXT, $NAME_EDUCATION TEXT  )");
      await db.execute(
          " CREATE TABLE $TABLE_INDIGENOUS_LANGUAJE ( $CODE_INDIGENOUS_LANGUAJE TEXT, $NAME_INDIGENOUS_LANGUAJE TEXT)");
      await db.execute(
          " CREATE TABLE $TABLE_ETHNIC_GROUP ( $CODE_ETHNIC_GROUP TEXT, $NAME_ETHNIC_GROUP TEXT )");
      await db.execute("CREATE TABLE $TABLE_SYNC ( " +
          "id INTEGER, validacion INTEGER, comentario TEXT, tipoPersona INTEGER, rfc TEXT, email TEXT, sectorAgroalimentario INTEGER, principalesCultivos TEXT, tipoDeCultivo INTEGER,superficie TEXT,volumenProduccion TEXT,valorDeLaProduccion TEXT, precioCultivo TEXT, regimenHidrico INTEGER, tipoTel INTEGER," +
          "noTel TEXT, comprobanteDeDomicilio TEXT, tipoDireccion INTEGER, tipoVialidad INTEGER,cp TEXT,nombreVialidad TEXT,noExterior TEXT, noInterior TEXT, tipoAsentamiento INTEGER, nombreAsentamiento TEXT,entidadFederativa TEXT,municipio TEXT, localidad TEXT, centroIntegrador TEXT, ubicacionGeografica TEXT," +
          "curp TEXT, sexo INTEGER, nombre TEXT, apmaterno TEXT, appaterno TEXT,estadoCivil INTEGER,nacionalidad TEXT,fechaDeNacimiento TEXT,tipoAsociacion TEXT,regimenPropiedad INTEGER, identificacionOficialVigente INTEGER,folioIdentificacion TEXT,cuentaConDiscapacidad TEXT,tipoDiscapacidad INTEGER, declaratoriaIndigena TEXT,dialecto TEXT,credencialDeElector TEXT,tipoDePropiedad TEXT, certificadosParcelarios TEXT, " +
          "razonSocial TEXT, fechaConstitucion TEXT, noRegistroInstrumentoConstitucion TEXT,noNotario TEXT, ultimaActualizacionActaConstitutiva TEXT, representanteLegal TEXT, noIdentificacionRepresentanteLegal TEXT, totalSociosFisicos INTEGER, noSociosMorales INTEGER,actividadEconomica INTEGER,grupoPersonasMorales TEXT,rfcVigente TEXT, actaConstitutiva TEXT )");
      await db.execute(
          "CREATE TABLE $TABLE_PARCELA ($PARCELA_INDEX INTEGER PRIMARY KEY AUTOINCREMENT, $PARCELA_USER_ID INTEGER, $PARCELA_ITEM TEXT, $PARCELA_CATEGORY_ID INTEGER ,$PARCELA_PLOT_ID INTEGER )");
      await db.execute(
          "CREATE TABLE $TABLE_TYPE_HONEY_PRODUCER ($TYPE_HONEY_PRODUCER_CODE TEXT, $TYPE_HONEY_PRODUCER_NAME TEXT )");
      // await db.execute("CREATE UNIQUE INDEX idx_parcela_id ON $TABLE_PARCELA( $PARCELA_ID)");
    });
  }
  Future<Database> get database async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "catalogues.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "catalogues.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    return await openDatabase(path, readOnly: false);
  }
  Future<UserModel> addPadron(UserModel user) async {
    final db = await database;

    final array = [];
    /*for(var i = 0; i < user.certificadosParcelarios.length; i++){
        array.add(user.certificadosParcelarios[i].toJson());

      }*/
    print("INE");
    /* print(user.credencialDeElector);
      var row = {
        'id'  : user.id,
        'tipoPersona':1,
        'curp':user.curp,
        'rfc':user.rfc,
        'sexo':user.sexo,
        'nombre':user.nombre,
        'appaterno':user.appaterno,
        'apmaterno':user.apmaterno,
        'estadoCivil':user.estadoCivil,
        'nacionalidad':user.nacionalidad,
        'fechaDeNacimiento':user.fechaDeNacimiento,
        'email':user.email,
        'tipoTel':user.tipoTel,
        'noTel':user.noTel,
        'sectorAgroalimentario':user.sectorAgroalimentario,
        'principalesCultivos':user.principalesCultivos,
        'tipoDeCultivo':user.tipoDeCultivo,
        'regimenHidrico':user.regimenHidrico,
        'regimenPropiedad':user.regimenPropiedad,
        'tipoAsociacion':user.tipoAsociacion,
        'identificacionOficialVigente':user.identificacionOficialVigente,
        'folioIdentificacion':user.folioIdentificacion,
        'cuentaConDiscapacidad':user.cuentaConDiscapacidad,
        'tipoDiscapacidad':user.tipoDiscapacidad,
        'declaratoriaIndigena':user.declaratoriaIndigena,
        'dialecto':user.dialecto,
        'tipoDireccion':user.tipoDireccion,
        'tipoVialidad':user.tipoVialidad,
        'cp':user.cp,
        'nombreVialidad':user.nombreVialidad,
        'noExterior':user.noExterior,
        'noInterior':user.noInterior,
        'tipoAsentamiento':user.tipoAsentamiento,
        'nombreAsentamiento':user.nombreAsentamiento,
        'entidadFederativa':user.entidadFederativa,
        'municipio':user.municipio,
        'localidad':user.localidad,
        'centroIntegrador':user.centroIntegrador,
        'ubicacionGeografica':user.ubicacionGeografica,
        'credencialDeElector':user.credencialDeElector,
        'comprobanteDeDomicilio':user.comprobanteDeDomicilio,
        'tipoDePropiedad':user.tipoDePropiedad,
        'certificadosParcelarios' : array.toString()
      };*/
    final response = await db.insert(TABLE_SYNC, {});
    return user;
  }

//INSERT PARCELA
  saveParcela(
      {@required int userId,
      @required String item,
      @required int categoryId,
      @required int plotId}) async {
    final db = await database;
    print("aqui ? ");
    
    return await db.rawQuery(
        "INSERT  INTO $TABLE_PARCELA ($PARCELA_USER_ID,$PARCELA_ITEM,$PARCELA_CATEGORY_ID, $PARCELA_PLOT_ID) VALUES ($userId,'$item',$categoryId, $plotId )");
  }
  setUpdateParcela( {@required int userIdTemp, @required int userId} )async{
    final db = await database;
    List<ParcelaOffline> list ;
    print('update ');
    final files = await db.rawQuery("SELECT * FROM $TABLE_PARCELA");
    list = files.isNotEmpty
        ? files.map((c) => ParcelaOffline.fromJson(c)).toList()
        : [];
        
    return list.forEach((f)async{
      print("update sql");
        await db.rawUpdate("UPDATE $TABLE_PARCELA SET $PARCELA_USER_ID = ? WHERE $PARCELA_USER_ID = ? ", [userId,userIdTemp]);  
          });
    
  }
  getSizeParcela() async {
    final db = await database;
    print("aqui 4 ?");
    List<ParcelaOffline> list;
    final existData = await db.rawQuery("SELECT * FROM $TABLE_PARCELA");
    list = existData.isNotEmpty
        ? existData.map((c) => ParcelaOffline.fromJson(c)).toList()
        : [];
        return list.length;
  }
  Future<List<ParcelaOffline>> getAllParcela({@required int userId}) async {
    final db = await database;
    print("aqui 3 ?");
    List<ParcelaOffline> list;
    final existData = await db.rawQuery("SELECT * FROM $TABLE_PARCELA");
    if (existData.isNotEmpty) {
      final res = await db.rawQuery("SELECT * FROM $TABLE_PARCELA WHERE $PARCELA_USER_ID = $userId ");

      list = res.isNotEmpty
        ? res.map((c) => ParcelaOffline.fromJson(c)).toList()
        : [];
    }else if(existData.isEmpty){
      list = [];
    }
    
    
    return list;
  }
   Future<void> deleteParcelasAll({  @required List<ParcelaOffline> list, @required int idUser} )async {
     final db = await database;
     return list.forEach((f)async{
       
        await db.delete(TABLE_PARCELA,where: '$PARCELA_USER_ID = ?', whereArgs: [idUser] );
     });
   }
  Future<int> deleteParcelaByIndex({@required int index}) async {
    final db = await database;
    print("aqui ?");
    final res = await db
        .rawDelete('DELETE FROM $TABLE_PARCELA WHERE $PARCELA_INDEX = $index ');
    return res;
  }
  Future<int> deleteParcelaByCategory({@required int categoryId}) async {
    final db = await database;
    //print("aqui ?");
    final res = await db
        .rawDelete('DELETE FROM $TABLE_PARCELA WHERE $PARCELA_PLOT_ID = $categoryId ');
    return res;
  }
  // Insert Federal Entity on database
  saveFederalEntity(List<GenericData> newData) async {
    await deleteAllFederalEntity();

    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_FEDERAL_ENTITY, f.toJson());
    });
  }

  Future<int> deleteAllFederalEntity() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_FEDERAL_ENTITY);
    return res;
  }

  Future<List<GenericData<String>>> getAllFederalEntity() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_FEDERAL_ENTITY);
    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }
   Future<int> deleteTypeProducerHoney() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_TYPE_HONEY_PRODUCER);
    return res;
  }
  //TYPE HONEY
   Future<List<GenericData<String>>> getTypeProducerHoney() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_TYPE_HONEY_PRODUCER);
    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // Insert Municipality on database
  saveMunicipality(List<Municipio> newData) async {
    await deleteAllMunicipality();
    final db = await database;
    Batch batch = db.batch();
    newData.forEach((f) async {
      batch.insert(TABLE_MUNICIPALITY, f.toJson());
    });
    return await batch.commit(noResult: true);
  }

  Future<int> deleteAllMunicipality() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_MUNICIPALITY);
    return res;
  }

  Future<List<GenericData>> getAllMunicipality() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_MUNICIPALITY);

    List<GenericData> list =
        res.isNotEmpty ? res.map((c) => GenericData.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<GenericData<String>>> getAllMunicipalityByCode(
      {@required String codigoEstado}) async {
    final db = await database;

    final res = await db.rawQuery("SELECT * FROM " +
        TABLE_MUNICIPALITY +
        " WHERE federal_entity_code = " +
        "'" +
        codigoEstado +
        "'");

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // Insert Localidades
  saveLocation(List<Localidad> newData) async {
    final db = await database;
    await deleteAllLocation();
    Batch batch = db.batch();
    newData.forEach((f) async {
      await batch.insert(TABLE_LOCATION, f.toJson());
    });
    return await batch.commit(noResult: true);
  }

  saveLocation2(List<Localidad> newData) async {
    final db = await database;
    Batch batch = db.batch();
    newData.forEach((f) async {
      await batch.insert(TABLE_LOCATION, f.toJson());
    });
    return await batch.commit(noResult: true);
  }

  Future deleteAllLocation() async {
    final db = await database;
    Batch batch = db.batch();
    final res = await batch.rawDelete('DELETE FROM ' + TABLE_LOCATION);
    return await batch.commit(noResult: true);
  }

  Future deleteAllLocationByCode(
      code, federal_entity_code, municipality_code) async {
    final db = await database;
    Batch batch = db.batch();
    await batch.rawDelete(
        "DELETE FROM $TABLE_LOCATION WHERE $CODE_LOCATION = '$code' AND $FEDERAL_ENTITY_LOCATION = '$federal_entity_code' AND $MUNICIPALITY_CODE =  '$municipality_code' ");
    return await batch.commit(noResult: true);
  }

  Future<List<GenericData<String>>> getAllLocationByCode(
      {@required String codigoEstado, @required String codigoMunicipio}) async {
    final db = await database;
    final res = await db.rawQuery(
        " SELECT * FROM $TABLE_LOCATION WHERE $FEDERAL_ENTITY_LOCATION = '$codigoEstado' AND $MUNICIPALITY_CODE = '$codigoMunicipio' ");
    print(
        " SELECT * FROM $TABLE_LOCATION WHERE $FEDERAL_ENTITY_LOCATION = '$codigoEstado' AND $MUNICIPALITY_CODE = '$codigoMunicipio' ");
    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // Insert sector agroalimentario
  saveFoodIndustry(List<GenericData> newData) async {
    await deleteAllFoodIndustry();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_FOOD_INDUSTRY, f.toJson());
    });
  }

  Future<int> deleteAllFoodIndustry() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_FOOD_INDUSTRY);
    return res;
  }

  Future<List<GenericData>> getAllFoodIndustry() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_FOOD_INDUSTRY);

    List<GenericData> list =
        res.isNotEmpty ? res.map((c) => GenericData.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<SectorAgroalimentario>> getFoodIndustry() async {
    SharedPreferences shared_User = await SharedPreferences.getInstance();
    final userMap = jsonDecode(shared_User.getString('sectorAgroalimentario'));
    return SectorAgroalimentarioModel.fromJson(userMap)
        .sectoresAgroalimentarios;
  }

  // Insert Principales Cultivos especies
  saveFoodIndustryEspecies(List<PrincipalCultivoEspecie> newData) async {
    await deleteAllFoodIndustryEspecies();
    final db = await database;

    return newData.forEach((f) async {
      await db.insert(TABLE_FOOD_INDUSTRY_ESPECIES, f.toJson());
    });
  }

  Future<int> deleteAllFoodIndustryEspecies() async {
    final db = await database;
    final res =
        await db.rawDelete('DELETE FROM ' + TABLE_FOOD_INDUSTRY_ESPECIES);
    return res;
  }

  Future<List<GenericData>> getAllFoodIndustryEspecies() async {
    final db = await database;
    final res =
        await db.rawQuery("SELECT * FROM " + TABLE_FOOD_INDUSTRY_ESPECIES);

    List<GenericData> list =
        res.isNotEmpty ? res.map((c) => GenericData.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<GenericData<String>>> getAllFoodIndustryEspeciesByCode(
      {@required int codigoSectorAgroalimentario}) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " +
        TABLE_FOOD_INDUSTRY_ESPECIES +
        " WHERE food_industry_code = $codigoSectorAgroalimentario ");

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // Insert Type Address
  saveTypeAddress(List<GenericData> newData) async {
    await deleteAllTypeAddres();
    final db = await database;

    return newData.forEach((f) async {
      await db.insert(TABLE_TYPE_ADDRESS, f.toJson());
    });
  }

  Future<int> deleteAllTypeAddres() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_TYPE_ADDRESS);
    return res;
  }

  Future<List<GenericData<String>>> getAllTypeAddress() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_TYPE_ADDRESS);

    List<GenericData> list =
        res.isNotEmpty ? res.map((c) => GenericData.fromJson(c)).toList() : [];

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
    ;
  }

  // Insert Tipo de asentamiento
  saveTypeSettElement(List<GenericData> newData) async {
    await deleteAllTypeElement();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_TYPE_SETTELEMENT, f.toJson());
    });
  }

  Future<int> deleteAllTypeElement() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_TYPE_SETTELEMENT);
    return res;
  }

  Future<List<GenericData<int>>> getAllSetElement() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_TYPE_SETTELEMENT);

    //List<GenericData> list = res.isNotEmpty ? res.map((c) => GenericData.fromJson(c)).toList() : [];

    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // Insert Tipo de Viabilidad
  saveTypeRoad(List<GenericData> newData) async {
    await deleteAllTypeRoad();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_TYPE_ROAD, f.toJson());
    });
  }

  Future<int> deleteAllTypeRoad() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_TYPE_ROAD);
    return res;
  }

  Future<List<GenericData<int>>> getAllTypeRoad() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_TYPE_ROAD);

    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // Insert Tipo de Viabilidad
  saveGender(List<GenericData> newData) async {
    await deleteAllGender();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_GENDER, f.toJson());
    });
  }

  Future<int> deleteAllGender() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_GENDER);
    return res;
  }

  Future<List<GenericData<int>>> getAllGender() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_GENDER);

    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // Insert Tipo de Viabilidad
  saveEconomicActivity(List<GenericData> newData) async {
    await deleteAllEconomicActivity();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_ECONOMIC_ACTIVITY, f.toJson());
    });
  }

  Future<int> deleteAllEconomicActivity() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_ECONOMIC_ACTIVITY);
    return res;
  }

  Future<List<GenericData>> getAllEconomicActivity() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_ECONOMIC_ACTIVITY);

    List<GenericData> list =
        res.isNotEmpty ? res.map((c) => GenericData.fromJson(c)).toList() : [];

    return list;
  }

  // Insert Regimen Hidrico
  saveRegimeWater(List<GenericData> newData) async {
    await deleteAllRegimeWater();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_WATER_REGIME, f.toJson());
    });
  }

  Future<int> deleteAllRegimeWater() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_WATER_REGIME);
    return res;
  }

  Future<List<GenericData<int>>> getAllRegimeWater() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_WATER_REGIME);

    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // Insert Discapacidad
  saveDisability(List<GenericData> newData) async {
    await deleteAllDisability();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_DISABILITY, f.toJson());
    });
  }

  Future<int> deleteAllDisability() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_DISABILITY);
    return res;
  }

  Future<List<GenericData<String>>> getAllDisability() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_DISABILITY);
    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // Insert
  savePropertyRegime(List<GenericData> newData) async {
    await deleteAllPropertyRegime();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_PROPERTY_REGIME, f.toJson());
    });
  }

  Future<int> deleteAllPropertyRegime() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_PROPERTY_REGIME);
    return res;
  }

  Future<List<GenericData<int>>> getAllPropertyRegime() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_PROPERTY_REGIME);
    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // Insert Tipo Telefono
  saveTypePhone(List<GenericData> newData) async {
    await deleteAllTypePhone();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_TYPE_PHONE, f.toJson());
    });
  }

  Future<int> deleteAllTypePhone() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_TYPE_PHONE);
    return res;
  }

  Future<List<GenericData<int>>> getAllTypePhone() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_TYPE_PHONE);

    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  //TYPE CROPS
  saveTypeCrops(List<GenericData> newData) async {
    await deleteAllTypeCrops();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_TYPE_CROPS, f.toJson());
    });
  }

  Future<int> deleteAllTypeCrops() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_TYPE_CROPS);
    return res;
  }

  Future<List<GenericData<int>>> getAllTypeCrops() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_TYPE_CROPS);
    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // Insert   Centros Integradores
  saveIntegractionCenter(List<CentroIntegrador> newData) async {
    await deleteAllIntegrationCenter();
    final db = await database;
    Batch batch = db.batch();
    newData.forEach((f) async {
      //print(TABLE_INTEGRATION_CENTER + f.toJson().toString());
      batch.insert(TABLE_INTEGRATION_CENTER, f.toJson());
    });

    return await batch.commit(noResult: true);
  }

  Future<int> deleteAllIntegrationCenter() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_INTEGRATION_CENTER);
    return res;
  }

  Future<List<CentroIntegrador>> getAllIntegrationCenter() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_INTEGRATION_CENTER);

    List<CentroIntegrador> list = res.isNotEmpty
        ? res.map((c) => CentroIntegrador.fromJson(c)).toList()
        : [];

    return list;
  }

  //codigoEstado/$codigoMunicipio
  Future<List<GenericData<String>>> getAllIntegrationCenterByCode(
      {@required String codigoEstado}) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " +
        TABLE_INTEGRATION_CENTER +
        " WHERE federal_entity_code = " +
        "'" +
        codigoEstado +
        "'" +
        "");

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // TABLE_TYPE_IDENTIFICATION
  saveTypeIdentification(List<GenericData> newData) async {
    await deleteAllIdentification();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_TYPE_IDENTIFICATION, f.toJson());
    });
  }

  Future<int> deleteAllIdentification() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_TYPE_IDENTIFICATION);
    return res;
  }

  Future<List<GenericData<int>>> getAllIndentification() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_TYPE_IDENTIFICATION);

    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // TABLE_MARITAL
  saveStatusMarital(List<GenericData> newData) async {
    await deleteAllStatusMarital();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_MARITAL_STATUS, f.toJson());
    });
  }

  Future<int> deleteAllStatusMarital() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_MARITAL_STATUS);
    return res;
  }

  Future<List<GenericData<int>>> getAllStatusMarital() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_MARITAL_STATUS);
    return res.isNotEmpty
        ? res.map((c) => GenericData<int>.fromJson(c)).toList()
        : [];
  }

  // TABLE_PRINCIPAL PRODUCTO
  savePrincipalProduct(List<PrincipalProducto> newData) async {
    await deleteAllPrincipalProduct();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_PRINCIPAL_PRODUCT, f.toJson());
    });
  }

  Future<int> deleteAllPrincipalProduct() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_PRINCIPAL_PRODUCT);
    return res;
  }
  // Desarrollo
  Future<int> deleteAllPrincipalProductDev() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $TABLE_PRINCIPAL_PRODUCT WHERE code =  1010012 AND name = "Carne engorda - Ave" ' );
    final res2 = await db.rawDelete('DELETE FROM $TABLE_PRINCIPAL_PRODUCT WHERE code =  1010014 AND name = "Carne desecho - Ave" ' );
    return res2;
  }
  Future<List<GenericData<String>>> getAllPrincipalProductByCode(
      {@required String principalCultivoEspecie}) async {
    final db = await database;
    print(
        "SELECT $CODE_PRINCIPAL_PRODUCTO,$NAME_PRINCIPAL_PRODUCTO  FROM $TABLE_PRINCIPAL_PRODUCT WHERE  $CAT_CROPS_CODE = $principalCultivoEspecie ");
    final res = await db.rawQuery(
        "SELECT $CODE_PRINCIPAL_PRODUCTO,$NAME_PRINCIPAL_PRODUCTO  FROM $TABLE_PRINCIPAL_PRODUCT WHERE  $CAT_CROPS_CODE = $principalCultivoEspecie ");

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // TABLE_PEASANT_ASSOCIATION
  savePeasantAssociation(List<GenericData> newData) async {
    await deleteAllPeasantAssociation();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_PEASANT_ASSOCIATION, f.toJson());
    });
  }

  Future<int> deleteAllPeasantAssociation() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_PEASANT_ASSOCIATION);
    return res;
  }

  Future<List<GenericData<String>>> getAllPeasantAssociation() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_PEASANT_ASSOCIATION);

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // TABLE_EDUCATION_LEVEL
  saveEducationLevel(List<GenericData> newData) async {
    await deleteAllEducationLevel();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_EDUCATION_LEVEL, f.toJson());
    });
  }

  Future<int> deleteAllEducationLevel() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_EDUCATION_LEVEL);
    return res;
  }

  Future<List<GenericData<String>>> getAllEducationLevel() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_EDUCATION_LEVEL);

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
    ;
  }

  // TABLE_INDIGENOUS_LANGUAJE
  saveIndigenousLanguaje(List<GenericData> newData) async {
    await deleteAllIndigenousLanguaje();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_INDIGENOUS_LANGUAJE, f.toJson());
    });
  }

  Future<int> deleteAllIndigenousLanguaje() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_INDIGENOUS_LANGUAJE);
    return res;
  }

  Future<List<GenericData<String>>> getAllIndigenousLanguaje() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_INDIGENOUS_LANGUAJE);
    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  //TABLE_ETHNIC_GROUP
  saveEthnicGroup(List<GenericData> newData) async {
    await deleteAllEthnicGroup();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_ETHNIC_GROUP, f.toJson());
    });
  }

  Future<int> deleteAllEthnicGroup() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_ETHNIC_GROUP);
    return res;
  }

  Future<List<GenericData<String>>> getAllEthnicGroup() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_ETHNIC_GROUP);

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }

  // Insert
  saveNacionality(List<GenericData> newData) async {
    await deleteAllNacionality();
    final db = await database;
    return newData.forEach((f) async {
      await db.insert(TABLE_NACIONALITY, f.toJson());
    });
  }

  Future<int> deleteAllNacionality() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ' + TABLE_NACIONALITY);
    return res;
  }

  Future<List<GenericData<String>>> getAllNacionality() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM " + TABLE_NACIONALITY);

    return res.isNotEmpty
        ? res.map((c) => GenericData<String>.fromJson(c)).toList()
        : [];
  }
//   // Delete all employees
//   Future<int> deleteAllEmployees() async {
//     final db = await database;
//     final res = await db.rawDelete('DELETE FROM locations');

//     return res;
//   }

}
