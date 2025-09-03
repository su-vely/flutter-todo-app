import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/home_page_view_model.dart';
import 'package:flutter_todo_app/todo.dart';
import 'package:flutter_todo_app/todo_widget.dart';

// CRUD
// Creat : 투두 작성, Read : 저장된 투두리스트 불러오기, Update : 수정, Delete : 삭제

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef ref => 리버팟 뷰모델 관리자한테 접근할 수 있게 해주는 객체
    // 1. 상태 가지고 오기
    final homeState = ref.watch(HomeViewModelProvider);
    // 2. 뷰모델 객체 가지고오기
    final homeViewModel = ref.read(HomeViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("투두앱"),
        // 안드로이드, 아이폰 모두 title이 가운데 옴!
        // 기본값 : 안드로이드 - 왼쪽, 아이폰 - 가운데
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: homeState.todoList.length, // 전체 아이템 개수 / 타이틀 개수만큼 반복
        separatorBuilder: (context, index) {
          // index는 있는만큼 증가
          return SizedBox(height: 20);
        },
        itemBuilder: (context, index) {
          Todo todoItem = homeState.todoList[index];
          return GestureDetector(
            onTap: () async {
              print('투두 위젯 터치');
              homeViewModel.updateTodo(todoItem.id, !todoItem.isDone);
            },
            onLongPress: () async {
              print('길게 터치됨');

              final result = await showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('삭제 하시겠습니까?'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        isDestructiveAction: true,
                        child: Text('삭제'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        isDefaultAction: true,
                        child: Text('취소'),
                      ),
                    ],
                  );
                  return Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.amber,
                    ),
                  );
                },
              );
              print('팝업 닫힘');
              if (result == true) {
                homeViewModel.deleteTodo(todoItem.id);
              }
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
                          onPressed: () async {
                            homeViewModel.createTodo(controller.text);
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
