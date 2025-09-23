part of 'view.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  _CategoryView();
  }
}

class _CategoryView extends StatefulWidget {
  const _CategoryView();

  @override
  State<_CategoryView> createState() => _CategoryPageViewState();
}

class _CategoryPageViewState extends State<_CategoryView> {

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryColorTheme().primary,
        title: Text(
          'Category',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeCubit>().getCategories();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const SizedBox(height: 24),
                _buildCategoriesWithSubcategories(),
               
            ],
          ),
        ),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cartItems = state.getCartItemsApiState.model?.data ?? [];
          
          if (cartItems.isNotEmpty) {
            // Get first 3 product images from cart items
            final List<String> productImages = [];
            for (int i = 0; i < cartItems.length && i < 3; i++) {
              final product = cartItems[i].product;
              if (product?.imagesUrls != null && product!.imagesUrls.isNotEmpty) {
                // Use first image from the URLs list
                productImages.add(product.imagesUrls.first);
              } else {
                // Use default image if no product image
                productImages.add(GroceryImages.category2);
              }
            }
            
            // Ensure we have at least one image
            if (productImages.isEmpty) {
              productImages.add(GroceryImages.category2);
            }
            
            return FloatingActionButton.extended(
              onPressed: () {
                 context.pushPage(CheckoutPage(
                          homeCubit: context.read<HomeCubit>(),
                        ));
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber, // Yellow background
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product images stack (max 3)
                    SizedBox(
                      width: 40 + (productImages.length > 1 ? (productImages.length - 1) * 15 : 0),
                      height: 40,
                      child: Stack(
                        children: List.generate(productImages.length, (index) {
                          return Positioned(
                            left: index * 15.0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child:Image.network(
                                        productImages[index].startsWith('http') 
                                            ? productImages[index]
                                            : '${GroceryApis.baseUrl}/${productImages[index]}',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            GroceryImages.category2,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Text
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'View cart',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${cartItems.length} item${cartItems.length > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Arrow Icon
                    InkWell(
                      onTap: () {
                        context.pushPage(CheckoutPage(
                          homeCubit: context.read<HomeCubit>(),
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GroceryColorTheme().white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            //  FloatingActionButton.extended(
            //   onPressed: () {
            //     // Navigate to cart screen or show cart details
            //   },
            //   label: Text('View Cart (${state.cartItems.length})'),
            //   icon: const Icon(Icons.shopping_cart),
            // );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

   Widget _buildCategoriesWithSubcategories() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.categoriesApiState != current.categoriesApiState,
      builder: (context, state) {
        final apiState = state.categoriesApiState;
        
        if (apiState.apiCallState == APICallState.loading) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        
        if (apiState.apiCallState == APICallState.failure) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              apiState.errorMessage ?? 'Failed to load categories',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        
        final categories = apiState.model?.data ?? [];
        
        if (categories.isEmpty) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text('No categories available'),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((category) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(category.name),
                _buildSubcategoryGrid(category.subCategories),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSubcategoryGrid(List<Category> subcategories) {
    if (subcategories.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'No subcategories available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subcategories.length,
        padding: const EdgeInsets.symmetric(vertical: 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 items per row
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return InkWell(
            onTap: () {
              // Navigate to products by subcategory
               if (subcategory.subSubCategories != null) {
              context.pushPage(
                ProductsByCategoryPage(
                  homeCubit: context.read<HomeCubit>(),
                  categoryName: subcategory.name, // Pass the clicked subcategory name
                  subCategory: subcategory.subSubCategories, // Pass subSubCategories of the clicked subcategory
                  selectedSubCategoryIndex: index,
                  isFromSubCategory: true, // Indicate it's from subcategory
                ),
              );
               }
            },
            child: SubcategoryItemContainer(
              subcategory: subcategory,
            ),
          );
        },
      ),
    );
  }

 
}


class CategoryContainer extends StatelessWidget {
  final String imageUrl;
  final String itemName;

  const CategoryContainer({
    super.key,
    required this.imageUrl,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 130,
          // Fixed width based on the screenshot
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: GroceryColorTheme().primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: imageUrl.isNotEmpty && (imageUrl.startsWith('http') || imageUrl.startsWith('https'))
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // If network image fails to load, show default icon
                      return Icon(
                        Icons.category,
                        size: 50,
                        color: GroceryColorTheme().primary,
                      );
                    },
                  ),
                )
              : imageUrl.isNotEmpty
                  ? Image.asset(
                      imageUrl,
                      width: 70,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.category,
                          size: 50,
                          color: GroceryColorTheme().primary,
                        );
                      },
                    )
                  : Icon(
                      Icons.category,
                      size: 50,
                      color: GroceryColorTheme().primary,
                    ),
        ),
        const SizedBox(height: 4),
        Text(
          itemName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
