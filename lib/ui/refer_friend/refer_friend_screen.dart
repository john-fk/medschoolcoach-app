import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/buttons/pop_back_button.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/inputs/main_text_field.dart';
import 'package:Medschoolcoach/widgets/inputs/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferFriendScreen extends StatefulWidget {
  final String source;

  const ReferFriendScreen(this.source);

  @override
  _ReferFriendScreenState createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  RepositoryErrorResult _error;
  bool _loading = false;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenReferFriend, widget.source);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          key: const Key("refer_scroll"),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    Style.of(context).svgAsset.refScreen,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 30,
                    left: 20,
                    child: InkWell(
                      key: const Key("app_bar_back_button"),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: PopBackButton(),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  autovalidateMode: _autovalidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Text(
                        FlutterI18n.translate(
                            context, "refer_friend_screen.line1"),
                        style: biggerResponsiveFont(
                          context,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: FlutterI18n.translate(
                                context,
                                "refer_friend_screen.line2",
                              ),
                              style: normalResponsiveFont(context),
                            ),
                            TextSpan(
                              text: ' \n',
                              style: normalResponsiveFont(context),
                            ),
                            TextSpan(
                              text: FlutterI18n.translate(
                                context,
                                "refer_friend_screen.link",
                              ),
                              style: normalResponsiveFont(
                                context,
                                fontWeight: FontWeight.bold,
                                fontColor: FontColor.Accent,
                              ).copyWith(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch(Config.swagStore);
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MainTextField(
                        key: const Key("name"),
                        controller: _nameController,
                        labelText: FlutterI18n.translate(
                          context,
                          "refer_friend_screen.name",
                        ),
                        keyboardType: TextInputType.text,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validators: [
                          Validators.requiredValidator(context),
                        ],
                      ),
                      const SizedBox(height: 5),
                      MainTextField(
                        key: const Key("surname"),
                        controller: _surnameController,
                        labelText: FlutterI18n.translate(
                          context,
                          "refer_friend_screen.surname",
                        ),
                        keyboardType: TextInputType.text,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validators: [
                          Validators.requiredValidator(context),
                        ],
                      ),
                      const SizedBox(height: 5),
                      MainTextField(
                        key: const Key("email"),
                        controller: _emailController,
                        labelText: FlutterI18n.translate(
                          context,
                          "refer_friend_screen.email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: _inviteFriend,
                        validators: [
                          Validators.requiredValidator(context),
                          Validators.emailValidator(context),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: EmptyState(repositoryResult: _error),
                        ),
                      PrimaryButton(
                        text: FlutterI18n.translate(
                            context, "refer_friend_screen.button"),
                        onPressed: _inviteFriend,
                        isLoading: _loading,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 30,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _inviteFriend() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autovalidate = true;
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    final NetworkResponse result =
        await Injector.appInstance.getDependency<ApiServices>().inviteFriend(
              email: _emailController.text,
              firstName: _nameController.text,
              lastName: _surnameController.text,
            );

    if (result is SuccessResponse) {
      await SuperStateful.of(context).updateBuddiesList();
      setState(() {
        _loading = false;
        _error = null;
      });
      await _showSuccessDialog();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _loading = false;
        _error = RepositoryUtils.handleRepositoryError<void>(result);
      });
    }

    _analyticsProvider
        .logEvent(AnalyticsConstants.tapSubmitInviteFriend, params: {
      AnalyticsConstants.keyIsSuccess: _error == null,
      AnalyticsConstants.keyError: _error?.error?.toString()
    });
  }

  Future _showSuccessDialog() {
    return showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "general.success",
          ),
          content: FlutterI18n.translate(
            context,
            "refer_friend_screen.success",
            translationParams: {
              "name": _nameController.text,
            },
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.continue",
              ),
              onTap: () => {
                Navigator.pop(context),
              },
            ),
          ],
        );
      },
    );
  }
}
