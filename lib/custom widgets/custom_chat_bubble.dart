part of "widgets.dart";

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          const SizedBox(
              width: 8), // Add some spacing between the avatar and the message
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        0.7, // 70% of screen width
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSender
                          ? GroceryColorTheme().primary
                          : GroceryColorTheme().greyColor,
                      borderRadius: isSender
                          ? BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Text(message,
                        style: GroceryTextTheme().lightText.copyWith(
                            fontSize: 16, color: GroceryColorTheme().greyColor54
                            //  isSender
                            //     ? GroceryColorTheme().greyColor54
                            //     : Maid360ColorTheme().black,
                            )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
