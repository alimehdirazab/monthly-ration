part of 'widgets.dart';

// void openModalBottomSheet(BuildContext context, HomeCubit cubit,
//     NavbarCubit navCubit, Product product , RewardsCubit rewardCubit) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true, // Allows full height control
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return BlocProvider.value(
//         value: cubit,
//         child: CustomBottomSheet(
//           onTapAddToCart: () {
//             context.pushPage(CartPage(
//               cubit: cubit,
//               navCubit: navCubit, rewardCubit: rewardCubit,
//             ));
//           },
//           onTapBuyNow: () {
//             context.pushPage(CartPage(
//               cubit: cubit,
//               navCubit: navCubit, rewardCubit: rewardCubit,
//             ));
//           },
//           product: product,
//           cubit: cubit,
//         ),
//       );
//     },
//   );
// }
