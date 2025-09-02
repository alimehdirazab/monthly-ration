part of 'repository.dart';

class HomeRepository {
  HomeRepository(this.generalRepository);
  final GeneralRepository generalRepository;

  // get banners
  Future<BannersModel> getBanners() async {
    final response = await generalRepository.get(
      handle: GroceryApis.banners,
      );
    return BannersModel.fromJson(response);
  }


  // get categories
  Future<CategoryModel> getCategories() async {
    final response = await generalRepository.get(
      handle: GroceryApis.categories,
    );
    return CategoryModel.fromJson(response);
  }

  // get default categories
  Future<CategoryModel> getDefaultCategories() async {
    final response = await generalRepository.get(
      handle: GroceryApis.defaultCategories,
    );
    return CategoryModel.fromJson(response);
  }

  // get products
  Future<ProductModel> getProducts({int? categoryId}) async {
    final handle = categoryId == null
        ? GroceryApis.products
        : '${GroceryApis.products}?category_id=$categoryId';
    final response = await generalRepository.get(
      handle: handle,
    );
    return ProductModel.fromJson(response);
  }

}