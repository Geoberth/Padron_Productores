import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';
import 'package:siap/blocs/register/common/production_step_bloc.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/register/widgets/catalogos_dropdown.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/decimal_formatter.dart';

class AddProductionScreen extends StatefulWidget {
  final List<SectorAgroalimentario> sectoresAgroalimentarios;
  final ProductionStepBloc productionStepBloc;
  final Produccion sector;

  AddProductionScreen({@required this.sectoresAgroalimentarios, @required this.productionStepBloc, this.sector});

  @override
  _AddProductionScreenState createState() => _AddProductionScreenState();
}

class _AddProductionScreenState extends State<AddProductionScreen> {
  final _formKeyStep4 = GlobalKey<FormState>();
  UserModel _userModel = UserSingleton.instance.user;
  ProductionStepBloc _productionStepBloc;
  CheckConectivity _checkConectivity = CheckConectivity();
  CatalogosDropDown _catalogosDropDown = CatalogosDropDown();
  CatalogosRepository _catalogosRepository = CatalogosRepository();
  List<SectorAgroalimentario> _sectoresAgroalimentarios = [];
  List<GenericData<String>> _principalesCultivosEspecies = [];
  List<GenericData<String>> _principalesProductos = [];
  List<GenericData<int>> _regimenHidricos = [];
  List<GenericData<int>> _tiposCultivos = [];
  List<GenericData<String>> __tipoProductorMiel = [];
  TextEditingController _valorProdTextCtrl = TextEditingController();
  TextEditingController _superficieTextCtrl = TextEditingController();
  TextEditingController _volumenTextCtrl = TextEditingController();
  TextEditingController _precioTextCtrl = TextEditingController();
  //TextEditingController _valorProdTextCtrl = TextEditingController();
  @override
  void initState() {
    _sectoresAgroalimentarios = widget.sectoresAgroalimentarios;
    _productionStepBloc = widget.productionStepBloc;
    if (widget.sector != null) {
      _sectoresAgroalimentarios = _sectoresAgroalimentarios.where((sa) => sa.code == widget.sector.foodIndustry.code).toList();
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.sector != null) {
        _productionStepBloc.changeSectorAgroalimentario(widget.sector.foodIndustry.code);
        _changeSector(widget.sector.foodIndustry.code);
      }
      if (widget?.sector?.productionValue != null) {
        _productionStepBloc.changeValorProduccion(widget?.sector?.productionValue?.toString());
        _valorProdTextCtrl.text = widget.sector.productionValue.toString();
      }
    });
  }

  Widget _buildSectorAgroalimentario(Size size) {
    return StreamBuilder<int>(
      stream: _productionStepBloc.sectorAgroalimentario,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildSectorAgroalimentario(
          size: size, title: "Sector agroalimentario", value: snapshot.data, sectoresAgroalimentarios: _sectoresAgroalimentarios,
          onChanged: _changeSector
        );
      }
    );
  }

  Future<void> _changeSector(int val) async {
    _resetStreamsForm();
    FocusScope.of(context).requestFocus(FocusNode());

    SectorAgroalimentario sector = _sectoresAgroalimentarios.firstWhere((s) => s.code == val);

    bool a, b, c, d, e, f, g, h;
    sector.validation.map((v) {
      switch (v.type) {
        case 1:
          if(v.show == true) {
            a = true;
          }
        break;
        case 2:
          if(v.show == true) {
            b = true;
          }
        break;
        case 3:
          if(v.show == true) {
            c = true;
          }
        break;
        case 4:
          if(v.show == true) {
            d = true;
          }
        break;
        case 5:
          if(v.show == true) {
            e = true;
          }
        break;
        case 6:
          if(v.show == true) {
            f = true;
          }
        break;
        case 7:
          if(v.show == true) {
            g = true;
          }
        break;
        case 8:
          if(v.show == true) {
            h = true;
          }
        break;
        default:
        break;
      }
    }).toList();

    try {
     await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      if(a == true) {
        if ( await _checkConectivity.checkConnectivity() ) {
          _principalesCultivosEspecies = await _catalogosRepository.getPrincipalesCultivos(codigoSectorAgroalimentario: sector.code);
          if (widget.sector != null) {
            _productionStepBloc.changePrincipalCultivoEspecie(widget.sector.mainCrop.code);
            if (widget.sector.mainProduct != null) {
              _principalesProductos = await _catalogosRepository.getPrincipalesProductos(principalCultivoEspecie: widget.sector.mainCrop.code);
              _productionStepBloc.changePrincipalProducto(widget.sector.mainProduct.code);
              if(widget.sector.typeOfHoneyProducer != null){
                  
                  __tipoProductorMiel = await _catalogosRepository.getTypeHoneyProducer();
                  
                    final code = widget.sector.typeOfHoneyProducer.code;
                     _productionStepBloc.changetypeOfHoneyProducer(code);
                    _productionStepBloc.changetypeOfHoneyProducerCode(code);
                    _productionStepBloc.changeNumberOfHives(widget?.sector?.numberOfHives.toString());
                  
            }
            if(widget.sector.numberOfPlantsHa != null ){
              _productionStepBloc.changenumberOfPlantsHa(widget.sector.numberOfPlantsHa.toString());
            }
            if(widget.sector.amountOfBellies != null){
              _productionStepBloc.changeAmountOfBellies(widget.sector.amountOfBellies.toString());
            }
            }
          }
        }else {
          _principalesCultivosEspecies = await DBProvider.db.getAllFoodIndustryEspeciesByCode(codigoSectorAgroalimentario: sector.code);
          if (widget.sector != null) {
            _productionStepBloc.changePrincipalCultivoEspecie(widget.sector.mainCrop.code);
            if (widget.sector.mainProduct != null) {
              _principalesProductos = await DBProvider.db.getAllPrincipalProductByCode(principalCultivoEspecie: widget.sector.mainCrop.code);
              _productionStepBloc.changePrincipalProducto(widget.sector.mainProduct.code);
              //Offline typeOfHoneyProducer
               if(widget.sector.typeOfHoneyProducer != null){
                  
                  __tipoProductorMiel = await DBProvider.db.getTypeProducerHoney();
                  
                    final code = widget.sector.typeOfHoneyProducer.code;
                     _productionStepBloc.changetypeOfHoneyProducer(code);
                    _productionStepBloc.changetypeOfHoneyProducerCode(code);
                    _productionStepBloc.changeNumberOfHives(widget?.sector?.numberOfHives.toString());
                  
            }
            }
          }
        }

      }
      if(c == true) {
        if ( await _checkConectivity.checkConnectivity() ) {
          _regimenHidricos = await _catalogosRepository.getRegimenHidrico();
          if (widget.sector != null) {
            _productionStepBloc.changeRegimenHidrico(widget.sector.waterRegime.code);
          }
        }else{
          _regimenHidricos = await DBProvider.db.getAllRegimeWater();
          if (widget.sector != null) {
            _productionStepBloc.changeRegimenHidrico(widget.sector.waterRegime.code);
          }
        }

      }
      if(d == true) {
        if ( await _checkConectivity.checkConnectivity() ){
          _tiposCultivos = await _catalogosRepository.getTiposCultivos();
          if (widget.sector != null) {
            _productionStepBloc.changeTipoCultivo(widget.sector.typeCrop.code);
          }
        }else{
          _tiposCultivos = await DBProvider.db.getAllTypeCrops();
          if (widget.sector != null) {
            _productionStepBloc.changeTipoCultivo(widget.sector.typeCrop.code);
          }
        }

      }
      if (e == true) {
        _productionStepBloc.changeSuperficie(widget?.sector?.superficie?.toString());
      }
      if (f == true) {
        _productionStepBloc.changeVolumenProduccion(widget?.sector?.productionVolumes?.toString());
      }
      if (g == true) {
        _productionStepBloc.changePrecio(widget?.sector?.price?.toString());
      }
      if (h == true) {
        _productionStepBloc.changeValorProduccion(widget?.sector?.productionValue?.toString());
      }
      setState(() {});
    } catch(e) {
      print("Error ");
      print(e );
      CustomFlushbar(
        message: e.toString(),
        flushbarType: FlushbarType.DANGER,
      )..show(context);
    } finally {
      Future.delayed(Duration(seconds: 1)).then((_) { hideLoadingDialog(); });
    }
    _productionStepBloc.changeSectorAgroalimentario(val);
  }

  Widget _buildPrincipalesCultivosEspecies(Size size, String title) {
    return StreamBuilder<String>(
      stream: _productionStepBloc.principalCultivoEspecie,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildPrincipalesCultivosEspecies(
          size: size, title: title, value: snapshot.data, principalesCultivosEspecies: _principalesCultivosEspecies,
          onChanged: (val) async {
            FocusScope.of(context).requestFocus(FocusNode());
            print('PRINCIPAL CULTIVO ESPECIE ');
            _resetStreamsForm2();
            if ( await _checkConectivity.checkConnectivity() ){
              
              try {
                showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
                _productionStepBloc.changePrincipalCultivoEspecie(val);
                _productionStepBloc.changePrincipalProducto(null);
                _principalesProductos = await _catalogosRepository.getPrincipalesProductos(principalCultivoEspecie: val);
                if(val == '19100'){
                  __tipoProductorMiel = await _catalogosRepository.getTypeHoneyProducer();
                 }
                setState(() {});
              } catch (e) {
                CustomFlushbar(
                  flushbarType: FlushbarType.DANGER,
                  message: e.toString(),
                )..show(context);
              } finally {
                hideLoadingDialog();
              }
            }else{
              try {
                showCustomLoadingWidget(CustomLoading(),tapDismiss: false);
                _productionStepBloc.changePrincipalCultivoEspecie(val);
                _productionStepBloc.changePrincipalProducto(null);
                _principalesProductos = await DBProvider.db.getAllPrincipalProductByCode(principalCultivoEspecie: val);
                //offline _tipoProductorMiel
                if(val == '19100'){
                  __tipoProductorMiel = await DBProvider.db.getTypeProducerHoney();
                 }
                setState(() {});
              } catch (e) {
                CustomFlushbar(
                  flushbarType: FlushbarType.DANGER,
                  message: e.toString(),
                )..show(context);
              } finally {
                Future.delayed(Duration(seconds: 1)).then((_) { hideLoadingDialog(); });
              }
            }
          }
        );
      }
    );
  }

  Widget _buildPrincipalesProductos(Size size, Validation v) {
    return StreamBuilder<String>(
      stream: _productionStepBloc.principalProducto,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildPrincipalesProductos(
          size: size, title: v.label, value: snapshot.data, principalesProductos: _principalesProductos,
          onChanged: (val) async {
            FocusScope.of(context).requestFocus(FocusNode());
            _productionStepBloc.changePrincipalProducto(val);
          }
        );
      }
    );
  }
  Widget _buildTipoProductorMiel(Size size) {
    return StreamBuilder<String>(
      stream: _productionStepBloc.typeOfHoneyProducer,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildTipoProductorMiel(
          size: size, title: "Tipo de productor Miel", value: snapshot.data, principalesProductos: __tipoProductorMiel,
          onChanged: (val) async {
            FocusScope.of(context).requestFocus(FocusNode());
            _productionStepBloc.changetypeOfHoneyProducer(val);
            _productionStepBloc.changetypeOfHoneyProducerCode(val);
          }
        );
      }
    );
  }
  Widget _buildNumberOfHives(Size size){
      return StreamBuilder<String>(
      stream: _productionStepBloc.numberOfHives,
      builder: (context, snapshot) {
        return TextFormField(
         initialValue: widget?.sector?.numberOfHives?.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            labelText: "Cantidad de colmenas",
            errorText: snapshot.error
          ),
          onChanged: (val) {
            _productionStepBloc.changeNumberOfHives(val);
            
          },
        );
      }
    );
  }
  Widget _buildAmountOfBellies(Size size){
      return StreamBuilder<String>(
      stream: _productionStepBloc.amountOfBellies,
      builder: (context, snapshot) {
        return TextFormField(
         initialValue: widget?.sector?.amountOfBellies?.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            labelText: "Cantidad de vientres",
            errorText: snapshot.error
          ),
          onChanged: (val) {
            _productionStepBloc.changeAmountOfBellies(val);
            
          },
        );
      }
    );
  }
  Widget _buildNumberOfPlantsHa(Size size){
      return StreamBuilder<String>(
      stream: _productionStepBloc.numberOfPlantsHa,
      builder: (context, snapshot) {
        return TextFormField(
         initialValue: widget?.sector?.numberOfPlantsHa?.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            labelText: "Cantidad de plantas (Ha)",
            errorText: snapshot.error
          ),
          onChanged: (val) {
            _productionStepBloc.changenumberOfPlantsHa(val);
            
          },
        );
      }
    );
  }
  Widget _buildRegimenHidricos(Size size, int sectorId, Validation v) {
    return StreamBuilder<int>(
      stream: _productionStepBloc.regimenHidrico,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildRegimenHidrico(
          size: size, title: v.label, value: snapshot.data, regimenHidricos: _regimenHidricos,
          onChanged: (val) async {
            FocusScope.of(context).requestFocus(FocusNode());
            _productionStepBloc.changeRegimenHidrico(val);
          }
        );
      }
    );
  }

  Widget _buildTiposCultivos(Size size, Validation v) {
    return StreamBuilder<int>(
      stream: _productionStepBloc.tipoCultivo,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildTipoCultivo(
          size: size, title: v.label, value: snapshot.data, tiposCultivos: _tiposCultivos,
          onChanged: (val) async {
            FocusScope.of(context).requestFocus(FocusNode());
            _productionStepBloc.changeTipoCultivo(val);
          }
        );
      }
    );
  }
  
  Widget _buildSuperficie(Size size, Validation validation) {
    return StreamBuilder<String>(
      stream: _productionStepBloc.superficie,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: widget?.sector?.superficie?.toString(),
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2, activatedNegativeValues: false)],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _superficieTextCtrl,
          decoration: InputDecoration(
            labelText: validation.label,
            errorText: snapshot.error
          ),
          validator: (val) => (snapshot.data == null || snapshot?.data?.trim() == "") ? 'Campo requerido' : null,
          onChanged: _productionStepBloc.changeSuperficie,
        );
      }
    );
  }

  Widget _buildVolumenProduccion(Size size, Validation validation) {
    return StreamBuilder<String>(
      stream: _productionStepBloc.volumenProduccion,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: widget?.sector?.productionVolumes?.toString(),
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2, activatedNegativeValues: false)],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _volumenTextCtrl,
          decoration: InputDecoration(
            labelText: validation.label + ' \*',
            errorText: snapshot.error
          ),
         validator: (val) => (snapshot.data == null || snapshot?.data?.trim() == "") ? 'Campo requerido' : null,
          onChanged: (val) {
            _productionStepBloc.changeVolumenProduccion(val);
            _calculateValorProduccion();
          },
        );
      }
    );
  }

  Widget _buildPrecio(Size size, Validation validation) {
    return StreamBuilder<String>(
      stream: _productionStepBloc.precio,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: widget?.sector?.price?.toString(),
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2, activatedNegativeValues: false)],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _precioTextCtrl,
          decoration: InputDecoration(
            labelText: validation.label,
            errorText: snapshot.error
          ),
          validator: (val) => (snapshot.data == null || snapshot?.data?.trim() == "") ? 'Campo requerido' : null,
          onChanged: (val) {
            _productionStepBloc.changePrecio(val);
            _calculateValorProduccion();
          },
        );
      }
    );
  }

  Widget _buildValorProduccion(Size size, Validation validation) {
    return StreamBuilder<String>(
      stream: _productionStepBloc.valorProduccion,
      builder: (context, snapshot) {
        return TextFormField(
          enabled: false,
          inputFormatters: [
            DecimalTextInputFormatter(decimalRange: 2, activatedNegativeValues: false)],
           keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _valorProdTextCtrl,
          decoration: InputDecoration(
            labelText: validation.label,
            errorText: snapshot.error
          ),
          onChanged: _productionStepBloc.changeValorProduccion,
        );
      }
    );
  }

  void _calculateValorProduccion() { 
    if ((_productionStepBloc.volumenProduccionCtrl.value != null && 
      _productionStepBloc.volumenProduccionCtrl.value.trim() != '') &&
      (_productionStepBloc.precioCtrl.value != null && 
      _productionStepBloc.precioCtrl.value.trim() != '')) {
      num volumenProd = num.parse(_productionStepBloc.volumenProduccionCtrl.value);
      num precio = num.parse(_productionStepBloc.precioCtrl.value);
      num valorProd = ( volumenProd * precio);
      String number  = valorProd.toStringAsFixed(2);//get only two decimals
      _productionStepBloc.changeValorProduccion(number);
      _valorProdTextCtrl.text = number;
    } else {
      _productionStepBloc.changeValorProduccion(null);
      _valorProdTextCtrl.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0.0,
        backgroundColor: UiData.colorAppBar,
        title: Image.asset(UiData.imgLogoSiap, width: UiData.widthAppBarLogo)
      ),
      body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Registro de producción', maxLines: 2, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              SizedBox(height: 10.0,),
              Text('Ingresa los siguientes datos.'),
              Form(
                key: _formKeyStep4,
                child: Column(
                  children: <Widget>[
                    _buildSectorAgroalimentario(size),
                    StreamBuilder(
                      stream: _productionStepBloc.sectorAgroalimentario,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          try {
                            List<Widget> widgets = [];
                            SectorAgroalimentario sector = _sectoresAgroalimentarios.firstWhere((s) => s.code == snapshot.data);
                            sector.validation.map((v) async {
                              switch (v.type) {
                                case 1:
                                  if(v.show == true) widgets.add(_buildPrincipalesCultivosEspecies(size, v.label));
                                break;
                                case 2:
                                  if(v.show == true) widgets.add(_buildPrincipalesProductos(size, v));
                                    final val = _productionStepBloc.principalCultivoEspecieCtrl.value;
                                   if(val == '19100' ){
                                    _productionStepBloc.changeAmountOfBellies(null);
                                    _productionStepBloc.changenumberOfPlantsHa(null);
                                    widgets.add(_buildTipoProductorMiel(size));
                                    widgets.add(_buildNumberOfHives(size));
                                  } 
                                  if(val == '12100') {
                                      _productionStepBloc.changetypeOfHoneyProducer(null);
                                      _productionStepBloc.changetypeOfHoneyProducerCode(null);
                                      _productionStepBloc.changeNumberOfHives(null);
                                      _productionStepBloc.changenumberOfPlantsHa(null);
                                      widgets.add(_buildAmountOfBellies(size));
                                  } 
                                  if(val == '57000'){
                                    _productionStepBloc.changetypeOfHoneyProducer(null);
                                    _productionStepBloc.changetypeOfHoneyProducerCode(null);
                                    _productionStepBloc.changeNumberOfHives(null);
                                    _productionStepBloc.changeAmountOfBellies(null);
                                    widgets.add(_buildNumberOfPlantsHa(size));
                                  };
                                  if( val != '57000' && val != '12100' && val != '19100'){
                                    print("AQUI ?");
                                    _productionStepBloc.changetypeOfHoneyProducer(null);
                                      _productionStepBloc.changetypeOfHoneyProducerCode(null);
                                      _productionStepBloc.changeNumberOfHives(null);
                                      _productionStepBloc.changenumberOfPlantsHa(null);
                                      _productionStepBloc.changeAmountOfBellies(null);
                                  }
                                break;
                                case 3:
                                  if(v.show == true) widgets.add(_buildRegimenHidricos(size, sector.code, v));
                                break;
                                case 4:
                                  if(v.show == true) widgets.add(_buildTiposCultivos(size, v));
                                break;
                                case 5:
                                  if(v.show == true) widgets.add(_buildSuperficie(size, v));
                                break;
                                case 6:
                                  if(v.show == true) widgets.add(_buildVolumenProduccion(size, v));
                                break;
                                case 7:
                                  if(v.show == true) widgets.add(_buildPrecio(size, v));
                                break;
                                case 8:
                                  if(v.show == true) widgets.add(_buildValorProduccion(size, v));
                                break;
                                default:
                                break;
                              }
                            }).toList();
                            return Column( children: widgets );
                          } catch (e) {
                            CustomFlushbar(
                              flushbarType: FlushbarType.DANGER,
                              message: e.toString(),
                            )..show(context);
                            return Container();
                          } 
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SizedBox(height: 40.0),
                    Center(
                      child: Container(
                        height: UiData.heightMainButtons - 10,
                        width: size.width * 0.5,
                        child: RaisedButton(
                          color: UiData.colorPrimary,
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          child: Text("Siguiente", style: TextStyle(color: Colors.white)),
                        )
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }

  void _submit() {
    if (_formKeyStep4.currentState.validate()) {
      final produccion = Produccion();
      if(_productionStepBloc.sectorAgroalimentarioCtrl.hasValue && _productionStepBloc.sectorAgroalimentarioCtrl.value != null) {
        final sector = _sectoresAgroalimentarios.firstWhere((s) => s.code == _productionStepBloc.sectorAgroalimentarioCtrl.value);
        produccion.foodIndustry = sector;
      }
      if(_productionStepBloc.principalCultivoEspecieCtrl.hasValue && _productionStepBloc.principalCultivoEspecieCtrl.value != null) {
        final cultivoEspecie = _principalesCultivosEspecies.firstWhere((pc) => pc.code == _productionStepBloc.principalCultivoEspecieCtrl.value);
        produccion.mainCrop = GenericData<String>(
          code: cultivoEspecie.code, name: cultivoEspecie.name
        );
      }
      if(_productionStepBloc.principalProductoCtrl.hasValue && _productionStepBloc.principalProductoCtrl.value != null) {
        final principalProducto = _principalesProductos.firstWhere((s) => s.code == _productionStepBloc.principalProductoCtrl.value);
        produccion.mainProduct = GenericData<String>(
          code: principalProducto.code, name: principalProducto.name
        );
      }
      if(_productionStepBloc.regimenHidricoCtrl.hasValue && _productionStepBloc.regimenHidricoCtrl.value != null) {
        final regimen = _regimenHidricos.firstWhere((s) => s.code == _productionStepBloc.regimenHidricoCtrl.value);
        produccion.waterRegime = GenericData<int>(
          code: regimen.code, name: regimen.name
        );
      }
      if(_productionStepBloc.tipoCultivoCtrl.hasValue && _productionStepBloc.tipoCultivoCtrl.value != null) {
        final tipoCultivo = _tiposCultivos.firstWhere((s) => s.code == _productionStepBloc.tipoCultivoCtrl.value);
        produccion.typeCrop = GenericData<int>(
          code: tipoCultivo.code, name: tipoCultivo.name
        );
      }
      if(_productionStepBloc.typeOfHoneyProducerCtrl.hasValue && _productionStepBloc.typeOfHoneyProducerCtrl.value != null){
        final typeOfHoneyProducer = __tipoProductorMiel.firstWhere((s) => s.code == _productionStepBloc.typeOfHoneyProducerCtrl.value);
        produccion.typeOfHoneyProducer = GenericData<String>(
          code: typeOfHoneyProducer.code,
          name:typeOfHoneyProducer.name
          );
       // print(produccion.typeOfHoneyProducer.toJson().toString());
      }
      if (_productionStepBloc.typeOfHoneyProducerCodeCtrl.hasValue && _productionStepBloc.typeOfHoneyProducerCodeCtrl.value != null) {
        produccion.typeOfHoneyProducerCode = _productionStepBloc.typeOfHoneyProducerCodeCtrl.value;
      }
      if (_productionStepBloc.numberOfHivesCtrl.hasValue && _productionStepBloc.numberOfHivesCtrl.value != null) {
        produccion.numberOfHives = num.parse(_productionStepBloc.numberOfHivesCtrl.value);
      }
      
      if (_productionStepBloc.amountOfBelliesCtrl.hasValue && _productionStepBloc.amountOfBelliesCtrl.value != null) {
        produccion.amountOfBellies = num.parse(_productionStepBloc.amountOfBelliesCtrl.value);
      }
      
      if (_productionStepBloc.numberOfPlantsHaCtrl.hasValue && _productionStepBloc.numberOfPlantsHaCtrl.value != null) {
        produccion.numberOfPlantsHa = num.parse(_productionStepBloc.numberOfPlantsHaCtrl.value);
      }


      if (_productionStepBloc.superficieCtrl.hasValue && _productionStepBloc.superficieCtrl.value != null) {
        produccion.superficie = num.parse(_productionStepBloc.superficieCtrl.value);
      }
      if (_productionStepBloc.volumenProduccionCtrl.hasValue && _productionStepBloc.volumenProduccionCtrl.value != null) {
        produccion.productionVolumes = num.parse(_productionStepBloc.volumenProduccionCtrl.value);
      }
      if (_productionStepBloc.precioCtrl.hasValue && _productionStepBloc.precioCtrl.value != null) {
        produccion.price = num.parse(_productionStepBloc.precioCtrl.value);
      }
      if (_productionStepBloc.valorProduccionCtrl.hasValue && _productionStepBloc.valorProduccionCtrl.value != null) {
        produccion.productionValue = num.parse(_productionStepBloc.valorProduccionCtrl.value);
      }
      Navigator.of(context).pop(produccion);
    } else {
      showDialog(
        builder: (context) => PlatformMessage(
          title: "Información incompleta",
          content: "Todos los datos son requeridos",
          okPressed: () => Navigator.of(context).pop()
        ), context: context
      );
    }
  }

  _resetStreamsForm() {
    _productionStepBloc.changeSectorAgroalimentario(null);
    _productionStepBloc.changePrincipalCultivoEspecie(null);
    _productionStepBloc.changePrincipalProducto(null);
    _productionStepBloc.changeRegimenHidrico(null);
    _productionStepBloc.changeTipoCultivo(null);
    _productionStepBloc.changeSuperficie(null);
    _productionStepBloc.changeVolumenProduccion(null);
    _productionStepBloc.changePrecio(null);
    _productionStepBloc.changeValorProduccion(null);
    _precioTextCtrl.text = "";
    _volumenTextCtrl.text = "";
    _superficieTextCtrl.text = "";
    _valorProdTextCtrl.text = "";
  }
  _resetStreamsForm2() {
    
    _productionStepBloc.changeSuperficie(null);
    _superficieTextCtrl.text = "";
    _productionStepBloc.changeVolumenProduccion(null);
    _volumenTextCtrl.text = "";
    _productionStepBloc.changePrecio(null);
    _precioTextCtrl.text = "";
    _productionStepBloc.changeValorProduccion(null);
    //_productionStepBloc.precioCtrl.value = "";
    _valorProdTextCtrl.text = "";
  }

  @override
  void dispose() {
    _resetStreamsForm();
    _valorProdTextCtrl.dispose();
    super.dispose();
  }

}