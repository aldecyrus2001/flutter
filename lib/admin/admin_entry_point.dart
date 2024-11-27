import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voting_system/Utils/rive_utils.dart';
import 'package:voting_system/admin/components/side_menu.dart';
import 'package:voting_system/admin/models/rive_asset.dart';
import 'package:voting_system/admin/screen/adminDashboard.dart';
import 'package:voting_system/assets/global/global_variable.dart';

import 'models/menu_btn.dart';

class AdminEntryPoint extends StatefulWidget {
  final Widget initialScreen;
  const AdminEntryPoint({super.key, required this.initialScreen});

  @override
  State<AdminEntryPoint> createState() => _AdminEntryPointState();
}

class _AdminEntryPointState extends State<AdminEntryPoint>
    with SingleTickerProviderStateMixin {
  RiveAsset selectedBottomNav = bottomNavs.first;
  late SMIBool isSideBarClosed;
  bool isSideMenuClosed = true;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  Widget currentScreen = const adminHomeScreen();// Default screen

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
    currentScreen = widget.initialScreen;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          // Add the Side Menu
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: SideMenu(onMenuSelected: (Widget screen) {
              setState(() {
                currentScreen = screen;
              });
            }),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              // Rotate 30 degree
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(isSideMenuClosed ? 0 : 24)),
                  child: currentScreen, // Render the selected screen here
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 220,
            // top: 16,
            child: MenuBtn(
              riveOnInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(
                    artboard,
                    stateMachineName: "State Machine");
                isSideBarClosed = controller.findSMI("isOpen") as SMIBool;
                isSideBarClosed.value = true;
              },
              press: () {
                isSideBarClosed.value = !isSideBarClosed.value;
                if (isSideMenuClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                setState(() {
                  isSideMenuClosed = isSideBarClosed.value;
                });
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Transform.translate(
      //   offset: Offset(0, 100 * animation.value),
      //
      //   child: SafeArea(
      //     child: Container(
      //       padding: EdgeInsets.all(12),
      //       margin: EdgeInsets.only(left: 24, right: 24, bottom: 3),
      //       decoration: BoxDecoration(
      //           color: Color(0xFF17203A).withOpacity(0.8),
      //           borderRadius: BorderRadius.all(Radius.circular(24))),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           ...List.generate(
      //             bottomNavs.length,
      //             (index) => GestureDetector(
      //               onTap: () {
      //                 bottomNavs[index].input!.change(true);
      //                 if (bottomNavs[index] != selectedBottomNav) {
      //                   setState(() {
      //                     selectedBottomNav = bottomNavs[index];
      //                   });
      //                 }
      //                 Future.delayed(const Duration(seconds: 1), () {
      //                   bottomNavs[index].input!.change(false);
      //                 });
      //               },
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   AnimatedBar(
      //                     isActive: bottomNavs[index] == selectedBottomNav,
      //                   ),
      //                   SizedBox(
      //                     height: 36,
      //                     width: 36,
      //                     child: Opacity(
      //                       opacity:
      //                           bottomNavs[index] == selectedBottomNav ? 1 : 0.5,
      //                       child: RiveAnimation.asset(
      //                         bottomNavs.first.src,
      //                         artboard: bottomNavs[index].artboard,
      //                         onInit: (artboard) {
      //                           StateMachineController contoller =
      //                               RiveUtils.getRiveController(artboard,
      //                                   stateMachineName:
      //                                       bottomNavs[index].stateMachineName);
      //                           bottomNavs[index].input =
      //                               contoller.findSMI("active") as SMIBool;
      //                         },
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      //
    );
  }
}
