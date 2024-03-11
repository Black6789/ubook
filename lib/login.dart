import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'Home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String es="";
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
      var url = "https://ubooksstore.000webhostapp.com/signup.php";
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
        setState(() {
          es=e1;
        });

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
      var url = "https://ubooksstore.000webhostapp.com/login.php";
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
     // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

     // if (isLoggedIn) {
      //  Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(builder: (context) => homepage()),
     //   );
     // }
    });
  }


  int x = 0;
  final emailRegex = RegExp(r'/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  TextEditingController logemail = TextEditingController();
  TextEditingController logpassword = TextEditingController();
  TextEditingController sigemail = TextEditingController();
  TextEditingController sigpassword = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  String? emailErrorText ;
  String?passwordErrorText;
  String?fnameErrorText;
  String?lnameErrorText;


  FocusNode fnameFocusNode = FocusNode();
  FocusNode logemailFocusNode = FocusNode();
  FocusNode logpassFocusNode = FocusNode();
  FocusNode lnameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final SWidth = MediaQuery.of(context).size.width;
    final SHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: Color(int.parse('0xFF04305E')),
      body: ModalProgressHUD(
          inAsyncCall: isAsyncCall,
          child: SingleChildScrollView(
            child: x == 0
                ? Stack(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipPath(
                          clipper: OvalBottomBorderClipper(),
                          child: Container(
                            color: Color.fromRGBO(0, 0, 0, 0.38),
                            height: SHeight * 0.34,
                            child: Center(
                              child: ClipOval(
                                  child: Image.asset("images/img.png",
                                      width: 300, height: 300)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: SHeight * 0.30,
                      right: -150,
                      child: ClipOval(
                        child: Container(
                          height: 220,
                          width: 200,
                          color: Color(int.parse('0xFFFBC61A')),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: SHeight * 0.45,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: SWidth * 0.08, right: SWidth * 0.15),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: logemail,
                            focusNode: logemailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                child: Icon(Icons.email_outlined),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.20),
                                    width: 0),
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(int.parse('0xFFFBC61A')),
                                    width: 2.0), // White border on focus
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(
                              left: SWidth * 0.08, right: SWidth * 0.15),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            controller: logpassword,
                            focusNode: logpassFocusNode,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                child: Icon(Icons.remove_red_eye_outlined),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.20),
                                    ),
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(int.parse('0xFFFBC61A')),
                                    width: 2.0), // White border on focus
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          txt,
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: SWidth * 0.06,
                            ),
                            Text(
                              'Sign in',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SWidth * 0.34,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await login();
                                if (r == "True") {
                                  setState(() {
                                    txt = "";
                                    r = '';
                                  });
                                  logemail.clear();
                                  logpassword.clear();
                                  logemailFocusNode.unfocus();
                                  logpassFocusNode.unfocus();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('isLoggedIn', true);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => homepage()),
                                  );
                                }
                              },
                              child: ClipOval(
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  color: Color(int.parse('0xFFFBC61A')),
                                  child: Icon(
                                    Icons.arrow_forward_outlined,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SHeight * 0.12,
                        ),
                        Container(
                          width: SWidth*0.75,
                          alignment: Alignment.topLeft,
                           height: 30,
                          child:    GestureDetector(
                            onTap: () {
                              setState(() {
                                x = 1;
                              });
                              logemail.clear();
                              logpassword.clear();
                              logemailFocusNode.unfocus();
                              logpassFocusNode.unfocus();
                            },
                            child: Text(
                              "Sign up ",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Color(int.parse('0xFFFBC61A')),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(int.parse('0xFFFBC61A')),
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ])
                : Stack(
                        children: [
                          Positioned(
                            top:SHeight*-0.25,
                            right: SWidth*-0.1,

                            child: ClipOval(
                              child: Container(
                                height: SWidth*1.2,
                                width: SWidth*2,
                                color: Color.fromRGBO(0, 0, 0, 0.38),
                              ),
                            ),
                          ),
                          Positioned(
                            top:SHeight*0.77,
                            right: SWidth*-0.3,


                            child: ClipOval(
                              child: Container(
                                height: SWidth*0.8,
                                width: SWidth*0.8,
                                color: Color.fromRGBO(0, 0, 0, 0.38),
                              ),
                            ),
                          ),
                          Container(
                            height: SHeight,

                        child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: SHeight*0.01,),
                              Container(
                                height: 75,
                                width: 75,
                                child: IconButton(
                                  color: Color(int.parse('0xFFFBC61A')),
                                    onPressed: (){
                                      fname.clear();
                                      lname.clear();
                                      sigemail.clear();
                                      sigpassword.clear();
                                      fnameFocusNode.unfocus();
                                      lnameFocusNode.unfocus();
                                      emailFocusNode.unfocus();
                                      passwordFocusNode.unfocus();
                                      setState(() {
                                        fnameErrorText=null;
                                        lnameErrorText=null;
                                        emailErrorText=null;
                                        passwordErrorText=null;
                                      });


                                 setState(() {
                                   x=0;
                                 });
                                }, icon: Icon(Icons.arrow_back)

                                ),

                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: SWidth * 0.05,),
                                height: 150,
                                width: 250,
                                child: Column(
                                  children: [

                                  Text("Create\nAccount",style:GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 45,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ), ),
                                  ],
                                )
                              ),

                              SizedBox(height:SHeight*0.10),

            Container(
              height: SHeight*0.36,
              padding: EdgeInsets.symmetric(horizontal: SWidth*0.12),


              child:Column(

                children: [


                  SizedBox(height: 12),
                      Container(

                        height: 80,

                      child: Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                      height: 80,
                      width: 150,
                      child:
                     TextFormField(
                       style: TextStyle(color: Colors.white),
                       focusNode: fnameFocusNode,
                       controller: fname,
                       keyboardType: TextInputType.text,
                       onChanged: (value) {
                         if (value.isEmpty) {
                           setState(() {
                             fnameErrorText = 'first name required';
                           });
                         } else {
                           if (value.length < 3) {
                             setState(() {
                               fnameErrorText = ' at least 3 characters long';
                             });
                           } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                             setState(() {
                               fnameErrorText = 'must contain only letters';
                             });
                           } else {
                             setState(() {
                               fnameErrorText = null;
                             });
                           }
                         }
                       },

                       decoration: InputDecoration(
                         filled: true,
                         errorText: fnameErrorText,
                         fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                         hintText: '  First name',
                         hintStyle: TextStyle(color: Colors.white),

                         floatingLabelStyle: TextStyle(fontSize: 15),
                         border:   OutlineInputBorder(
                           borderSide: BorderSide(
                             color: Color.fromRGBO(0, 0, 0, 0.20),
                           ),
                           borderRadius: BorderRadius.circular(32.0),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                               color: Color(int.parse('0xFFFBC61A')),
                               width: 2.0), // White border on focus
                           borderRadius: BorderRadius.circular(32.0),
                         ),
                       ),
                     ),
                     ),
                     SizedBox(
                      width: 10,
                     ),
                     Container(
                       alignment: Alignment.topLeft,
                     height: 80,
                     width: 150,
                     child:
                     TextFormField(
                       style: TextStyle(color: Colors.white),
                       focusNode: lnameFocusNode,
                       controller: lname,
                       keyboardType: TextInputType.text,
                       onChanged: (value) {
                         if (value.isEmpty) {
                           setState(() {
                             lnameErrorText = 'last name required';
                           });
                         } else {
                           if (value.length < 3) {
                             setState(() {
                               lnameErrorText = 'at least 3 characters long';
                             });
                           }else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                             setState(() {
                               lnameErrorText = 'must contain only letters';
                             });
                           }else {
                             setState(() {
                               lnameErrorText = null;
                             });
                           }
                         }
                       },
                       decoration: InputDecoration(
                         filled: true,
                         errorText: lnameErrorText,
                         fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                         hintText: '  Last name',
                         hintStyle: TextStyle(color: Colors.white),

                         floatingLabelStyle: TextStyle(fontSize: 15),
                         border:   OutlineInputBorder(
                           borderSide: BorderSide(
                             color: Color.fromRGBO(0, 0, 0, 0.20),
                           ),
                           borderRadius: BorderRadius.circular(32.0),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                               color: Color(int.parse('0xFFFBC61A')),
                               width: 2.0), // White border on focus
                           borderRadius: BorderRadius.circular(32.0),
                         ),
                       ),
                     ),
                     ),
                  ]
                      )
                      ),

                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    focusNode: emailFocusNode,
                    controller: sigemail,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          emailErrorText = 'Email required';
                        });
                      } else if (!EmailValidator.validate(value)&&emailRegex.hasMatch(value)==false) {
                        setState(() {
                          emailErrorText = 'Invalid Email';
                        });
                      } else {
                        setState(() {
                          emailErrorText = null;
                        });
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      errorText: emailErrorText,
                      fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                        child: Icon(Icons.email_outlined),
                      ),
                      floatingLabelStyle: TextStyle(fontSize: 15),
                      border:   OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(0, 0, 0, 0.20),
                        ),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(int.parse('0xFFFBC61A')),
                            width: 2.0), // White border on focus
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    focusNode: passwordFocusNode,
                    controller: sigpassword,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          passwordErrorText = 'Password required';
                        });
                      } else {
                        if (value.length < 8) {
                          setState(() {
                            passwordErrorText = 'at least 8 characters long';
                          });
                        } else if (!value.contains(RegExp(r'[a-zA-Z]'))) {
                          setState(() {
                            passwordErrorText = ' at least one letter';
                          });
                        } else {
                          setState(() {
                            passwordErrorText = null;

                          });
                        }
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      errorText:passwordErrorText,
                      fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                        child: Icon(Icons.lock_outline_rounded),
                      ),
                      floatingLabelStyle: TextStyle(fontSize: 15),
                      border:   OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(0, 0, 0, 0.20),
                        ),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(int.parse('0xFFFBC61A')),
                            width: 2.0), // White border on focus
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                es == "True" ? Text(
                  "Added Successfully",
                  style: TextStyle(color: Color(int.parse('0xFFFBC61A'))),
                ) :es=="false"?Text(
                  "Email is already exist",
                  style: TextStyle(color: Colors.red),
                ):
                SizedBox(),


                  ]
              )
            ),
Container(
  padding: EdgeInsets.only(left: SWidth * 0.12),
  height: 90,

          child:   Row(
                                  children: [

                                    Text(
                                      'Done',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: SWidth * 0.34,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        checkFormValidation();
                                        if(isFormValid==true) {
                                          await adddatasign();
                                          if(es=="True") {

                                            fname.clear();
                                            lname.clear();
                                            sigemail.clear();
                                            sigpassword.clear();
                                          }
                                          fnameFocusNode.unfocus();
                                          lnameFocusNode.unfocus();
                                          emailFocusNode.unfocus();
                                          passwordFocusNode.unfocus();

                                        }
                                      },
                                      child: ClipOval(
                                        child: Container(
                                          height: 90,
                                          width: 90,
                                          color: Color(int.parse('0xFFFBC61A')),
                                          child: Icon(
                                            Icons.arrow_forward_outlined,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
),
          ]
                          )
                          )
                        ],
                      ),

          )
      ),
    );
  }
}
