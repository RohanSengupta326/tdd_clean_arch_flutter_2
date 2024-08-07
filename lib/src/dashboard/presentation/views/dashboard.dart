import 'package:clean_arch_bloc_2/core/common/app/providers/user_provider.dart';
import 'package:clean_arch_bloc_2/core/res/colours.dart';
import 'package:clean_arch_bloc_2/src/auth/data/models/user_model.dart';
import 'package:clean_arch_bloc_2/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:clean_arch_bloc_2/src/dashboard/presentation/utils/dashboard_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

// Because for dashboard we don't have to talk to a server
// or do any api call no backend is required, only we are
// showing and playing with already fetched data.
// so that's why only UI is present for dashboard.

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
      // streamBuilder is keeping a check on the stream if user data is
      // fetched or not, if fetched then rebuild.

      // consumer is listening to DashBoardController , if something like index
      // and stuff is changed this consumer will rebuild and show new UI.
      stream: DashboardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data is LocalUserModel) {
          context.read<UserProvider>().user = snapshot.data;
          //   calling the setter, this is passing arguments even though we are
          //   using '='.
          //   and in the router.main we are calling initUser() with limited
          //   attributes of the user, can't access all.
          //   so here we are getting all info from stream by calling
          //   and then we are calling the ' setter ' and updating locally
          //   stored userData.
        }
        return Consumer<DashboardController>(
          builder: (_, controller, __) {
            return Scaffold(
              // IndexedStack takes a list of screens & shows the screen
              // according to the index argument it has which stored the
              // current index.
              // now to navigate between indexes we use BottonNavigatonBar
              // to call methods to change indexes and stuff, can do
              // with other methods too.
              body: IndexedStack(
                index: controller.currentIndex,

                // here the screens from dashboardController are linked
                // with this screen.
                children: controller.screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.currentIndex,
                // once on tap index changes, then this consumer will get
                // rebuilt
                // and currentIndex value will be different and new page will be
                // shown.
                showSelectedLabels: false,
                backgroundColor: Colors.white,
                elevation: 8,
                onTap: controller.changeIndex,
                // here we are calling the
                // function from DashBoardController provider functions.
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 0
                          ? IconlyBold.home
                          : IconlyLight.home,
                      color: controller.currentIndex == 0
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 1
                          ? IconlyBold.document
                          : IconlyLight.document,
                      color: controller.currentIndex == 1
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'Materials',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 2
                          ? IconlyBold.chat
                          : IconlyLight.chat,
                      color: controller.currentIndex == 2
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'Chat',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 3
                          ? IconlyBold.profile
                          : IconlyLight.profile,
                      color: controller.currentIndex == 3
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'User',
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
