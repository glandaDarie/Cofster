import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Padding> OptionsBox({
  @required void Function() fn,
  @required Map<String, dynamic> params,
  @required bool Function() questionnaireFinishedFn,
}) {
  List<String> options = [];
  if (params["questionOption"] != null) {
    options = [...params["questionOption"]];
  }
  return options
      .map(
        (String option) => option != "None"
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    print("Length: ${params.values.length}");
                    fn();
                    // Function.apply(fn, params.values);
                    print(
                        "questionnaireFinishedFn(): ${questionnaireFinishedFn()}");
                    if (questionnaireFinishedFn()) {
                      print("Questionnaire finished checkpoint!");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.brown, width: 1.0),
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter text here",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 14.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 225.0),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Function.apply(fn, params.values);
                        print("ALIVE (1)?");
                        fn();
                        print("ALIVE (2)?");
                        if (questionnaireFinishedFn()) {
                          print("Questionnaire finished checkpoint!");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        minimumSize: Size(320.0, 50.0),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      )
      .toList();
}
