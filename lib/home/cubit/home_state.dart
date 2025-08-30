class HomeState {
  final List<String> cartItems;

  HomeState({ this.cartItems =const  []});

  // Initial state
  factory HomeState.initial() {
    return HomeState(cartItems: []);
  }

  // CopyWith
  HomeState copyWith({List<String>? cartItems}) {
    return HomeState(
      cartItems: cartItems ?? this.cartItems,
    );
  }
}