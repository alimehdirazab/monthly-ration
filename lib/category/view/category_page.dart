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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const SizedBox(height: 24),
              _buildSectionTitle('Categories'),
              _buildCategoryGrid(),
          ],
        ),
      )
    );
  }

  Widget _buildCategoryGrid() {
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
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            shrinkWrap: true, // Important for nested scrolling
            physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 items per row as per screenshot
              crossAxisSpacing: 0, // No horizontal spacing between items
              mainAxisSpacing: 0, // No vertical spacing between items
              childAspectRatio: 0.56, // Adjust as needed to fit content
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
                  // Navigate to subcategories or products of this category
                  // You can pass the category object or ID for navigation
                  context.pushPage(
                    ProductsByCategoryPage(
                      homeCubit: context.read<HomeCubit>(),
                      categoryName: category.name,
                      subCategory: category.subCategories,
                    ),
                  );
                },
                child: CategoryContainer(
                  imageUrl: category.image ?? '',
                  itemName: category.name,
                ),
              );
            },
          ),
        );
      },
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
