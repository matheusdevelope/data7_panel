import 'package:data7_panel/domain/entity/carousel.dart';
import 'package:data7_panel/domain/repository/carousel_repository.dart';

class GetCarousels {
  ICarouselRepository repository;
  GetCarousels({required this.repository});
  Future<List<Carousel>> execute() async {
    return await repository.list();
  }
}
