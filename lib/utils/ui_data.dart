import 'package:flutter/material.dart';

class UiData {

  //Static images path
  static final _mainDir = "assets/img";

  static final imgLogoSiap               = "$_mainDir/logos/siap.png";
  static final imgLogoSiapSader          = "$_mainDir/logos/sader.png";
  static final imgLogoSiapCirculo        = "$_mainDir/logos/siap_circulo.jpg";
  static final imgLogoSiapLetras         = "$_mainDir/logos/siap_letras.png";
  static final imgLogoSiapAgricultura    = "$_mainDir/logos/logo_agricultura_siap.png";
  static final imgMessageValidation      = "$_mainDir/messages/validation.png";
  static final imgMessageUnauthorized    = "$_mainDir/messages/unauthorized.png";
  static final imgEmailSent              = "$_mainDir/messages/email_sent.png";
  static final imgCloud                  = "$_mainDir/cloud.png";
  static final imgPdf                    = "$_mainDir/pdf.png";

  //Routes
  static const routeSplash          = "siap.splash";
  static const routeRequirement     = "siap.requirement";
  static const routeProfile         = "siap.profile";
  static const routeLogin           = "siap.login";
  static const routePreRegister     = "siap.preRegister";
  static const routeRegister        = "siap.register";
  static const routeFormFisica      = "siap.formFisica";
  static const routeFormMoral       = "siap.formMoral";
  static const routeAddSocio        = "siap.addSocio";
  static const routeSocios          = "siap.socios";
  static const routeRecovery        = "siap.recovery";
  static const routeRecoverySuccess = "siap.recoverySuccess";
  static const routeMap             = "siap.map";
  static const routeMaps            = "siap.maps";
  static const routeMapLocation     = "siap.mapLocation";
  static const routeHome            = "siap.home";
  static const routeSector          = "siap.sectorAgroalimentario";
  static const routeHelp            = "siap.help";
  static const routeHelpDetail      = "siap.helpDetail";
  static const routeFiles           = "siap.files";
  //Pantalla extras para Offline
   static const routeTypePerson      = "siap.typePerson";
   static const routePreRegisterOffline = "siap.preRegisterOffline";
   static const routeRequirementApp = "siap.requirementApp";
  //Colors
  static final colorAppBar = Colors.white;
  static final colorPrimary = Color(0xff0f7a44);

  //Common style properties
  static final borderRadiusTextField = 4.0;
  static final borderRadiusButton = 4.0;
  static final heightMainButtons = 55.0;
  static final widthAppBarLogo = 250.0;
  static final heightLogo = 80.0;

  //Messages
  static final msgNotAvailable = "";

}