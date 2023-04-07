import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Make a Flutter App
// Objectives :

// • CREATE a Flutter app and integrate the following apis :
// reqres.in (From this given site)
// Connect: /api/users?page=2
// And /api/users post route
// • Make the API integration visible with a basic UI

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReqRes.in API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReqRes.in API Demo'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final email = user.email;
            final first_name = user.first_name;
            final imageUrl = user.avatar;
            final last_name = user.last_name;
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
              title: Text('${first_name} ${last_name}'),
              subtitle: Text(email),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createUser();
        },
        tooltip: 'Create User',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchUsers() async {
    print('fetchUser called');
    final url = "https://reqres.in/api/users?page=2";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    if (response.statusCode == 200) {
      final jsonData = json.decode(body);
      //final json = jsonDecode(body);
      setState(() {
        users = List<User>.from(jsonData['data'].map((x) => User.fromJson(x)));
        //users = List<dynamic>.from(json['data']);
      });
      print('fetchUsers completed');
    }
  }

  Future<void> createUser() async {
    final url = "https://reqres.in/api/users";
    final uri = Uri.parse(url);
    final response = await http
        .post(uri, body: {'name': 'John Doe', 'job': 'Software Developer'});
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      setState(() {
        users.add(User.fromJson(jsonData));
      });
    }
  }
}

class User {
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String avatar;

  User(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.avatar});
//       String jsonsDataString = responseJson.toString();
// final jsonData = jsonDecode(jsonsDataString);

// //then you can get your values from the map
// if(jsonData[AuthUtils.authTokenKey] != null){
// ...
// }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // String idString = responseJson.toString();
      // final id = jsonDecode(idString);
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
