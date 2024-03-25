import 'dart:io';
import 'package:flutter/services.dart';
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

class position {
  String p;
  position(this.p);
}

List<position> pos = [];

void addposition() {
  pos.add(position("Sell"));
  pos.add(position("Trade"));
  pos.add(position("Stock"));
}

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

  bool pc = false;
  late File CoverFile;

  Future<void> pickCover() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String mimeType = lookupMimeType(pickedFile.path) ?? '';
      List<String> allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif'];
      if (allowedMimeTypes.contains(mimeType)) {
        setState(() {
          pc = true;
          CoverFile = File(pickedFile.path);
        });
      } else {
        print('Unsupported image type.');
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> addbook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';

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
      request.fields['price'] = priceEditingController.text;
      request.fields['position'] = positionEditing;
      request.fields['email'] = email;


      for (int i = 0; i < images.length; i++) {
        File imageFile = images[i];
        if (imageFile != null && await imageFile.length() > 0) {
          String fieldName = 'image$i';
          String originalFilename =
              imageFile.path.split('/').last; // Obtain original filename
          request.files.add(await http.MultipartFile.fromPath(
            fieldName,
            imageFile.path,
            filename: originalFilename, // Use the original filename
          ));
        }
      }
      request.files.add(http.MultipartFile(
        'Cover',
        CoverFile.readAsBytes().asStream(),
        CoverFile.lengthSync(),
        filename: CoverFile.path.split('/').last,
      ));
      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          isAsyncCall = false;
        });
        String e1 = await response.stream.bytesToString();
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

  List<File> images = [];
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

  static const int maxImages = 3;
  static const int maxCover = 1;
  String filterTextcat = '';

  FocusNode descFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  FocusNode titleFocusNode = FocusNode();
  FocusNode authFocusNode = FocusNode();
  TextEditingController nationality = TextEditingController();
  TextEditingController cname = TextEditingController();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController authEditingController = TextEditingController();
  TextEditingController catEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  String positionEditing = "";
  String positionHintText = "Select position";
  position selePlayer = position("");
  String cvalue = '';
  late bool showListauth;
  late bool showListtitle;
  late bool showListcat;
  late String txt;

  String? r;
  String? selectedAuthor;
  String? titleErrorText;
  String? authErrorText;
  File? file;
  //late String Nfile;

  String nauthor = '';
  bool isAsyncCall = false;
  Category? selectedCategory;
  position? selectedpos;
  String hintTextCat = '  Select Category';
  String hintTextpos = '  Select pos';
  String hintTexttitle = '  Title';
  String hintTextauth = '  author';
  String Status = "";

  String valueselected = "";
  String? natErrorText;
  String? catErrorText;
  String? descErrorText;
  String? priceErrorText;
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
        Status.isNotEmpty &&
        images.isNotEmpty &&
        pc == true &&
        priceEditingController.text.isNotEmpty &&
        positionEditing.isNotEmpty) {
      print("price: ${priceEditingController.text}");
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

  @override
  void initState() {
    // TODO: implement initState
    addposition();
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
                            descErrorText = 'description required';
                          });
                        } else {
                          setState(() {
                            descErrorText = null;
                          });
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        filled: true,
                        errorText: descErrorText,
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
                    Container(
                        height: 80,
                        child: Row(children: [
                          SizedBox(
                            width: SWidth * 0.03,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            height: 80,
                            width: 150,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              focusNode: priceFocusNode,
                              controller: priceEditingController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^[1-9]\d*\.?\d*|^0\.?\d*[1-9]\d*$')),
                              ],
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    priceErrorText = 'price required';

                                  });
                                } else {
                                  setState(() {
                                    print(
                                        "price:${priceEditingController.text}");
                                    priceErrorText = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                errorText: priceErrorText,
                                fillColor: Color.fromRGBO(0, 0, 0, 0.20),
                                hintText: '  Price \$',
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
                          ),
                          SizedBox(
                            width: SWidth * 0.08,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            height: 80,
                            width: 150,
                            child: DropdownButtonFormField<position>(
                              enableFeedback: false,
                              value: selectedpos,
                              hint: Text(
                                hintTextpos,
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
                              onChanged: (position? value) {
                                setState(() {
                                  if (value != null) {
                                    hintTextpos = value.p;
                                    positionEditing = value.p;
                                    print('Selected position: ${value.p}');
                                  } else {
                                    hintTextpos = 'Select pos';
                                    positionEditing = "";
                                    print('No position selected');
                                  }
                                });
                              },
                              items: pos.map<DropdownMenuItem<position>>(
                                  (position postn) {
                                return DropdownMenuItem<position>(
                                  value: postn,
                                  child: Text(
                                    postn.p,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ])),
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
                              catEditingController.text = value.cname;
                              print('Selected Category: ${value.cname}');
                            } else {
                              hintTextCat = 'Select Category';
                              catEditingController.text = "";
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
                      onPressed: pickCover,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Pick Cover'),
                    ),
                    pc == true
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: Image.file(
                                  CoverFile,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: getImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Pick Images'),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: images
                          .map((image) => Container(
                                width: 100,
                                height: 100,
                                child: Image.file(image),
                              ))
                          .toList(),
                    ),
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
