import 'dart:io';

import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_onboarding_flutter/screen/at_onboarding_reference_screen.dart';
import 'package:at_onboarding_flutter/utils/at_onboarding_dimens.dart';
import 'package:at_onboarding_flutter/utils/at_onboarding_strings.dart';
import 'package:at_onboarding_flutter/widgets/at_onboarding_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AtOnboardingInputAtSignScreen extends StatefulWidget {
  final AtOnboardingConfig config;

  const AtOnboardingInputAtSignScreen({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<AtOnboardingInputAtSignScreen> createState() =>
      _AtOnboardingInputAtSignScreenState();
}

class _AtOnboardingInputAtSignScreenState
    extends State<AtOnboardingInputAtSignScreen> {
  final TextEditingController _atsignController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      primaryColor: widget.config.theme?.appColor,
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: widget.config.theme?.appColor,
          ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AtOnboardingStrings.onboardingTitle,
          ),
          actions: [
            IconButton(
              onPressed: _showReferenceWebview,
              icon: const Icon(Icons.help),
            ),
          ],
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(AtOnboardingDimens.borderRadius)),
            padding: const EdgeInsets.all(AtOnboardingDimens.paddingNormal),
            margin: const EdgeInsets.all(AtOnboardingDimens.paddingNormal),
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Activate an atSign',
                  style: TextStyle(
                    fontSize: AtOnboardingDimens.fontLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Enter the atSign you would like to activate",
                  style: TextStyle(
                    fontSize: AtOnboardingDimens.fontSmall,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  enabled: true,
                  validator: (String? value) {
                    if ((value ?? '').isEmpty) {
                      return 'atSign cannot be empty';
                    }
                    return null;
                  },
                  controller: _atsignController,
                  decoration: InputDecoration(
                    hintText: AtOnboardingStrings.atsignHintText,
                    prefix: Text(
                      '@',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AtOnboardingDimens.paddingSmall),
                  ),
                ),
                const SizedBox(height: 20),
                AtOnboardingPrimaryButton(
                  height: 48,
                  borderRadius: 24,
                  onPressed: _activateAtSign,
                  child: const Center(
                    child: Text(
                      'Activate',
                      style: TextStyle(
                        fontSize: AtOnboardingDimens.fontLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReferenceWebview() {
    if (Platform.isAndroid || Platform.isIOS) {
      AtOnboardingReferenceScreen.push(
        context: context,
        title: AtOnboardingStrings.faqTitle,
        url: AtOnboardingStrings.faqUrl,
        config: widget.config,
      );
    } else {
      launchUrl(
        Uri.parse(
          AtOnboardingStrings.faqUrl,
        ),
      );
    }
  }

  void _activateAtSign() async {
    final String atSign = _atsignController.text;
    Navigator.pop(context, atSign);
  }
}
