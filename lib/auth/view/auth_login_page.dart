part of "view.dart";

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  final ScrollController _scrollController1 = ScrollController();

  final ScrollController _scrollController2 = ScrollController();

  final ScrollController _scrollController3 = ScrollController();

  final List<String> imagesRow1 = [
    GroceryImages.ration1,
    GroceryImages.ration2,
    GroceryImages.ration3,
    GroceryImages.ration4,
  ];

  final List<String> imagesRow2 = [
    GroceryImages.ration4,
    GroceryImages.ration5,
    GroceryImages.ration3,
    GroceryImages.ration7,
  ];

  final List<String> imagesRow3 = [
    GroceryImages.ration1,
    GroceryImages.ration6,
    GroceryImages.ration8,
    GroceryImages.ration4,
  ];

  final double _scrollSpeed = 0.7; 
 // Adjust speed as needed
  final Duration _scrollDuration = const Duration(milliseconds: 25);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startContinuousScroll(_scrollController1, true); // Row 1: LTR
      _startContinuousScroll(_scrollController2, false); // Row 2: RTL
      _startContinuousScroll(_scrollController3, true); // Row 3: LTR
    });
  }

  void _startContinuousScroll(ScrollController controller, bool leftToRight) {
    Timer.periodic(_scrollDuration, (timer) {
      if (!controller.hasClients) return;

      double maxScrollExtent = controller.position.maxScrollExtent;
      double currentScrollPosition = controller.position.pixels;

      if (leftToRight) {
        double newPosition = currentScrollPosition + _scrollSpeed;
        if (newPosition >= maxScrollExtent) {
          controller.jumpTo(0.0); // Jump back to start for continuous effect
        } else {
          controller.jumpTo(newPosition);
        }
      } else {
        double newPosition = currentScrollPosition - _scrollSpeed;
        if (newPosition <= 0) {
          controller.jumpTo(
            maxScrollExtent,
          ); // Jump back to end for continuous effect
        } else {
          controller.jumpTo(newPosition);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    _scrollController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GroceryColorTheme().white, // Light blue background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 15), // Padding from top
              // Top Section - Image Rows
              _buildImageRow(
                imagesRow1,
                _scrollController1,
                false,
              ), // Row 1: Left to Right
              _buildImageRow(
                imagesRow2,
                _scrollController2,
                true,
              ), // Row 2: Right to Left (indicated by isSelected true for vegetables)
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  // This function creates the gradient that will be used as the mask
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // The colors of the mask. Black is opaque, transparent is see-through.
                    // This has no effect on the actual color of your child widget.
                    colors: [Colors.black, Colors.transparent],
                    // This list defines where the fade begins and ends.
                    // 0.0 is the top of the widget, 1.0 is the bottom.
                    // Here, the content is fully opaque from the top (0.0) to 60% of the way down (0.6),
                    // then it fades to fully transparent at the bottom (1.0).
                    stops: [0.2, 1.0],
                  ).createShader(bounds);
                },
                // This blend mode applies the mask to the child.
                blendMode: BlendMode.dstIn,
                // This is the widget that will get the fade effect
                child: _buildImageRow(
                  imagesRow3,
                  _scrollController3,
                  false,
                ), // Row 3: Left to Right
              ),
              const SizedBox(height: 50),

              // Logo and Slogan
              Column(
                spacing: 7,
                children: [
                  // SvgPicture.asset(GroceryImages.logo),
                  Image.asset(GroceryImages.logo, width: 170, height: 80),
                  const SizedBox(height: 5),
                  Text(
                    'Slogan line is type here, Slogan line is type here.',
                    textAlign: TextAlign.center,
                    style: GroceryTextTheme().lightText.copyWith(
                      color: GroceryColorTheme().black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Mobile Number Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const _MobileNumberInput(),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthCubit, AuthState>(
                      listenWhen: (previous, current) =>
                          previous.mobileNumberStatus != current.mobileNumberStatus || previous.isMobileNumberValid != current.isMobileNumberValid ,
                      listener: (context, state) {
                        if (state.mobileNumberStatus.apiCallState ==
                            APICallState.loaded) {
                          // Navigate to OTP Verification Page
                          context.pushPage(OtpVerificationPage());
                          context.showSnacbar("OTP sent successfully");

                        } else if (state.mobileNumberStatus.apiCallState ==
                            APICallState.failure) {
                          // Show error message
                          final String errorMessage =
                              state.mobileNumberStatus.errorMessage ??
                                  'An unknown error occurred';
                          context.showSnacbar(errorMessage,backgroundColor: GroceryColorTheme().redColor);
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.mobileNumberStatus != current.mobileNumberStatus || previous.isMobileNumberValid != current.isMobileNumberValid ,
                      builder: (context, state) {
                        return CustomElevatedButton(
                          backgrondColor: GroceryColorTheme().primary,
                          width: double.infinity,
                          onPressed: () {
                            if (state.isMobileNumberValid &&
                                state.mobileNumberStatus.apiCallState !=
                                    APICallState.loading) {
                              // Trigger send OTP
                              context
                                  .read<AuthCubit>()
                                  .sendOtp();
                            } else if (!state.isMobileNumberValid) {
                              context.showSnacbar(
                                  "Please enter a valid mobile number",
                                  backgroundColor:
                                      GroceryColorTheme().redColor);
                            }
                          },
                          buttonText:  state.mobileNumberStatus.apiCallState == APICallState.loading?
                           const Center(child: CircularProgressIndicator()):
                          Text(
                            "Continue",
                            style: GroceryTextTheme().bodyText.copyWith(
                              fontSize: 14,
                              color: GroceryColorTheme().black,
                            ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'By continuing you allow to our ',
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle Terms of Service tap
                          },
                          child: Text(
                            '‘Term of services’',
                            style: GroceryTextTheme().lightText.copyWith(
                              color: GroceryColorTheme().primary,
                            ),
                          ),
                        ),
                        const Text(
                          ' and',
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle Privacy Policy tap
                          },
                          child: Text(
                            '‘Privacy Policy’',
                            style: GroceryTextTheme().lightText.copyWith(
                              color: GroceryColorTheme().primary,
                            ),
                          ),
                        ),
                        const Text(
                          '.', // Period after policy
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageRow(
    List<String> images,
    ScrollController controller,
    bool highlightVegetables,
  ) {
    // Duplicate images to create a continuous loop
    List<String> duplicatedImages = List.from(images)..addAll(images);

    return Container(
      height: 100, // Height of each image row
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: duplicatedImages.length,
        itemBuilder: (context, index) {
          final isVegetables =
              duplicatedImages[index] == 'assets/images/vegetables_icon.png';
          return Container(
            width: 90,
            height: 90,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: GroceryColorTheme().lightPeachColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color:
                    isVegetables && highlightVegetables
                        ? const Color(0xFF6495ED)
                        : Colors.transparent, // Highlight color
                width: isVegetables && highlightVegetables ? 2 : 0,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Center(child: Image.asset(duplicatedImages[index])),
          );
        },
      ),
    );
  }
}



class _MobileNumberInput extends StatelessWidget {
  const _MobileNumberInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen:
          (AuthState previous, AuthState current) =>
              previous.mobileNumber != current.mobileNumber,
      builder: (BuildContext context, AuthState state) {
        return CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          hintText: 'Enter mobile number',
          initialValue:
              state.mobileNumber.isPure ? null : state.mobileNumber.value,
          onChanged:
              (String value) =>
                  context.read<AuthCubit>().mobileNumberChanged(value),
          keyboardType: TextInputType.phone,
         
          prefixText: "+91  ",
          
          prefixStyle: TextStyle(
            color: GroceryColorTheme().black.withValues(alpha: 0.7),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          error:
              state.mobileNumber.displayError != null
                  ? CustomTextfieldErrorWidget(
                    title: _buildPhoneErrorText(state, context),
                  )
                  : null,
        );
      },
    );
  }

  String? _buildPhoneErrorText(AuthState state, BuildContext context) {
    final InvalidValidationError? error = state.mobileNumber.error;

    if (error == InvalidValidationError.empty) {
      return "Mobile number is required!";
    } else if (error == InvalidValidationError.invalid) {
      return "Please enter a valid mobile number!";
    }

    return null;
  }
}
