import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../const/color_const.dart';
import '../model/error_model.dart';
import '../model/user_model.dart';
import 'local_storage_repository.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    localStoreageRepositroy: LocalStoreageRepositroy(),
    client: Client(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStoreageRepositroy _localStoreageRepositroy;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStoreageRepositroy localStoreageRepositroy,
  })  : _googleSignIn = googleSignIn,
        _localStoreageRepositroy = localStoreageRepositroy,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
        );

        var res = await _client.post(Uri.parse('$host/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });
        print("the data ${res.body}");
        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
                uid: jsonDecode(res.body)['user']['_id'],
                token: jsonDecode(res.body)['token']);
            error = ErrorModel(error: null, data: newUser);
            _localStoreageRepositroy.setToken(newUser.token);

            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel errorModel = ErrorModel(data: null, error: "Something error");
    try {
      String? token = await _localStoreageRepositroy.getToken();

      if (token != null) {
        Response res = await _client.get(Uri.parse("$host/"), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "x-auth-token": token
        });
        switch (res.statusCode) {
          case 200:
            final newUser =
                UserModel.fromJson(jsonEncode(jsonDecode(res.body)["user"]))
                    .copyWith(token: token);
            errorModel = ErrorModel(data: newUser, error: null);
            _localStoreageRepositroy.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      errorModel = ErrorModel(data: null, error: e.toString());
    }

    return errorModel;
  }
}
