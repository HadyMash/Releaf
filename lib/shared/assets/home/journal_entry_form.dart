import 'package:flutter/material.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';

class JournalEntryForm extends StatefulWidget {
  final String? initialText;
  JournalEntryForm({this.initialText});

  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  AuthService _auth = AuthService();
  bool _textFieldFocused = false;
  late TextEditingController _controller;

  DateTime currentDate = DateTime.now();
  // List pictures;
  String? entryText;
  int feeling = 3; // TODO add feeling functionality

  @override
  void initState() {
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
                      fillColor: Colors.grey[300],
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
                  // TODO add rive feeling selector
                  Placeholder(
                    fallbackHeight: 70,
                    fallbackWidth: 150,
                  ),
                  ThemedButton(
                    label: _textFieldFocused
                        ? 'Done'
                        : (widget.initialText == null
                            ? 'Add Entry'
                            : 'Confirm Changes'),
                    onPressed: _textFieldFocused
                        ? _unfocusTextField
                        : () async {
                            if (widget.initialText == null) {
                              // TODO disable button until request is complete

                              dynamic result = await DatabaseService(
                                      uid: _auth.getUser()!.uid)
                                  .addNewJournalEntry(
                                currentDate.toString(),
                                entryText ?? '',
                                feeling,
                              );
                              if (result is JournalEntryData) {
                                AppTheme.homeNavkey.currentState!.pop();
                              } else {
                                // TODO enable button

                                // TODO show error snackbar
                              }
                            } else {}
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
