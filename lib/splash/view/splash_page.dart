part of 'view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // ignore: use_build_context_synchronously
      context.pushPage(AuthLoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.mHeight,
        width: context.mWidth,
        child: Image.asset(GroceryImages.splash),
      ),
    );
  }
}
