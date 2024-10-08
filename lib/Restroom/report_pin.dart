import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:http/http.dart" as http;
import "package:http_parser/http_parser.dart";
import "package:image_picker/image_picker.dart";
import 'package:clay_containers/widgets/clay_container.dart';
import "package:mime/mime.dart";
import "package:ruam_mitt/Restroom/Component/font.dart";
import "package:ruam_mitt/Restroom/Component/loading_screen.dart";
import "package:ruam_mitt/Restroom/Component/navbar.dart";
import "package:ruam_mitt/Restroom/Component/theme.dart";
import "package:ruam_mitt/global_const.dart";
import "package:ruam_mitt/global_func.dart";
import "package:ruam_mitt/global_var.dart";

class RestroomRoverReportPin extends StatefulWidget {
  const RestroomRoverReportPin({super.key, required this.restroomData});
  final Map<String, dynamic> restroomData;
  @override
  State<RestroomRoverReportPin> createState() => _RestroomRoverReportPinState();
}

class _RestroomRoverReportPinState extends State<RestroomRoverReportPin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _reportTextController = TextEditingController();

  File? _image;

  Future<void> _sendReport() async {
    await requestNewToken(context);
    debugPrint('Send report');
    final url = Uri.parse("$api$reportRoute");
    http.MultipartRequest request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Bearer $publicToken",
      "Content-Type": "application/json"
    });
    if (_image != null) {
      debugPrint("Image added");
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          _image!.readAsBytesSync(),
          filename: _image!.path,
          contentType:
              MediaType.parse(lookupMimeType(_image!.path) ?? "image/jpeg"),
        ),
      );
    }
    request.fields['title'] =
        "Report for Pin ${widget.restroomData["id"]} : ${widget.restroomData["name"]}";
    request.fields['type'] = "restroom";
    request.fields['description'] = _reportTextController.text;
    request.fields['more_info'] = jsonEncode(widget.restroomData);
    debugPrint("Request: ${request.fields}");
    try {
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return Future.error(response.reasonPhrase ?? "Failed to send report");
      }
      http.Response res = await http.Response.fromStream(response)
          .timeout(const Duration(seconds: 10));

      debugPrint("Response: ${res.body}");
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> _getImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Camera"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("gallery "),
            ),
          ],
        ),
      ),
    );

    if (isCamera == null) return;
    final pickedFile = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      var result = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        '${pickedFile.path}_compressed.jpg',
        quality: 40,
      );
      setState(() {
        if (result != null) {
          _image = File(result.path);
        } else {
          debugPrint('Compresstion error.');
        }
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Theme(
        data: RestroomThemeData,
        child: Builder(builder: (context) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.025,
                      horizontal: size.width * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: size.height * 0.01,
                            ),
                            height: size.height * 0.03,
                            alignment: Alignment.bottomLeft,
                            child: const Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 30, 49, 67),
                              ),
                            ),
                          ),
                          ClayContainer(
                            height: size.height * 0.04,
                            width: size.width * 0.6,
                            color: const Color.fromRGBO(239, 239, 239, 1),
                            borderRadius: 30,
                            depth: -20,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * 0.03,
                                  top: size.height * 0.003),
                              child: Text(
                                widget.restroomData["name"],
                                style: TextStyle(
                                    fontFamily:
                                        widget.restroomData["name"].contains(
                                      RegExp("[ก-๛]"),
                                    )
                                            ? "THSarabunPSK"
                                            : "Sen",
                                    fontSize:
                                        widget.restroomData["name"].contains(
                                      RegExp("[ก-๛]"),
                                    )
                                            ? 22
                                            : 16,
                                    fontWeight:
                                        widget.restroomData["name"].contains(
                                      RegExp("[ก-๛]"),
                                    )
                                            ? FontWeight.w700
                                            : FontWeight.normal,
                                    color: const Color.fromRGBO(0, 30, 49, 67)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            widget.restroomData["picture"] ??
                                "https://media.discordapp.net/attachments/1033741246683942932/1213677182161920020/toilet_sign.png?ex=65f657f5&is=65e3e2f5&hm=69aa24e997ae288613645b0c45363aea72cdb7d9f0cbabacbfe7a3f04d6047ea&=&format=webp&quality=lossless&width=702&height=702",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding:
                                EdgeInsets.only(bottom: size.height * 0.01),
                            child: Text(
                              'Report',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          ClayContainer(
                            width: size.width * 0.82,
                            height: size.height * 0.25,
                            color: const Color(0xFFEAEAEA),
                            borderRadius: 30,
                            depth: -20,
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextField(
                                  style: text_input(
                                      _reportTextController.text, context),
                                  maxLength: 200,
                                  maxLines: 9,
                                  controller: _reportTextController,
                                  decoration: const InputDecoration(
                                    // counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 10,
                                        top: 15),
                                    hintText: 'Write a report...',
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      InkWell(
                        onTap: () {
                          _getImage();
                        },
                        child: _image == null
                            ? Container(
                                width: size.width * 0.8,
                                height: size.height * 0.125,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      const Color(0xFFFFB432).withOpacity(0.9),
                                      const Color(0xFFFFFCCE).withOpacity(1),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.005,
                                        left: size.width * 0.01,
                                      ),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        width: size.width * 0.035,
                                        height: size.height * 0.035,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Image.asset(
                                              "assets/images/PinTheBin/corner.png"),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.005,
                                        left: size.width * 0.75,
                                      ),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        width: size.width * 0.035,
                                        height: size.height * 0.035,
                                        child: Transform.rotate(
                                          angle: 90 * 3.141592653589793 / 180,
                                          child: Opacity(
                                            opacity: 0.5,
                                            child: Image.asset(
                                                "assets/images/PinTheBin/corner.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.085,
                                        left: size.width * 0.01,
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        width: size.width * 0.035,
                                        height: size.height * 0.035,
                                        child: Transform.rotate(
                                          angle: 270 * 3.141592653589793 / 180,
                                          child: Opacity(
                                            opacity: 0.5,
                                            child: Image.asset(
                                                "assets/images/PinTheBin/corner.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.085,
                                        left: size.width * 0.75,
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        width: size.width * 0.035,
                                        height: size.height * 0.035,
                                        child: Transform.rotate(
                                          angle: 180 * 3.141592653589793 / 180,
                                          child: Opacity(
                                            opacity: 0.5,
                                            child: Image.asset(
                                                "assets/images/PinTheBin/corner.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.only(
                                          bottom: size.height * 0.01),
                                      child: Opacity(
                                        opacity: 0.4,
                                        child: Text(
                                          "Upload picture",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/PinTheBin/upload.png",
                                        height: size.height * 0.05,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.67),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300],
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showRestroomLoadingScreen(context);
                              _sendReport().then((value) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Report sent"),
                                  ),
                                );
                                Navigator.pop(context);
                              }).onError((error, stackTrace) {
                                debugPrint("Error: $error");
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Failed to send report",
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.amber,
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Builder(
                    builder: (context) =>
                        RestroomAppBar(scaffoldKey: _scaffoldKey)),
              ]),
            ),
            drawerScrimColor: Colors.transparent,
            drawer: const RestroomRoverNavbar(),
          );
        }));
  }
}

class RestroomAppBar extends StatelessWidget {
  const RestroomAppBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFB330),
            Color(0xFFFFE9A6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                child: Icon(
                  Icons.menu_rounded,
                  size: Theme.of(context).appBarTheme.iconTheme!.size,
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                ),
                onTap: () {
                  debugPrint("Open Drawer");
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              const SizedBox(width: 10),
              Text(
                "Report Pin",
                style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize,
                  fontWeight:
                      Theme.of(context).textTheme.headlineMedium!.fontWeight,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
