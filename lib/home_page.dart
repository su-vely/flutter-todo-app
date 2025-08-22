import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/todo.dart';
import 'package:flutter_todo_app/todo_widget.dart';

// CRUD
// Creat : 투두 작성, Read : 저장된 투두리스트 불러오기, Update : 수정, Delete : 삭제

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 필요한것 : 투두내용(title), 완료여부(isDone)
  List<Todo> todoList = [];

  // @override => 어노테이션
  void buttonClick() {}

  // todos 컬렉션의 모든 투두 데이터 가지고 오는 함수
  void loadTodoList() async {
    // 1. Firestore 인스턴스 (객체)
    final firestore = FirebaseFirestore.instance;
    // 2. 1번에서 만든 객체로 컬렉션 참조 만들어주기
    final colRef = firestore.collection('todos');
    // 3. 2번에서 만든 컬렉션 참조로 모든 데이터 불러오기
    final result = await colRef.get();
    final documentList = result.docs;

    List<Todo> newTodoList = [];
    for (var i = 0; i < documentList.length; i++) {
      final document = documentList[i];
      print(document.id);
      // QueryDocumentSnapshot 이라는 객체 내에서 data() 함수 호출해주면
      // 우리가 원하는 진짜 데이터 반환해줌
      final realData = document.data();
      Todo todo = Todo(title: realData['title'], isDone: realData['isDone']);
      newTodoList.add(todo);
    }

    setState(() {
      todoList = newTodoList;
    });
  }

  // StateFulWidget이 화면에 보일 때 딱 한번만 호출되는 함수
  @override
  void initState() {
    super.initState();
    loadTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("투두앱"),
        // 안드로이드, 아이폰 모두 title이 가운데 옴!
        // 기본값 : 안드로이드 - 왼쪽, 아이폰 - 가운데
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: todoList.length, // 전체 아이템 개수 / 타이틀 개수만큼 반복
        separatorBuilder: (context, index) {
          // index는 있는만큼 증가
          return SizedBox(height: 20);
        },
        itemBuilder: (context, index) {
          Todo todoItem = todoList[index];
          return GestureDetector(
            onTap: () {
              print('투두 위젯 터치');
              // todoItem 변수에 담긴 InDone 바꿔주기!
              todoItem.isDone = !todoItem.isDone;
              setState(() {});
            },
            onLongPress: () {
              print('길게 터치됨');
              // todoList 변수에 담긴 Todo를 삭제
              todoList.removeAt(index);
              setState(() {});
            },
            child: TodoWidget(title: todoItem.title, isDone: todoItem.isDone),
          );
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

              // FIXME dispose 호출 해줘야됨
              TextEditingController controller = TextEditingController();

              return GestureDetector(
                onTap: () {
                  print('터치됨');
                  // 키보드 내릴 때 사용
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
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
                      TextField(
                        controller: controller,
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
                      // ElevatedButton 속성에는 크기를 정할 수 있는 속성이 없음
                      // 부모위젯의 크기가 있다면 => 부모위젯의 크기만큼 버튼크기가 확장
                      // 없으면 자녀 위젯의 크기만큼 축소
                      // double.infinity => 소수 표현하는 타입
                      // => double(소수) 이 가질 수 있는 값중에서 가장 큰 값 무한임
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          // ButtonStyle 클래스 사용하면
                          // WidgetStatePropertyAll(Colors.red)
                          // 이런식으로 객체 하나 더 감싸줘야해서
                          // 코드가 길어짐
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5714e6),
                            foregroundColor:
                                Colors.white, // 버튼 내 아이콘, 텍스트 모두 적용됨
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            // 여기서 todoList에 Map 추가
                            Map<String, dynamic> newDate = {
                              'title': controller.text,
                              'isDone': false,
                            };
                            Todo newTodo = Todo(
                              title: controller.text,
                              isDone: false,
                            );
                            todoList.add(newTodo);
                            setState(() {});
                            // 네비게이터가 관리하는 페이지들 담아놓는 컵(스텍)에서
                            // 가장 위에 쌓인 페이지 꺼내기 => pop
                            print('저장된 투두 리스트 개수 : ${todoList.length}');
                            Navigator.pop(context);
                          },
                          child: Text('저장'),
                        ),
                      ),
                    ],
                  ),
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
