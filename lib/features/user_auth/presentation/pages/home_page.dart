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
        title: const Text('User Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showUserForm(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add New User',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: usersCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No users found", style: TextStyle(fontSize: 18)));
                  }

                  final users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final userModel = UserModel.fromSnapshot(user);

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(userModel.username ?? "No Name", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          subtitle: Text(userModel.address ?? "No Address", style: const TextStyle(fontSize: 14)),
                          leading: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteData(user.id),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () => _showUserForm(userId: user.id, userModel: userModel),
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
      ),
    );
  }

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
              _buildTextField(_nameController, "Username", Icons.person),
              _buildTextField(_addressController, "Address", Icons.location_on),
              _buildTextField(_ageController, "Age", Icons.cake, isNumber: true),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

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

  void _deleteData(String id) {
    usersCollection.doc(id).delete();
  }

  void _updateData(String id) {
    usersCollection.doc(id).update({
      "username": _nameController.text,
      "address": _addressController.text,
      "age": int.tryParse(_ageController.text) ?? 0,
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
