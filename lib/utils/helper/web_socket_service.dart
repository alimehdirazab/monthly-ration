part of 'helpers.dart';



// class WebSocketService {
//   WebSocketChannel? _channel;
//   Function(Map<String, dynamic>)? onMessageReceived;
//   StreamSubscription? _connectivitySubscription;
//   bool _isConnected = false;
//   String? _url;
//   BuildContext? _context;
//   // ignore: unused_field
//   // String? _chatRoomId;
//   bool? _isSupportChat;
//   // bool? _isEmployee;

//   // Reconnection variables
//   Timer? _reconnectTimer;
//   int _reconnectAttempts = 0;
//   static const int _maxReconnectAttempts = 5;
//   static const Duration _initialReconnectDelay = Duration(seconds: 1);
//   static const Duration _maxReconnectDelay = Duration(seconds: 30);

//   /// Connect to WebSocket Server
//   void connect(BuildContext context, String chatRoomId,
//       {required bool isSupportChat, bool isEmployee = false}) {
//     _context = context;
//     // _chatRoomId = chatRoomId;
//     _isSupportChat = isSupportChat;
//     // _isEmployee = isEmployee;

//     _url = isSupportChat
//         ? "${FoxApis.socketBaseUrl}/support-chat/$chatRoomId/"
//         : "${FoxApis.socketBaseUrl}/booking-chat/$chatRoomId/";

//     _connectToWebSocket();

//     // Listen for connectivity changes
//     _connectivitySubscription =
//         Connectivity().onConnectivityChanged.listen((result) {
//       // ignore: unrelated_type_equality_checks
//       if (result != ConnectivityResult.none) {
//         if (!_isConnected) {
//           _connectToWebSocket();
//         }
//       } else {
//         // Internet disconnected, close the connection
//         _disconnect();
//       }
//     });
//   }

//   void _connectToWebSocket() {
//     // Cancel any pending reconnection attempts
//     _cancelReconnectTimer();

//     // Close existing connection if any
//     _disconnect();

//     try {
//       _channel = WebSocketChannel.connect(Uri.parse(_url!));
//       log("Connected to WebSocket: $_url");

//       _channel!.stream.listen(
//         (message) {
//           _handleIncomingMessage(message);
//         },
//         onError: (error) {
//           log("WebSocket error: $error");
//           _isConnected = false;
//           _scheduleReconnect();
//         },
//         onDone: () {
//           log("WebSocket disconnected");
//           _isConnected = false;
//           _scheduleReconnect();
//         },
//       );

//       _isConnected = true;
//       _reconnectAttempts = 0; // Reset attempts on successful connection
//     } catch (e) {
//       log("WebSocket connection error: $e");
//       _isConnected = false;
//       _scheduleReconnect();
//     }
//   }

//   void _handleIncomingMessage(dynamic message) {
//     log("Message received: $message");

//     try {
//       final parsedMessage = jsonDecode(message);
//       if (onMessageReceived != null) {
//         onMessageReceived!(parsedMessage);
//       }

//       if (_context?.mounted ?? false) {
//         if (_isSupportChat! ) {


//           // _context!.read<ProfileCubit>().addMessageFromSocket(
//           //     MessageModel.fromJson(parsedMessage["data"]));
        
//         } else if (!_isSupportChat! ) {
        
        
//           // _context!.read<HomeCubit>().addMessageFromSocket(
//           //     ChatModel.fromJson(parsedMessage["data"]["data"]));
      
//         } else if ( !_isSupportChat!) {
         
         
//           // _context!.read<EmployeeHomeCubit>().employeeAddMessageFromSocket(
//           //     ChatModel.fromJson(parsedMessage["data"]["data"]));
        
        
//         } else if ( _isSupportChat!) {
        
//           // _context!
//           //     .read<employeeProfileCubit.ProfileCubit>()
//           //     .addMessageFromSocket(
//           //         MessageModel.fromJson(parsedMessage["data"]));
       
//         }
//       }
//     } catch (e) {
//       log("Error processing message: $e");
//     }
//   }

//   void _scheduleReconnect() {
//     if (_reconnectAttempts >= _maxReconnectAttempts) {
//       log("Max reconnection attempts reached");
//       return;
//     }

//     _cancelReconnectTimer();

//     // Exponential backoff with max limit
//     final delay = Duration(
//       seconds: math.min(
//         _initialReconnectDelay.inSeconds *
//             math.pow(2, _reconnectAttempts).toInt(),
//         _maxReconnectDelay.inSeconds,
//       ),
//     );

//     log("Scheduling reconnection attempt ${_reconnectAttempts + 1} in ${delay.inSeconds} seconds");

//     _reconnectTimer = Timer(delay, () {
//       _reconnectAttempts++;
//       log("Attempting to reconnect (attempt $_reconnectAttempts)");
//       _connectToWebSocket();
//     });
//   }

//   void _cancelReconnectTimer() {
//     _reconnectTimer?.cancel();
//     _reconnectTimer = null;
//   }

//   void _disconnect() {
//     if (_channel != null) {
//       try {
//         _channel!.sink.close(1000); // Use a valid close code
//         log("WebSocket connection closed");
//       } catch (e) {
//         log("Error closing WebSocket: $e");
//       }
//       _isConnected = false;
//     }
//     _cancelReconnectTimer();
//   }

//   /// Close Connection
//   void disconnect() {
//     _disconnect();
//     _connectivitySubscription?.cancel();
//     _reconnectAttempts = _maxReconnectAttempts; // Prevent auto-reconnect
//   }

//   /// Send message through WebSocket
//   void sendMessage(Map<String, dynamic> message) {
//     if (_isConnected && _channel != null) {
//       try {
//         _channel!.sink.add(jsonEncode(message));
//       } catch (e) {
//         log("Error sending message: $e");
//         _scheduleReconnect();
//       }
//     }
//   }
// }

// final webSocketService = WebSocketService();
