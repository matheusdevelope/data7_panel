import 'package:data7_panel/core/domain/repository/carousel_repository.dart';

class DeleteCarousel {
  ICarouselRepository repository;
  DeleteCarousel({required this.repository});
  Future<void> execute(String id) async {
    return await repository.delete(id);
  }
}
