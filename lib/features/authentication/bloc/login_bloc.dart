import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:qurinorm_task/core/common/config/constants/url.dart';
import 'package:qurinorm_task/features/authentication/data/models/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  FutureOr<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await http.post(
        Uri.parse(Url.loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": event.email,
          "password": event.password,
          "role": event.role,
        }),
      );
      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(jsonDecode(response.body));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', userModel.token);
        print(userModel.token);
        print(userModel.id);
        await prefs.setString('userId', userModel.id);
        emit(LoginSuccess(userModel: userModel));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
      debugPrint("Error: $e");
    }
  }
}
