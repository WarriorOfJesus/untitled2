import 'package:flutter/material.dart';
import 'package:untitled2/models/user.dart';

class UserInfoPage extends StatelessWidget {
  User? user;

  UserInfoPage({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Page'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Card(
        margin: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${user?.name}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text('${user?.story}'),
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              trailing: Text('${user?.country}'),
            ),
            ListTile(
              title: Text(
                '${user?.phone}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(
                Icons.phone,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                '${user?.email}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(
                Icons.mail,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
