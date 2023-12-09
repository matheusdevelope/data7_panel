import 'package:data7_panel/core/domain/entity/carousel.dart';
import 'package:data7_panel/core/domain/repository/carousel_repository.dart';

class GetCarousel {
  ICarouselRepository repository;
  GetCarousel({required this.repository});
  Future<Carousel?> execute(String id) async {
    return await repository.get(id);
  }
}
