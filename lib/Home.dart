import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:google_fonts/google_fonts.dart';
import 'Home.dart';
import 'addbooks.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

bool isAsyncCall = false;

class _homepageState extends State<homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: Container(
            color: Color(int.parse('0xFFF04305e')),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                ClipOval(
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      "images/img.png",
                      height: 85,
                      width: 85,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'user23762',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle_outlined,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.book_outlined,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'My Books',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => addb()),
                    );
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.swap_horiz_outlined,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'Trade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.monetization_on_sharp,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'Sell',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.sell_outlined,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'your suggestion',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.receipt_long_outlined,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'Orders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outlined,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'About Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout_outlined,
                    color: Color(int.parse('0xFFFFBC61A')),
                    size: 40,
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    // Update UI based on the selected item
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  color: Color(int.parse('0xFFF021e3a')),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color(int.parse('0xFF04305E')),
        body: ModalProgressHUD(
          inAsyncCall: isAsyncCall,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              IconButton(
                color: Color(int.parse('0xFFFBC61A')),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              )
            ],
          )),
        ));
  }
}
