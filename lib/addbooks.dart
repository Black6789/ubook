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
import 'package:ubook/addbooks.dart';
import 'Home.dart';

class addb extends StatefulWidget {
  @override
  State<addb> createState() => _addbState();
}
List<File> images = [];

class author {
  String name;

  author(this.name);
}

List<author> auth = [];

class titles {
  String title_book;
  String cat_book;
  String auth_book;
  titles(this.title_book, this.cat_book, this.auth_book);
}

List<titles> titl = [];
String FilterTexttitle = '';

String FilterTextauth = '';
String filterTextcat = '';

class Category {
  String cname;

  Category(this.cname);
}

List<Category> cat = [];
bool isAsyncCall = false;

class _addbState extends State<addb> {
  @override
  List<author> filteredAuth = auth;
  List<titles> filteredtitle = titl;
  Future<void> lcateg() async {
    try {
      var url = "https://ubooksstore.000webhostapp.com/cat.php";
      final response = await http.post(Uri.parse(url), body: {
        'cat': "True",
      });
      cat.clear();
      if (response.statusCode == 200) {
        setState(() {
          isAsyncCall = false;
        });
        final jsonResponse = convert.jsonDecode(response.body);
        print(response.body);
        for (var item in jsonResponse) {
          cat.add(Category(item['cname']));
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating products: $e');
    }
  }

  Future<void> lauther() async {
    try {
      setState(() {
        isAsyncCall = true;
      });
      var url = "https://ubooksstore.000webhostapp.com/cat.php";
      final response = await http.post(Uri.parse(url), body: {
        'cat': "False",
      });
      auth.clear();
      if (response.statusCode == 200) {
        setState(() {
          isAsyncCall = false;
        });
        final jsonResponse = convert.jsonDecode(response.body);
        print(response.body);
        for (var row in jsonResponse) {
          author a = author(
            row['name'],
          );
          auth.add(a);
        }
        print(auth);
      }
    } catch (e) {
      print('Error updating : $e');
      // Handle the error as needed, e.g., show an error message to the user
    }
  }

  Future<void> lbook() async {
    try {
      setState(() {
        isAsyncCall = true;
      });
      var url = "https://ubooksstore.000webhostapp.com/lbook.php";
      final response = await http.post(Uri.parse(url), body: {});
      titl.clear();
      if (response.statusCode == 200) {
        setState(() {
          isAsyncCall = false;
        });
        final jsonResponse = convert.jsonDecode(response.body);
        print(response.body);
        for (var row in jsonResponse) {
          titles t = titles(
            row['title'],
            row['cname'],
            row['aname'],
          );
          titl.add(t);
        }
        print(titl);
      }
    } catch (e) {
      print('Error updating : $e');
      // Handle the error as needed, e.g., show an error message to the user
    }
  }

  Future<void> addbook() async {
    try {
      setState(() {
        isAsyncCall = true;
      });

      var url = "https://ubooksstore.000webhostapp.com/addbook.php";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add other form data
      request.fields['title'] = titleEditingController.text;
      request.fields['author'] = authEditingController.text;
      request.fields['category'] = catEditingController.text;
      request.fields['description'] = descEditingController.text;
      request.fields['status'] = Status;
      print(titleEditingController.text);
      print(authEditingController.text);
      print(catEditingController.text);
      print(descEditingController.text);

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
  Future<void> getImages() async {
    List<XFile>? xFiles = await ImagePicker().pickMultiImage();
    if (xFiles == null) {
      return;
    }

    int totalImages = images.length + xFiles.length;
    if (totalImages > maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only select up to $maxImages images'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      images.addAll(xFiles.map((xFile) => File(xFile.path)));
    });
  }
  static const int maxImages = 5;
  String filterTextcat = '';

  FocusNode descFocusNode = FocusNode();
  FocusNode titleFocusNode = FocusNode();
  FocusNode authFocusNode = FocusNode();
  TextEditingController nationality = TextEditingController();
  TextEditingController cname = TextEditingController();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController authEditingController = TextEditingController();
  TextEditingController catEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  String cvalue = '';
  late bool showListauth;
  late bool showListtitle;
  late bool showListcat;
  late String txt;
  late Image image;
  String? r;
  String? selectedAuthor;
  String? titleErrorText;
  String? authErrorText;
  File? file;
  //late String Nfile;
  late String imageName = 'No image selected';
  late File imageFile;
  String nauthor = '';
  bool isAsyncCall = false;
  Category? selectedCategory;
  String hintTextCat = '  Select Category';
  String hintTexttitle = '  Title';
  String hintTextauth = '  author';
  String Status = "";

  String valueselected = "";
  String? natErrorText;
  String? catErrorText;
  String? addressErrorText;
  Color buttoncolor = Colors.blue;
  bool isButtonenabled = true;
  int x = 1;
  bool addbookValid = false;
  bool addcatValid = false;
  bool addauthValid = false;
  bool isImageSelected = false;
  bool isLoading = false;
  void checkFormValidation() {
    if (descEditingController.text.isNotEmpty &&
        titleEditingController.text.isNotEmpty &&
        authEditingController.text.isNotEmpty &&
        catEditingController.text.isNotEmpty &&
        Status.isNotEmpty) {
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

  @override
  void initState() {
    // TODO: implement initState
    lbook();
    lcateg();
    lauther();

    super.initState();

    setState(() {
      isAsyncCall = true;
      showListtitle = false;
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

  Widget build(BuildContext context) {
    final SWidth = MediaQuery.of(context).size.width;
    final SHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(int.parse('0xFF04305E')),
        body: ModalProgressHUD(
            inAsyncCall: isAsyncCall,
            child: SingleChildScrollView(
                child: Column(children: [
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
                      controller: titleEditingController,
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
                        setState(() {
                          FilterTexttitle = value;

                          filteredtitle = titl
                              .where((a) => a.title_book
                                  .toLowerCase()
                                  .startsWith(value.toLowerCase()))
                              .toList();
                          showListtitle =
                              filteredtitle.isNotEmpty && value.isNotEmpty;
                          if (filteredtitle.isEmpty ||
                              !titl.any((a) =>
                                  '${a.title_book}'.toLowerCase() ==
                                  value.toLowerCase())) {
                            FilterTexttitle = '';
                          }
                        });
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
                              width: 2.0),
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),

                    if (showListtitle)

                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredtitle.length,
                        itemBuilder: (context, index) {
                          final title = filteredtitle[index];
                          return Container(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    '${title.title_book}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      FilterTextauth = '${title.title_book}';
                                      // Update the value of the text field
                                      titleEditingController.text =
                                          FilterTextauth;
                                      catEditingController.text =
                                          title.cat_book;
                                      hintTextCat = title.cat_book;
                                      authEditingController.text =
                                          title.auth_book;
                                      hintTextauth = title.auth_book;

                                      showListtitle = false;
                                    });
                                  },
                                ),
                                Divider(
                                  color: Color(int.parse(
                                      '0xFFFBC61A')), // Customize the color of the divider as needed
                                  thickness:
                                      1, // Adjust the thickness of the divider as needed
                                  height:
                                      0, // Adjust the height of the divider as needed
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      focusNode: descFocusNode,
                      controller: descEditingController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            addressErrorText = 'description required';
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
                        hintText: '  Description',
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
                    Theme(
                      // Wrap the body with Theme
                      data: Theme.of(context).copyWith(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      child: DropdownButtonFormField<Category>(
                        enableFeedback: false,
                        value: selectedCategory,
                        hint: Text(
                          hintTextCat,
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: InputDecoration(
                          hoverColor: Color(int.parse('0xFFF052a50')),
                          filled: true,
                          fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        focusColor: Color(int.parse('0xFFF052a50')),
                        dropdownColor: Color(int.parse('0xFFF052a50')),
                        onChanged: (Category? value) {
                          setState(() {
                            if (value != null) {
                              hintTextCat = value.cname;
                              print('Selected Category: ${value.cname}');
                            } else {
                              hintTextCat = 'Select Category';
                              print('No category selected');
                            }
                          });
                        },
                        items: cat.map<DropdownMenuItem<Category>>(
                            (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(
                              category.cname,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      focusNode: authFocusNode,
                      controller: authEditingController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.isEmpty && hintTextauth != "author") {
                          setState(() {
                            authErrorText = 'is required';
                          });
                        } else {
                          setState(() {
                            authErrorText = null;
                          });
                        }
                        setState(() {
                          FilterTextauth = value;

                          filteredAuth = auth
                              .where((a) => a.name
                                  .toLowerCase()
                                  .startsWith(value.toLowerCase()))
                              .toList();
                          showListauth =
                              filteredAuth.isNotEmpty && value.isNotEmpty;
                          if (filteredAuth.isEmpty ||
                              !auth.any((a) =>
                                  '${a.name}'.toLowerCase() ==
                                  value.toLowerCase())) {
                            FilterTextauth = '';
                          }
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        errorText: authErrorText,
                        fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                        hintText: hintTextauth,
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
                    SizedBox(height: 20),
                    if (showListauth)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredAuth.length,
                        itemBuilder: (context, index) {
                          final auther = filteredAuth[index];
                          return ListTile(
                            title: Text(
                              '${auther.name}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            onTap: () {
                              setState(() {
                                FilterTextauth = '${auther.name}';
                                authEditingController.text = FilterTextauth;

                                hintTextauth = auther.name;

                                showListauth = false;
                              });
                            },
                          );
                        },
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "   Status:",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "new",
                            groupValue: Status,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Color(int.parse('0xFFFFBC61A'));
                              }
                              return Colors.white;
                            }),
                            onChanged: (val) {
                              setState(() {
                                Status = val as String;
                              });
                            }),
                        Text(
                          "new",
                          style: TextStyle(
                              color: Status == "new"
                                  ? Color(int.parse('0xFFFFBC61A'))
                                  : Colors.white,
                              fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Radio(
                            value: "used",
                            groupValue: Status,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Color(int.parse('0xFFFFBC61A'));
                              }
                              return Colors.white;
                            }),
                            onChanged: (val) {
                              setState(() {
                                Status = val as String;
                              });
                            }),
                        Text(
                          "used",
                          style: TextStyle(
                              color: Status == "used"
                                  ? Color(int.parse('0xFFFFBC61A'))
                                  : Colors.white,
                              fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Radio(
                            value: "barely_used",
                            groupValue: Status,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Color(int.parse('0xFFFFBC61A'));
                              }
                              return Colors.white;
                            }),
                            onChanged: (val) {
                              setState(() {
                                Status = val as String;
                              });
                            }),
                        Text(
                          "barely_used",
                          style: TextStyle(
                              color: Status == "barely_used"
                                  ? Color(int.parse('0xFFFFBC61A'))
                                  : Colors.white,
                              fontSize: 18),
                        ),
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
                      onPressed:  getImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Pick Images'),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: images.map((image) => Container(
                        width: 100,
                        height: 100,
                        child: Image.file(image),
                      )).toList(),
                    ), ElevatedButton(
                      onPressed: getImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Pick Images'),
                    ),

                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: images.map((image) => Container(
                                width: 100,
                                height: 100,
                                child: Image.file(image),
                              )).toList(),
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
