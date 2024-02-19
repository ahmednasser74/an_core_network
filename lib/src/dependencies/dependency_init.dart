import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency_init.config.dart';

final GetIt networkPackageGetIt = GetIt.instance;

@InjectableInit(
  usesNullSafety: true,
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<GetIt> networkCorePackageConfigDependencies() async {
  return $initGetIt(networkPackageGetIt);
}
