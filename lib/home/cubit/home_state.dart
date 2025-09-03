part of 'home_cubit.dart';
class HomeState extends Equatable {
   const HomeState({
    this.cartItems =const  [],
     // banners api State
    this.bannersApiState = const GeneralApiState<BannersModel>(),
    // categories api State
    this.categoriesApiState = const GeneralApiState<CategoryModel>(),
    // default categories api State
    this.defaultCategoriesApiState = const GeneralApiState<CategoryModel>(),
    // selected category index
    this.selectedCategoryIndex = 0,
    // products api State
    this.productsApiState = const GeneralApiState<ProductModel>(),
    // productsBySubCategory api State
    this.productsBySubCategoryApiState = const GeneralApiState<ProductModel>(),
    // product details api State
    this.productDetailsApiState = const GeneralApiState<ProductDetailsModel>(),
  });
   final List<String> cartItems;
   // banners api State
   final GeneralApiState<BannersModel> bannersApiState;
   // categories api State
   final GeneralApiState<CategoryModel> categoriesApiState;
   // default categories api State
   final GeneralApiState<CategoryModel> defaultCategoriesApiState;
   // selected category index
   final int selectedCategoryIndex;
   // products api State
   final GeneralApiState<ProductModel> productsApiState;
   // productsBySubCategory api State
   final GeneralApiState<ProductModel> productsBySubCategoryApiState;
   // product details api State
   final GeneralApiState<ProductDetailsModel> productDetailsApiState;


  // CopyWith
  HomeState copyWith({
    List<String>? cartItems,
    GeneralApiState<BannersModel>? bannersApiState,
    GeneralApiState<CategoryModel>? categoriesApiState,
    GeneralApiState<CategoryModel>? defaultCategoriesApiState,
    int? selectedCategoryIndex,
    GeneralApiState<ProductModel>? productsApiState,
    GeneralApiState<ProductModel>? productsBySubCategoryApiState,
    GeneralApiState<ProductDetailsModel>? productDetailsApiState,
  }) {
    return HomeState(
      cartItems: cartItems ?? this.cartItems,
      bannersApiState: bannersApiState ?? this.bannersApiState,
      categoriesApiState: categoriesApiState ?? this.categoriesApiState,
      defaultCategoriesApiState: defaultCategoriesApiState ?? this.defaultCategoriesApiState,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      productsApiState: productsApiState ?? this.productsApiState,
      productsBySubCategoryApiState: productsBySubCategoryApiState ?? this.productsBySubCategoryApiState,
      productDetailsApiState: productDetailsApiState ?? this.productDetailsApiState,
    );
  }
  
  @override
  List<Object?> get props => [
    cartItems,
    bannersApiState,
    categoriesApiState,
    defaultCategoriesApiState,
    selectedCategoryIndex,
    productsApiState,
    productsBySubCategoryApiState,
    productDetailsApiState,
    ];
}