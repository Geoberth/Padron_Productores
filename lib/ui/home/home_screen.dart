import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap/models/offline/parcela_offline.dart';
import 'package:siap/models/geolocation-list/geolocation_model_list.dart';
import 'package:siap/models/pdf/pdf_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/repository/utils/utils_repository.dart';
import 'package:siap/ui/map/map_polygon_screenv2.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:latlong/latlong.dart';
class TipoParcela {
  static const int shape = 1, kml = 2, kmz = 3, georeferencia = 4, poligono = 5;
}

class StatusSiap {
  static const int pendiente = 0, autorizado = 1, rechazado = 2,offline=3;
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SlidableController slidableController = SlidableController();
  RegisterRepository _registerRepository = RegisterRepository();
  UtilsRepository _utilsRepository = UtilsRepository();
  HomeRepository _homeRepository = HomeRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserModel _userModel = UserSingleton.instance.user;
  CheckConectivity _checkConectivity = CheckConectivity();
  List<Parcela> parcelas = [];
  List<ParcelaOffline> parcelasOffline = [];
  bool isLoading = false;
  int idTemp = 1234;
  @override
  void initState()  {
    print('WELCOME TO HOME');
    super.initState();
   
     _initData();
  }

  _initData() async {
bool net =  await _checkConectivity.checkConnectivity();
  
  
    await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    
    if ( net ) {
     _refreshData();
      try{
        isLoading = true;
        if(_userModel.id != null ){
          if(_userModel.tipoPersona == 1 ){
            parcelas = await _homeRepository.getParcelas(  curp: _userModel.curp);
          }else {
            parcelas = await _homeRepository.getParcelas2(  rfc: _userModel.rfc);
          }
          
          await DBProvider.db.setUpdateParcela(userIdTemp: idTemp, userId: _userModel.id);
          parcelasOffline = await   DBProvider.db.getAllParcela(userId:_userModel.id);

        }
        isLoading = false;
        setState(() {});
      }catch(e){
        print("Error ");
        print(e.toString());
      }finally{
        Future.delayed(Duration(seconds: 2 )).then((_) { hideLoadingDialog();});
      }
    }else{
      
      try{
        
        isLoading = true;
        // if(_userModel.id != null ){
        //   parcelasOffline = await DBProvider.db.getAllParcela(userId:_userModel.id);
        // }
        _refreshListOffline();
        isLoading = false;

        setState(() {});
      }catch(e){
        print("Error ");
        print(e.toString());
        /* CustomFlushbar(
        flushbarType: FlushbarType.DANGER,
        message: e.toString(),
      )..topBar().show(context);*/
      }finally{
        print("Second Loading ");
        Future.delayed(Duration(seconds: 2 )).then((_) { hideLoadingDialog();});
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          elevation: 0.0,
          backgroundColor: UiData.colorAppBar,
          title: Image.asset(UiData.imgLogoSiap, width: UiData.widthAppBarLogo),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pushNamed(UiData.routeHelp),
            icon: Icon(FontAwesomeIcons.infoCircle, color: Colors.green),
          ),
          actions: <Widget>[
            IconButton(
              onPressed:()=> _closeSession(),
                icon: Icon(FontAwesomeIcons.signOutAlt, color: Colors.grey),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMessage(size,  context)
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return Slidable(
                          key: Key(index.toString()),
                          controller: slidableController,
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () => _showDetails(parcelas[index]),
                              trailing: _buildCategory(int.parse(parcelas[index].categoryId)),
                              leading: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.black),
                              title: Text((_userModel.tipoPersona == 1) ? _userModel.nombre ?? "N/D" : _userModel.razonSocial ?? "N/D"),
                              subtitle: Text(_userModel.rfc ?? "N/D"),
                            ),
                          ),
                          secondaryActions: <Widget>[
                            (_userModel?.validacion  != StatusSiap.autorizado)?
                            IconSlideAction(
                              caption: 'Eliminar',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                await _deleteParcela(parcelas[index]);
                                parcelas.removeAt(index);
                                setState(() {});
                              },
                            ):Container(),
                          ],
                        );
                      },
                      childCount: parcelas.length
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([

                    _titleListOffline()
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return Slidable(
                          key: Key(index.toString()),
                          controller: slidableController,
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () => _parcelaOfflineToServer(parcelasOffline[index],index),
                             //trailing: _buildCategory(parcelasOffline[index].categoryId),
                              leading: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.black),
                              title: Text((_userModel.tipoPersona == 1) ? _userModel.nombre ?? "N/D" : _userModel.razonSocial ?? "N/D"),
                              subtitle: Text(_userModel.rfc ?? "N/D"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                
                                  
                                  InkWell(
                                    onTap: () async {

                                    },
                                    child:  Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4.0),
                                           color: Colors.green
                                      ),
                                      child: Text(_listTilw(parcelasOffline[index].categoryId), style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  InkWell(
                                onTap: () async {
                                 await _parcelaOfflineToServer(parcelasOffline[index],index);
                                },
                                  child: Icon(FontAwesomeIcons.cloudUploadAlt, color: Colors.green, size: 20.0,),
                                ),
                                ],

                              ),
                            ),

                          ),
                          secondaryActions: <Widget>[
                            (_userModel?.validacion  != StatusSiap.autorizado)?
                            IconSlideAction(
                              caption: 'Eliminar',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                await _deleteParcelaOffline(parcelasOffline[index]);
                                parcelasOffline.removeAt(index);
                               setState(() {});
                              },
                            ):Container(),
                          ],
                        );
                      },
                      childCount: parcelasOffline.length
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: (_userModel?.validacion == StatusSiap.autorizado) ?
          FloatingActionButton(
            backgroundColor: Colors.black,
            mini: true,
            heroTag: null,
            onPressed: () => Navigator.of(context).pushNamed(UiData.routeProfile),
            child: Icon(Icons.person_outline, color: Colors.white),
          ) : Container(),
          bottomNavigationBar:(_userModel?.validacion == StatusSiap.autorizado) ?
           Container(child:Text("")):_buildBottomOptions()
      
    );
  }
  _closeSession() async{
    if (_userModel.id == null) {
      showDialog(
                  builder: (context) => PlatformMessage(
                      title: "Importante",

                      content: "Si aún no haz sincronizado tu información  la información registrada se perderá, ¿estás seguro de salir? ",
                      cancelPressed: () => Navigator.of(context).pop(),
                      cancelLabel: "No",
                      okLabel: "Si",
                      okPressed: () async {
                        await _registerRepository.signOut();
                        await DBProvider.db.deleteParcelasAll(list:parcelasOffline, idUser: idTemp);
                        await DBProvider.db.deleteParcelasAll(list:parcelasOffline, idUser: _userModel.id);
                        Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeTypePerson, (e) => false);
                      }
                  ), context: context
                ); 
    }else{
      showDialog(
                  builder: (context) => PlatformMessage(
                      title: "Cerrar sesión",
                      content: "El registro en el padrón georreferenciado de productores del sector agroalimentario no garantiza el acceso a ningún incentivo, requiere estar pendiente en su ventanilla más cercana.",
                      cancelPressed: () => Navigator.of(context).pop(),
                      cancelLabel: "No",
                      okLabel: "Si",
                      okPressed: () async {
                        await _registerRepository.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeLogin, (e) => false);
                      }
                  ), context: context
                );  
    }
                    
  }
   _titleListOffline(){
    return   RichText(
      textAlign:TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: [
          (parcelasOffline.length > 0 )?
          TextSpan(text: 'Georreferencia almacenada en tu teléfono celular, presiona el botón( ',style: TextStyle(fontWeight: FontWeight.bold)):TextSpan(text: ""),
          (parcelasOffline.length > 0 )?
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(FontAwesomeIcons.cloudUploadAlt,color: Colors.green, size: 20.0),
            ),
          ):TextSpan(text: ""),
          (parcelasOffline.length > 0 )?
          TextSpan(text: '  ) en cuando tengas conexión a internet', style: TextStyle(fontWeight: FontWeight.bold)):TextSpan(text: ""),
        ],
      ),
    );

  }
  _listTilw(int categoryId){
    String textLabel = "";
    switch(categoryId) {
      case TipoParcela.georeferencia:
       return textLabel = "Georreferencia";
        break;
      case TipoParcela.poligono:
        return textLabel = "Polígono";
        break;
      case TipoParcela.kml:
        return textLabel = "Kml";
        break;
      case TipoParcela.kmz:
        return textLabel = "Kmz";
        break;
      case TipoParcela.shape:
        return  textLabel = "Shape";
        break;
      default:
        return  textLabel = "";
        break;
    }
  }
  Widget _buildCategory( int categoryId) {
    String textLabel = "";
   // int category = int.parse(categoryId);
    switch(categoryId) {
      case TipoParcela.georeferencia:
        textLabel = "Georreferencia";
        break;
      case TipoParcela.poligono:
        textLabel = "Polígono";
        break;
      case TipoParcela.kml:
        textLabel = "Kml";
        break;
      case TipoParcela.kmz:
        textLabel = "Kmz";
        break;
      case TipoParcela.shape:
        textLabel = "Shape";
        break;
      default:
        textLabel = "";
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.green
      ),
      child: Text(textLabel, style: TextStyle(color: Colors.white)),
    );
  }
  Future<bool> futureTime(visible)async {
    if(visible >= 1) {
      bool val = await  _checkConectivity.checkConnectivity();
      await new Future.delayed(const Duration(seconds: 3),(){});
      return val;

    }
    return false;
  }
  Widget _buildMessage(Size size,BuildContext context) {
    //_refreshListOffline();
    print('_buildMessage');
    print(_userModel?.validacion);
    switch(_userModel?.validacion) {
      case StatusSiap.pendiente:
        return Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              (parcelas.length > 0) ?
              Text("Su registro se ha completado exitosamente y se encuentra en proceso de validación por personal responsable de ventanilla.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))
                  : (isLoading == false) ?
              Column(children: <Widget>[
               
                Text("Completa tu registro en el padrón georreferenciado de productores del sector agroalimentario.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text("La información que registres será validada por personal responsable de ventanilla.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ]) : Container(),
              
              Container(
                height: 40.0,
                margin: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                  ),
                  color: Colors.black,
                  onPressed: _goToUpdatedData,
                  child: Text("Actualizar mi información", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
        break;
      case StatusSiap.autorizado:
        return Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Registro validado", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
        );
        break;
      case StatusSiap.rechazado:
        return Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Verificar la información", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              Text("Verifica y actualiza tu información para ser validada, las observaciones fueron enviadas a ${_userModel.email}.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              //SizedBox(height: 10.0),
              //Text(_userModel?.comentario ?? ''),
              SizedBox(height: 10.0),
              Container(
                height: 40.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                  ),
                  color: Colors.black,
                  onPressed: _goToUpdatedData,
                  child: Text("Actualizar información", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
        break;
      case StatusSiap.offline:
       int visible = 0;
        return Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Tu información está almacenada en tu teléfono celular.",textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              Text("De clic en el botón Sincronizar en cuanto tenga conexión a internet", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              //SizedBox(height: 10.0),
              //Text(_userModel?.comentario ?? ''),
              SizedBox(height: 10.0),
              
              Container(
                height: 40.0,
                child: RaisedButton(
                  
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                  ),
                  color: Colors.black,
                  onPressed:() async { await  _gotToUpdateoffline();},
                  child: Text("Sincronizar información", style: TextStyle(color: Colors.white)),
                ),
              ),

              
              SizedBox(height: 10.0),

               Container(
                height: 40.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                  ),
                  color: Colors.black,
                  onPressed: _goToUpdatedData,
                  child: Text("Actualizar información ", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
       
        break;
      default:
        return Container(margin: EdgeInsets.all(16.0), child: Text("Al parecer no se ha podido obtener correctamente tu información."));
    }
  }
  
  _buildBottomOptions() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                height: 40.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                  ),
                  color: UiData.colorPrimary,
                  onPressed: () {
                    if (_userModel.produccion.length > 0) {
                      _optionsModalBottomSheet();
                    } else {
                      showDialog(
                          builder: (context) => PlatformMessage(
                              title: "Mensaje",
                              content: "Es necesario contar con al menos un sector agroalimentario para poder agregar georreferencias.",
                              okPressed: () => Navigator.of(context).pop()
                          ), context: context
                      );
                      return null;
                    }
                  },
                  child: Text("Nueva georreferencia", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                ),
              )
          ),
        ],
      ),
    );
  }

  void _optionsModalBottomSheet(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc){
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.pin_drop, color: Colors.black),
                    title: Text('Coordenadas'),
                    onTap: () async {
                      if (await _checkConectivity.checkConnectivity()) {
                        if(_userModel.id != null){
                            Navigator.of(context).pop();
                            final sectorCode = await _getSectorCode();
                            if(sectorCode != null) {
                              _showCoordenadas(sectorCode);
                              
                            }
                        }else{
                          _messageUpload();
                        }
                        
                      }else{
                        
                        final sectorCode = await _getSectorCode();
                        if (sectorCode != null ) {
                        await  showCustomLoadingWidget(CustomLoadingLocation(message: "Coordenada",), tapDismiss: false);
                       print("location is LatLng");
                        Position location = await Geolocator().getCurrentPosition();
                        final ubicacion = LatLng(location.latitude, location.longitude);
                        if(ubicacion is LatLng) {
                          
                          String itemParcela = "${ubicacion.latitude}, ${ubicacion.longitude}";
                          _addParcelaOffline(TipoParcela.georeferencia, itemParcela, sectorCode);
                          
                        }
                        Future.delayed(Duration(seconds: 1)).then((_) { hideLoadingDialog(); });
                        }
                        
                      }

                    }
                ),
                ListTile(
                  leading: Icon(Icons.map, color: Colors.black),
                  title: Text('Polígono'),
                  onTap: () async {
                    if (await _checkConectivity.checkConnectivity()){
                      if(_userModel.id != null){
                        Navigator.of(context).pop();
                      final sectorCode = await _getSectorCode();
                      if(sectorCode != null) {
                        final success = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PolygonPage(sectorCode: sectorCode)));
                        if(success != null) {
                          await _refreshData();
                        }
                      }
                      }else{
                        _messageUpload();
                      }
                      
                    }else{
                      Flushbar(
                        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
                        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
                        isDismissible: true, duration: Duration(seconds: 8),
                        icon: Icon(Icons.close,color: Colors.white,),
                        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                        messageText: Text("Esta Funcionalidad no esta disponible en modo Offline", style: TextStyle(color: Colors.white)),
                      )..show(context);
                    }

                  },
                ),
                ListTile(
                  leading: Icon(Icons.featured_play_list, color: Colors.black),
                  title: Text('Archivo KML'),
                  onTap: () async {
                    
                      if ( await _checkConectivity.checkConnectivity() ){
                        if(_userModel.id != null){
                          Navigator.of(context).pop();
                         final sectorCode = await _getSectorCode();
                         if(sectorCode != null) {
                           PdfModel kml = await _utilsRepository.filePicker(_scaffoldKey, "kml", maxMBfileSize: 10);
                           if(kml != null) {
                              await _addParcela(2, kml.base64, sectorCode);
                              await _refreshData();
                            }
                            }
                         }else{  _messageUpload(); }
                        
                      }else{
                          Navigator.of(context).pop();
                         final sectorCode = await _getSectorCode();
                         if(sectorCode != null) {
                           PdfModel kml = await _utilsRepository.filePicker(_scaffoldKey, "kml", maxMBfileSize: 10);
                           if(kml != null) {
                              await _addParcelaOffline(2, kml.base64, sectorCode);
                              //await _refreshData();
                            }
                            }
                      }


                  },
                ),
                ListTile(
                  leading: Icon(Icons.featured_play_list, color: Colors.black),
                  title: Text('Archivo KMZ'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final sectorCode = await _getSectorCode();
                    if(sectorCode != null) {
                      PdfModel kmz = await _utilsRepository.filePicker(_scaffoldKey, "kmz", maxMBfileSize: 10);
                       if ( await _checkConectivity.checkConnectivity() ) {
                         if(_userModel.id != null){
                            if (kmz != null) {
                           await _addParcela(3, kmz.base64, sectorCode);
                           await _refreshData();
                         }
                         }else{
                           _messageUpload();
                         }
                         
                       }else{
                         if (kmz != null){
                           await _addParcelaOffline(3, kmz.base64, sectorCode);
                         }
                       }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.featured_play_list, color: Colors.black),
                  title: Text('Shape (Archivo zip)'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final sectorCode = await _getSectorCode();
                    if(sectorCode != null) {
                      PdfModel shape = await _utilsRepository.filePicker(_scaffoldKey, "zip", maxMBfileSize: 5);
                        if ( await _checkConectivity.checkConnectivity() ) {
                          if(_userModel.id != null){
                            if (shape != null) {
                            await _addParcela(1, shape.base64, sectorCode);
                            await _refreshData();
                          }
                          }else{
                             _messageUpload();
                          }
                          
                        }else{
                          if (shape != null) {
                            await _addParcelaOffline(1, shape.base64, sectorCode);
                          }
                        }
                    }
                  },
                ),
              ],
            ),
          );
        }
    );
  }
  _messageUpload(){
    showDialog( builder: (context) => PlatformMessage( title: "Mensaje",content: "Es necesario sincronizar informacion.", okPressed: () => Navigator.of(context).pop()), context: context);
      return null;
  }
  Future<int> _getSectorCode({Function callback}) async {
    if (_userModel.produccion.length > 0) {
      final sectorCode = await Navigator.of(context).pushNamed(UiData.routeSector);
      if(sectorCode != null) {
        return sectorCode;
      }
      return null;
    } else {
      showDialog(
          builder: (context) => PlatformMessage(
              title: "Mensaje",
              content: "Es necesario contar con almenos un sector agroalimentario para poder agregar georreferencias.",
              okPressed: () => Navigator.of(context).pop()
          ), context: context
      );
      return null;
    }
  }

  void _showCoordenadas(int sectorCode) async {
     Map<String, dynamic> params = { "latitude": null,"longitude":null };
    final ubicacion = await Navigator.of(context).pushNamed(UiData.routeMaps,arguments: params);
    if(ubicacion is LatLng) {
      String itemParcela = "${ubicacion.latitude}, ${ubicacion.longitude}";
     await _addParcela(TipoParcela.georeferencia, itemParcela, sectorCode);
      //parcelas.add(Parcela(categoryId: TipoParcela.georeferencia.toString()));
      await _refreshData();
      //setState(() {});
    }
  }

  Future<void> _addParcela(int categoryId, String content, int sectorCode) async {
    try {
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      await _homeRepository.addParcela(userId: _userModel.id, item: content, categoryId: categoryId, plotId: sectorCode);
    }catch(error) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text(error.toString(), style: TextStyle(color: Colors.white)),
      )..show(context);
    }finally {
      hideLoadingDialog();
    }
  }
  Future<void> _parcelaOfflineToServer(ParcelaOffline parcela,index) async {
   
    if ( await _checkConectivity.checkConnectivity() ) {
       await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      try {
        
        await _homeRepository.addParcela(userId: _userModel.id,
            item: parcela.item,
            categoryId: parcela.categoryId,
            plotId: parcela.plotsId);
        _deleteParcelaOffline(parcela);
        parcelasOffline.removeAt(index);
        _refreshData(showLoading:false);
      } catch (error) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          forwardAnimationCurve: Curves.elasticOut,
          backgroundColor: Colors.red,
          leftBarIndicatorColor: Colors.red,
          isDismissible: true,
          duration: Duration(seconds: 8),
          icon: Icon(Icons.close, color: Colors.white,),
          titleText: Text("Mensaje", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white)),
          messageText: Text(
              error.toString(), style: TextStyle(color: Colors.white)),
        )
          ..show(context);
      } finally {

          hideLoadingDialog();

      }
    }else{
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text("De clic en el botón Sincronizar información en cuanto tenga conexión a internet.", style: TextStyle(color: Colors.white)),
      )..show(context);
    }
  }
  Future<void> _addParcelaOffline(int categoryId, String content, int sectorCode) async {
    try {
      
      if (_userModel.id == null) {
         await DBProvider.db.saveParcela(userId: idTemp, item: content, categoryId: categoryId, plotId: sectorCode);
      }else{
        await DBProvider.db.saveParcela(userId: _userModel.id, item: content, categoryId: categoryId, plotId: sectorCode);
      }
      print("_ADDPARCELAOFFLINE");
      _refreshListOffline();
    }catch(error) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text("Ha Ocurrido un error", style: TextStyle(color: Colors.white)),
      )..show(context);
    }finally {
      
    }
  }

  _deleteParcela(Parcela parcela) async {
    try {
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      if(_userModel.tipoPersona == 1 ){
         await _homeRepository.deleteParcela(idUnico: parcela.ogcFid.toString());
      }else {
         await _homeRepository.deleteParcela2(idUnico: parcela.ogcFid.toString());
      }
     
    }catch(error) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text(error.toString(), style: TextStyle(color: Colors.white)),
      )..show(context);
    }finally {
      hideLoadingDialog();
    }
  }
  _deleteParcelaOffline( ParcelaOffline parcela) async {
    print("parcela id");
    print(parcela.index);
    showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    try {
      
      await DBProvider.db.deleteParcelaByIndex(index: parcela.index );
    }catch(error) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text(error.toString(), style: TextStyle(color: Colors.white)),
      )..show(context);
    }finally {
      Future.delayed(Duration(seconds: 1 )).then((_) { hideLoadingDialog(); });
    }
  }
  Future<void> _refreshData({bool showLoading}) async {
    
    try {
     // if(showLoading == true) showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      //isLoading = true;

      if(_userModel.tipoPersona == 1 ){
            parcelas = await _homeRepository.getParcelas(  curp: _userModel.curp);
          }else {
            parcelas = await _homeRepository.getParcelas2(  rfc: _userModel.rfc);
          }
      _refreshListOffline();
      print(_userModel.validacion);
      if(_userModel.validacion == 3){}else{
        final validacion = await _homeRepository.getValidacion(userId: _userModel.id);
        _userModel.validacion = validacion["validacion"];
        if(_userModel.validacion == 2) {
          _userModel.comentario = validacion["comentarios"]["comment"];
        }
      }
      await _registerRepository.setUser(json.encode(_userModel));
      UserSingleton.instance.user = _userModel;
      setState(() {});
    } catch(error) {
      print("Error updating data: ${error.toString()}");
    } finally {
      // isLoading = false;
      // if(showLoading == true) hideLoadingDialog();
    }
  }
   _refreshListOffline() async {
    
    try {

      if ( _userModel.id == null ) {
        print("refreshAllParcela");
          parcelasOffline = await DBProvider.db.getAllParcela(userId: idTemp);
          print(parcelasOffline.toString());
      }else{
        await DBProvider.db.setUpdateParcela(userIdTemp: idTemp, userId: _userModel.id);
        parcelasOffline = await DBProvider.db.getAllParcela(userId: _userModel.id );
      }
      
      setState(() {});
    } catch(error) {
      print("Error updating data: ${error.toString()}");
    } finally {
    }
  }
  void _showDetails(Parcela parcela) {
    int category = int.parse(parcela.categoryId);
    switch(category) {
      case TipoParcela.georeferencia:
        Navigator.of(context).pushNamed(UiData.routeMapLocation, arguments: parcela);
        break;
      case TipoParcela.poligono:
         Navigator.of(context).pushNamed(UiData.routeMapLocation, arguments: parcela);
        // final data = jsonDecode(parcela.item);
        // if(data != null) {
        //   Navigator.of(context).pushNamed(UiData.routeMapLocation, arguments: parcela);
        // }
        break;
      case TipoParcela.kml:
         Navigator.of(context).pushNamed(UiData.routeMapLocation, arguments: parcela);
        break;
      case TipoParcela.kmz:
         Navigator.of(context).pushNamed(UiData.routeMapLocation, arguments: parcela);
        break;
      case TipoParcela.shape:
        Navigator.of(context).pushNamed(UiData.routeMapLocation, arguments: parcela);
        break;
    }
  }

  void _goToUpdatedData() async {
    final statusNetwork = await _checkConectivity.checkConnectivity();
    if(statusNetwork && _userModel.id  == null ){
      showDialog(
                          builder: (context) => PlatformMessage(
                              title: "Importante",
                              content: "Es necesario sincronizar información.",
                              okPressed: () => Navigator.of(context).pop()
                          ), context: context
                      ); 
    }else {

      if (_userModel.tipoPersona == 1) {
      Navigator.of(context).pushNamed(UiData.routeFormFisica);
    } else if (_userModel.tipoPersona == 2) {
      Navigator.of(context).pushNamed(UiData.routeFormMoral);
    } else {
      print("Something was wrong");
    }
    }
    
  }

   _gotToUpdateoffline() async {
     
     showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
     Future.delayed(const Duration(seconds:5, ) ,() async {

     
     final statusNetwork = await _checkConectivity.checkConnectivity();
     if (  statusNetwork  ) {
      
       //var status;
      if(_userModel.id == null){
            hideLoadingDialog();
           final status = await Navigator.of(context).pushNamed(UiData.routePreRegisterOffline); 
              if (status) {
                _saveData(_userModel.tipoPersona,true);
              }
              
      }else{
         _saveData(_userModel.tipoPersona,false);
      }
  }else{
    Future.delayed(Duration(seconds: 1 )).then((_) { hideLoadingDialog(); });
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text("De clic en el botón Sincronizar información en cuanto tenga conexión a internet.", style: TextStyle(color: Colors.white)),
      )..show(context);}

      });
   }

   _saveData( int typePerson, bool statusLoading )async {
       if(statusLoading){
       print("ShowLoading yyy");
         showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
     }
     if(typePerson == 1 ){

      try {
        // SharedPreferences shared_User = await SharedPreferences.getInstance();
        // final userData = jsonDecode(shared_User.getString('user'));
        // UserModel userTemp = UserModel.fromJson(userData);
        final UserModel userModelDB = await _registerRepository.addPadron(user: UserSingleton.instance.user );
        _registerRepository.setUser(json.encode(userModelDB));
        UserSingleton.instance.user = userModelDB;
        await DBProvider.db.setUpdateParcela(userIdTemp: idTemp, userId: userModelDB.id);
        List<ParcelaOffline> parcelasOffline = [];
          parcelasOffline = await  DBProvider.db.getAllParcela(userId:_userModel.id);
          if (parcelasOffline.length > 0) {
            Map<String, dynamic> res = await _registerRepository.saveAllFilesGeo(filesFoodIndustry: parcelasOffline,idUser:_userModel.id );
            if(res['code'] == 200){
              await DBProvider.db.deleteParcelasAll(list:parcelasOffline, idUser: _userModel.id);
            }
            print("Archivos Georreferencia ");
            print(res.toString());
            parcelasOffline = [];
          }
        Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
          backgroundColor: Colors.green, leftBarIndicatorColor: Colors.green[400],
          isDismissible: true, duration: Duration(seconds: 8),
          icon: Icon(Icons.check_circle, color: Colors.white,),
          titleText: Text("Éxito",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
          messageText: Text("Información actualizada correctamente", style: TextStyle(color: Colors.white)),
        )..show(context);
      }catch(error) {
        hideLoadingDialog();
        var msg = error.toString().contains("500");
        if (msg) {
          var mensaje = 'No se pudo verificar tu información con Renapo, intenta mas tarde';
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(mensaje), duration: Duration(minutes: 20),backgroundColor: Colors.red,));
        }else{
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString()), duration: Duration(minutes: 20),backgroundColor: Colors.red,));
        }
        
      }finally {
        hideLoadingDialog();
      }
    }else{
        try {
        
          SharedPreferences shared_User = await SharedPreferences.getInstance();
          final userData = jsonDecode(shared_User.getString('userMoral'));
          var invalidCurp = [];
          var invalidCurp2 = [];
          UserModel userTemp = UserModel.fromJson(userData);
         final validateCurp =  UserSingleton.instance.user.grupoPersonasMorales;
         var stringCurp = "";
         print("No Socios Morales");
     print(UserSingleton.instance.user.grupoPersonasMorales.length);
     
     if(validateCurp.length >= 0 ){
       for (var i = 0; i < validateCurp.length ; i++ ) {
            print(validateCurp[i].curp);
            try{
              Map<String, dynamic> response = await RegisterRepository().validateCurpWithRenapo2(curp: validateCurp[i].curp, noValid: true,legalId: UserSingleton.instance.user.id);
              if (response["code"] == 200) {
                
                UserSingleton.instance.user.grupoPersonasMorales[i].nombre = response['data']["nombre"];
                UserSingleton.instance.user.grupoPersonasMorales[i].appaterno = response['data']["appaterno"];
                UserSingleton.instance.user.grupoPersonasMorales[i].apmaterno = response['data']["apmaterno"];
                UserSingleton.instance.user.grupoPersonasMorales[i].apmaterno = response['data']["apmaterno"];
                UserSingleton.instance.user.grupoPersonasMorales[i].fechaDeNacimiento = response['data']["fechaDeNacimiento"];
                UserSingleton.instance.user.grupoPersonasMorales[i].rfc = response['data']["rfc"];
              }
              if(response['code'] == 500){
                print('Error 500');
                print(response.toString());
              }
              if(response["code"] == 451 ){
           
                print("451 Code error ");
                invalidCurp.add(validateCurp[i].curp);
                invalidCurp2.add(validateCurp[i].curp);
              }
              
            }catch( e ){
             
             // print("Error Renapo: $e");
              var msg = e.toString().contains("500");
              if ( msg  ) {
                invalidCurp.add(validateCurp[i].curp + ": " + "Ocurrio un error con  RENAPO");
              }else{
                print('Error Catch ${e.toString()} ${   validateCurp[i].curp }');
                var msg2 = e.toString();
                invalidCurp.add(validateCurp[i].curp + " " +msg2 );
                invalidCurp2.add(validateCurp[i].curp);
              }
               
            }
          }
     }
   
    //delete 
     for (var i = 0; i <validateCurp.length ; i++) {
        for (var j = 0; j < invalidCurp2.length; j++) {
          if (validateCurp[i].curp == invalidCurp2[j]) {
            UserSingleton.instance.user.grupoPersonasMorales.remove(validateCurp[i]);
          }
          
        }
     }
          
          final UserModel userModelDB = await _registerRepository.addPadron(user: UserSingleton.instance.user );
          _registerRepository.setUser(json.encode(userModelDB));
          UserSingleton.instance.user = userModelDB;
          //Guardar Todos lo archivos
          await DBProvider.db.setUpdateParcela(userIdTemp: idTemp, userId: userModelDB.id);
          List<ParcelaOffline> parcelasOffline = [];
          parcelasOffline = await  DBProvider.db.getAllParcela(userId:_userModel.id);
          if (parcelasOffline.length > 0) {
            Map<String, dynamic> res = await _registerRepository.saveAllFilesGeo(filesFoodIndustry: parcelasOffline,idUser:_userModel.id );
            if(res['code'] == 200){
              await DBProvider.db.deleteParcelasAll(list:parcelasOffline, idUser: _userModel.id);
            }
           
            parcelasOffline = [];
          }
          
          // Falta Revisar 
          Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
          if( validateCurp.length > 0 ){
            for( var i = 0; i < invalidCurp.length ; i++){
              print("FOR $invalidCurp[i].toString()");
              stringCurp += invalidCurp[i].toString() + "\n";
            }
            if (stringCurp != "" ) {
              Flushbar(
              flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
              backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
              isDismissible: true, duration: Duration(seconds: 8),
              icon: Icon(Icons.close,color: Colors.white,),
              titleText: Text(""),
              messageText: Text(stringCurp, style: TextStyle(color: Colors.white)),
            )..show(context);
            }
          }else {
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              forwardAnimationCurve: Curves.elasticOut,
              backgroundColor: Colors.green,
              leftBarIndicatorColor: Colors.green[400],
              isDismissible: true,
              duration: Duration(seconds: 8),
              icon: Icon(Icons.check_circle, color: Colors.white,),
              titleText: Text("Éxito", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white)),
              messageText: Text("Información actualizada correctamente",
                  style: TextStyle(color: Colors.white)),
            )
              ..show(context);
          }
        }catch(error) {
          hideLoadingDialog();
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString()), duration: Duration(minutes: 20),backgroundColor: Colors.red,));
        }finally {
          hideLoadingDialog();
        }

    }
   }


}
