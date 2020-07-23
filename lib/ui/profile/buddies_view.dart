import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/buddy_list_cell.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/refer_friend_cell/refer_friend_cell.dart';
import 'package:flutter/cupertino.dart';

class BuddiesView extends StatefulWidget {
  @override
  _BuddiesViewState createState() => _BuddiesViewState();
}

class _BuddiesViewState extends State<BuddiesView> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: ReferFriendCell(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: _buildContent(),
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) ProgressBar();

    final buddies = SuperStateful.of(context).buddiesList;

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) => BuddyListCell(
        status: buddies[index].status,
        userEmail: buddies[index].invitedEmail,
        userName: buddies[index].invitedFirstName +
            " " +
            buddies[index].invitedLastName,
      ),
      itemCount: buddies.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => Container(
        height: 8,
      ),
    );
  }

  Future<void> _fetchData() async {
    SuperStateful.of(context).updateBuddiesList();

    setState(() {
      _loading = false;
    });
  }
}
