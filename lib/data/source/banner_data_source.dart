import 'package:dio/dio.dart';
import 'package:nike2/data/banner.dart';
import 'package:nike2/data/common/response_validator.dart';




abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    final List<BannerEntity> banners = [];
    for (var jsonObject in (response.data as List)) {
      banners.add(BannerEntity.fromJson(jsonObject));
    }
    return banners;
  }
}
