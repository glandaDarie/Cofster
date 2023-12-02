import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/profileInformationScreen/profileCard.dart'
    show ProfileCard;
import 'package:coffee_orderer/services/profileCardService.dart'
    show ProfileCardService;

List<Card> ProfileCards(BuildContext context) {
  return [
    ProfileCard(
      name: "Orders In Progress",
      icon: Icons.history_edu_sharp,
      onTapCallback: () {
        final String errorMsg =
            ProfileCardService.ordersInProgress(context: context);
        assert(
          errorMsg == null,
          "Error on Orders In Progress button: ${errorMsg}",
        );
      },
    ),
    ProfileCard(
      name: "Purchase History",
      icon: Icons.history,
      onTapCallback: () async {
        final String errorMsg =
            ProfileCardService.purchaseHistory(context: context);
        assert(
          errorMsg == null,
          "Error on Purchase History button: ${errorMsg}",
        );
      },
    ),
    ProfileCard(
      name: "Help & Support",
      icon: Icons.privacy_tip_sharp,
      onTapCallback: () {
        final String errorMsg =
            ProfileCardService.helpAndSupport(context: context);
        assert(
          errorMsg == null,
          "Error on Help & Support button: ${errorMsg}",
        );
      },
    ),
    ProfileCard(
      name: "Invite a Friend",
      icon: Icons.add_reaction_sharp,
      onTapCallback: () async {
        final String errorMsg =
            await ProfileCardService.inviteAFriend(context: context);
        assert(
          errorMsg == null,
          "Error on Invite a Friend button: ${errorMsg}",
        );
      },
    ),
    ProfileCard(
      name: "Sign Out",
      icon: Icons.logout,
      onTapCallback: () async {
        final String errorMsg =
            await ProfileCardService.singOut(context: context);
        assert(
          errorMsg == null,
          "Error on Sign Out button: ${errorMsg}",
        );
      },
    ),
    ProfileCard(
      name: "Delete Account",
      icon: Icons.delete,
      onTapCallback: () async {
        String errorMsg =
            await ProfileCardService.deleteAccount(context: context);
        assert(
          errorMsg == null,
          "Error on Delete Account button: ${errorMsg}",
        );
        errorMsg = await ProfileCardService.singOut(context: context);
        assert(
          errorMsg == null,
          "Error when signing out: ${errorMsg}",
        );
      },
    ),
  ];
}
