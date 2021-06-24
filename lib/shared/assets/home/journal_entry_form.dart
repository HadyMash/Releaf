import 'package:flutter/material.dart';
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

  late AnimationController happyController;
  late AnimationController mehController;
  late AnimationController sadController;

  late DateTime currentDate;
  // List pictures;
  String? entryText;
  int? feeling;

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
                      label: 'Pick Photo',
                      onPressed: () async {},
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
