import 'package:flutter/material.dart';

class GroceryIcons {
  GroceryIcons._internal();

  static final GroceryIcons _instance = GroceryIcons._internal();

  factory GroceryIcons() {
    return _instance;
  }

  IconData get visibilityOffOutlined => Icons.visibility_off_outlined;
  IconData get backButton => Icons.arrow_back_ios_new;
  IconData get edit => Icons.edit;
  IconData get myLocation => Icons.my_location_outlined;

  IconData get homeIcon => Icons.home_filled;
  IconData get menuIcon => Icons.menu_book_rounded;
  IconData get rewardsIcon => Icons.card_giftcard_outlined;
  IconData get settingIcon => Icons.settings_outlined;
  IconData get hideImage => Icons.hide_image_outlined;
  IconData get errorIcon => Icons.error_outline;
  IconData get user => Icons.person_pin;
  IconData get search => Icons.search_outlined;
  IconData get operator => Icons.directions_boat_filled_outlined;
  IconData get orders => Icons.shopping_cart_checkout;
  IconData get category => Icons.category_outlined;
  IconData get account => Icons.account_circle_outlined;

  IconData get message => Icons.message_outlined;
  IconData get sms => Icons.sms;
  IconData get products => Icons.icecream_rounded;
  IconData get more => Icons.more_vert_outlined;
  IconData get payment => Icons.account_balance_wallet_outlined;
  IconData get wallet => Icons.wallet;
  IconData get favorite => Icons.favorite;
  IconData get favoriteBorder => Icons.favorite_outline_rounded;
  IconData get forward => Icons.arrow_forward_ios;
  IconData get chatRounded => Icons.chat_rounded;
  IconData get refresh => Icons.refresh_outlined;
  IconData get star => Icons.star_outline_rounded;
  IconData get fillStar => Icons.star;
  IconData get share => Icons.share;
  IconData get remove => Icons.remove;
  IconData get profile => Icons.person;
  IconData get filledStar => Icons.star;
  IconData get add => Icons.add;
  IconData get done => Icons.done;
  IconData get help => Icons.help_outline;
  IconData get camera => Icons.camera_alt;
  IconData get article => Icons.article_outlined;
  IconData get notification => Icons.notifications_none_outlined;
  IconData get cloud => Icons.cloud_outlined;
  IconData get privacy => Icons.privacy_tip_outlined;
  IconData get accountBalance => Icons.account_balance_wallet_outlined;
  IconData get logout => Icons.logout_outlined;
  IconData get photo => Icons.photo;
  IconData get send => Icons.send_rounded;
  IconData get playArrow => Icons.play_arrow;
  IconData get cancelEmojiIcon => Icons.sentiment_very_dissatisfied;
  IconData get verifiedIcon => Icons.verified_outlined;
  IconData get close => Icons.close;
  IconData get powerSetting => Icons.power_settings_new;
  IconData get visibility => Icons.visibility_outlined;
  IconData get imageError => Icons.image_not_supported_outlined;
  IconData get lock => Icons.lock_outline_rounded;
  IconData get order => Icons.arrow_outward_rounded;
  IconData get refund => Icons.south_east_outlined;
}
