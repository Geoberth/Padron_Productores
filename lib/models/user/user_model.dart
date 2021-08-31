import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/pdf/pdf_model.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';

class UserModel {
  //Información general en común para ambos usuarios (Personas Físicas y Personas Morales)
  int id;
  int validacion;
  String comentario;
  int tipoPersona;
  int typePersonId;
  String rfc;
  String email;
  
  
  String celPhone;
  int tipoTel;
  String noTel;
  
  String tipoDireccion;
  int tipoVialidad;
  String cp;
  String nombreVialidad;
  String noExterior;
  String noInterior;
  int tipoAsentamiento;
  String nombreAsentamiento;
  String entidadFederativa;
  String municipio;
  String localidad;
  String centroIntegrador;
  String ubicacionGeografica;
  List<Produccion> produccion;
  List<FilesPersons> filesPersons;
  List<FilesFoodIndustry> filesFoodIndustry;

  //Información general para usuario del tipo Persona Física
  String curp;
  String homoclave;
  int sexo;
  String nombre;
  String apmaterno;
  String appaterno;
  int estadoCivil;
  String nacionalidad;
  String fechaDeNacimiento;
  String tipoAsociacion;
  int regimenPropiedad;
  int identificacionOficialVigente;
  String folioIdentificacion;
  String cuentaConDiscapacidad;
  String tipoDiscapacidad;
  String declaratoriaIndigena;
  String grupoEtnico;
  String nivelDeEstudios;
  String hablaEspanol;
  String hablaLenguaIndigena;
  String lenguaIndigena;

  //Información general para el usuario del tipo Persona Moral
  String razonSocial;
  String fechaConstitucion;
  String noRegistroInstrumentoConstitucion;
  String noNotario;
  String ultimaActualizacionActaConstitutiva;
  String representanteLegal;
  String noIdentificacionRepresentanteLegal;
  int totalSociosFisicos;
  int noSociosMorales;
  int actividadEconomica;
  List<GrupoPersonaMoral> grupoPersonasMorales;
  
  String token;

  UserModel(
      {
        this.typePersonId,
      this.id,
      this.validacion,
      this.comentario,
      this.tipoPersona,
      this.rfc,
      this.email,
      this.curp,
      this.homoclave,
      this.sexo,
      this.nombre,
      this.apmaterno,
      this.appaterno,
      this.estadoCivil,
      this.nacionalidad,
      this.fechaDeNacimiento,
      this.tipoAsociacion,
      this.regimenPropiedad,
      this.identificacionOficialVigente,
      this.folioIdentificacion,
      this.cuentaConDiscapacidad,
      this.tipoDiscapacidad,
      this.declaratoriaIndigena,
      this.grupoEtnico,
      this.nivelDeEstudios,
      this.hablaEspanol,
      this.hablaLenguaIndigena,
      this.lenguaIndigena,
      this.razonSocial,
      this.fechaConstitucion,
      this.noRegistroInstrumentoConstitucion,
      this.noNotario,
      this.ultimaActualizacionActaConstitutiva,
      this.representanteLegal,
      this.noIdentificacionRepresentanteLegal,
      this.totalSociosFisicos,
      this.noSociosMorales,
      this.actividadEconomica,
      this.celPhone,
      this.tipoTel,
      this.noTel,
      this.tipoDireccion,
      this.tipoVialidad,
      this.cp,
      this.nombreVialidad,
      this.noExterior,
      this.noInterior,
      this.tipoAsentamiento,
      this.nombreAsentamiento,
      this.entidadFederativa,
      this.municipio,
      this.localidad,
      this.centroIntegrador,
      this.ubicacionGeografica,
      this.produccion,
      this.grupoPersonasMorales,
      this.token,
      this.filesPersons,
      this.filesFoodIndustry
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    typePersonId = json["type_person_id"];
    id = json['id'];
    validacion = json['validacion'];
    comentario = json['comentario'];
    tipoPersona = json['tipoPersona'];
    rfc = json['rfc'];
    email = json['email'];
    curp = json['curp'];
    homoclave = json['homoclave'];
    sexo = json['sexo'];
    nombre = json['nombre'];
    apmaterno = json['apmaterno'];
    appaterno = json['appaterno'];
    estadoCivil = json['estadoCivil'];
    nacionalidad = json['nacionalidad'];
    fechaDeNacimiento = json['fechaDeNacimiento'];
    tipoAsociacion = json['tipoAsociacion'];
    regimenPropiedad = json['regimenPropiedad'];
    identificacionOficialVigente = json['identificacionOficialVigente'];
    folioIdentificacion = json['folioIdentificacion'];
    cuentaConDiscapacidad = json['cuentaConDiscapacidad'];
    tipoDiscapacidad = json['tipoDiscapacidad'];
    declaratoriaIndigena = json['declaratoriaIndigena'];
    grupoEtnico = json['grupoEtnico'];
    nivelDeEstudios = json['nivelDeEstudios'];
    hablaEspanol = json['hablaEspanol'];
    hablaLenguaIndigena = json['hablaLenguaIndigena'];
    lenguaIndigena = json['lenguaIndigena'];
    razonSocial = json['razonSocial'];
    fechaConstitucion = json['fechaConstitucion'];
    noRegistroInstrumentoConstitucion =
        json['noRegistroInstrumentoConstitucion'];
    noNotario = json['noNotario'];
    ultimaActualizacionActaConstitutiva =
        json['ultimaActualizacionActaConstitutiva'];
    representanteLegal = json['representanteLegal'];
    noIdentificacionRepresentanteLegal =
        json['noIdentificacionRepresentanteLegal'];
    totalSociosFisicos = json['totalSociosFisicos'];
    noSociosMorales = json['noSociosMorales'];
    actividadEconomica = json['actividadEconomica'];
    celPhone = json['phone'];
    tipoTel = json['tipoTel'];
    noTel = json['noTel'];
    tipoDireccion = json['tipoDireccion'];
    tipoVialidad = json['tipoVialidad'];
    cp = json['cp'];
    nombreVialidad = (json['nombreVialidad']);
    noExterior = json['noExterior'];
    noInterior = json['noInterior'];
    tipoAsentamiento = json['tipoAsentamiento'];
    nombreAsentamiento = json['nombreAsentamiento'];
    entidadFederativa = json['entidadFederativa'];
    municipio = json['municipio'];
    localidad = json['localidad'];
    centroIntegrador = json['centroIntegrador'];
    ubicacionGeografica = json['ubicacionGeografica'];
    token = json["token"];

    if (json['produccion'] != null) {
      produccion = new List<Produccion>();
      json['produccion'].forEach((v) {
        produccion.add(new Produccion.fromJson(v));
      });
    }
    if (json['grupoPersonasMorales'] != null) {
      grupoPersonasMorales = new List<GrupoPersonaMoral>();
      json['grupoPersonasMorales'].forEach((v) {
        grupoPersonasMorales.add(new GrupoPersonaMoral.fromJson(v));
      });
    }
    if (json['filesPersons'] != null) {
      filesPersons = new List<FilesPersons>();
      json['filesPersons'].forEach((v) {
        filesPersons.add(new FilesPersons.fromJson(v));
      });
    }
    if (json['filesFoodIndustry'] != null) {
      filesFoodIndustry = new List<FilesFoodIndustry>();
      json['filesFoodIndustry'].forEach((v) {
        filesFoodIndustry.add(new FilesFoodIndustry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_person_id'] = this.typePersonId;
    data['id'] = this.id;
    data['validacion'] = this.validacion;
    data['comentario'] = this.comentario;
    data['tipoPersona'] = this.tipoPersona;
    data['rfc'] = this.rfc;
    data['email'] = this.email;
    data['curp'] = this.curp;
    data['homoclave'] = this.homoclave;
    data['sexo'] = this.sexo;
    data['nombre'] = this.nombre;
    data['apmaterno'] = this.apmaterno;
    data['appaterno'] = this.appaterno;
    data['estadoCivil'] = this.estadoCivil;
    data['nacionalidad'] = this.nacionalidad;
    data['fechaDeNacimiento'] = this.fechaDeNacimiento;
    data['tipoAsociacion'] = this.tipoAsociacion;
    data['regimenPropiedad'] = this.regimenPropiedad;
    data['identificacionOficialVigente'] = this.identificacionOficialVigente;
    data['folioIdentificacion'] = this.folioIdentificacion;
    data['cuentaConDiscapacidad'] = this.cuentaConDiscapacidad;
    data['tipoDiscapacidad'] = this.tipoDiscapacidad;
    data['declaratoriaIndigena'] = this.declaratoriaIndigena;
    data['grupoEtnico'] = this.grupoEtnico;
    data['nivelDeEstudios'] = this.nivelDeEstudios;
    data['hablaEspanol'] = this.hablaEspanol;
    data['hablaLenguaIndigena'] = this.hablaLenguaIndigena;
    data['lenguaIndigena'] = this.lenguaIndigena;
    data['razonSocial'] = this.razonSocial;
    data['fechaConstitucion'] = this.fechaConstitucion;
    data['noRegistroInstrumentoConstitucion'] =
        this.noRegistroInstrumentoConstitucion;
    data['noNotario'] = this.noNotario;
    data['ultimaActualizacionActaConstitutiva'] =
        this.ultimaActualizacionActaConstitutiva;
    data['representanteLegal'] = this.representanteLegal;
    data['noIdentificacionRepresentanteLegal'] =
        this.noIdentificacionRepresentanteLegal;
    data['totalSociosFisicos'] = this.totalSociosFisicos;
    data['noSociosMorales'] = this.noSociosMorales;
    data['actividadEconomica'] = this.actividadEconomica;
    data['phone'] = this.celPhone;
    data['tipoTel'] = this.tipoTel;
    data['noTel'] = this.noTel;
    data['tipoDireccion'] = this.tipoDireccion;
    data['tipoVialidad'] = this.tipoVialidad;
    data['cp'] = this.cp;
    data['nombreVialidad'] = this.nombreVialidad;
    data['noExterior'] = this.noExterior;
    data['noInterior'] = this.noInterior;
    data['tipoAsentamiento'] = this.tipoAsentamiento;
    data['nombreAsentamiento'] = this.nombreAsentamiento;
    data['entidadFederativa'] = this.entidadFederativa;
    data['municipio'] = this.municipio;
    data['localidad'] = this.localidad;
    data['centroIntegrador'] = this.centroIntegrador;
    data['ubicacionGeografica'] = this.ubicacionGeografica;

    data['token'] = this.token;

    if (this.produccion != null) {
      data['produccion'] = this.produccion.map((v) => v.toJson()).toList();
    }
    if (this.grupoPersonasMorales != null) {
      data['grupoPersonasMorales'] = this.grupoPersonasMorales.map((v) => v.toJson()).toList();
    }
    if (this.filesPersons != null) {
      data['filesPersons'] = this.filesPersons.map((v) => v.toJson()).toList();
    }
    if (this.filesFoodIndustry != null) {
      data['filesFoodIndustry'] =
          this.filesFoodIndustry.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GrupoPersonaMoral {
  int tempIndex;
  int id;
  String nombre;
  String appaterno;
  String apmaterno;
  int sexo;
  String rfc;
  String homoclave;
  String curp;
  int estadoCivil;
  String email;
  String nacionalidad;
  String fechaDeNacimiento;
  String noTel;
  String tipoDireccion;
  int tipoVialidad;
  String cp;
  String nombreVialidad;
  String noExterior;
  String noInterior;
  int tipoAsentamiento;
  String nombreAsentamiento;
  String entidadFederativa;
  String municipio;
  String localidad;
  String ubicacionGeografica;

  GrupoPersonaMoral(
      {
      this.tempIndex,
      this.id,
      this.nombre,
      this.appaterno,
      this.apmaterno,
      this.sexo,
      this.rfc,
      this.homoclave,
      this.curp,
      this.estadoCivil,
      this.email,
      this.nacionalidad,
      this.fechaDeNacimiento,
      this.noTel,
      this.tipoDireccion,
      this.tipoVialidad,
      this.cp,
      this.nombreVialidad,
      this.noExterior,
      this.noInterior,
      this.tipoAsentamiento,
      this.nombreAsentamiento,
      this.entidadFederativa,
      this.municipio,
      this.localidad,
      this.ubicacionGeografica});

  GrupoPersonaMoral.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    appaterno = json['appaterno'];
    apmaterno = json['apmaterno'];
    sexo = json['sexo'];
    rfc = json['rfc'];
    homoclave = json['homoclave'];
    curp = json['curp'];
    estadoCivil = json['estadoCivil'];
    email = json['email'];
    nacionalidad = json['nacionalidad'];
    fechaDeNacimiento = json['fechaDeNacimiento'];
    noTel = json['noTel'];
    tipoDireccion = json['tipoDireccion'];
    tipoVialidad = json['tipoVialidad'];
    cp = json['cp'];
    nombreVialidad = json['nombreVialidad'];
    noExterior = json['noExterior'];
    noInterior = json['noInterior'];
    tipoAsentamiento = json['tipoAsentamiento'];
    nombreAsentamiento = json['nombreAsentamiento'];
    entidadFederativa = json['entidadFederativa'];
    municipio = json['municipio'];
    localidad = json['localidad'];
    ubicacionGeografica = json['ubicacionGeografica'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['appaterno'] = this.appaterno;
    data['apmaterno'] = this.apmaterno;
    data['sexo'] = this.sexo;
    data['rfc'] = this.rfc;
    data['homoclave'] = this.homoclave;
    data['curp'] = this.curp;
    data['estadoCivil'] = this.estadoCivil;
    data['email'] = this.email;
    data['nacionalidad'] = this.nacionalidad;
    data['fechaDeNacimiento'] = this.fechaDeNacimiento;
    data['noTel'] = this.noTel;
    data['tipoDireccion'] = this.tipoDireccion;
    data['tipoVialidad'] = this.tipoVialidad;
    data['cp'] = this.cp;
    data['nombreVialidad'] = this.nombreVialidad;
    data['noExterior'] = this.noExterior;
    data['noInterior'] = this.noInterior;
    data['tipoAsentamiento'] = this.tipoAsentamiento;
    data['nombreAsentamiento'] = this.nombreAsentamiento;
    data['entidadFederativa'] = this.entidadFederativa;
    data['municipio'] = this.municipio;
    data['localidad'] = this.localidad;
    data['ubicacionGeografica'] = this.ubicacionGeografica;
    return data;
  }
}

class FilesPersons {
  int id;
  String name;
  int numFiles;
  num fileId;
  String file;
  PdfModel tempFile; // This property is only used to show the name of the file in UI.

  FilesPersons({this.id, this.name, this.numFiles, this.fileId, this.file, this.tempFile});

  FilesPersons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    numFiles = json['num_files'];
    fileId = json['fileId'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['num_files'] = this.numFiles;
    data['fileId'] = this.fileId;
    data['file'] = this.file;
    return data;
  }
}

class FilesFoodIndustry {
  int id;
  int code;
  String name;
  List<FIDocument> doc;

  FilesFoodIndustry({this.id, this.code, this.name, this.doc});

  FilesFoodIndustry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    if (json['doc'] != null) {
      doc = new List<FIDocument>();
      json['doc'].forEach((v) {
        doc.add(new FIDocument.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.doc != null) {
      data['doc'] = this.doc.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FIDocument {
  int id;
  String name;
  int numFiles;
  int fileId;
  String file;
  int plotsId;
  int  isRequired;
  PdfModel tempFile;

  FIDocument(
      {this.id,
      this.name,
      this.numFiles,
      this.fileId,
      this.file,
      this.plotsId,
      this.isRequired
      
      });

  FIDocument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    numFiles = json['num_files'];
    fileId = json['fileId'];
    file = json['file'];
    plotsId = json['plots_id'];
    isRequired = json['is_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['num_files'] = this.numFiles;
    data['fileId'] = this.fileId;
    data['file'] = this.file;
    data['plots_id'] = this.plotsId;
    data['is_required'] = this.isRequired;
    return data;
  }
}

class Produccion {
  SectorAgroalimentario foodIndustry; // Sector agroalimentario
  GenericData<String> mainCrop; // Principal cultivo - Especie
  GenericData<String> mainProduct; // Principal producto
  GenericData<int> waterRegime; // Regimen hidrico
  GenericData<int> typeCrop;  // tipo de cultivo
  GenericData<String> typeOfHoneyProducer; 
  num superficie;
  num productionVolumes;
  num productionValue;
  num price;

  String typeOfHoneyProducerCode;
  num numberOfHives;
  num amountOfBellies;
  num numberOfPlantsHa;
  Produccion(
      {this.mainCrop,
      this.mainProduct,
      this.foodIndustry,
      this.waterRegime,
      this.typeCrop,
      this.superficie,
      this.productionVolumes,
      this.productionValue,
      this.price,
      this.typeOfHoneyProducer,
      this.typeOfHoneyProducerCode,
      this.numberOfHives,
      this.amountOfBellies,
      this.numberOfPlantsHa
      });

  Produccion.fromJson(Map<String, dynamic> json) {
    mainCrop = json['main_crop'] != null
        ? new GenericData<String>.fromJson(json['main_crop'])
        : null;
    mainProduct = json['main_product'] != null
        ? new GenericData<String>.fromJson(json['main_product'])
        : null;
    foodIndustry = json['food_industry'] != null
        ? new SectorAgroalimentario.fromJson(json['food_industry'])
        : null;
    waterRegime = json['water_regime'] != null
        ? new GenericData<int>.fromJson(json['water_regime'])
        : null;
    typeCrop = json['type_crop'] != null
        ? new GenericData<int>.fromJson(json['type_crop'])
        : null;
    typeOfHoneyProducer = json['type_of_honey_producer'] != null
        ? new GenericData<String>.fromJson(json['type_of_honey_producer'])
        : null;
    superficie = json['superficie'];
    productionVolumes = json['production_volumes'];
    productionValue = json['production_value'];
    price = json['price'];
    typeOfHoneyProducerCode  = json['type_of_honey_producer_code'];
    numberOfHives            = json['number_of_hives'];
    amountOfBellies          = json['amount_of_bellies'];
    numberOfPlantsHa         = json['number_of_plants_ha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mainCrop != null) {
      data['main_crop'] = this.mainCrop.toJson();
    }
    if (this.mainProduct != null) {
      data['main_product'] = this.mainProduct.toJson();
    }
    if (this.foodIndustry != null) {
      data['food_industry'] = this.foodIndustry.toJson();
    }
    if (this.waterRegime != null) {
      data['water_regime'] = this.waterRegime.toJson();
    }
    if (this.typeCrop != null) {
      data['type_crop'] = this.typeCrop.toJson();
    }
    if (this.typeOfHoneyProducer != null) {
      data['type_of_honey_producer'] = this.typeOfHoneyProducer.toJson();
    }
    
    data['superficie'] = this.superficie;
    data['production_volumes'] = this.productionVolumes;
    data['production_value'] = this.productionValue;
    data['price'] = this.price;
    data['type_of_honey_producer_code'] = this.typeOfHoneyProducerCode;
    data['number_of_hives'] = this.numberOfHives;
    data['amount_of_bellies'] = this.amountOfBellies;
    data['number_of_plants_ha'] = this.numberOfPlantsHa;
    return data;
  }
}