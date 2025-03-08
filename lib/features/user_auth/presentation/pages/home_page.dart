import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User Management')),
      ),
      body: Column(
        children: [
          // Button to Add User
          GestureDetector(
            onTap: () {
              _showUserForm(); // Show form to enter user data
            },
            child: Container(
              height: 50,
              width: 150,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Add New User',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Display User List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userModel = UserModel.fromSnapshot(user);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ListTile(
                        title: Text(userModel.username ?? "No Name"),
                        subtitle: Text(userModel.address ?? "No Address"),
                        leading: GestureDetector(
                          onTap: () => _deleteData(user.id),
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                        trailing: GestureDetector(
                          onTap: () => _showUserForm(
                              userId: user.id, userModel: userModel),
                          child: const Icon(Icons.edit, color: Colors.green),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Show User Form for Adding/Updating
  void _showUserForm({String? userId, UserModel? userModel}) {
    if (userModel != null) {
      _nameController.text = userModel.username ?? "";
      _addressController.text = userModel.address ?? "";
      _ageController.text = userModel.age?.toString() ?? "";
    } else {
      _nameController.clear();
      _addressController.clear();
      _ageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(userId == null ? "Add New User" : "Update User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Age"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (userId == null) {
                  _createData();
                } else {
                  _updateData(userId);
                }
                Navigator.pop(context);
              },
              child: Text(userId == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  // Add User
  void _createData() {
    String id = usersCollection.doc().id;
    final newUser = UserModel(
      username: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      address: _addressController.text,
      id: id,
    ).toJson();

    usersCollection.doc(id).set(newUser);
  }

  // Delete User
  void _deleteData(String id) {
    usersCollection.doc(id).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully!')),
      );
    }).catchError((error) {
      print("Error deleting user: $error");
    });
  }

  // Update User
  void _updateData(String id) {
    usersCollection.doc(id).update({
      "username": _nameController.text,
      "address": _addressController.text,
      "age": int.tryParse(_ageController.text) ?? 0,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
    }).catchError((error) {
      print("Error updating user: $error");
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}

// User Model
class UserModel {
  final String? username;
  final String? address;
  final int? age;
  final String? id;

  UserModel({this.id, this.username, this.address, this.age});

  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      username: data['username'],
      address: data['address'],
      age: data['age'],
      id: data['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "age": age,
      "id": id,
      "address": address,
    };
  }
}
