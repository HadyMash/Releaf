import 'package:flutter/material.dart';
import 'package:releaf/shared/assets/themed_button.dart';

class JournalEntryForm extends StatefulWidget {
  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
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
                    label: 'pick photo',
                    onPressed: () async {},
                    tapDownFeedback: true,
                    tapFeedback: true,
                  ),
                  ThemedButton(
                    label: 'change date',
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: _currentDate,
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2023),
                      ).then((date) {
                        setState(() {
                          _currentDate = date ?? DateTime.now();
                        });
                      });
                    },
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
                  label: 'submit text',
                  onPressed: () async {},
                  tapDownFeedback: true,
                  tapFeedback: true,
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
