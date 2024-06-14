import 'package:nike2/data/banner.dart';
import 'package:nike2/data/common/response_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  @override
  Future<List<BannerEntity>> getAll() async {
    return [
      BannerEntity("b1", "https://www.worldofwatches.com/media/wysiwyg/homePage/2023/8/oris-02-2020.jpg"),
      BannerEntity("b2", "https://www.worldofwatches.com/media/wysiwyg/homePage/2023/9/omega-0221.jpg"),
      BannerEntity("b3", "https://www.worldofwatches.com/media/wysiwyg/homePage/2023/9/versace-22.jpg"),
    ];
  }
}
