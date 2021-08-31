import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/offline/centro_integrador_model.dart';
import 'package:siap/models/offline/localidades_model.dart';
import 'package:siap/models/offline/municipios_model.dart';
import 'package:siap/models/offline/principal_producto_model.dart';
import 'package:siap/models/offline/principales_cultivos_especies_model.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/utils/api/api_base_helper.dart';
import 'package:siap/utils/settings.dart';

class CatalogosRepositoryOffline {
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  //LOCATIONS
  String _urlLocalidades0                 = "${Settings.apiSegment}/download/location/list?offset=0";
  String _urlLocalidades1                 = "${Settings.apiSegment}/download/location/list?offset=50000";
  String _urlLocalidades2                 = "${Settings.apiSegment}/download/location/list?offset=100000";
  String _urlLocalidades3                 = "${Settings.apiSegment}/download/location/list?offset=150000";
  String _urlLocalidades4                 = "${Settings.apiSegment}/download/location/list?offset=200000";
  String _urlLocalidades5                 = "${Settings.apiSegment}/download/location/list?offset=250000";


  String _urlEstados                     = "${Settings.apiSegment}/download/federal-entity/list";
  String _urlMunicipios                  = "${Settings.apiSegment}/download/municipality/list";
  String _urlSectorAgroalimentario       = "${Settings.apiSegment}/download/food-industry/list";
  String _urlPrincipalesCultivosEspecies = "${Settings.apiSegment}/download/food-industry/crops";
  String _urlTiposCultivos               = "${Settings.apiSegment}/download/type-crops/list";
  String _urlPrincipalesProductos        = "${Settings.apiSegment}/download/food-industry/list/product";
  String _urlTipoDireccion               = "${Settings.apiSegment}/download/type-address/list";
  String _urlTipoAsentamiento            = "${Settings.apiSegment}/download/type-settlement/list";
  String _urlTipoVialidad                = "${Settings.apiSegment}/download/type-road/list";
  String _urlGeneros                     = "${Settings.apiSegment}/download/gender/list";
  // String _urlActividadEconomica          = "${Settings.apiSegment}/download/economic-activity/list";
  String _urlRegimenHidrico              = "${Settings.apiSegment}/download/water-regime/list";
  String _urlDiscapacidades              = "${Settings.apiSegment}/download/disability/list";
  String _urlRegimenPropiedad            = "${Settings.apiSegment}/download/property-regime/list";
  String _urlTipoTelefono                = "${Settings.apiSegment}/download/type-phone/list";
  String _urlCentroIntegrador            = "${Settings.apiSegment}/download/integration-center/list";
  String _urlNacionalidades              = "${Settings.apiSegment}/download/nacionality/list";
  String _urlIdentificacionOficial       = "${Settings.apiSegment}/download/type-identification/list";
  String _urlEstadoCivil                 = "${Settings.apiSegment}/download/marital-status/list";
  String _urlAsociacionCampesina         = "${Settings.apiSegment}/download/peasant-association/list";
  String _urlNivelEstudios               = "${Settings.apiSegment}/download/education-level/list";
  String _urlLenguasIndigenas            = "${Settings.apiSegment}/download/indigenous-language/list";
  String _urlPueblosEtnias               = "${Settings.apiSegment}/download/ethnic-group/list";
  String _urlFiles = "${Settings.apiSegment}/download/list-files-by-food-industry/list";

   getLocalidadPart1() async {
     final localidades = await _apiHelper.get(_urlLocalidades1);
     return await DBProvider.db.saveLocation2(LocalidadesModel.fromJson(localidades).localidades);
   }
  getLocalidadPart2() async {
    final localidades = await _apiHelper.get(_urlLocalidades2);
    return await DBProvider.db.saveLocation2(LocalidadesModel.fromJson(localidades).localidades);
  }
  getLocalidadPart3() async {
    final localidades = await _apiHelper.get(_urlLocalidades3);
    return await DBProvider.db.saveLocation2(LocalidadesModel.fromJson(localidades).localidades);
  }
  getLocalidadPart4() async {
    final localidades = await _apiHelper.get(_urlLocalidades4);
    return await DBProvider.db.saveLocation2(LocalidadesModel.fromJson(localidades).localidades);
  }
  getLocalidadPart5() async {
    final localidades = await _apiHelper.get(_urlLocalidades5);
    return await DBProvider.db.saveLocation2(LocalidadesModel.fromJson(localidades).localidades);
  }
  getLocalidadPart0() async {
     print("url Localidaeds ");
     print( _urlLocalidades0);
    final localidades = await _apiHelper.get(_urlLocalidades0);
    return await DBProvider.db.saveLocation(LocalidadesModel.fromJson(localidades).localidades);
  }

  Future loadOfflineData() async {
     final resEstados = await _apiHelper.get(_urlEstados);
    final resMunicipios = await _apiHelper.get("$_urlMunicipios");
    final respSectorAgroalimentario = await _apiHelper.get(_urlSectorAgroalimentario);
    final resPrincipalesCultivosEspecies = await _apiHelper.get("$_urlPrincipalesCultivosEspecies");
    final resTipoCultivo = await _apiHelper.get("$_urlTiposCultivos");
    final resPrincipalesProductos = await _apiHelper.get("$_urlPrincipalesProductos");
    final resTipoDireccion = await _apiHelper.get(_urlTipoDireccion);
    final resTipoAsentamiento = await _apiHelper.get(_urlTipoAsentamiento);
    final resTipoViabilidad = await _apiHelper.get(_urlTipoVialidad);
    final resGeneros = await _apiHelper.get(_urlGeneros);
    final resRegimenHidrico = await _apiHelper.get(_urlRegimenHidrico);
    final resDiscapacidades = await _apiHelper.get(_urlDiscapacidades);
    final resRegimePropiedad = await _apiHelper.get(_urlRegimenPropiedad);
    final resTipoTelefono = await _apiHelper.get(_urlTipoTelefono);
    final resCentroIntegrador = await _apiHelper.get("$_urlCentroIntegrador");
    final resNacionalidades = await _apiHelper.get(_urlNacionalidades);
    final resIdentificacionOficial = await _apiHelper.get(_urlIdentificacionOficial);
    final resEstadoCivil = await _apiHelper.get(_urlEstadoCivil);
    final resAsociacionCampesina = await _apiHelper.get(_urlAsociacionCampesina);
    final resNivelEstudios = await _apiHelper.get(_urlNivelEstudios);
    final resLenguaIndigenas = await _apiHelper.get(_urlLenguasIndigenas);
    final resPueblosEtnias = await _apiHelper.get(_urlPueblosEtnias);
   //SHARED PREFERENCES
    SharedPreferences sectorAgroalimentario = await SharedPreferences.getInstance();
    String sector = jsonEncode(SectorAgroalimentarioModel.fromJson(respSectorAgroalimentario));
    sectorAgroalimentario.setString('sectorAgroalimentario', sector );


    await DBProvider.db.saveFederalEntity( GenericModel<String>.fromJson(resEstados).items );
    await DBProvider.db.saveMunicipality( MunicipiosModel.fromJson(resMunicipios).municipios);
    await DBProvider.db.saveFoodIndustryEspecies(PrincipalesCultivosEspeciesModel.fromJson(resPrincipalesCultivosEspecies).principalesCultivosEspecies);
    await DBProvider.db.saveTypeCrops( GenericModel.fromJson(resTipoCultivo).items );
    await DBProvider.db.savePrincipalProduct( PrincipalProductoModel.fromJson(resPrincipalesProductos).principalproductos);
    await DBProvider.db.saveTypeAddress(GenericModel.fromJson(resTipoDireccion).items);
    await DBProvider.db.saveTypeSettElement(GenericModel.fromJson(resTipoAsentamiento).items);
    await DBProvider.db.saveTypeRoad(GenericModel.fromJson(resTipoViabilidad).items);
    await DBProvider.db.saveGender(GenericModel.fromJson(resGeneros).items);
    await DBProvider.db.saveRegimeWater(GenericModel.fromJson(resRegimenHidrico).items);
    await DBProvider.db.saveDisability(GenericModel.fromJson(resDiscapacidades).items);
    await DBProvider.db.savePropertyRegime(GenericModel.fromJson(resRegimePropiedad).items);
    await DBProvider.db.saveTypePhone(GenericModel.fromJson(resTipoTelefono).items);
    await DBProvider.db.saveIntegractionCenter(CentroIntegradorModel.fromJson(resCentroIntegrador).centrosIntegradores);
    await DBProvider.db.saveNacionality(GenericModel.fromJson(resNacionalidades).items);
    await DBProvider.db.saveTypeIdentification(GenericModel.fromJson(resIdentificacionOficial).items);
    await DBProvider.db.saveStatusMarital(GenericModel.fromJson(resEstadoCivil).items);
    await DBProvider.db.savePeasantAssociation( GenericModel.fromJson(resAsociacionCampesina).items  );
    await DBProvider.db.saveEducationLevel( GenericModel.fromJson(resNivelEstudios).items);
    await DBProvider.db.saveIndigenousLanguaje( GenericModel.fromJson(resLenguaIndigenas).items);
    await DBProvider.db.saveEthnicGroup( GenericModel.fromJson(resPueblosEtnias).items);
    //Segunda inicio ya no va descargar Catalogos.
    SharedPreferences statusLoadOffline = await SharedPreferences.getInstance();
     statusLoadOffline.setString("loadOfflineData", '1');
   }



}