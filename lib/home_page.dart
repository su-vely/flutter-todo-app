import 'package:flutter/material.dart';
import 'package:flutter_todo_app/todo_widget.dart';

class HomePage extends StatelessWidget {
  // @override => 어노테이션
  // 코드의 메타데이터!
  // 없어도 에러는 나지 않음
  // 협업할 때, 다른개발자한테 알려주기위해서!
  // 빌드할때 (apk파일 만들 때)
  @override
  Widget build(BuildContext context) {
    List<String> titles = ["물마시기", "프로그래밍", "아침에코딩", "Q&A", "스터디"];
    return Scaffold(
      appBar: AppBar(
        title: Text("투두앱"),
        // 안드로이드, 아이폰 모두 title이 가운데 옴!
        // 기본값 : 안드로이드 - 왼쪽, 아이폰 - 가운데
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: titles.length, // 전체 아이템 개수 / 타이틀 개수만큼 반복
        separatorBuilder: (context, index) {
          // index는 있는만큼 증가
          return SizedBox(height: 20);
        },
        itemBuilder: (context, index) {
          return TodoWidget(title: titles[index], isDone: index % 2 == 0);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('버튼');
          showModalBottomSheet(
            context: context,
            // 화면 전체 사용할 수 있게 해주는 속성
            isScrollControlled: true,
            builder: (context) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              print('키보드의 높이는 : $keyboardHeight');

              return Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 20,
                  bottom: 24,
                ),
                margin: EdgeInsets.only(bottom: keyboardHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '할일',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 11),
                    // todo 키보드 올라와있을 때 흰색 컨테이너 터치하면 키보드 없애는 거 구현
                    // todo 저장 버튼 꾸미기
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xff1414e6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff1414e6),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(onPressed: () {}, child: Text('저장')),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Color(0xff5714e6), // 0xff 붙이기
        shape: RoundedRectangleBorder(
          // 모서리 둥글게
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 36),
      ),
    );
  }
}
