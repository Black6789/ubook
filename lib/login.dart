import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool isAsyncCall = false;
  bool isFormValid =false;
  String? r;
  String txt='';
  void checkFormValidation() {
    setState(() {
      if(
      (fnameErrorText == null && fname.text.isNotEmpty) &&
          (lnameErrorText == null && lname.text.isNotEmpty) &&
          (emailErrorText == null && sigemail.text.isNotEmpty) &&
          (passwordErrorText == null && sigpassword.text.isNotEmpty)){
        isFormValid=true;
      }
    });
  }

  Future<void> adddatasign() async {
    try {
      setState(() {
        isAsyncCall = true;
      });
      var url = "https://viewless-disasters.000webhostapp.com/php/signup.php";
      var res = await http.post(Uri.parse(url), body: {
        'fname': fname.text,
        'lname': lname.text,
        'sigemail': sigemail.text,
        'sigpassword': sigpassword.text,
      });

      if (res.statusCode == 200) {
        setState(() {
          isAsyncCall = false;
        });
        String e1 = jsonDecode(res.body);
        print('True');
      }
    }catch(e){
      setState(() {
        isAsyncCall = false;
      });
      print(e);
    }
  }
  Future<void> login() async {
    try {
      setState(() {
        isAsyncCall = true;
      });
      var url = "https://viewless-disasters.000webhostapp.com/php/login.php";
      var res = await http.post(Uri.parse(url), body: {
        'email': logemail.text,
        'password': logpassword.text,
      });

      if (res.statusCode == 200) {
        setState(() {
          isAsyncCall = false;
        });
        String e1 = jsonDecode(res.body);
        if (e1 == 'True') {
          print(e1);
          setState(() {
            r = e1;
          });
        }
        else {
          setState(() {
            txt = e1;
          });
        }
      }
    }catch(e){
      setState(() {
        isAsyncCall = false;
      });
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
       // Navigator.of(context).pushReplacement(
        //  MaterialPageRoute(builder: (context) => prpa()),
       // );
      }
    });
  }


  int x = 1;
  final emailRegex = RegExp(r'/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  TextEditingController logemail = TextEditingController();
  TextEditingController logpassword = TextEditingController();
  TextEditingController sigemail = TextEditingController();
  TextEditingController sigpassword = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  FocusNode _focusNode = FocusNode();
  FocusNode _focusNode1 = FocusNode();
  String? emailErrorText ;
  String?passwordErrorText;
  String?fnameErrorText;
  String?lnameErrorText;



  FocusNode fnameFocusNode = FocusNode();
  FocusNode lnameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final SWidth = MediaQuery.of(context).size.width;
    final SHeight = MediaQuery.of(context).size.height;



    return Scaffold(

      backgroundColor: Color(int.parse('0xFF04305E')) ,

        body: Stack(
          children: [


        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [



            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.38),
                height: SHeight*0.38,

                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
            ),


          ],
        ),
            Positioned(
              top:   SHeight*0.35,
              right: -135,
              child: ClipOval(
                child: Container(
                  height: 200,
                  width: 200,
                  color: Color(int.parse('0xFFFBC61A')),

                ),
              ),
            ),

               Column(
                children: [
                  SizedBox(height: SHeight*0.40,),
                  Container(
                    padding:  EdgeInsets.symmetric(horizontal: 100),
                    child: TextFormField(
                      controller: logemail,



                      focusNode: _focusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        floatingLabelStyle: TextStyle(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    child: TextField(
                      controller: logpassword,
                      focusNode: _focusNode1,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.remove_red_eye_outlined),
                        floatingLabelStyle: TextStyle(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              )



]

        ),


    );
  }
}