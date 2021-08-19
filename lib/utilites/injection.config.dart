// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../generated/l10n.dart' as _i8;
import '../pages/auth/auth_bloc.dart' as _i3;
import 'repositories/auth_repository.dart' as _i7;
import 'repositories/token_repository.dart' as _i5;
import 'services/auth_service.dart' as _i6;
import 'services/services_module.dart'
    as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceModule = _$ServiceModule();
  gh.factory<_i3.AuthBloc>(() => _i3.AuthBloc());
  gh.lazySingleton<_i4.Dio>(() => serviceModule.dio, instanceName: 'auth_dio');
  gh.factory<_i5.TokenRepository>(() => _i5.TokenRepository());
  gh.factory<_i6.AuthService>(
      () => _i6.AuthService(get<_i4.Dio>(instanceName: 'auth_dio')));
  gh.singleton<_i7.AuthenticationRepository>(_i7.AuthenticationRepository());
  gh.singleton<_i8.S>(serviceModule.s);
  return get;
}

class _$ServiceModule extends _i9.ServiceModule {}
