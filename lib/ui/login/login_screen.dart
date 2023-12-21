import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_app/bloc/login_bloc/logic_bloc.dart';
import 'package:trade_app/bloc/login_bloc/login_event.dart';
import 'package:trade_app/bloc/login_bloc/login_state.dart';
import 'package:trade_app/models/user_model.dart';
import 'package:trade_app/services/trade_store.dart';
import 'package:trade_app/ui/home/home_screen.dart';
import 'package:trade_app/utils/app_colors.dart';
import 'package:trade_app/utils/app_image.dart';
import 'package:trade_app/widgets/app_toast.dart';
import 'package:trade_app/widgets/custom_Input_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  GlobalKey<FormState> formKay = GlobalKey<FormState>();
  bool isLoading = true;

  late LoginBloc loginBloc;

  CountryCode? code = CountryCode(
    code: "IN",
    dialCode: "+91",
  );

  @override
  void initState() {
    loginBloc = context.read<LoginBloc>();

    super.initState();
    getSession();
  }

  getSession() {
    tradeSharedStore.restoreSession();
    tradeSharedStore.isSessionValid.listen((event) {
      if (event == true) {
        isLoading = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          // (toure) => true
        );
      } else {
        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.blue,
        body: isLoading
            ? const CircularProgressIndicator(
                color: AppColors.blue,
              )
            : SingleChildScrollView(
                child: Form(
                  key: formKay,
                  child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginLoadingState) {
                        const CircularProgressIndicator();
                      }
                      if (state is LoginErrorState) {
                        AppToast.instance.showError(context, state.msg);
                      }

                      if (state is LoginSuccessState) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.08),
                              height: 140,
                              width: 140,
                              child: Image.asset(AppImageString.icLogo)),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.10,
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 25.0,
                                      color: Colors.white.withOpacity(0.50)),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(30),
                                    left: Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 40),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Opacity(
                                      opacity: 0.50,
                                      child: Text(
                                        'Mobile number',
                                        style: TextStyle(
                                          color: Color(0xFF171717),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CountryCodePicker(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 0),
                                          barrierColor:
                                              Colors.black.withOpacity(0.2),
                                          onChanged: (CountryCode codeValue) {
                                            setState(() {
                                              code = codeValue;
                                            });
                                          },
                                          initialSelection: 'IN',
                                          favorite: const ['+91', 'IN'],
                                          searchDecoration: InputDecoration(
                                            hintText:
                                                "Search Country Code (Past selected)",
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black
                                                        .withOpacity(0.50))),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                ?.copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: CustomInputForm(
                                            controller: mobileController,
                                            hint: "Enter Mobile number",
                                            inputformtters: [
                                              FilteringTextInputFormatter.deny(
                                                  ' '),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value
                                                      ?.trimLeft()
                                                      .trimRight()
                                                      .isEmpty ??
                                                  true) {
                                                return "Please enter mobile number";
                                              } else if (!RegExp(
                                                      r"^(?:[0-9] ?){9,14}[0-9]$")
                                                  .hasMatch(value ?? '')) {
                                                return "Please enter valid mobile number";
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        FocusNode? focusNode =
                                            FocusManager.instance.primaryFocus;
                                        if (focusNode != null) {
                                          if (focusNode.hasPrimaryFocus) {
                                            focusNode.unfocus();
                                          }
                                        }
                                        if (formKay.currentState?.validate() ??
                                            false) {
                                          loginBloc.add(LoginSubmitEvent(
                                            loginModel: UserModel(
                                                mobile: mobileController.text
                                                    .trim(),
                                                countryCode:
                                                    code?.dialCode ?? ""),
                                          ));
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          fixedSize: const Size(335, 55),
                                          backgroundColor: AppColors.blue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  strokeAlign: 1.0,
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    const Row(
                                      children: [
                                        Expanded(child: Divider()),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            'With',
                                            style: TextStyle(
                                              color: Color(0xFF686868),
                                              fontSize: 15,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Divider()),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 29,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        AppToast.instance.showSuccess(
                                            context, "In Development");
                                      },
                                      style: OutlinedButton.styleFrom(
                                          fixedSize: const Size(335, 55),
                                          backgroundColor: Colors.red.shade800,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  strokeAlign: 1.0,
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      child: const Text(
                                        "Google",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ));
  }
}
