import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:956852221273:android:f05b788b3401a74b840848',
      apiKey: 'AIzaSyADFe2sHFoC_Q2iv-5x6G0zjCwbqGkr0oA',
      messagingSenderId: '956852221273',
      projectId: "todoapp-be862",
      // Add more options as needed for other Firebase services
    ),
  ); // Initialize Firebase with specific options
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _email = '';
  String _password = '';
  String _errorMessage = '';
  bool _passwordVisible = false; // Added this line for password visibility

  void _signInWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _errorMessage = ''; // Clear any previous error messages
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodoHomePage(userCredential.user!.displayName ?? '', userCredential.user!.email ?? '')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _errorMessage = ''; // Clear any previous error messages
    });
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodoHomePage(userCredential.user!.displayName ?? '', userCredential.user!.email ?? '')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim(); // Update the email
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim(); // Update the password
                    });
                  },
                  obscureText: !_passwordVisible, // Use the _passwordVisible variable to toggle password visibility
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off), // Change icon based on _passwordVisible value
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _signInWithEmailAndPassword(context),
                  child: Text('Sign In'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _signInWithGoogle(context),
                  child: Text('Sign In with Google'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('New User? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  String _errorMessage = '';

  void _signUpWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _errorMessage = ''; // Clear any previous error messages
    });
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim(); // Update the email
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim(); // Update the password
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _signUpWithEmailAndPassword(context),
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  TodoHomePage(this.userName, this.userEmail);

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _activityController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _imageFile;

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(String activityId) async {
    try {
      if (_imageFile != null) {
        // Upload the image to Firebase Storage
        TaskSnapshot snapshot = await _storage.ref().child('activities/$activityId.jpg').putFile(_imageFile!);
        String downloadURL = await snapshot.ref.getDownloadURL();

        // Update the Firestore document with the image URL
        await FirebaseFirestore.instance.collection('activities').doc(activityId).update({'imageUrl': downloadURL});
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _addActivity(String userId) async {
    String activity = _activityController.text.trim();
    if (activity.isNotEmpty) {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('activities').add({
        'userId': userId,
        'activity': activity,
        'isCompleted': false,
        'date': DateTime.now(),
        'imageUrl':''
      });

      // Upload image if available
      if (_imageFile != null) {
        await _uploadImage(docRef.id);
      }

      _activityController.clear();
      setState(() {
        _imageFile = null;
      });
    }
  }

  void _deleteActivity(String activityId) {
    FirebaseFirestore.instance.collection('activities').doc(activityId).delete();
  }

  void _toggleActivityCompletion(String activityId, bool isCompleted) {
    FirebaseFirestore.instance.collection('activities').doc(activityId).update({'isCompleted': !isCompleted});
  }

  void _editActivity(String activityId, String newActivity) {
    FirebaseFirestore.instance.collection('activities').doc(activityId).update({'activity': newActivity});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _activityController,
                    decoration: InputDecoration(
                      labelText: 'Enter Activity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Select Image'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _addActivity(widget.userEmail),
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('activities').where('userId', isEqualTo: widget.userEmail).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No activities yet')); // Show message if no data or no activities
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                    String activityId = documents[index].id;

                    return Dismissible(
                      key: Key(activityId),
                      onDismissed: (_) {
                        _deleteActivity(activityId);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                      ),
                      child: CheckboxListTile(
                        title: Row(
                          children: [
                            if (data.containsKey('imageUrl'))
                              Image.network(
                                data['imageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                initialValue: data['activity'],
                                onFieldSubmitted: (newValue) {
                                  _editActivity(activityId, newValue);
                                },
                                style: TextStyle(
                                  decoration: data['isCompleted'] ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        value: data['isCompleted'],
                        onChanged: (bool? newValue) {
                          _toggleActivityCompletion(activityId, data['isCompleted']);
                        },
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
}
