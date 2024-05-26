import 'package:flutter/material.dart';


enum MessageType { error, info, success }


class MessageBanner extends StatelessWidget {
  final String message;
  final MessageType messageType;
  final Function? onClose;


  const MessageBanner({
    Key? key,
    required this.message,
    required this.messageType,
    this.onClose,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData icon;


    switch (messageType) {
      case MessageType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case MessageType.info:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
      case MessageType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      default:
        backgroundColor = Colors.grey;
        icon = Icons.info;
    }


    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => onClose!(),
            ),
        ],
      ),
    );
  }
}

