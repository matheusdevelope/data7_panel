import 'package:data7_panel/domain/entity/carousel.dart';

abstract class ICarouselRepository {
  Future<Carousel> save(Carousel carousel);
  Future<Carousel?> get(String id);
  Future<void> delete(String id);
  Future<List<Carousel>> list();
}
