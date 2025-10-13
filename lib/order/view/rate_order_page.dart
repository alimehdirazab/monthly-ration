part of 'view.dart';

class RateOrderPage extends StatelessWidget {
  final dynamic order;
  final HomeCubit homeCubit;
  
  const RateOrderPage({super.key, required this.order, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: _RateOrderView(order: order),
    );
  }
}

class _RateOrderView extends StatefulWidget {
  final dynamic order;
  
  const _RateOrderView({required this.order});

  @override
  State<_RateOrderView> createState() => _RateOrderViewState();
}

class _RateOrderViewState extends State<_RateOrderView> {
  final Map<int, int> _itemRatings = {};
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize ratings for each item
    final orderItems = widget.order.items ?? [];
    for (int i = 0; i < orderItems.length; i++) {
      _itemRatings[i] = 0;
    }
    
    // Fetch existing review if any
    context.read<HomeCubit>().getOrderReview(orderId: widget.order.id ?? 0);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _setItemRating(int itemIndex, int rating) {
    setState(() {
      _itemRatings[itemIndex] = rating;
    });
  }

  void _submitRating() {
    // Validate that at least one item rating is provided
    final orderItems = widget.order.items ?? [];
    bool hasAnyRating = _itemRatings.values.any((rating) => rating > 0);
    
    if (!hasAnyRating) {
      context.showSnacbar('Please rate at least one item');
      return;
    }

    // Prepare ratings data for API (only product ratings as per API spec)
    final List<Map<String, dynamic>> ratings = [];
    
    // Add item ratings with product_id as expected by API
    for (int i = 0; i < orderItems.length; i++) {
      final itemRating = _itemRatings[i] ?? 0;
      if (itemRating > 0) {
        ratings.add({
          'product_id': orderItems[i].productId ?? orderItems[i].id,
          'rating': itemRating,
        });
      }
    }

    // Submit review via API
    context.read<HomeCubit>().submitReview(
      orderId: widget.order.id ?? 0,
      review: _feedbackController.text.trim(),
      ratings: ratings,
    );
  }

  Widget _buildStarRating(int currentRating, Function(int) onRatingChanged) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: index < currentRating ? Colors.amber : Colors.grey,
            size: 32,
          ),
        );
      }),
    );
  }

  Widget _buildReadOnlyStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.amber : Colors.grey,
          size: 32,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = widget.order.items ?? [];
    
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.submitReviewApiState != current.submitReviewApiState ||
          previous.getOrderReviewApiState != current.getOrderReviewApiState,
      listener: (context, state) {
        if (state.submitReviewApiState.apiCallState == APICallState.loaded) {
          context.showSnacbar('Thank you for your feedback!');
          Navigator.pop(context);
        } else if (state.submitReviewApiState.apiCallState == APICallState.failure) {
          context.showSnacbar(
            state.submitReviewApiState.errorMessage ?? 'Failed to submit review'
          );
        }
        
        // Handle get review API response
        if (state.getOrderReviewApiState.apiCallState == APICallState.loaded && 
            state.getOrderReviewApiState.model != null) {
          final reviewData = state.getOrderReviewApiState.model!;
          if (reviewData['success'] == true && reviewData['data'] != null) {
            // Populate existing review data
            final data = reviewData['data'];
            _feedbackController.text = data['review'] ?? '';
            
            // Populate existing ratings
            final ratings = data['ratings'] as List<dynamic>? ?? [];
            final orderItems = widget.order.items ?? [];
            
            for (int i = 0; i < orderItems.length; i++) {
              final orderItem = orderItems[i];
              final matchingRating = ratings.firstWhere(
                (rating) => rating['product_id'] == (orderItem.productId ?? orderItem.id),
                orElse: () => null,
              );
              
              if (matchingRating != null) {
                setState(() {
                  _itemRatings[i] = matchingRating['rating'] ?? 0;
                });
              }
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: GroceryColorTheme().primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Rate Your Experience',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.getOrderReviewApiState != current.getOrderReviewApiState,
          builder: (context, state) {
            // Check if review already exists
            final hasExistingReview = state.getOrderReviewApiState.apiCallState == APICallState.loaded &&
                state.getOrderReviewApiState.model != null &&
                state.getOrderReviewApiState.model!['success'] == true &&
                state.getOrderReviewApiState.model!['data'] != null;
            
            // Show loading state
            if (state.getOrderReviewApiState.apiCallState == APICallState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Header Card with Order Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GroceryColorTheme().primary.withValues(alpha: 0.1),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      hasExistingReview ? Icons.check_circle_outline : Icons.shopping_bag_outlined,
                      size: 48,
                      color: hasExistingReview ? Colors.green : GroceryColorTheme().primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Order #${widget.order.id ?? "N/A"}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hasExistingReview 
                          ? 'Thank you for your review!' 
                          : 'Help us improve by sharing your experience',
                      style: TextStyle(
                        fontSize: 16,
                        color: hasExistingReview ? Colors.green : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Items Rating Section
              if (orderItems.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      hasExistingReview ? Icons.star : Icons.inventory_2_outlined,
                      color: hasExistingReview ? Colors.amber : GroceryColorTheme().primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hasExistingReview ? 'Your Ratings' : 'Rate Your Items',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Items List
                ...orderItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final itemRating = _itemRatings[index] ?? 0;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: item.image != null && item.image!.isNotEmpty
                                  ? Image.network(
                                      item.image!.startsWith('http') 
                                          ? item.image!
                                          : '${GroceryApis.baseUrl}/${item.image}',
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 72,
                                          height: 72,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey[400],
                                            size: 32,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.grey[400],
                                        size: 32,
                                      ),
                                    ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName ?? 'Unknown Product',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Qty: ${item.quantity ?? 1}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Star Rating for this item
                        Row(
                          children: [
                            Text(
                              hasExistingReview ? 'Your rating:' : 'Rate this item:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            hasExistingReview 
                                ? _buildReadOnlyStarRating(itemRating)
                                : _buildStarRating(itemRating, (rating) => _setItemRating(index, rating)),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            
            const SizedBox(height: 32),
            
            // Feedback Section
            Row(
              children: [
                Icon(
                  hasExistingReview ? Icons.comment : Icons.feedback_outlined,
                  color: hasExistingReview ? Colors.blue : GroceryColorTheme().primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  hasExistingReview ? 'Your Feedback' : 'Additional Feedback',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 6,
                readOnly: hasExistingReview,
                decoration: InputDecoration(
                  hintText: hasExistingReview 
                      ? (_feedbackController.text.isEmpty ? 'No additional feedback provided' : null)
                      : 'Share your experience, suggestions, or any issues you faced...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: hasExistingReview ? Colors.grey[800] : Colors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Submit Button
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.submitReviewApiState != current.submitReviewApiState,
              builder: (context, state) {
                final isLoading = state.submitReviewApiState.apiCallState == APICallState.loading;
                
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasExistingReview ? null : (isLoading ? null : _submitRating),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasExistingReview ? Colors.green.shade100 : GroceryColorTheme().primary,
                      foregroundColor: hasExistingReview ? Colors.green.shade800 : Colors.black87,
                      disabledBackgroundColor: hasExistingReview ? Colors.green.shade100 : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: hasExistingReview
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade800,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Review Submitted',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ],
                          )
                        : isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Submitting...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Submit Review',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
    ), // Close BlocListener child: Scaffold
    ); // Close BlocListener
  }
}