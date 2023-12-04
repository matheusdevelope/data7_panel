import 'package:data7_panel/dependecy_injection.dart';
import 'package:data7_panel/domain/entity/carousel.dart';
import 'package:data7_panel/domain/repository/carousel_repository.dart';
import 'package:data7_panel/infra/storage/storage.dart';

class StorageCarouselRepository implements ICarouselRepository {
  final IStorage _storage = DI.get<IStorage>();
  final String _key = 'carousels';
  StorageCarouselRepository();

  @override
  Future<Carousel> save(Carousel carousel) async {
    final List<Carousel> list = await this.list();
    if (list.isEmpty) {
      await _storage.setList(_key, [carousel.toJson()]);
    } else {
      final index = list.indexWhere((element) => element.id == carousel.id);
      if (index == -1) {
        list.add(carousel);
      } else {
        list[index] = carousel;
      }
      await _storage.setList(_key, list.map((e) => e.toJson()).toList());
    }
    return carousel;
  }

  @override
  Future<Carousel?> get(String id) async {
    final List<Carousel> list = await this.list();
    final index = list.indexWhere((element) => element.id == id);
    if (index != -1) {
      return list[index];
    }
    return null;
  }

  @override
  Future<void> delete(String id) async {
    final List<Carousel> list = await this.list();
    final index = list.indexWhere((element) => element.id == id);
    if (index != -1) {
      list.removeAt(index);
      await _storage.setList(_key, list.map((e) => e.toJson()).toList());
    }
  }

  @override
  Future<List<Carousel>> list() async {
    final List<Carousel> list = [];
    final json = await _storage.getList<Map<String, dynamic>>(_key);
    if (json == null) return list;
    for (final Map<String, dynamic> item in json) {
      list.add(Carousel.fromJson(item));
    }
    return list;
  }
}
