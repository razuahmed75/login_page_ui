// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  static const String path = "homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var getId;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameEditingCtrl = TextEditingController();
  TextEditingController ageEditingCtrl = TextEditingController();

  void toast(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontFamily: "Raleway", color: Colors.white),
    )));
  }

  getUsers() {
    return FirebaseFirestore.instance.collection("todos").get();
  }

  CollectionReference todos = FirebaseFirestore.instance.collection("todos");
  void addUser() {
    todos.add({
      'Name': nameEditingCtrl.text,
      'Age': ageEditingCtrl.text,
    }).then((value) {
      setState(() {});
      nameEditingCtrl.clear();
      ageEditingCtrl.clear();

      toast("Successfully added");
    }).catchError((error) {
      toast("Failed to add $error");
    });
  }

  void editUser(id, name, age) {
    setState(() {
      getId = id;
      nameEditingCtrl.text = name;
      ageEditingCtrl.text = age;
    });
  }

  void updateUser() {
    FirebaseFirestore.instance.collection("todos").doc(getId).update({
      "Name": nameEditingCtrl.text,
      "Age": ageEditingCtrl.text
    }).then((value) {
      setState(() {});
      nameEditingCtrl.clear();
      ageEditingCtrl.clear();

      toast("Successfully updated");
    }).catchError((onError) {
      toast("Failed to update: $onError");
    });
  }

  void deleteUser(getId) {
    FirebaseFirestore.instance
        .collection("todos")
        .doc(getId)
        .delete()
        .then((value) {
      setState(() {});
      toast("Successfully deleted");
    }).catchError((onError) {
      toast("Failed to delete: $onError");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          "FIREBASE CRUD",
          style: TextStyle(fontFamily: "Raleway", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field must not be empty!";
                  }
                  return null;
                },
                controller: nameEditingCtrl,
                decoration: InputDecoration(
                  hintText: "name",
                  hintStyle: TextStyle(fontFamily: "Raleway"),
                  errorStyle: TextStyle(fontFamily: "Raleway"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field must not be empty!";
                  }
                  return null;
                },
                controller: ageEditingCtrl,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: InputDecoration(
                  hintText: "age",
                  hintStyle: TextStyle(fontFamily: "Raleway"),
                  errorStyle: TextStyle(fontFamily: "Raleway"),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(150, 40)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addUser();
                      }
                    },
                    child: Text("Add")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(150, 40)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUser();
                      }
                    },
                    child: Text("Update")),
              ],
            ),
            FutureBuilder(
                future: getUsers(),
                builder:
                    (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (!snapshot.hasData) {
                    return Text("Data not found");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<DocumentSnapshot> todo = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: todo.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return ListTile(
                              leading: Icon(Icons.message),
                              title: Text(todo[index]['Name']),
                              subtitle: Text(todo[index]['Age']),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          deleteUser(todo[index].id);
                                        },
                                        icon: Icon(Icons.delete)),
                                    IconButton(
                                        onPressed: () {
                                          editUser(
                                              todo[index].id,
                                              todo[index]['Name'],
                                              todo[index]["Age"]);
                                        },
                                        icon: Icon(Icons.edit)),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }

                  return CircularProgressIndicator(
                    color: Colors.red,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
