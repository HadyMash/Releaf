import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/services/storage.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';

class JournalEntryForm extends StatefulWidget {
  final String? date;
  final String? initialText;
  final int? feeling;
  final List<Uint8List>? pictures;
  JournalEntryForm({this.date, this.initialText, this.feeling, this.pictures});

  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm>
    with TickerProviderStateMixin {
  AuthService _auth = AuthService();
  bool _textFieldFocused = false;
  late TextEditingController _controller;
  FocusNode _focusNode = FocusNode();

  final GlobalKey happyKey = GlobalKey();
  final GlobalKey mehKey = GlobalKey();
  final GlobalKey sadKey = GlobalKey();

  final GlobalKey<AnimatedListState> pictureListKey =
      GlobalKey<AnimatedListState>();

  late AnimationController happyController;
  late AnimationController mehController;
  late AnimationController sadController;

  late DateTime currentDate;
  List<Uint8List> pictures = [];
  List<Uint8List> compressedPictures = [];
  String? entryText;
  int? feeling;

  final imagePicker = ImagePicker();

  bool initialised = false;

  @override
  void initState() {
    happyController = AnimationController(vsync: this);
    mehController = AnimationController(vsync: this);
    sadController = AnimationController(vsync: this);

    currentDate =
        widget.date != null ? DateTime.parse(widget.date!) : DateTime.now();
    feeling = widget.feeling;
    entryText = widget.initialText;
    if (widget.pictures != null) {
      pictures = widget.pictures!;
    }
    _controller = TextEditingController(text: widget.initialText);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (initialised == false) {
      if (widget.pictures != null) {
        addCompressedPicturesFromExistingEntry();
        initialised = true;
      }
    }
    super.didChangeDependencies();
  }

  Future<void> addCompressedPicturesFromExistingEntry() async {
    for (Uint8List picture in pictures) {
      compressedPictures.add(
          await FlutterImageCompress.compressWithList(picture, quality: 50));
      pictureListKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 800));
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    happyController.dispose();
    mehController.dispose();
    sadController.dispose();
    super.dispose();
  }

  void _unfocusTextField() {
    setState(() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      _textFieldFocused = false;
    });
  }

  void _removePicPreview({
    required int index,
    required Uint8List compressedPicture,
    required double width,
  }) {
    final picture = compressedPicture;
    setState(
      () => pictureListKey.currentState?.removeItem(
        index,
        (context, animation) {
          CurvedAnimation curvedAnim =
              CurvedAnimation(curve: Curves.easeOut, parent: animation);
          return SizeTransition(
            sizeFactor: curvedAnim,
            axis: Axis.horizontal,
            child: Stack(
              children: [
                Container(
                  width: width / 5,
                  height: width / 5,
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.symmetric(horizontal: (10 * width) / 428),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey,
                  ),
                  child: Image.memory(
                    picture,
                    key: Key(picture.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: (-10 * width) / 428,
                  child: Container(
                    height: width / 15,
                    width: width / 15,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[300]!.withOpacity(0.7)
                          : Colors.grey[700]!.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 23,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        duration: Duration(milliseconds: 500),
      ),
    );
    pictures.removeAt(index);
    compressedPictures.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal Entry',
          style: Theme.of(context).textTheme.headline3,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ThemedButton(
                      label: 'Add Photos',
                      onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                child: Text("Take Photo"),
                                onPressed: () async {
                                  Navigator.pop(context);

                                  PickedFile? image = await imagePicker
                                      .getImage(source: ImageSource.camera);

                                  if (image != null) {
                                    final imageBytes =
                                        await image.readAsBytes();
                                    pictures.insert(0, imageBytes);

                                    ImageProperties properties =
                                        await FlutterNativeImage
                                            .getImageProperties(image.path);

                                    File compressedFile =
                                        await FlutterNativeImage.compressImage(
                                      image.path,
                                      quality: 50,
                                      percentage: 50,
                                      targetWidth:
                                          (properties.width! * 0.5).round(),
                                      targetHeight:
                                          (properties.height! * 0.5).round(),
                                    );

                                    Uint8List compressedImage =
                                        await compressedFile.readAsBytes();
                                    compressedPictures.insert(
                                        0, compressedImage);

                                    setState(() => pictureListKey.currentState
                                        ?.insertItem(0,
                                            duration:
                                                Duration(milliseconds: 800)));
                                  }
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text("Pick Photos"),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  List<PickedFile>? images =
                                      await imagePicker.getMultiImage();

                                  if (images != null) {
                                    images.forEach(
                                      (image) async {
                                        final imageBytes =
                                            await image.readAsBytes();
                                        pictures.insert(0, imageBytes);

                                        ImageProperties properties =
                                            await FlutterNativeImage
                                                .getImageProperties(image.path);

                                        File compressedFile =
                                            await FlutterNativeImage
                                                .compressImage(
                                          image.path,
                                          quality: 50,
                                          percentage: 50,
                                          targetWidth:
                                              (properties.width! * 0.5).round(),
                                          targetHeight:
                                              (properties.height! * 0.5)
                                                  .round(),
                                        );

                                        Uint8List compressedImage =
                                            await compressedFile.readAsBytes();
                                        compressedPictures.insert(
                                            0, compressedImage);

                                        setState(() => pictureListKey
                                            .currentState
                                            ?.insertItem(0,
                                                duration: Duration(
                                                    milliseconds: 800)));
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        );
                      },
                      notAllCaps: true,
                      tapDownFeedback: true,
                      tapFeedback: true,
                    ),
                    ThemedButton(
                      label: 'Change Date',
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: currentDate,
                          firstDate: DateTime(2001),
                          lastDate: DateTime(2023),
                        ).then((date) {
                          setState(() {
                            currentDate = date ?? DateTime.now();
                          });
                        });
                      },
                      notAllCaps: true,
                      tapDownFeedback: true,
                      tapFeedback: true,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(
                  vertical: pictures.isEmpty ? 0 : 10,
                  horizontal: pictures.isEmpty ? 0 : (18 - (10 * width) / 428),
                ),
                height: pictures.isEmpty ? 0 : (width / 5),
                width: pictures.isEmpty
                    ? 0
                    : MediaQuery.of(context).size.width - (10 * 2),
                clipBehavior: Clip.none,
                child: AnimatedList(
                  key: pictureListKey,
                  initialItemCount: compressedPictures.length,
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index, animation) {
                    CurvedAnimation curvedAnim = CurvedAnimation(
                        curve: Curves.easeInOut, parent: animation);

                    if (pictures.length > 1) {
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(-1, 0), end: Offset(0, 0))
                            .animate(curvedAnim),
                        child: PicturePreview(compressedPictures[index],
                            index: index,
                            picsEmpty: pictures.isEmpty,
                            removePreview: _removePicPreview),
                      );
                    } else {
                      return AnimatedBuilder(
                        animation: curvedAnim,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Tween<Offset>(
                                    begin: Offset(30, 0), end: Offset(0, 0))
                                .animate(curvedAnim)
                                .value,
                            child: Opacity(
                              opacity: curvedAnim.value,
                              child: child,
                            ),
                          );
                        },
                        child: PicturePreview(compressedPictures[index],
                            index: index,
                            picsEmpty: pictures.isEmpty,
                            removePreview: _removePicPreview),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    onTap: () => setState(() => _textFieldFocused = true),
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (val) => entryText = val,
                    style: Theme.of(context).textTheme.bodyText1!,
                    textAlignVertical: TextAlignVertical.top,
                    expands: true,
                    decoration: InputDecoration(
                      fillColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[300]
                              : Colors.grey[900],
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Lorem ipsum",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      feeling = 1;
                      sadController.forward();
                      mehController.reverse();
                      happyController.reverse();
                    },
                    child: Lottie.asset(
                      'assets/lottie/faces/sad.json',
                      key: sadKey,
                      controller: sadController,
                      width: width / 6,
                      height: width / 6,
                      onLoaded: (comp) {
                        sadController.duration = comp.duration;
                        if (feeling == 1) {
                          sadController.value = 1;
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      feeling = 2;
                      sadController.reverse();
                      mehController.forward();
                      happyController.reverse();
                    },
                    child: Lottie.asset(
                      'assets/lottie/faces/meh.json',
                      key: mehKey,
                      controller: mehController,
                      width: width / 6,
                      height: width / 6,
                      onLoaded: (comp) {
                        mehController.duration = comp.duration;
                        if (feeling == 2) {
                          mehController.value = 1;
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      feeling = 3;
                      sadController.reverse();
                      mehController.reverse();
                      happyController.forward();
                    },
                    child: Lottie.asset(
                      'assets/lottie/faces/happy.json',
                      key: happyKey,
                      controller: happyController,
                      height: width / 6,
                      width: width / 6,
                      onLoaded: (comp) {
                        happyController.duration = comp.duration;
                        if (feeling == 3) {
                          happyController.value = 1;
                        }
                      },
                    ),
                  ),
                  ThemedButton(
                    label: _textFieldFocused
                        ? 'Done'
                        : (widget.initialText == null ? 'Upload' : 'Confirm'),
                    onPressed: _textFieldFocused
                        ? _unfocusTextField
                        : () async {
                            // TODO disable button until request is complete
                            if (feeling != null) {
                              if (pictures.isNotEmpty) {
                                DateTime currentDate = DateTime.now();
                                DateTime newDateTime =
                                    DateTime.parse(currentDate.toString());
                                DateTime hybridDate = DateTime(
                                  newDateTime.year,
                                  newDateTime.month,
                                  newDateTime.day,
                                  currentDate.hour,
                                  currentDate.minute,
                                  currentDate.second,
                                  currentDate.millisecond,
                                  currentDate.microsecond,
                                );
                                print(hybridDate.toString());

                                if (widget.date == null) {
                                  dynamic result = await DatabaseService(
                                          uid: _auth.getUser()!.uid)
                                      .addJournalEntry(
                                    hybridDate.toString(),
                                    entryText ?? '',
                                    feeling!,
                                    pictures,
                                  );
                                  print(hybridDate.toString());
                                  if (result is JournalEntryData) {
                                    AppTheme.homeNavkey.currentState!.pop();
                                  } else {
                                    // TODO enable button
                                  }
                                } else {
                                  // dynamic result = await DatabaseService(
                                  //         uid: _auth.getUser()!.uid)
                                  //     .editEntry(
                                  //   widget.date!,
                                  //   hybridDate.toString(),
                                  //   entryText ?? '',
                                  //   feeling!,
                                  //   pictures,
                                  // );
                                  // if (result == true) {
                                  //   AppTheme.homeNavkey.currentState!.pop();
                                  // }
                                }
                              } else {
                                final SnackBar snackBar = SnackBar(
                                  content: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(Icons.warning_rounded,
                                            color: Colors.amber),
                                      ),
                                      Expanded(
                                        child: Text(
                                            'Please upload at least 1 picture.'),
                                      ),
                                    ],
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              final SnackBar snackBar = SnackBar(
                                content: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(Icons.warning_rounded,
                                          color: Colors.amber),
                                    ),
                                    Expanded(
                                      child: Text(
                                          'Please choose how you\'re feeling.'),
                                    ),
                                  ],
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                    notAllCaps: true,
                    tapDownFeedback: true,
                    tapFeedback: true,
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class PicturePreview extends StatelessWidget {
  PicturePreview(this.compressedPicture,
      {Key? key,
      required this.index,
      required this.picsEmpty,
      required this.removePreview})
      : super(key: key);
  int index;
  Uint8List compressedPicture;
  bool picsEmpty;
  void Function(
      {required int index,
      required Uint8List compressedPicture,
      required double width}) removePreview;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // TODO add gesture detecor which then expands to show an image gallery where they can see their photos in detail
        Container(
          width: width / 5,
          height: width / 5,
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.symmetric(horizontal: (10 * width) / 428),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.grey,
          ),
          child: picsEmpty
              ? null
              : Image.memory(
                  compressedPicture,
                  key: Key(compressedPicture.toString()),
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: (-10 * width) / 428,
          child: GestureDetector(
            onTap: () => removePreview(
                index: index,
                compressedPicture: compressedPicture,
                width: width),
            child: Container(
              height: width / 15,
              width: width / 15,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[300]!.withOpacity(0.7)
                    : Colors.grey[700]!.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.close_rounded,
                  size: 23,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
