part of 'view.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavBarCubit>(create: (context) => NavBarCubit()),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            HomeRepository(context.read<GeneralRepository>()),
          ),
        ),
        // BlocProvider<OperatorHomeCubit>(
        //   create: (context) => OperatorHomeCubit(
        //     OperatorsHomeRepository(context.read<GeneralRepository>()),
        //   ),
        // ),
        // BlocProvider<ProductCubit>(
        //   create: (context) => ProductCubit(
        //     ProductRepository(context.read<GeneralRepository>()),
        //   ),
        // ),
        // BlocProvider<MessageCubit>(
        //   create: (context) => MessageCubit(
        //     MessageRepository(context.read<GeneralRepository>()),
        //   ),
        // ),
      ],
      child: NavView(),
    );
  }
}

class NavView extends StatelessWidget {
  const NavView({super.key});

  @override
  Widget build(BuildContext context) {
    int navBarIndex = context.select(
      (NavBarCubit cubit) => cubit.state.navBarItem.index,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        if (navBarIndex == 0) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          context.read<NavBarCubit>().getNavBarItem(NavBarItem.home);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: _HomeViewPages(),
        bottomNavigationBar: _BottomNavBar(),
      ),
    );
  }
}

class _HomeViewPages extends StatelessWidget {
  const _HomeViewPages();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavbarStates>(
      buildWhen:
          (previous, current) => previous.navBarItem != current.navBarItem,
      builder: (context, state) {
        return IndexedStack(
          index: _getPageIndex(state),
          children: const [
            HomePage(),
            CategoryPage(),
            OrderPage(),
            AccountPage(),
          ],
        );
      },
    );
  }

  int _getPageIndex(NavbarStates state) {
    switch (state.navBarItem) {
      case NavBarItem.home:
        return 0;
      case NavBarItem.category:
        return 1;
      case NavBarItem.order:
        return 2;
      case NavBarItem.account:
        return 3;
      //   case NavBarItem.more:
      //     return 4;
    }
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavbarStates>(
      buildWhen:
          (previous, current) => previous.navBarItem != current.navBarItem,
      builder: (context, state) {
        return NavbarWidget(
          currentIndex: state.navBarItem.index,
          onTapHome: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<NavBarCubit>().getNavBarItem(NavBarItem.home);
          },
          onTapCategory: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<NavBarCubit>().getNavBarItem(NavBarItem.category);
          },
          onTapOrder: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<NavBarCubit>().getNavBarItem(NavBarItem.order);
          },
          onTapAccount: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<NavBarCubit>().getNavBarItem(NavBarItem.account);
          },
          // onTapMore: () {
          //   FocusManager.instance.primaryFocus?.unfocus();
          //   context.read<NavBarCubit>().getNavBarItem(NavBarItem.more);
          // },
        );
      },
    );
  }
}
