part of 'view.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OtpVerificationView();
  }
}

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Example back navigation
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'OPT Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'We have send you 4 digits code to ',
                  style: GroceryTextTheme().lightText.copyWith(
                    color: GroceryColorTheme().darkGreyColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '+91 123 456 801',
                      style: GroceryTextTheme().bodyText.copyWith(
                        color: GroceryColorTheme().black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _OtpInput(),
            const SizedBox(height: 20),
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) =>
                  previous.otpResendCountdown != current.otpResendCountdown ||
                  previous.canResendOtp != current.canResendOtp,
              builder: (context, state) {
                if (state.canResendOtp) {
                  return GestureDetector(
                    onTap: () {
                      context.read<AuthCubit>().resendOtp();
                    },
                    child: Text(
                      'Resend OTP',
                      style: GroceryTextTheme().bodyText.copyWith(
                        color: GroceryColorTheme().primary,
                      ),
                    ),
                  );
                } 
                else{
                      return Text(
                    'Resend OTP in  0: ${state.otpResendCountdown}',
                    style: GroceryTextTheme().lightText.copyWith(
                      color: GroceryColorTheme().darkGreyColor,
                    ),
                  );
                }
              
              }
            ),

            const SizedBox(height: 30),
            BlocConsumer<AuthCubit,AuthState>(
              listenWhen: (previous, current) =>
                  previous.otpStatus != current.otpStatus,
              listener: (context,state) {
                if(state.otpStatus.apiCallState == APICallState.loaded){
                  context.pushPage(RootPage());
                }
                else if(state.otpStatus.apiCallState == APICallState.failure){
                  context.showSnacbar(state.otpStatus.errorMessage ?? "Something went wrong",backgroundColor: GroceryColorTheme().redColor);
                }
              },
              buildWhen: (previous, current) => previous.isOtpValid != current.isOtpValid ||
              previous.otpStatus != current.otpStatus,
              builder: (context,state) {
                return CustomElevatedButton(
                  backgrondColor: GroceryColorTheme().primary,
                  width: double.infinity,
                  onPressed: () {
                    if (state.isOtpValid) {
                      context.read<AuthCubit>().loginWithOtp();
                    } else {
                      context.showSnacbar("Please enter valid OTP",backgroundColor: GroceryColorTheme().redColor);
                    }
                  },
                  buttonText: state.otpStatus.apiCallState == APICallState.loading ?
                   const CircularProgressIndicator() :
                   Text(
                    "Verify",
                    style: GroceryTextTheme().bodyText.copyWith(
                      fontSize: 14,
                      color: GroceryColorTheme().black,
                    ),
                  ),
                );
              }
            ),
            const SizedBox(height: 20),

            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Didn’t received OTP code? ',
                style: GroceryTextTheme().lightText.copyWith(
                  color: GroceryColorTheme().black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Resend Code',
                    style: GroceryTextTheme().bodyText.copyWith(
                      color: GroceryColorTheme().primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// OTP Input
class _OtpInput extends StatelessWidget {
  const _OtpInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.otp != current.otp ,
      builder: (context, state) {
        return PinCodeTextField(
                  appContext: context,
                  length: 4,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(17),
                    fieldHeight: context.mHeight * 0.075,
                    fieldWidth: context.mWidth * 0.16,
                    activeFillColor: GroceryColorTheme().white,
                    inactiveFillColor: GroceryColorTheme().white,
                    selectedFillColor: GroceryColorTheme().white,
                    activeColor: GroceryColorTheme().primary,
                    inactiveColor: GroceryColorTheme().black.withValues(alpha: 0.2),
                    selectedColor: GroceryColorTheme().primary,
                    borderWidth: 1,
                    errorBorderColor:
                        state.isOtpValid
                            ? null
                            : GroceryColorTheme().redColor, // Use local state
                    errorBorderWidth: 1,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                   context.read<AuthCubit>().otpChanged(value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                 
                  onCompleted: (v) {
                     context.read<AuthCubit>().loginWithOtp();
                  },
                );
      }
    );
  }
}