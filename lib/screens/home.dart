import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/hadafi_appbar.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../components/hadafi_todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _filteredToDo = [];
  final _todoController = TextEditingController();
  final _filterController = TextEditingController();
  final _user = FirebaseAuth.instance.currentUser!;
  bool _isTyping = false;

  @override
  void initState() {
    _filteredToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: const HadafiAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'Welcome to Hadafis, ${_user.email!}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todo in _filteredToDo.reversed)
                        HadafiTodoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _handleToDoDelete,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      onChanged: (value) {
                        setState(() {
                          _isTyping = value.isEmpty ? false : true;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Add new Hadaf',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 60),
                      elevation: 5.0,
                      backgroundColor: _isTyping ? tdBlue : Colors.black26,
                    ),
                    onPressed: () {
                      // print('Pressed add todo button');
                      _handleToDoAdd(_todoController.text);
                    },
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleToDoDelete(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _handleToDoAdd(String todoText) {
    setState(() {
      if (todoText != "") {
        _isTyping = false;
        todosList.add(
          ToDo(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            todoText: todoText,
          ),
        );
      }
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((todo) => todo.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _filterController,
        onChanged: (text) {
          _runFilter(text);
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }
}
