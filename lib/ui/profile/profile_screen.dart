import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/try_again.dart';
import 'package:siap/utils/ui_data.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserModel _userModel = UserSingleton.instance.user;
  CatalogosRepository _catalogosRepository = CatalogosRepository();

  List<GenericData<String>> _estados = [];
  List<GenericData<String>> _municipios = [];
  List<GenericData<String>> _localidades = [];
  List<GenericData<String>> _centrosIntegradores = [];

  bool _tryAgain = false;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    try {
      _tryAgain = false;
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      _estados = await _catalogosRepository.getEstados();
      if(_userModel.entidadFederativa != null) {
        _municipios = await _catalogosRepository.getMunicipios(codigoEstado: _userModel.entidadFederativa);
        if(_userModel.municipio != null) {
          _localidades = await _catalogosRepository.getLocalidades(codigoEstado: _userModel.entidadFederativa, codigoMunicipio: _userModel.municipio);
          _centrosIntegradores = await _catalogosRepository.getCentrosIntegradores(codigoEstado: _userModel.entidadFederativa);
        }
      }      
    } catch(e) {
      _tryAgain = true;
    } finally {
      hideLoadingDialog();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0.0,
        backgroundColor: UiData.colorAppBar,
        title: Image.asset(UiData.imgLogoSiap, width: UiData.widthAppBarLogo),
      ),
      body: (_tryAgain == true) ? TryAgain(onPressed: _initData) : _buildProfile(),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Padrón georreferenciado de productores del sector agroalimentario", textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 30.0),
            Text("Tipo de persona ${(_userModel.tipoPersona == 1) ? 'Física' : 'Moral'}, estatus validado.", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  (_userModel.rfc != null) ?
                    Text("RFC:  ${_userModel.rfc ?? UiData.msgNotAvailable}")
                    : Container(),
                  SizedBox(height: 10.0),
                  (_userModel.curp != null) ?
                    Text("Curp:  ${_userModel.curp ?? UiData.msgNotAvailable}")
                    : Container(),
                  SizedBox(height: 10.0),
                  (_userModel.entidadFederativa != null && _estados.length > 0) ?
                    Text("Entidad:  ${_estados.firstWhere((e) => e.code == _userModel.entidadFederativa).name ?? UiData.msgNotAvailable}") 
                    : Container(),
                  SizedBox(height: 10.0),
                  (_userModel.municipio != null && _municipios.length > 0) ?
                    Text("Municipio:  ${_municipios.firstWhere((e) => e.code == _userModel.municipio).name ?? UiData.msgNotAvailable}")
                    : Container(),
                  SizedBox(height: 10.0),
                  (_userModel.localidad != null && _localidades.length > 0) ?
                    Text("Localidad:  ${_localidades.firstWhere((e) => e.code == _userModel.localidad).name ?? UiData.msgNotAvailable}")
                    : Container(),
                  SizedBox(height: 10.0),
                  (_userModel.centroIntegrador != null && _centrosIntegradores.length > 0) ?
                    Text("Centro integrador:  ${_centrosIntegradores.firstWhere((e) => e.code == _userModel.centroIntegrador).name ?? UiData.msgNotAvailable}")
                    : Container(),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            _buildSectoresAgroalimentarios()
          ],
        ),
      ),
    );
  }

  Widget _buildSectoresAgroalimentarios() {
    return Column(
      children: _userModel.produccion.map((p) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Sector ${p.foodIndustry?.name ?? ''}", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (p.mainCrop?.name != null) ?
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text("Principal cultivo/especie:  ${p.mainCrop?.name ?? ''}", textAlign: TextAlign.center)
                  ) : Container(),                  
                  (p.waterRegime?.name != null) ?
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text("Régimen hídrico:  ${p.waterRegime?.name ?? ''}", textAlign: TextAlign.center)
                  ) : Container(),                  
                  (p.mainProduct?.name != null) ?
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text("Principal producto:  ${p.mainProduct?.name ?? ''}", textAlign: TextAlign.center)
                  ) : Container(),                  
                  (p.typeCrop?.name != null) ?
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text("Tipo de cultivo: ${p.typeCrop?.name ?? ''}", textAlign: TextAlign.center)
                  ) : Container(),
                  SizedBox(height: 20.0)
                ],
              ),
            )
          ],
        );
      }).toList(),
    );
  }

}