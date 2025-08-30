import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_flutter_app/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void addToCart(String itemName) {
    final updatedList = List<String>.from(state.cartItems)..add(itemName);
    emit(state.copyWith(cartItems: updatedList));
  }

  void clearCart() {
    final List<String> updatedList = [];
    emit(state.copyWith(cartItems: updatedList));
  }

  int get cartCount => state.cartItems.length;
}
