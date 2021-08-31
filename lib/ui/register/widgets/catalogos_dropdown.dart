import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';

class CatalogosDropDown {

  Widget buildSectorAgroalimentario({
    @required Size size,
    @required String title,
    @required int value,
    @required List<SectorAgroalimentario> sectoresAgroalimentarios,
    @required Function(int) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title + " \*",
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (val) => value == null ? 'Campo requerido' : null,
        // underline: Container(),
        isExpanded: true,
        value: value,
        items: sectoresAgroalimentarios.map((sectorAgroalimentario) {
          return DropdownMenuItem<int>(
            value: sectorAgroalimentario.code,
            child: Text(sectorAgroalimentario.name),
          );
        }).toList(),
        onChanged: onChanged,
      )
    );
  }

  Widget buildPrincipalesCultivosEspecies({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> principalesCultivosEspecies,
    @required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title + " \*",
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (val) => value == null ? 'Campo requerido' : null,
        // underline: Container(),
        isExpanded: true,
        value: value,
        items: principalesCultivosEspecies.map((principalCultivoEspecie) {
          return DropdownMenuItem<String>(
            value: principalCultivoEspecie.code,
            child: Text(principalCultivoEspecie.name),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildPrincipalesProductos({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> principalesProductos,
    @required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title + " \*",
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (val) => value == null ? 'Campo requerido' : null,
        // underline: Container(),
        isExpanded: true,
        value: value,
        items: principalesProductos.map((principalProducto) {
          return DropdownMenuItem<String>(
            value: principalProducto.code,
            child: Text(principalProducto.name),
          );
        }).toList(),
        onChanged: onChanged,
      )
    );
  }
     Widget buildTipoProductorMiel({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> principalesProductos,
    @required Function(String) onChanged}) {
      
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title.toString(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (val) => value == null ? 'Campo requerido' : null,
        // underline: Container(),
        isExpanded: true,
        value: value,
        items: principalesProductos.map((principalProducto) {
          return DropdownMenuItem<String>(
            value: principalProducto.code,
            child: Text(principalProducto.name),
          );
        }).toList(),
        onChanged: onChanged,
      )
    );
  }
  Widget buildRegimenHidrico({
    @required Size size,
    @required String title,
    @required int value,
    @required List<GenericData<int>> regimenHidricos,
    @required Function(int) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<int>(
          decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: title + " \*",
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (val) => value == null ? 'Campo requerido' : null,
        // underline: Container(),
        isExpanded: true,
        value: value,
        items: regimenHidricos.map((regimenHidrico) {
          return DropdownMenuItem<int>(
            value: regimenHidrico.code,
            child: Text(regimenHidrico.name),
          );
        }).toList(),
        onChanged: onChanged
      )
    );
  }

  Widget buildTipoCultivo({
    @required Size size,
    @required String title,
    @required int value,
    @required List<GenericData<int>> tiposCultivos,
    @required Function(int) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<int>(
          decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: title + " \*",
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (val) => value == null ? 'Campo requerido' : null,
        // underline: Container(),
        isExpanded: true,
        value: value,
        items: tiposCultivos.map((tipoCultivo) {
          return DropdownMenuItem<int>(
            value: tipoCultivo.code,
            child: Text(tipoCultivo.name),
          );
        }).toList(),
        onChanged: onChanged
      )
    );
  }

  Widget buildTipoTel({
    @required Size size,
    @required String title,
    @required int value,
    @required List<GenericData<int>> tiposTelefonos,
    @required Function(int) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: InputDecorator(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        child: DropdownButton<int>(
          underline: Container(),
          isExpanded: true,
          hint: Text("Selecciona una opción"),
          value: value,
          items: tiposTelefonos.map((tipoTelefono) {
            return DropdownMenuItem<int>(
              value: tipoTelefono.code,
              child: Text(tipoTelefono.name),
            );
          }).toList(),
          onChanged: onChanged
        )
      )
    );
  }

  Widget buildTipoDireccion({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> tiposDirecciones,
    @required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<String>(
          //underline: Container(),
          decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title ,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
          isExpanded: true,
         // hint: Text("Selecciona una opción"),
          value: value,
          validator: (value) => value == null ? 'Campo requerido' : null,
          items: tiposDirecciones.map((tipoDireccion) {
            return DropdownMenuItem<String>(
              value: tipoDireccion.code,
              child: Text(tipoDireccion.name, style: TextStyle(fontSize: 13.0)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      
    );
  }

  Widget buildTipoVialidad({
    @required Size size,
    @required String title,
    @required int value,
    @required List<GenericData<int>> tiposVialidades,
    @required Function(int) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child:  DropdownButtonFormField<int>(
         // underline: Container(),
          isExpanded: true,
          decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
         // hint: Text("Selecciona una opción"),
          value: value,
          validator: (value) => value == null ? 'Campo requerido' : null,
          items: tiposVialidades.map((tipoVialidad) {
            return DropdownMenuItem<int>(
              value: tipoVialidad.code,
              child: Text(tipoVialidad.name),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      );
    
  }


  Widget buildTipoAsentamiento({
    @required Size size,
    @required String title,
    @required int value,
    @required List<GenericData<int>> tiposAsentamientos,
    @required Function(int) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField <int>(
          //underline: Container(),
          decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
          isExpanded: true,
          //hint: Text("Selecciona una opción"),
          value: value,
          validator: (value) => value == null ? 'Campo requerido' : null,
          items: tiposAsentamientos.map((tipoAsentamiento) {
            return DropdownMenuItem<int>(
              value: tipoAsentamiento.code,
              child: Text(tipoAsentamiento.name),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      
    );
  }

  Widget buildEstados({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> estados,
    @required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child:  DropdownButtonFormField<String>(
          //underline: Container(),
          decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
          isExpanded: true,
          //hint: Text("Selecciona una opción"),
          value: value,
          validator: (value) => value == null ? 'Campo requerido' : null,
          items: estados.map((estado) {
            return DropdownMenuItem<String>(
              value: estado.code,
              child: Text(estado.name),
            );
          }).toList(),
          onChanged: onChanged,
        )
      
    );
  }

  Widget buildMunicipios({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> municipios,
    @required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: DropdownButtonFormField<String>(
          //underline: Container(),
          decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
          isExpanded: true,
         // hint: Text("Selecciona una opción"),
          value: value,
          validator: (value) => value == null ? 'Campo requerido' : null,
          items: municipios.map((municipio) {
            return DropdownMenuItem<String>(
              value: municipio.code,
              child: Text(municipio.name ?? 'No disponible'),
            );
          }).toList(),
          onChanged: onChanged
        ),
      
    );
  }

  Widget buildLocalidad({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> localidades,
    @required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child:  DropdownButtonFormField<String>(
          //underline: Container(),
          isExpanded: true,
          decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
          //hint: Text("Selecciona una opción"),
          value: value,
          validator: (value) => value == null ? 'Campo requerido' : null,
          items: localidades.map((localidad) {
            return DropdownMenuItem<String>(
              value: localidad.code,
              child: Text(localidad.name),
            );
          }).toList(),
          onChanged: onChanged
        ),
      
    );
  }

  Widget buildCentroIntegrador({
    @required Size size,
    @required String title,
    @required String value,
    @required List<GenericData<String>> centrosIntegradores,
    @required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child:  DropdownButtonFormField<String>(
          //underline: Container(),
          decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
          isExpanded: true,
        //  hint: Text("Selecciona una opción"),
         validator: (value) => value == null ? 'Campo requerido' : null,
          value: value,
          items: centrosIntegradores.map((centroIntegrador) {
            return DropdownMenuItem<String>(
              value: centroIntegrador.code,
              child: Text(centroIntegrador.name),
            );
          }).toList(),
          onChanged: onChanged
        ),
      
    );
  }

}