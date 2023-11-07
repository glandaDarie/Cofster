import 'package:flutter/material.dart';

void showPopup(BuildContext context, String favouriteDrink) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: CurvedAnimation(
                parent: ModalRoute.of(context).animation,
                curve: Interval(0.0, 0.5),
              ),
              child: Icon(
                Icons.coffee,
                size: 50.0,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 16.0),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context).animation,
                  curve: Interval(0.3, 1.0),
                ),
              ),
              child: Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context).animation,
                  curve: Interval(0.5, 1.0),
                ),
              ),
              child: Center(
                child: Text(
                  "You won a free ${favouriteDrink.toLowerCase()} coffee. Enjoy!",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ScaleTransition(
              scale: CurvedAnimation(
                parent: ModalRoute.of(context).animation,
                curve: Interval(0.8, 1.0),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Claim'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
