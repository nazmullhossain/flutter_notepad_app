import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_app/repository/auth_repository.dart';

import '../const/color_const.dart';
import 'home_pages.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authRepositoryProvider).signInWithGoogle();

    void singinWithGoogle(WidgetRef ref) async {
      final errorModel =
          await ref.watch(authRepositoryProvider).signInWithGoogle();
      final sMesserger = ScaffoldMessenger.of(context);
      if (errorModel.error == null) {
        ref.read(userProvider.notifier).update((state) => errorModel.data);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        sMesserger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
      }
    }

    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50),
              backgroundColor: kWhiteColor,
            ),
            onPressed: () {
              singinWithGoogle(ref);
            },
            icon: Image.asset(
              "images/g-logo-2.png",
              height: 20,
            ),
            label: Text(
              "Sing in Google",
              style: TextStyle(color: kBlackColor),
            )),
      ),
    );
  }
}
