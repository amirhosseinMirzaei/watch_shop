

import 'package:nike2/data/banner.dart';
import 'package:nike2/data/source/banner_data_source.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource());

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getAll() => dataSource.getAll();
}
