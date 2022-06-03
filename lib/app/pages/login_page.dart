import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/components/indicator/waiting_indicator.dart';
import 'package:personal_financial_management/app/components/widgets/ChangeLoginMethod.dart';
import 'package:personal_financial_management/app/utils/assets.dart';
import 'package:personal_financial_management/app/utils/global_key.dart';
import 'package:personal_financial_management/app/utils/validators.dart';
import 'package:personal_financial_management/domain/blocs/auth_bloc/authentication_bloc.dart';
import 'package:personal_financial_management/domain/blocs/login/login_bloc.dart';
import 'package:personal_financial_management/domain/repositories/repositories.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  NavigatorState get _navigator => GlobalKeys.appNavigatorKey.currentState!;

  late bool savePassword;
  late final TextEditingController _userNameController;
  late final TextEditingController _passwordController;
  late bool _isVisbilityPassword;
  late bool _isLoading;
  @override
  void initState() {
    super.initState();
    savePassword = false;
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _isVisbilityPassword = false;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        create: (loginBlocContext) => LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context)),
        child: SafeArea(
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == loginStatus.success) {
                BlocProvider.of<AuthenticationBloc>(context).add(
                    const AuthenticationStatusChanged(
                        AuthenticationStatus.authenticated));
              }
              if (state.status == loginStatus.loading) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Đang đăng nhâp...'),
                  duration: Duration(seconds: 1),
                ));
                showDialog(
                    context: context,
                    builder: (context) {
                      return WaitingIndicator();
                    });
              }
              if (state.status == loginStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Đăng nhập thất bại! Vui lòng kiểm tra lại tên đăng nhập và mật khẩu!'),
                  duration: Duration(seconds: 1),
                ));
                // Future.delayed(const Duration(seconds: 1), () {
                //   // Navigator.; //pop dialog
                // });
              }
            },
            child: Scaffold(
                backgroundColor: Colors.white,
                bottomNavigationBar: BottomAppBar(
                  shape: const CircularNotchedRectangle(),
                  color: MyAppColors.white000,
                  elevation: 0,
                  child: SizedBox(
                    height: 111,
                    child: SvgPicture.asset(
                      BackgroundImages.foregroundImagesURL,
                      fit: BoxFit.fill,
                      width: 1000,
                    ),
                  ),
                ),

                // child: FittedBox(
                //     fit: BoxFit.fitWidth,
                //     alignment: Alignment.centerLeft,
                //     child: MyAppImages.foregroundImage),
                body: ListView(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _logo(),
                      const Text(
                        'Đăng nhập',
                        style: TextStyle(
                            fontSize: 42,
                            color: Color.fromRGBO(34, 73, 87, 1),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lexend Deca'),
                      ),
                      const SizedBox(
                        height: 34,
                      ),
                      const Text(
                        'Đăng nhập và bắt đầu quản lý tài chính!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          wordSpacing: 1,
                          letterSpacing: .6,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(34, 73, 87, 1),
                          fontFamily: 'Lexend Deca',
                        ),
                      ),
                      _buildUserNameTextField(),
                      _buildPasswordTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    visualDensity: VisualDensity.compact,
                                    activeColor: MyAppColors.accent900,
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: savePassword,
                                    onChanged: (_) {
                                      setState(() {
                                        savePassword = !savePassword;
                                      });
                                    }),
                                const Text('Ghi nhớ mật khẩu',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(156, 124, 69, 1.0),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lexend Deca',
                                    ))
                              ],
                            ),
                            TextButton(
                                onPressed: () {}, child: Text('Quên mật khẩu?'))
                          ],
                        ),
                      ),

                      //login button
                      _buildLoginButton(
                          userNameController: _userNameController,
                          passwordController: _passwordController),
                      // haven't account
                      const SizedBox(
                        height: 42,
                      ),

                      ChangeLoginMethod(onPressed: () {}, children: []),

                      // _buildBackground()
                    ],
                  ),
                ])),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SizedBox(
        child: MyAppIcons.logo,
        height: 72,
        width: 72,
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      width: 297,
      height: 45,
      margin: const EdgeInsets.only(top: 30),
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (loginBlocContext, state) {
          return TextFormField(
            controller: _passwordController,
            maxLength: 30,
            obscureText: !_isVisbilityPassword,
            smartQuotesType: SmartQuotesType.disabled,
            maxLines: 1,
            decoration: InputDecoration(
                filled: true,
                counterText: '',
                // errorText: _errorText(controller: _passwordController),
                suffixIcon: _isVisbilityPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisbilityPassword = !_isVisbilityPassword;
                          });
                        },
                        icon: MyAppIcons.visibility)
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisbilityPassword = !_isVisbilityPassword;
                          });
                        },
                        icon: MyAppIcons.visibilityOff,
                      ),
                hoverColor: MyAppColors.gray300,
                fillColor: MyAppColors.gray200,
                labelText: "Mật khẩu",
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    width: 1,
                    color: MyAppColors.gray300,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide:
                      BorderSide(width: 1, color: MyAppColors.accent800),
                ),
                labelStyle: const TextStyle(
                    fontSize: 14,
                    color: MyAppColors.accent800,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend Deca'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                )),
          );
        },
      ),
    );
  }

  Widget _buildUserNameTextField() {
    return Container(
      width: 297,
      height: 45,
      margin: const EdgeInsets.only(top: 30),
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.username != current.username,
        builder: (loginBlocContext, state) {
          return TextFormField(
            controller: _userNameController,
            maxLength: 30,
            smartQuotesType: SmartQuotesType.disabled,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                filled: true,
                counterText: '',

                // errorText: _errorText(controller: _userNameController),
                hoverColor: MyAppColors.gray300,
                fillColor: MyAppColors.gray200,
                labelText: "Tài khoản",
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    width: 1,
                    color: MyAppColors.gray300,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide:
                      BorderSide(width: 1, color: MyAppColors.accent800),
                ),
                labelStyle: const TextStyle(
                    fontSize: 14,
                    color: MyAppColors.accent800,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend Deca'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                )),
          );
        },
      ),
    );
  }

  Widget _buildLoginButton(
      {required TextEditingController userNameController,
      required TextEditingController passwordController}) {
    return Container(
      margin: const EdgeInsets.only(top: 21),
      width: 280,
      height: 45,
      child: Expanded(
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: MyAppColors.accent800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Đăng nhập',
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(34, 73, 87, 1),
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (userNameController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Lỗi'),
                          content: const Text('Vui lòng nhập đầy đủ thông tin'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Đóng'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                } else {
                  BlocProvider.of<LoginBloc>(context).add(LoginSubmitted(
                      username: _userNameController.text,
                      password: _passwordController.text));
                }

                setState(() {
                  _isLoading = true;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
