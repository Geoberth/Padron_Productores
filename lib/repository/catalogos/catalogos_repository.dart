import 'package:meta/meta.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';
import 'package:siap/utils/api/api_base_helper.dart';
import 'package:siap/utils/settings.dart';

class CatalogosRepository {
  ApiBaseHelper _apiHelper = ApiBaseHelper();

  String _urlEstados                     = "${Settings.apiSegment}/catalogues/federal-entity/list";
  String _urlMunicipios                  = "${Settings.apiSegment}/catalogues/municipality/list";
  String _urlLocalidades                 = "${Settings.apiSegment}/catalogues/location/list";
  String _urlSectorAgroalimentario       = "${Settings.apiSegment}/catalogues/food-industry/list";
  String _urlPrincipalesCultivosEspecies = "${Settings.apiSegment}/catalogues/food-industry/crops";
  String _urlTiposCultivos               = "${Settings.apiSegment}/catalogues/type-crops/list";
  String _urlPrincipalesProductos        = "${Settings.apiSegment}/catalogues/food-industry/list/product/";
  String _urlTipoDireccion               = "${Settings.apiSegment}/catalogues/type-address/list";
  String _urlTipoAsentamiento            = "${Settings.apiSegment}/catalogues/type-settlement/list";
  String _urlTipoVialidad                = "${Settings.apiSegment}/catalogues/type-road/list";
  String _urlGeneros                     = "${Settings.apiSegment}/catalogues/gender/list";
  // String _urlActividadEconomica          = "${Settings.apiSegment}/catalogues/economic-activity/list";
  String _urlRegimenHidrico              = "${Settings.apiSegment}/catalogues/water-regime/list";
  String _urlDiscapacidades              = "${Settings.apiSegment}/catalogues/disability/list";
  String _urlRegimenPropiedad            = "${Settings.apiSegment}/catalogues/property-regime/list";
  String _urlTipoTelefono                = "${Settings.apiSegment}/catalogues/type-phone/list";
  String _urlCentroIntegrador            = "${Settings.apiSegment}/catalogues/integration-center/list";
  String _urlNacionalidades              = "${Settings.apiSegment}/catalogues/nacionality/list";
  String _urlIdentificacionOficial       = "${Settings.apiSegment}/catalogues/type-identification/list";
  String _urlEstadoCivil                 = "${Settings.apiSegment}/catalogues/marital-status/list";
  String _urlAsociacionCampesina         = "${Settings.apiSegment}/catalogues/peasant-association/list";
  String _urlNivelEstudios               = "${Settings.apiSegment}/catalogues/education-level/list";
  String _urlLenguasIndigenas            = "${Settings.apiSegment}/catalogues/indigenous-language/list";
  String _urlPueblosEtnias               = "${Settings.apiSegment}/catalogues/ethnic-group/list";
   String _typeOfHoneyProducer            = "${Settings.apiSegment}/catalogues/type-of-honey-producer/list";
  // String _urlFiles                       = "${Settings.apiSegment}/catalogues/list-files-by-food-industry/list";

  Future<List<GenericData<String>>> getEstados() async {
    final response = await _apiHelper.get(_urlEstados);
    return GenericModel<String>.fromJson(response).items;
  }
  
  Future<List<GenericData<String>>> getMunicipios({@required String codigoEstado}) async {
    final response = await _apiHelper.get("$_urlMunicipios/$codigoEstado");
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getLocalidades({@required String codigoEstado, @required String codigoMunicipio}) async {
    final response = await _apiHelper.get("$_urlLocalidades/$codigoEstado/$codigoMunicipio");
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<SectorAgroalimentario>> getSectorAgroalimentario() async {
    final response = await _apiHelper.get(_urlSectorAgroalimentario);
    return SectorAgroalimentarioModel.fromJson(response).sectoresAgroalimentarios;
  }

  Future<List<GenericData<String>>> getPrincipalesCultivos({@required int codigoSectorAgroalimentario}) async {
    final response = await _apiHelper.get("$_urlPrincipalesCultivosEspecies/$codigoSectorAgroalimentario");
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getTiposCultivos() async {
    final response = await _apiHelper.get("$_urlTiposCultivos");
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getPrincipalesProductos({@required String principalCultivoEspecie}) async {
    final response = await _apiHelper.get("$_urlPrincipalesProductos/$principalCultivoEspecie");
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getTipoDireccion() async {
    final response = await _apiHelper.get(_urlTipoDireccion);
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getTipoAsentamiento() async {
    final response = await _apiHelper.get(_urlTipoAsentamiento);
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getTipoVialidad() async {
    final response = await _apiHelper.get(_urlTipoVialidad);
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getGeneros() async {
    final response = await _apiHelper.get(_urlGeneros);
    return GenericModel<int>.fromJson(response).items;
  }

  /* Future<List<GenericData<int>>> getActividadEconomica() async {
    final response = await _apiHelper.get(_urlActividadEconomica);
    return GenericModel<int>.fromJson(response).items;
  } */

  Future<List<GenericData<int>>> getRegimenHidrico() async {
    final response = await _apiHelper.get(_urlRegimenHidrico);
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getDiscapacidades() async {
    final response = await _apiHelper.get(_urlDiscapacidades);
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getRegimenPropiedad() async {
    final response = await _apiHelper.get(_urlRegimenPropiedad);
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getTipoTelefono() async {
    final response = await _apiHelper.get(_urlTipoTelefono);
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getCentrosIntegradores({@required String codigoEstado}) async {
    final response = await _apiHelper.get("$_urlCentroIntegrador/$codigoEstado");
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getNacionalidades() async {
    final response = await _apiHelper.get(_urlNacionalidades);
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getIdentificacionOficial() async {
    final response = await _apiHelper.get(_urlIdentificacionOficial);
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<int>>> getEstadoCivil() async {
    final response = await _apiHelper.get(_urlEstadoCivil);
    return GenericModel<int>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getAsociacionCampesina() async {
    final response = await _apiHelper.get(_urlAsociacionCampesina);
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getNivelEstudios() async {
    final response = await _apiHelper.get(_urlNivelEstudios);
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getLenguasIndigenas() async {
    final response = await _apiHelper.get(_urlLenguasIndigenas);
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getPueblosEtnias() async {
    final response = await _apiHelper.get(_urlPueblosEtnias);
    return GenericModel<String>.fromJson(response).items;
  }

  Future<List<GenericData<String>>> getTypeHoneyProducer() async {
    final response = await _apiHelper.get(_typeOfHoneyProducer);
    return GenericModel<String>.fromJson(response).items;
  }
  /* Future<List<GenericData<int>>> getFilesBySector({@required int sectorAgroalimentario, @required int tipoPersona}) async {
    final response = await _apiHelper.get("$_urlFiles/$sectorAgroalimentario/$tipoPersona");
    return GenericModel<int>.fromJson(response).items;
  } */

}