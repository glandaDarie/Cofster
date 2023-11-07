import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/mapScreen.dart' show GoogleMapPage;
import 'package:coffee_orderer/components/mainScreen/footerImage.dart'
    show footerImage;
import 'package:coffee_orderer/utils/constants.dart'
    show PARTNER_COFFEE_SHOPS, PARTNER_FOOTER_IMAGES;

List<Widget> Footer(BuildContext context) {
  return [
    for (int i = 0; i < PARTNER_COFFEE_SHOPS.length; ++i)
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  GoogleMapPage(coffeeStoreName: PARTNER_COFFEE_SHOPS[i]),
            ),
          );
        },
        child: footerImage(PARTNER_FOOTER_IMAGES[i]),
      )
  ];
}
