import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:voting_system/Utils/rive_utils.dart';
import 'package:voting_system/admin/components/side_menu_tile.dart';
import 'package:voting_system/admin/models/rive_asset.dart';
import 'package:voting_system/admin/screen/adminDashboard.dart';
import 'package:voting_system/admin/screen/admin_candidate_list.dart';
import 'package:voting_system/admin/screen/application.dart';
import 'package:voting_system/admin/screen/scheduler.dart';
import 'package:voting_system/admin/screen/voters_list.dart';
import 'package:voting_system/assets/global/global_variable.dart';
import '../../login/Services/authentication.dart';
import 'info_card.dart';

class SideMenu extends StatefulWidget {
  final ValueChanged<Widget> onMenuSelected;
  const SideMenu({super.key, required this.onMenuSelected});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  RiveAsset selectedMenu = sideMenus.first;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0xFF17203A),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: adminEmail,
                profession: "Admin",
                base64Image: adminProfile ?? "",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sideMenus.map(
                    (menu) => SideMenuTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    StateMachineController controller = RiveUtils.getRiveController(artboard,
                        stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectedMenu = menu;
                      if (menu.title == "VOTERS") {
                        widget.onMenuSelected(const VotersList());
                      } else if (menu.title == "CANDIDATES") {
                        widget.onMenuSelected(const AdminCandidateList(showButton: false));
                      }
                      else if (menu.title == "APPLICATION") {
                        widget.onMenuSelected(const CandidateApplication());
                      }
                      else if (menu.title == "SCHEDULE") {
                        widget.onMenuSelected(const Scheduler()); // Replace with correct screen
                      } else {
                        widget.onMenuSelected(const adminHomeScreen()); // Default home screen
                      }
                    });
                  },
                  isActive: selectedMenu == menu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
