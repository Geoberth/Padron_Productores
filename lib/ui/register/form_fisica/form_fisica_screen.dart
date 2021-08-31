import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siap/blocs/register/common/address_step_bloc.dart';
import 'package:siap/blocs/register/common/production_step_bloc.dart';
import 'package:siap/blocs/register/fisica/characterization_step/characterization_step_bloc.dart';
import 'package:siap/blocs/register/fisica/personal_info_step/personal_info_step_bloc.dart';
import 'package:siap/ui/register/common/steps/address_step_screen.dart';
import 'package:siap/ui/register/common/steps/production/production_step_screen.dart';
import 'package:siap/ui/register/form_fisica/steps/characterization_step_screen.dart';
import 'package:siap/ui/register/form_fisica/steps/files_step_screen.dart';
import 'package:siap/ui/register/form_fisica/steps/personal_info_step_screen.dart';
import 'package:siap/ui/register/widgets/circular_step.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/general_validator.dart';

class FormFisicaScreen extends StatefulWidget {

  @override
  _FormFisicaScreenState createState() => _FormFisicaScreenState();
}

class _FormFisicaScreenState extends State<FormFisicaScreen> with TickerProviderStateMixin {
  TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    
    _tabController.addListener(() {
      if(!_tabController.indexIsChanging) {
        _currentTab = _tabController.index;
        setState(() {});
      }
    });
  } 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressStepBloc>(create: (context) => AddressStepBloc()),
        BlocProvider<ProductionStepBloc>(create: (context) => ProductionStepBloc()),
        BlocProvider<PersonalInfoStepBloc>(create: (context) => PersonalInfoStepBloc()),
        BlocProvider<CharacterizationStepBloc>(create: (context) => CharacterizationStepBloc()),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: UiData.colorAppBar,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircularStep(currentStep: _currentTab),
                Flexible(child: Image.asset(UiData.imgLogoSiap, width: 250))
              ],
            )
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              PersonalInfoStepScreen(tabController: _tabController),
              AddressStepScreen(tabController: _tabController),
              CharacterizationStepScreen(tabController: _tabController),
              ProductionStepScreen(prevStep: () => _tabController.animateTo(2), nextStep: () => _tabController.animateTo(4)),
              FilesStepScreen(tabController: _tabController)
            ],
          )
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

}