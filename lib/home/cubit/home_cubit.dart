
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_flutter_app/home/repository/models/models.dart';
import 'package:grocery_flutter_app/home/repository/repository.dart';
import 'package:grocery_flutter_app/utils/generics/generics.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepository) : super(HomeState());
  final HomeRepository homeRepository;

  void addToCart(String itemName) {
    final updatedList = List<String>.from(state.cartItems)..add(itemName);
    emit(state.copyWith(cartItems: updatedList));
  }

  void clearCart() {
    final List<String> updatedList = [];
    emit(state.copyWith(cartItems: updatedList));
  }

  int get cartCount => state.cartItems.length;

  // Set selected category index
  void setSelectedCategoryIndex(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  // get banners Method
  Future<void> getBanners() async {
    emit(state.copyWith(bannersApiState: GeneralApiState<BannersModel>(
      apiCallState: APICallState.loading
    )));

    await homeRepository.getBanners().then((bannersModel) {
      emit(state.copyWith(bannersApiState: GeneralApiState<BannersModel>(
        apiCallState: APICallState.loaded,
        model: bannersModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(bannersApiState: GeneralApiState<BannersModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get categories Method
  Future<void> getCategories() async {
    emit(state.copyWith(categoriesApiState: GeneralApiState<CategoryModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getCategories().then((categoriesModel) {
      emit(state.copyWith(categoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.loaded,
        model: categoriesModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(categoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get default categories Method
  Future<void> getDefaultCategories() async {
    emit(state.copyWith(defaultCategoriesApiState: GeneralApiState<CategoryModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getDefaultCategories().then((categoriesModel) {
      emit(state.copyWith(defaultCategoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.loaded,
        model: categoriesModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(defaultCategoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get products Method
  Future<void> getProducts({int? categoryId}) async {
    emit(state.copyWith(productsApiState: GeneralApiState<ProductModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getProducts(categoryId: categoryId).then((productsModel) {
      emit(state.copyWith(productsApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.loaded,
        model: productsModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(productsApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get products by sub category Method
  Future<void> getProductsBySubCategory({int? subCategoryId}) async {
    emit(state.copyWith(productsBySubCategoryApiState: GeneralApiState<ProductModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getProducts(categoryId: subCategoryId).then((productsModel) {
      emit(state.copyWith(productsBySubCategoryApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.loaded,
        model: productsModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(productsBySubCategoryApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

}
