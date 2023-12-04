import 'package:data7_panel/domain/entity/carousel.dart';
import 'package:data7_panel/domain/repository/carousel_repository.dart';

class CreateCarousel {
  ICarouselRepository repository;
  CreateCarousel({required this.repository});
  Future<Carousel> execute(Carousel carousel) async {
    return await repository.save(carousel);
  }
}
