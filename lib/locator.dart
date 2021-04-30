import 'package:get_it/get_it.dart';
import 'package:sirius_geo/app_info.dart';
import 'package:sirius_geo/builder/comp_builder.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/model/main_model.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerFactory(() => AppInfo());

  locator.registerLazySingleton<MainModel>(() => MainModel());
  locator.registerLazySingleton<CompBuilder>(() => CompBuilder());
  locator.registerLazySingleton<ProcessController>(() => ProcessController());
}
