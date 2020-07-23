import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/ui/profile/buddies_view.dart';
import 'package:Medschoolcoach/ui/profile/stats_view.dart';
import 'package:Medschoolcoach/utils/api/models/auth0_user_data.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/app_bars/profile_app_bar.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  RepositoryResult<Auth0UserData> _auth0DataResult;

  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();

  @override
  void initState() {
    super.initState();
    _fetchAuth0UserData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: ProfileAppBar(
                  userName: _getUserName(),
                  avatarUrl: _getAvatar(),
                ),
              ),
              _buildTabBar(context),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    BuddiesView(),
                    StatsView(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildTabBar(BuildContext context) {
    return Container(
      color: Style.of(context).colors.inputBackground,
      child: TabBar(
        indicatorPadding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 50.0,
        ),
        indicatorColor: Style.of(context).colors.content,
        unselectedLabelColor: Style.of(context).colors.content.withOpacity(0.3),
        labelColor: Style.of(context).colors.content,
        tabs: [
          Tab(
            text: FlutterI18n.translate(
              context,
              "profile_screen.buddies_tab",
            ),
          ),
          Tab(
            text: FlutterI18n.translate(
              context,
              "profile_screen.stats_tab",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchAuth0UserData({
    bool forceApiRequest = false,
  }) async {
    dynamic result = await _userRepository.getAuth0UserData(
      forceApiRequest: forceApiRequest,
    );
    setState(() {
      _auth0DataResult = result;
    });
  }

  String _getUserName() {
    if (_auth0DataResult is RepositorySuccessResult<Auth0UserData>) {
      RepositorySuccessResult<Auth0UserData> result = _auth0DataResult;
      if (result.data != null && result.data.name != null) {
        return " " + result.data.name;
      }
    }
    return "";
  }

  String _getAvatar() {
    if (_auth0DataResult is RepositorySuccessResult<Auth0UserData>) {
      RepositorySuccessResult<Auth0UserData> result = _auth0DataResult;
      if (result.data != null && result.data.picture != null) {
        return result.data.picture;
      }
    }
    return "";
  }
}
