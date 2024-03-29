import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/utils/api/models/auth0_user_data.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class HomeAppBar extends StatefulWidget {
  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String storedName = "";
  final UserManager _userManager =
      Injector.appInstance.getDependency<UserManager>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchUserData(forceApiRequest: true),
    );
  }

  Future<void> _fetchUserData({
    bool forceApiRequest = false,
  }) async {
    await SuperStateful.of(context)
        .updateUserData(forceApiRequest: forceApiRequest);
  }

  Future<void> _fetchUserStored() async {
    var name = await _userManager.getName();
    setState(() {
      storedName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    _fetchUserStored();
    final userData = SuperStateful.of(context).userData;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              FlutterI18n.translate(
                context,
                "home_screen.user_header",
                {
                  "user": userData != null ? 
                  userData.name : storedName,
                },
              ),
              style: biggerResponsiveFont(context, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget profileAvatar(Auth0UserData userData) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.profile, arguments: AnalyticsConstants.screenHome),
      child: CircleAvatar(
        backgroundImage: userData != null && userData.picture.isNotEmpty
            ? NetworkImage(userData.picture)
            : null,
        backgroundColor: Style.of(context).colors.separator,
        radius: whenDevice(
          context,
          large: 20,
          tablet: 30,
        ),
      ),
    );
  }
}
