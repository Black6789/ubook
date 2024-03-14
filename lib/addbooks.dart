import 'dart:io';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'Home.dart';

class addb extends StatefulWidget {
  final List<Category> cat; // تحديث استيراد الفئة واستخدام List<Category>
  addb({required this.cat});

  @override
  State<addb> createState() => _addbState();
}

class _addbState extends State<addb> {
  @override
  String filterTextcat = '';

  FocusNode cnameFocusNode = FocusNode();
  FocusNode descFocusNode = FocusNode();
  TextEditingController nationality = TextEditingController();
  TextEditingController cname = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController authEditingController = TextEditingController();
  TextEditingController catEditingController = TextEditingController();
  TextEditingController descreption = TextEditingController();
  String cvalue = '';
  late bool showListauth;
  late bool showListcat;
  late String txt;
  late Image image;
  String? r;
  String? selectedAuthor;
  String? titleErrorText;
  FocusNode titleFocusNode = FocusNode();
  File? file;
  //late String Nfile;
  late String imageName = 'No image selected';
  late File imageFile;
  String nauthor = '';
  bool isAsyncCall = false;
  Category? selectedCategory;
  String hintText = 'Select Category';
  String State="";

  String valueselected = "";
  String? natErrorText;
  String? catErrorText;
  String? addressErrorText;
  Color buttoncolor = Colors.blue;
  bool _isButtonEnabled = true;
  int x = 1;
  bool addbookValid = false;
  bool addcatValid = false;
  bool addauthValid = false;
  bool isImageSelected = false;
  bool isLoading = false;
  void checkFormValidation() {
    if (descreption.text.isNotEmpty &&
        title.text.isNotEmpty &&
        filterTextcat.isNotEmpty &&
        isImageSelected != false) {
      setState(() {
        addbookValid = true;
      });
    } else {
      setState(() {
        addbookValid = false;
      });
    }
  }

  void checkcat() {
    if (cname.text.isNotEmpty && catErrorText == null) {
      setState(() {
        addcatValid = true;
      });
    } else {
      setState(() {
        addcatValid = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Check the mime type
      String mimeType = lookupMimeType(pickedImage.path) ?? '';
      List<String> allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif'];

      if (allowedMimeTypes.contains(mimeType)) {
        setState(() {
          isImageSelected = true;
          imageFile = File(pickedImage.path);
          imageName = pickedImage.name;
        });
      } else {
        print('Unsupported image type.');
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> addbook() async {
    try {
      setState(() {
        isAsyncCall = true;
      });

      var url = "https://viewless-disasters.000webhostapp.com/php/addbook.php";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Attach the file to the request

      // Add other form data
      request.fields['title'] = title.text;
      request.fields['category'] = filterTextcat;
      request.fields['description'] = descreption.text;

      // Upload the image if it's available

      request.files.add(http.MultipartFile(
        'image',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split('/').last,
      ));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          isAsyncCall = false;
        });
        String e1 = jsonDecode(response.body);
        if (e1 == "True") {
          print(e1);
          setState(() {
            r = e1;
          });
        } else {
          setState(() {
            print(e1);
            txt = e1;
          });
        }
      }
    } catch (e) {
      setState(() {
        isAsyncCall = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isAsyncCall = true;

      showListauth = false;
      showListcat = false;
      txt = '';
      r = '';
      selectedAuthor = '';
    });

    setState(() {
      isAsyncCall = false;
    });
  }

  void toggleButtonState() {
    setState(() {
      _isButtonEnabled = !_isButtonEnabled;
      buttoncolor = _isButtonEnabled ? Colors.blue : Colors.black;
    });
  }

  Widget build(BuildContext context) {
    final SWidth = MediaQuery.of(context).size.width;
    final SHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(int.parse('0xFF04305E')),
        body: ModalProgressHUD(
            inAsyncCall: isAsyncCall,
            child: SingleChildScrollView(
                child: Column(

                    children: [
              SizedBox(
                height: 20,
              ),
              Row(children: [
                IconButton(
                  color: Color(int.parse('0xFFFBC61A')),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => homepage()));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  'Add Books',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 40,
                      color: Color(int.parse('0xFFFFBC61A')),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: SHeight * 0.10),
              Container(

                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      focusNode: titleFocusNode,
                      controller: title,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            titleErrorText = 'is required';
                          });
                        } else {
                          setState(() {
                            titleErrorText = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        errorText: titleErrorText,
                        fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                        hintText: '  Title',
                        hintStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(fontSize: 15),
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
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      focusNode: descFocusNode,
                      controller: descreption,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            addressErrorText = 'address required';
                          });
                        } else {
                          setState(() {
                            addressErrorText = null;
                          });
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        filled: true,
                        errorText: addressErrorText,
                        fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                        hintText: '  Descreption',
                        hintStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(fontSize: 15),
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
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<Category>(
                      value: selectedCategory,
                      hint: Text(
                        hintText,
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: Color(int.parse('0xFFF052a50')),
                      onChanged: (Category? value) {
                        setState(() {
                          if (value != null) {
                            hintText = value.cname;
                            print('Selected Category: ${value.cname}');
                          } else {
                            hintText = 'Select Category';
                            print('No category selected');
                          }
                        });
                      },
                      items: widget.cat
                          .map<DropdownMenuItem<Category>>((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.cname,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),

                    Row(
                      children: [
                        Text("   State:",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        Radio(
                            value: "new",
                            groupValue: State,

                            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Color(int.parse('0xFFFFBC61A'));
                              }
                              return Colors.white;
                            }),
                            onChanged: (val) {
                              setState(() {
                                State=val as String;
                              });

                            }

                            ),
                        Text("new",style: TextStyle(color:State=="new"?Color(int.parse('0xFFFFBC61A')):Colors.white,fontSize: 18),),
                        SizedBox(width: 20,),
                        Radio(
                            value: "used",
                            groupValue: State,
                            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Color(int.parse('0xFFFFBC61A'));
                              }
                              return Colors.white;
                            }),
                            onChanged: (val) {
                              setState(() {
                                State=val as String;
                              });

                            }),
                        Text("used",style: TextStyle(color:State=="used"?Color(int.parse('0xFFFFBC61A')):Colors.white,fontSize: 18),),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            // Text(
                            //  '$Nfile',
                            //  style: TextStyle(fontSize: 16),
                            // )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: Text('Choose Image'),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              '$imageName',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          checkFormValidation();
                          if (addbookValid) {
                            await addbook();
                          } else {
                            print(
                                "Erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
                          }
                        },
                        child: Text("addbook"))
                  ],
                ),
              ),
            ]))));
  }
}
