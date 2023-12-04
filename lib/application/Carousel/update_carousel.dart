import 'package:data7_panel/domain/entity/carousel.dart';
import 'package:data7_panel/domain/repository/carousel_repository.dart';

class UpdateCarousel {
  ICarouselRepository repository;
  UpdateCarousel({required this.repository});
  Future<Carousel> execute(Carousel panel) async {
    return await repository.save(panel);
  }
}
