import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';

class JournalEntryForm extends StatefulWidget {
  final String? date;
  final String? initialText;
  final int? feeling;
  JournalEntryForm({this.date, this.initialText, this.feeling});

  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm>
    with TickerProviderStateMixin {
  AuthService _auth = AuthService();
  bool _textFieldFocused = false;
  late TextEditingController _controller;

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
  String? entryText;
  int? feeling;

  final imagePicker = ImagePicker();

  @override
  void initState() {
    happyController = AnimationController(vsync: this);
    mehController = AnimationController(vsync: this);
    sadController = AnimationController(vsync: this);

    currentDate =
        widget.date != null ? DateTime.parse(widget.date!) : DateTime.now();
    feeling = widget.feeling;
    entryText = widget.initialText;
    _controller = TextEditingController(text: widget.initialText);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // TODO fix title centering issue
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
                                    final int length = pictures.length;
                                    pictures.add(imageBytes);
                                    setState(() => pictureListKey.currentState
                                        ?.insertItem(length,
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
                                        print(image.path);
                                        final imageBytes =
                                            await image.readAsBytes();
                                        final int length = pictures.length;

                                        // TODO Add check to see if the image already exists.
                                        pictures.add(imageBytes);
                                        setState(() => pictureListKey
                                            .currentState
                                            ?.insertItem(length,
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
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index, animation) {
                    CurvedAnimation curvedAnim = CurvedAnimation(
                        curve: Curves.easeInOut, parent: animation);
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
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: width / 5,
                            height: width / 5,
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.symmetric(
                                horizontal: (10 * width) / 428),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey,
                            ),
                            child: pictures.isEmpty
                                ? null
                                : Image.memory(
                                    pictures[index],
                                    key: Key(pictures[index].toString()),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: (-10 * width) / 428,
                            child: GestureDetector(
                              onTap: () {
                                final picture = pictures[index];
                                setState(
                                  () => AnimatedList.of(context).removeItem(
                                    index,
                                    (context, animation) {
                                      CurvedAnimation curvedAnim =
                                          CurvedAnimation(
                                              curve: Curves.easeOut,
                                              parent: animation);
                                      return SizeTransition(
                                        sizeFactor: curvedAnim,
                                        axis: Axis.horizontal,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: width / 5,
                                              height: width / 5,
                                              clipBehavior: Clip.hardEdge,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      (10 * width) / 428),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
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
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors.grey[300]!
                                                          .withOpacity(0.7)
                                                      : Colors.grey[700]!
                                                          .withOpacity(0.8),
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
                              },
                              child: Container(
                                height: width / 15,
                                width: width / 15,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
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
                      ),
                    );
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
                    onChanged: (val) => entryText = val,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(overflow: TextOverflow.fade),
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
                            if (feeling != null) {
                              if (widget.date == null) {
                                // TODO disable button until request is complete

                                dynamic result = await DatabaseService(
                                        uid: _auth.getUser()!.uid)
                                    .addNewJournalEntry(
                                  currentDate.toString(),
                                  entryText ?? '',
                                  feeling!,
                                );
                                if (result is JournalEntryData) {
                                  AppTheme.homeNavkey.currentState!.pop();
                                } else {
                                  // TODO enable button

                                  // TODO show error snackbar
                                }
                              } else {
                                dynamic result = await DatabaseService(
                                        uid: _auth.getUser()!.uid)
                                    .editEntry(
                                  widget.date!,
                                  currentDate.toString(),
                                  entryText,
                                  feeling!,
                                );
                                if (result == true) {
                                  AppTheme.homeNavkey.currentState!.pop();
                                }
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
