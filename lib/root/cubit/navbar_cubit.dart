
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navbar_states.dart';

class NavBarCubit extends Cubit<NavbarStates> {
  NavBarCubit() : super(const NavbarStates());

  void getNavBarItem(NavBarItem navBarItem) {
    switch (navBarItem) {
      case NavBarItem.home:
        emit(state.copyWith(navBarItem: NavBarItem.home));
        break;
      case NavBarItem.category:
        emit(state.copyWith(navBarItem: NavBarItem.category));
        break;
      case NavBarItem.order:
        emit(state.copyWith(navBarItem: NavBarItem.order));
        break;
      case NavBarItem.account:
        emit(state.copyWith(navBarItem: NavBarItem.account));
        break;
      // case NavBarItem.more:
      //   emit(state.copyWith(navBarItem: NavBarItem.more));
      //   break;
    }
  }
}
