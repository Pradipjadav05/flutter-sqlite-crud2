// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rkit_task/model/user.dart';

import '../utils/database_halper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static int id = 0;
  var db = DatabaseHelper();

  List<Users> _itemList = <Users>[];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readUserList();
  }

  void _handleSubmitted(int id, String unm, String pass) async {
    print("Username : $unm");
    print("Password : $pass");
    print("Id : $id");
    // id++;
    Users addUser = Users(id: id, name: unm, password: pass);
    int savedUser = await db.saveData(addUser);

    setState(() {
      _readUserList();
    });

    print("Item saved id: $savedUser");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLITE CRUD"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  child: ListTile(
                    title: Text("Username : ${_itemList[index].name}"),
                    subtitle: Text("Password : ${_itemList[index].password}"),
                    trailing: Wrap(children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.green,
                        onPressed: () => _showUpdateDialog(_itemList[index].id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          db.deleteUser(_itemList[index].id);
                          setState(() {
                            _itemList.removeAt(index);
                          });
                          print("deleted...");
                        },
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        child: const ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: "Username",
                hintText: "eg. Pradip05",
                icon: Icon(Icons.person)),
          ),
          TextField(
            controller: _passwordController,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: "Password",
                hintText: "eg. 123",
                icon: Icon(Icons.lock)),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              id++;
              _handleSubmitted(
                  id, _usernameController.text, _passwordController.text);
              _clearController();
              Navigator.pop(context);
            },
            child: const Text("Save")),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    );
    showDialog(
      context: context,
      builder: (_) {
        return alert;
      },
    );
  }

  void _readUserList() async {
    final item = await db.getUser();
    // ignore: avoid_function_literals_in_foreach_calls
    item.forEach((element) {
      setState(() {
        _itemList = item;
      });
    });
  }

  void _showUpdateDialog(int id) {
    var dialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
                labelText: "Username", hintText: "e.g. Pradip05"),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
                labelText: "Password", hintText: "e.g. 123"),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () async {
            Users updateUser = Users.fromMap({
              "name": _usernameController.text,
              "id": id,
              "password": _passwordController.text,
            });

            await db.updateUser(updateUser);

            _clearController();
            setState(() {
              _readUserList();
            });

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void _clearController() {
    _usernameController.text = "";
    _passwordController.text = "";
  }
}
