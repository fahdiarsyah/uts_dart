import 'package:flutter/material.dart';
import 'package:to_do_list/todo.dart';
import 'package:to_do_list/database_helper.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
  });
  
  @override
  State<StatefulWidget> createState() => _TodoList();
}

class _TodoList extends State<TodoList>{
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _deksripsiCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  List<Todo> todoList = [];

  final dbHelper = DatabaseHelper();

  void refreshList() async {
    final todos = await dbHelper.getAllTodos();
    setState(() {
      todoList = todos;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void addItem() async {
    await dbHelper.addTodo(Todo(_namaCtrl.text, _deksripsiCtrl.text));
    refreshList();
  }

  void updateItem(int index, bool done) async {
    todoList[index].done = done;
    await dbHelper.updateTodo(todoList[index]);
    refreshList();
  }

  void deleteItem(int id) async {
    await dbHelper.deleteTodo(id);
    refreshList();
  }

    
  void cariTodo() async {
    String teks = _searchCtrl.text.trim();
    List<Todo> todos = [];
    if(teks.isEmpty) {
      todos = await dbHelper.getAllTodos();
    } else {
      todos = await dbHelper.searchTodo(teks);
    }

    setState(() {
      todoList = todos;
    });
  }

  void editForm(int index) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(20),
        title: const Text("Edit To-Do"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              todoList[index].nama = _namaCtrl.text;
              todoList[index].deksripsi = _deksripsiCtrl.text;
              dbHelper.updateTodo(todoList[index]);
              refreshList();
              Navigator.pop(context);
            },
            child: const Text("SAVE"),
          ),
        ],
        content: SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              tfieldTodo(_namaCtrl..text = todoList[index].nama, "Name of Activity"),
              tfieldTodo(_deksripsiCtrl..text = todoList[index].deksripsi, "Description of Activities"),
            ],
          )
        )
      )
    );
  }

  void tampilForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(20),
        title: const Text("Add To-Do"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CLOSE")
          ),
          ElevatedButton(
            onPressed: () {
              addItem();
              Navigator.pop(context);
            },
            child: const Text("ADD")
          ),
        ],
        content: SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              tfieldTodo(_namaCtrl, "Name of Activity"),
              tfieldTodo(_deksripsiCtrl, "Description of Activities"),
            ],
          )
        )
      ),
    );
  }

  TextField tfieldTodo(TextEditingController textCtrl, String? namaHint) {
    return TextField(
              controller: textCtrl,
              decoration: InputDecoration(hintText: namaHint),
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do List Application',
          style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black54,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _namaCtrl.text = '';
          _deksripsiCtrl.text = '';
          tampilForm();
        },
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        child: attIcon(Icons.add_task_sharp, Colors.white),
      ),
      body: Column(
        children: [
          navSearch(),
          contentTodo(),
        ],
      ),
    );
  }

  Expanded contentTodo() {
    return Expanded(
          child: ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: todoList[index].done
                  ? IconButton(
                    icon: attIcon(Icons.check_circle_sharp, Colors.black),
                    onPressed: () {
                      updateItem(index, !todoList[index].done);
                    },
                  )
                  : IconButton(
                    icon:attIcon(Icons.radio_button_unchecked_sharp, Colors.black),
                    onPressed: () {
                      updateItem(index, !todoList[index].done);
                    },
                  ),
                title: Text(
                  todoList[index].nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(todoList[index].deksripsi),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  IconButton(
                    icon: attIcon(Icons.edit_sharp, Colors.orange),
                    onPressed: () {
                      editForm(index);
                    },
                  ),
                  IconButton(
                    icon: attIcon(Icons.delete_sharp, Colors.red),
                    onPressed: () {
                      deleteItem(todoList[index].id ?? 0);
                    },
                  )],
                ),
              );
            },
          )
        );
  }

  Icon attIcon(IconData namaIcon, Color? warnaIcon) {
    return Icon(
      namaIcon,
      color: warnaIcon,
    );
  }

  Container navSearch() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (_) {
              cariTodo();
            },
            decoration: InputDecoration(
              hintText: "Please search here...",
              prefixIcon: const Icon(Icons.search_sharp),
              border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
  }
}