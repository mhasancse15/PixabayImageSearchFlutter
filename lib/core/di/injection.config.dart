// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pixabay_image_search/core/di/register_module.dart' as _i43;
import 'package:pixabay_image_search/core/network/api_client.dart' as _i785;
import 'package:pixabay_image_search/core/network/network_info.dart' as _i794;
import 'package:pixabay_image_search/data/datasources/image_remote_data_source.dart'
    as _i903;
import 'package:pixabay_image_search/data/repositories/image_repository_impl.dart'
    as _i1052;
import 'package:pixabay_image_search/domain/entities/image_entity.dart'
    as _i163;
import 'package:pixabay_image_search/domain/repositories/image_repository.dart'
    as _i144;
import 'package:pixabay_image_search/domain/usecases/search_images_usecase.dart'
    as _i915;
import 'package:pixabay_image_search/presentation/home/controllers/home_controller.dart'
    as _i636;
import 'package:pixabay_image_search/presentation/image_detail/controllers/image_detail_controller.dart'
    as _i732;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i794.NetworkInfo>(
      () => _i794.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i785.ApiClient>(() => _i785.ApiClient(gh<_i361.Dio>()));
    gh.factoryParam<_i732.ImageDetailController, _i163.ImageEntity, dynamic>(
      (image, _) => _i732.ImageDetailController(image: image),
    );
    gh.lazySingleton<_i903.ImageRemoteDataSource>(
      () => _i903.ImageRemoteDataSourceImpl(gh<_i785.ApiClient>()),
    );
    gh.lazySingleton<_i144.ImageRepository>(
      () => _i1052.ImageRepositoryImpl(
        remoteDataSource: gh<_i903.ImageRemoteDataSource>(),
        networkInfo: gh<_i794.NetworkInfo>(),
      ),
    );
    gh.factory<_i915.SearchImagesUseCase>(
      () => _i915.SearchImagesUseCase(gh<_i144.ImageRepository>()),
    );
    gh.factory<_i636.HomeController>(
      () => _i636.HomeController(
        searchImagesUseCase: gh<_i915.SearchImagesUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i43.RegisterModule {}
