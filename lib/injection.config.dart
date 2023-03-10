// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sample_2/service/notification_service.dart' as _i3;
import 'package:sample_2/service/real_time_service.dart' as _i4;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singletonAsync<_i3.NotificationService>(
        () => _i3.NotificationService.create());
    await gh.singletonAsync<_i4.RealTimeService>(
      () => _i4.RealTimeService.create(),
      preResolve: true,
    );
    return this;
  }
}
