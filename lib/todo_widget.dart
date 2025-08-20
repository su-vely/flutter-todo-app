import 'package:flutter/material.dart';

class TodoWidget extends StatelessWidget {
  TodoWidget({required this.title, required this.isDone});

  String title;
  bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0x1A7990F8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF5773FF) : Colors.white,
              border: Border.all(color: Color(0xFFD6D6D6)),
              borderRadius: BorderRadius.circular(6),
            ),
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: isDone
                ? Icon(Icons.check, size: 18, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF121212),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
