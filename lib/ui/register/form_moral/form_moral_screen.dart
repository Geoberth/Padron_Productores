import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siap/blocs/register/common/address_step_bloc.dart';
import 'package:siap/blocs/register/common/production_step_bloc.dart';
import 'package:siap/blocs/register/moral/company_info_step/company_info_step_bloc.dart';
import 'package:siap/ui/register/common/steps/address_step_screen.dart';
import 'package:siap/ui/register/common/steps/production/production_step_screen.dart';
import 'package:siap/ui/register/form_moral/steps/company_info_step_screen.dart';
import 'package:siap/ui/register/form_moral/steps/files_moral_step_screen.dart';
import 'package:siap/ui/register/widgets/circular_step.dart';
import 'package:siap/utils/ui_data.dart';

class FormMoralScreen extends StatefulWidget {
  @override
  _FormMoralScreenState createState() => _FormMoralScreenState();
}

class _FormMoralScreenState extends State<FormMoralScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      if(!_tabController.indexIsChanging) {
        _currentTab = _tabController.index;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressStepBloc>(create: (context) => AddressStepBloc()),
        BlocProvider<ProductionStepBloc>(create: (context) => ProductionStepBloc()),
        BlocProvider<CompanyInfoStepBloc>(create: (context) => CompanyInfoStepBloc()),
      ],
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
            CompanyInfoStepScreen(tabController: _tabController),
            AddressStepScreen(tabController: _tabController),
            ProductionStepScreen(prevStep: () => _tabController.animateTo(1), nextStep: () => _tabController.animateTo(3)),
            FilesMoralStepScreen(tabController: _tabController)
          ],
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}