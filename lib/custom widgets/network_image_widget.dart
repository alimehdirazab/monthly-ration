part of 'widgets.dart';

class ImageNetworkWidget extends StatefulWidget {
  const ImageNetworkWidget({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  final String imageUrl;
  final double? height;
  final double? width;

  @override
  State<ImageNetworkWidget> createState() => _ImageNetworkWidgetState();
}

class _ImageNetworkWidgetState extends State<ImageNetworkWidget> {
  bool _hasError = false;
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isLoaded && !_hasError) {
          _showFullScreenImageDialog(context, widget.imageUrl);
        }
      },
      child: Image.network(
        widget.imageUrl,
        height: widget.height,
        width: widget.width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            if (!_isLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _isLoaded = true;
                  });
                }
              });
            }
            return child;
          } else {
            return ShimmerWidget.fromColors(
              baseColor: context.shimmerBaseColor,
              highlightColor: context.shimmerHighlightColor,
              child: Container(
                color: GroceryColorTheme().white,
              ),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          if (!_hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                });
              }
            });
          }
          return Container(
            height: widget.height,
            width: widget.width,
            color: GroceryColorTheme().greyColor,
            child: Center(
              child: Icon(
                GroceryIcons().imageError,
                color: GroceryColorTheme().greyShade1,
                size: 60,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullScreenImageDialog(BuildContext context, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: GroceryColorTheme().black,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Stack(
          children: [
            Image.network(
              imageUrl,
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    GroceryIcons().imageError,
                    color: GroceryColorTheme().greyShade1,
                    size: 60,
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => context.popPage(),
                child: Container(
                  decoration: BoxDecoration(
                    color: GroceryColorTheme().black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      GroceryIcons().close,
                      color: GroceryColorTheme().white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
