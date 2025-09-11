// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message('Login', name: 'Login', desc: '', args: []);
  }

  /// `Enter your mobile number`
  String get EnterPhone {
    return Intl.message(
      'Enter your mobile number',
      name: 'EnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get MobileNumber {
    return Intl.message(
      'Mobile Number',
      name: 'MobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get EnterPassword {
    return Intl.message(
      'Enter your password',
      name: 'EnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message('Password', name: 'Password', desc: '', args: []);
  }

  /// `Forgot Password ?`
  String get ForgotPassword {
    return Intl.message(
      'Forgot Password ?',
      name: 'ForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get NoAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'NoAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignUp {
    return Intl.message('Sign Up', name: 'SignUp', desc: '', args: []);
  }

  /// `Choose where to send you\nRecover Link`
  String get ChooseRecovery {
    return Intl.message(
      'Choose where to send you\nRecover Link',
      name: 'ChooseRecovery',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail`
  String get Email {
    return Intl.message('E-Mail', name: 'Email', desc: '', args: []);
  }

  /// `Phone`
  String get Phone {
    return Intl.message('Phone', name: 'Phone', desc: '', args: []);
  }

  /// `We have sent you a recover link to\nchange your password`
  String get RecoverySent {
    return Intl.message(
      'We have sent you a recover link to\nchange your password',
      name: 'RecoverySent',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get Resend {
    return Intl.message('Resend', name: 'Resend', desc: '', args: []);
  }

  /// `Change Password`
  String get ChangePassword {
    return Intl.message(
      'Change Password',
      name: 'ChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message('Sign in', name: 'sign_in', desc: '', args: []);
  }

  /// `Name`
  String get Name {
    return Intl.message('Name', name: 'Name', desc: '', args: []);
  }

  /// `Enter your Name`
  String get EnterName {
    return Intl.message(
      'Enter your Name',
      name: 'EnterName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email`
  String get EnterEmail {
    return Intl.message(
      'Enter your Email',
      name: 'EnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get EnterNewPassword {
    return Intl.message(
      'Enter your new password',
      name: 'EnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get ConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'ConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account ? `
  String get Alreadyhaveanaccount {
    return Intl.message(
      'Already have an account ? ',
      name: 'Alreadyhaveanaccount',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get VerifyCode {
    return Intl.message('Verify Code', name: 'VerifyCode', desc: '', args: []);
  }

  /// `Don’t receive OTP code?`
  String get DontreceiveOTPcode {
    return Intl.message(
      'Don’t receive OTP code?',
      name: 'DontreceiveOTPcode',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get ResendOTP {
    return Intl.message('Resend OTP', name: 'ResendOTP', desc: '', args: []);
  }

  /// `Enter OTP`
  String get EnterOTP {
    return Intl.message('Enter OTP', name: 'EnterOTP', desc: '', args: []);
  }

  /// `OTP`
  String get OTP {
    return Intl.message('OTP', name: 'OTP', desc: '', args: []);
  }

  /// `Enter your current password`
  String get EnterCurrentPassword {
    return Intl.message(
      'Enter your current password',
      name: 'EnterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get Next {
    return Intl.message('Next', name: 'Next', desc: '', args: []);
  }

  /// `New Password`
  String get NewPassword {
    return Intl.message(
      'New Password',
      name: 'NewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get Done {
    return Intl.message('Done', name: 'Done', desc: '', args: []);
  }

  /// `Connection to server failed`
  String get connectionToServerFailed {
    return Intl.message(
      'Connection to server failed',
      name: 'connectionToServerFailed',
      desc: '',
      args: [],
    );
  }

  /// `requestToTheServerWasCancelled`
  String get requestToTheServerWasCancelled {
    return Intl.message(
      'requestToTheServerWasCancelled',
      name: 'requestToTheServerWasCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Connection timeout with the server`
  String get connectionTimeoutWithTheServer {
    return Intl.message(
      'Connection timeout with the server',
      name: 'connectionTimeoutWithTheServer',
      desc: '',
      args: [],
    );
  }

  /// `Connection to the server failed due to internet connection`
  String get connectionToTheServerFailedDueToInternetConnection {
    return Intl.message(
      'Connection to the server failed due to internet connection',
      name: 'connectionToTheServerFailedDueToInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Receive timeout in connection with the server`
  String get receiveTimeOutInConnectionWithTheServer {
    return Intl.message(
      'Receive timeout in connection with the server',
      name: 'receiveTimeOutInConnectionWithTheServer',
      desc: '',
      args: [],
    );
  }

  /// `Send timeout in connection with the server`
  String get sendTimeoutInConnectionWithTheServer {
    return Intl.message(
      'Send timeout in connection with the server',
      name: 'sendTimeoutInConnectionWithTheServer',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error occurred`
  String get UnexpectedErrorOccurred {
    return Intl.message(
      'Unexpected error occurred',
      name: 'UnexpectedErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Hello, Welcome back You’ve been missed`
  String get HelloWelcome {
    return Intl.message(
      'Hello, Welcome back You’ve been missed',
      name: 'HelloWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Or sign in with`
  String get Orsigninwith {
    return Intl.message(
      'Or sign in with',
      name: 'Orsigninwith',
      desc: '',
      args: [],
    );
  }

  /// `Fill your information below or register with your social account`
  String get Fillaccount {
    return Intl.message(
      'Fill your information below or register with your social account',
      name: 'Fillaccount',
      desc: '',
      args: [],
    );
  }

  /// `Agree with `
  String get Agreewith {
    return Intl.message('Agree with ', name: 'Agreewith', desc: '', args: []);
  }

  /// `Terms & Conditions`
  String get TermsConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'TermsConditions',
      desc: '',
      args: [],
    );
  }

  /// `Or sign up with`
  String get Orsignup {
    return Intl.message(
      'Or sign up with',
      name: 'Orsignup',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code we just sent to email carinosama24@gmail.com`
  String get Enterthecode {
    return Intl.message(
      'Enter the code we just sent to email carinosama24@gmail.com',
      name: 'Enterthecode',
      desc: '',
      args: [],
    );
  }

  /// `Todays special`
  String get Todaysspecial {
    return Intl.message(
      'Todays special',
      name: 'Todaysspecial',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get Verify {
    return Intl.message('Verify', name: 'Verify', desc: '', args: []);
  }

  /// `best features with courses as low as EGP 399.99`
  String get bestfeatures {
    return Intl.message(
      'best features with courses as low as EGP 399.99',
      name: 'bestfeatures',
      desc: '',
      args: [],
    );
  }

  /// `Popular courses`
  String get Popularcourses {
    return Intl.message(
      'Popular courses',
      name: 'Popularcourses',
      desc: '',
      args: [],
    );
  }

  /// `Ends in`
  String get Endsin {
    return Intl.message('Ends in', name: 'Endsin', desc: '', args: []);
  }

  /// `See all`
  String get Seeall {
    return Intl.message('See all', name: 'Seeall', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Account Profile`
  String get accountprofile {
    return Intl.message(
      'Account Profile',
      name: 'accountprofile',
      desc: '',
      args: [],
    );
  }

  /// `Edit Account`
  String get editaccount {
    return Intl.message(
      'Edit Account',
      name: 'editaccount',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get Country {
    return Intl.message('Country', name: 'Country', desc: '', args: []);
  }

  /// `City`
  String get City {
    return Intl.message('City', name: 'City', desc: '', args: []);
  }

  /// `Address`
  String get Address {
    return Intl.message('Address', name: 'Address', desc: '', args: []);
  }

  /// `Save`
  String get Save {
    return Intl.message('Save', name: 'Save', desc: '', args: []);
  }

  /// `Enter your Country`
  String get EnterCountry {
    return Intl.message(
      'Enter your Country',
      name: 'EnterCountry',
      desc: '',
      args: [],
    );
  }

  /// `Enter your City`
  String get EnterCity {
    return Intl.message(
      'Enter your City',
      name: 'EnterCity',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Address`
  String get EnterAddress {
    return Intl.message(
      'Enter your Address',
      name: 'EnterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get Edit {
    return Intl.message('Edit', name: 'Edit', desc: '', args: []);
  }

  /// `Delete`
  String get Delete {
    return Intl.message('Delete', name: 'Delete', desc: '', args: []);
  }

  /// `Delete Account`
  String get DeleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'DeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get AreYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'AreYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get Yes {
    return Intl.message('Yes', name: 'Yes', desc: '', args: []);
  }

  /// `No`
  String get No {
    return Intl.message('No', name: 'No', desc: '', args: []);
  }

  /// `Edit Profile`
  String get EditProfile {
    return Intl.message(
      'Edit Profile',
      name: 'EditProfile',
      desc: '',
      args: [],
    );
  }

  /// `Edit Account`
  String get EditAccount {
    return Intl.message(
      'Edit Account',
      name: 'EditAccount',
      desc: '',
      args: [],
    );
  }

  /// `Edit Password`
  String get EditPassword {
    return Intl.message(
      'Edit Password',
      name: 'EditPassword',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get Setting {
    return Intl.message('Setting', name: 'Setting', desc: '', args: []);
  }

  /// `Push Notifications`
  String get PushNotifications {
    return Intl.message(
      'Push Notifications',
      name: 'PushNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get Logout {
    return Intl.message('Logout', name: 'Logout', desc: '', args: []);
  }

  /// `Deleting your account will:`
  String get Deletingyouraccountwill {
    return Intl.message(
      'Deleting your account will:',
      name: 'Deletingyouraccountwill',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get Orders {
    return Intl.message('Orders', name: 'Orders', desc: '', args: []);
  }

  /// `WishList`
  String get WishList {
    return Intl.message('WishList', name: 'WishList', desc: '', args: []);
  }

  /// `Get Help`
  String get GetHelp {
    return Intl.message('Get Help', name: 'GetHelp', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get PrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'PrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `About App`
  String get AboutApp {
    return Intl.message('About App', name: 'AboutApp', desc: '', args: []);
  }

  /// `Account info`
  String get Accountinfo {
    return Intl.message(
      'Account info',
      name: 'Accountinfo',
      desc: '',
      args: [],
    );
  }

  /// `Edit account`
  String get Editaccount {
    return Intl.message(
      'Edit account',
      name: 'Editaccount',
      desc: '',
      args: [],
    );
  }

  /// `Edit account info`
  String get Editaccountinfo {
    return Intl.message(
      'Edit account info',
      name: 'Editaccountinfo',
      desc: '',
      args: [],
    );
  }

  /// `Saved Addresses`
  String get SavedAddresses {
    return Intl.message(
      'Saved Addresses',
      name: 'SavedAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message('Language', name: 'Language', desc: '', args: []);
  }

  /// `Delete account`
  String get Deleteaccount {
    return Intl.message(
      'Delete account',
      name: 'Deleteaccount',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get OldPassword {
    return Intl.message(
      'Old Password',
      name: 'OldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Add your old password`
  String get Enteryouroldpassword {
    return Intl.message(
      'Add your old password',
      name: 'Enteryouroldpassword',
      desc: '',
      args: [],
    );
  }

  /// `Add your new password`
  String get Enteryournewpassword {
    return Intl.message(
      'Add your new password',
      name: 'Enteryournewpassword',
      desc: '',
      args: [],
    );
  }

  /// `Sorry failed to featch user data please restart the app or check your internet connection!!`
  String get sorry {
    return Intl.message(
      'Sorry failed to featch user data please restart the app or check your internet connection!!',
      name: 'sorry',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get selectcountry {
    return Intl.message(
      'Select Country',
      name: 'selectcountry',
      desc: '',
      args: [],
    );
  }

  /// `Delete your account info.`
  String get Deleteyouraccountinfo {
    return Intl.message(
      'Delete your account info.',
      name: 'Deleteyouraccountinfo',
      desc: '',
      args: [],
    );
  }

  /// `Remove all your data.`
  String get Removeallyourdata {
    return Intl.message(
      'Remove all your data.',
      name: 'Removeallyourdata',
      desc: '',
      args: [],
    );
  }

  /// `Delete your history.`
  String get Deleteyourhistory {
    return Intl.message(
      'Delete your history.',
      name: 'Deleteyourhistory',
      desc: '',
      args: [],
    );
  }

  /// `Delete Your Account`
  String get DeleteYourAccount {
    return Intl.message(
      'Delete Your Account',
      name: 'DeleteYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cansel {
    return Intl.message('Cancel', name: 'Cansel', desc: '', args: []);
  }

  /// `Procced To Checkout`
  String get ProccedToCheckout {
    return Intl.message(
      'Procced To Checkout',
      name: 'ProccedToCheckout',
      desc: '',
      args: [],
    );
  }

  /// `You might like to fit it with`
  String get Youmightliketofititwith {
    return Intl.message(
      'You might like to fit it with',
      name: 'Youmightliketofititwith',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message('Search', name: 'Search', desc: '', args: []);
  }

  /// `Sub-Categories`
  String get SubCategories {
    return Intl.message(
      'Sub-Categories',
      name: 'SubCategories',
      desc: '',
      args: [],
    );
  }

  /// `Lastest search`
  String get Lastestsearch {
    return Intl.message(
      'Lastest search',
      name: 'Lastestsearch',
      desc: '',
      args: [],
    );
  }

  /// `Popular product`
  String get Popularproduct {
    return Intl.message(
      'Popular product',
      name: 'Popularproduct',
      desc: '',
      args: [],
    );
  }

  /// `City name`
  String get CityName {
    return Intl.message('City name', name: 'CityName', desc: '', args: []);
  }

  /// `Enter Your city name`
  String get CityNameDes {
    return Intl.message(
      'Enter Your city name',
      name: 'CityNameDes',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Street name`
  String get StreetName {
    return Intl.message(
      'Enter Your Street name',
      name: 'StreetName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Street name`
  String get StreetNameDes {
    return Intl.message(
      'Enter Your Street name',
      name: 'StreetNameDes',
      desc: '',
      args: [],
    );
  }

  /// `Building Number`
  String get BuildingNumber {
    return Intl.message(
      'Building Number',
      name: 'BuildingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Building name`
  String get BuildingNumberDes {
    return Intl.message(
      'Enter Your Building name',
      name: 'BuildingNumberDes',
      desc: '',
      args: [],
    );
  }

  /// `Apartment num`
  String get ApartmentNum {
    return Intl.message(
      'Apartment num',
      name: 'ApartmentNum',
      desc: '',
      args: [],
    );
  }

  /// `Apartment num`
  String get ApartmentNumDes {
    return Intl.message(
      'Apartment num',
      name: 'ApartmentNumDes',
      desc: '',
      args: [],
    );
  }

  /// `Floor Number`
  String get FloorNumber {
    return Intl.message(
      'Floor Number',
      name: 'FloorNumber',
      desc: '',
      args: [],
    );
  }

  /// `Floor Number`
  String get FloorNumberDes {
    return Intl.message(
      'Floor Number',
      name: 'FloorNumberDes',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get PhoneNumber {
    return Intl.message(
      'Phone number',
      name: 'PhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Phone number`
  String get PhoneNumberDes {
    return Intl.message(
      'Enter Your Phone number',
      name: 'PhoneNumberDes',
      desc: '',
      args: [],
    );
  }

  /// `Save Address`
  String get SaveAddress {
    return Intl.message(
      'Save Address',
      name: 'SaveAddress',
      desc: '',
      args: [],
    );
  }

  /// `What’s Your Location`
  String get WhatsYourLocation {
    return Intl.message(
      'What’s Your Location',
      name: 'WhatsYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `We need to know your location in order to deliver your order`
  String get WhatsYourLocationDes {
    return Intl.message(
      'We need to know your location in order to deliver your order',
      name: 'WhatsYourLocationDes',
      desc: '',
      args: [],
    );
  }

  /// `Allow location Access`
  String get AllowlocationAccess {
    return Intl.message(
      'Allow location Access',
      name: 'AllowlocationAccess',
      desc: '',
      args: [],
    );
  }

  /// `Add location manually`
  String get Addlocationmanually {
    return Intl.message(
      'Add location manually',
      name: 'Addlocationmanually',
      desc: '',
      args: [],
    );
  }

  /// `Add address`
  String get Addaddress {
    return Intl.message('Add address', name: 'Addaddress', desc: '', args: []);
  }

  /// `English`
  String get English {
    return Intl.message('English', name: 'English', desc: '', args: []);
  }

  /// `العربية`
  String get Arabic {
    return Intl.message('العربية', name: 'Arabic', desc: '', args: []);
  }

  /// `Add New card`
  String get AddNewCard {
    return Intl.message('Add New card', name: 'AddNewCard', desc: '', args: []);
  }

  /// `Proceed To checkout`
  String get ProceedTocheckout {
    return Intl.message(
      'Proceed To checkout',
      name: 'ProceedTocheckout',
      desc: '',
      args: [],
    );
  }

  /// `Add Card`
  String get AddCard {
    return Intl.message('Add Card', name: 'AddCard', desc: '', args: []);
  }

  /// `Card Holder Name`
  String get CardHolderName {
    return Intl.message(
      'Card Holder Name',
      name: 'CardHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Card Holder Name`
  String get CardHolderNameDes {
    return Intl.message(
      'Enter Card Holder Name',
      name: 'CardHolderNameDes',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get CardNumber {
    return Intl.message('Card Number', name: 'CardNumber', desc: '', args: []);
  }

  /// `Enter Card Number`
  String get CardNumberDes {
    return Intl.message(
      'Enter Card Number',
      name: 'CardNumberDes',
      desc: '',
      args: [],
    );
  }

  /// `Card Expiry Date`
  String get CardExpiryDate {
    return Intl.message(
      'Card Expiry Date',
      name: 'CardExpiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Pay with`
  String get Paywith {
    return Intl.message('Pay with', name: 'Paywith', desc: '', args: []);
  }

  /// `Cash`
  String get Cash {
    return Intl.message('Cash', name: 'Cash', desc: '', args: []);
  }

  /// `Buy Now`
  String get buynow {
    return Intl.message('Buy Now', name: 'buynow', desc: '', args: []);
  }

  /// `Already added to cart`
  String get alreadyAddedToCart {
    return Intl.message(
      'Already added to cart',
      name: 'alreadyAddedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get AddToCart {
    return Intl.message('Add To Cart', name: 'AddToCart', desc: '', args: []);
  }

  /// `Add To Wish List`
  String get AddToWishList {
    return Intl.message(
      'Add To Wish List',
      name: 'AddToWishList',
      desc: '',
      args: [],
    );
  }

  /// `Already added to wish list`
  String get AlreadyAddedToWishList {
    return Intl.message(
      'Already added to wish list',
      name: 'AlreadyAddedToWishList',
      desc: '',
      args: [],
    );
  }

  /// `Already added to cart`
  String get AlreadyAddedToCart {
    return Intl.message(
      'Already added to cart',
      name: 'AlreadyAddedToCart',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get search {
    return Intl.message('search', name: 'search', desc: '', args: []);
  }

  /// `Search For course or categoty `
  String get Searchcourseorcategoty {
    return Intl.message(
      'Search For course or categoty ',
      name: 'Searchcourseorcategoty',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get namecannotbeempty {
    return Intl.message(
      'Name cannot be empty',
      name: 'namecannotbeempty',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get Emailcannotbeempty {
    return Intl.message(
      'Email cannot be empty',
      name: 'Emailcannotbeempty',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get Enteravalidemailaddress {
    return Intl.message(
      'Enter a valid email address',
      name: 'Enteravalidemailaddress',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordcannotbeempty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordcannotbeempty',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 7 characters`
  String get passwordmustbeatleast7characters {
    return Intl.message(
      'Password must be at least 7 characters',
      name: 'passwordmustbeatleast7characters',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid password`
  String get Enteravalidpassword {
    return Intl.message(
      'Enter a valid password',
      name: 'Enteravalidpassword',
      desc: '',
      args: [],
    );
  }

  /// `Continue as guest`
  String get continueasguest {
    return Intl.message(
      'Continue as guest',
      name: 'continueasguest',
      desc: '',
      args: [],
    );
  }

  /// `Nice to meet you`
  String get Nicetomeetyou {
    return Intl.message(
      'Nice to meet you',
      name: 'Nicetomeetyou',
      desc: '',
      args: [],
    );
  }

  /// `Login/Signup`
  String get LoginSignup {
    return Intl.message(
      'Login/Signup',
      name: 'LoginSignup',
      desc: '',
      args: [],
    );
  }

  /// `Promo code`
  String get Promocode {
    return Intl.message('Promo code', name: 'Promocode', desc: '', args: []);
  }

  /// `More Like This`
  String get MoreLikThis {
    return Intl.message(
      'More Like This',
      name: 'MoreLikThis',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get Notifications {
    return Intl.message(
      'Notifications',
      name: 'Notifications',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profession`
  String get EditProfession {
    return Intl.message(
      'Edit Profession',
      name: 'EditProfession',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message('Settings', name: 'Settings', desc: '', args: []);
  }

  /// `Check Our Courses`
  String get Checknewcourses {
    return Intl.message(
      'Check Our Courses',
      name: 'Checknewcourses',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message('Home', name: 'Home', desc: '', args: []);
  }

  /// `My Courses`
  String get MyCourses {
    return Intl.message('My Courses', name: 'MyCourses', desc: '', args: []);
  }

  /// `Cart`
  String get Cart {
    return Intl.message('Cart', name: 'Cart', desc: '', args: []);
  }

  /// `Profile`
  String get Profile {
    return Intl.message('Profile', name: 'Profile', desc: '', args: []);
  }

  /// `For you`
  String get Foryou {
    return Intl.message('For you', name: 'Foryou', desc: '', args: []);
  }

  /// `Passwords don't match`
  String get Passwordsdontmatch {
    return Intl.message(
      'Passwords don\'t match',
      name: 'Passwordsdontmatch',
      desc: '',
      args: [],
    );
  }

  /// `How Can I Help You`
  String get HowCanIHeYou {
    return Intl.message(
      'How Can I Help You',
      name: 'HowCanIHeYou',
      desc: '',
      args: [],
    );
  }

  /// `Favourite`
  String get favourite {
    return Intl.message('Favourite', name: 'favourite', desc: '', args: []);
  }

  /// `Help & FAQ`
  String get helpFaq {
    return Intl.message('Help & FAQ', name: 'helpFaq', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `العربية`
  String get arabic {
    return Intl.message('العربية', name: 'arabic', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Help & FAQ`
  String get HelpFAQ {
    return Intl.message('Help & FAQ', name: 'HelpFAQ', desc: '', args: []);
  }

  /// `Contact Us`
  String get ContactUs {
    return Intl.message('Contact Us', name: 'ContactUs', desc: '', args: []);
  }

  /// `Dark Mode`
  String get DarkMode {
    return Intl.message('Dark Mode', name: 'DarkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get LightMode {
    return Intl.message('Light Mode', name: 'LightMode', desc: '', args: []);
  }

  /// `Notification`
  String get Notification {
    return Intl.message(
      'Notification',
      name: 'Notification',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get Dark {
    return Intl.message('Dark', name: 'Dark', desc: '', args: []);
  }

  /// `Likes`
  String get likes {
    return Intl.message('Likes', name: 'likes', desc: '', args: []);
  }

  /// `Bookings`
  String get bookings {
    return Intl.message('Bookings', name: 'bookings', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
