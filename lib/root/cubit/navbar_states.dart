

import 'package:equatable/equatable.dart';

enum NavBarItem { home, category, order, account, }

class NavbarStates extends Equatable {
  const NavbarStates({
    this.navBarItem = NavBarItem.home,
  });

  final NavBarItem navBarItem;

  NavbarStates copyWith({
    NavBarItem? navBarItem,
  }) =>
      NavbarStates(
        navBarItem: navBarItem ?? this.navBarItem,
      );

  @override
  List<Object> get props => [navBarItem];
}
