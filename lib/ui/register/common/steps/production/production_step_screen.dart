import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load/load.dart';
import 'package:siap/blocs/register/common/production_step_bloc.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/register/common/steps/production/add_production_screen.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/ui_data.dart';

class ProductionStepScreen extends StatefulWidget {
  final Function prevStep;
  final Function nextStep;
  ProductionStepScreen({@required this.prevStep, @required this.nextStep});
  @override
  _ProductionStepScreenState createState() => _ProductionStepScreenState();
}

class _ProductionStepScreenState extends State<ProductionStepScreen>  with AutomaticKeepAliveClientMixin {
  UserModel _userModel = UserSingleton.instance.user;
  ProductionStepBloc _productionStepBloc;
  HomeRepository _homeRepository = HomeRepository();

  CatalogosRepository _catalogosRepository = CatalogosRepository();
  List<SectorAgroalimentario> _sectoresAgroalimentarios = [];
  List<Produccion> _produccionList = [];
    CheckConectivity _checkConectivity = CheckConectivity();
  @override
  void initState() {
    print("produccion");
    print(_userModel.produccion.length );
    _produccionList = _userModel.produccion ?? [];
    super.initState();
    _productionStepBloc = BlocProvider.of<ProductionStepBloc>(context);
    _initData();
  }

  _initData() async {
    showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    if ( await _checkConectivity.checkConnectivity() ) {
      try {
        if(_userModel.tipoPersona == 1 ){
            if(_userModel.curp != null )
              await _homeRepository.getParcelas(  curp: _userModel.curp);
          }else {
            if( _userModel.rfc != null)
            await _homeRepository.getParcelas2(  rfc: _userModel.rfc);
        }
        _sectoresAgroalimentarios = await _catalogosRepository.getSectorAgroalimentario();
        if (_userModel.produccion.length > 0) {
          for (Produccion prod in _userModel.produccion) {
            if (prod.foodIndustry != null) {
              prod.foodIndustry = _sectoresAgroalimentarios.firstWhere((sa) => sa.code == prod.foodIndustry.code);
              _sectoresAgroalimentarios = _sectoresAgroalimentarios.where((sa) => sa.code != prod.foodIndustry.code).toList();
            }
          }
        }
        setState(() {});
      } catch(e) {
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        hideLoadingDialog();
      }
    }else{
      print("Offline-mode");

      try {
        _sectoresAgroalimentarios = await DBProvider.db.getFoodIndustry();
        if (_userModel.produccion.length > 0) {
          for (Produccion prod in _userModel.produccion) {
            if (prod.foodIndustry != null) {
              prod.foodIndustry = _sectoresAgroalimentarios.firstWhere((sa) => sa.code == prod.foodIndustry.code);
              _sectoresAgroalimentarios = _sectoresAgroalimentarios.where((sa) => sa.code != prod.foodIndustry.code).toList();
            }
          }
        }
        setState(() {});
      } catch(e) {
        print("Error");
        print(e);
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        Future.delayed(Duration(seconds: 1)).then((_) { hideLoadingDialog(); });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    _produccionList = _userModel.produccion ?? [];
    _productionStepBloc.changeProduccion(_produccionList);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Registro de producción', maxLines: 2, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              SizedBox(height: 10.0,),
              Text('Ingresa la información de tus sectores agroalimentarios.'),
              SizedBox(height: 10.0),
              Column(
                children: _produccionList.map((pl) {
                  return ListTile(
                    onTap: () => _editSector(pl),
                    contentPadding: EdgeInsets.all(0.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(pl?.foodIndustry?.name?.substring(0,2)?.toUpperCase() ?? "N/D", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(pl?.foodIndustry?.name ?? "N/D"),
                    trailing: InkWell(
                      onTap: () {
                        print('ID-PROD');
                        print(pl.foodIndustry.code);
                        showDialog(
                          builder: (context) => PlatformMessage(
                            title: "Eliminar",
                            content: "Eliminar sector agroalimentario",
                            cancelPressed: () => Navigator.of(context).pop(),
                            okPressed: () async {
                              Navigator.of(context).pop();
                              _produccionList.remove(pl);
                              // _removeFilesBySector(pl);
                              try {
                                await DBProvider.db.deleteParcelaByCategory(categoryId:pl.foodIndustry.code );
                              } catch (e) {
                              }
                              _productionStepBloc.changeProduccion(_produccionList);
                              _sectoresAgroalimentarios.add(pl.foodIndustry);
                              setState(() {});
                            },
                          ), context: context
                        );
                      },
                      child: Icon(FontAwesomeIcons.trash, color: Colors.red),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 40.0),
              Container(
                width: size.width,
                height: UiData.heightMainButtons,
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                  ),
                  color: Colors.black,
                  icon: Icon(Icons.plus_one, color: Colors.white),
                  label: Flexible(child: Text("Nuevo sector agroalimentario", maxLines: 2, style: TextStyle(color: Colors.white))),
                  onPressed: (_sectoresAgroalimentarios.length == 0) ? null : () async {
                    final Produccion sector = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProductionScreen(sectoresAgroalimentarios: _sectoresAgroalimentarios, productionStepBloc: _productionStepBloc)));
                    if(sector != null) {
                      _produccionList.add(sector);
                      _productionStepBloc.changeProduccion(_produccionList);
                      _sectoresAgroalimentarios = _sectoresAgroalimentarios.where((sa) => sa.code != sector.foodIndustry.code).toList();
                    }
                  }
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 100.0,
                height: UiData.heightMainButtons,
                child: RaisedButton(
                  color: Colors.black,
                  onPressed: widget.prevStep,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                  ),
                  child: Text("Atrás", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: Container(
                  height: UiData.heightMainButtons,
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
          ),
        ),
      ),
    );
  }

  void _editSector(Produccion pl) async {
    // Agregamos el item actual a las opciones disponibles en los sectores
    _sectoresAgroalimentarios.add(pl.foodIndustry);
    // Mostramos la siguiente vista
    final Produccion sector = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => 
      AddProductionScreen(
        sectoresAgroalimentarios: _sectoresAgroalimentarios, 
        productionStepBloc: _productionStepBloc,
        sector: pl,
      )));
    if(sector != null) {
      // Actualiza el sector actual por el que regresa de la vista
      for (int i = 0; i < _produccionList.length; i ++) {
        if (_produccionList[i].foodIndustry.code == pl.foodIndustry.code) {
          _produccionList[i] = sector;
          break;
        }
      }
      _productionStepBloc.changeProduccion(_produccionList);
    }
    // Quitamos el sector de las opciones disponibles
    _sectoresAgroalimentarios = _sectoresAgroalimentarios.where((sa) => sa.code != pl.foodIndustry.code).toList();
  }

  /// Itera los archivos y settea el valor a null
  /// de los ids y archivos correspondiente al sector que se desea eliminar.
  /* void _removeFilesBySector(Produccion produccion) {
    for (FilesFoodIndustry fileFoodInd in _userModel.filesFoodIndustry) {
      if (fileFoodInd.code == produccion.foodIndustry.code) {
        for (FIDocument doc in fileFoodInd.doc) {
          doc.fileId = null;
          doc.file = null;
        }
      }
    }
  } */

  void _submit() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_produccionList.length <= 0) {
      showDialog(
        builder: (context) => PlatformMessage(
          title: "Información incompleta",
          content: "Debes de tener al menos 1 sector agroalimentario",
          okPressed: () => Navigator.of(context).pop()
        ), context: context
      );
    } else {
      widget.nextStep();
    }
  }

  @override
  bool get wantKeepAlive => true;
}