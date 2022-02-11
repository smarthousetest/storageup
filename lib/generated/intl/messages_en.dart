// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) => "${count} B";

  static String m1(date, count_of_gb) =>
      "Your ${count_of_gb} GB subscription will be valid until ${date} after which time ";

  static String m2(count) => "${count} files";

  static String m3(date, cost) => "Next payment on ${date} will be ${cost} \$";

  static String m4(count_of_gb, cost) =>
      "${count_of_gb} GB for ${cost} \$/mounth";

  static String m5(count_of_gb) =>
      "objects from the files and media sections, filling ${count_of_gb}";

  static String m6(count) => "${count} Gb";

  static String m7(count) => "${count} Kb";

  static String m8(count) => "${count} Mb";

  static String m9(count) => "${count} Pb";

  static String m10(count) => "${count} \$/mounth";

  static String m11(count) => "${count} Tb";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accaunt_deleting":
            MessageLookupByLibrary.simpleMessage("Account deleting"),
        "active_sub":
            MessageLookupByLibrary.simpleMessage("Active subscription"),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "add_location": MessageLookupByLibrary.simpleMessage("Add location"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "all_files": MessageLookupByLibrary.simpleMessage("All files"),
        "already_have_an_account":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "already_registered_email": MessageLookupByLibrary.simpleMessage(
            "User with this Email is already registered"),
        "b": m0,
        "back_to_authorization":
            MessageLookupByLibrary.simpleMessage("Go to authorization"),
        "back_to_main":
            MessageLookupByLibrary.simpleMessage("Go to the main page"),
        "before_deleting":
            MessageLookupByLibrary.simpleMessage("Before deleting an account"),
        "by_date_added": MessageLookupByLibrary.simpleMessage("By date addded"),
        "by_date_viewed":
            MessageLookupByLibrary.simpleMessage("By date viewed"),
        "by_name": MessageLookupByLibrary.simpleMessage("By name"),
        "by_size": MessageLookupByLibrary.simpleMessage("By size"),
        "by_type": MessageLookupByLibrary.simpleMessage("By type"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancel_sub": m1,
        "canceled": MessageLookupByLibrary.simpleMessage("Canceled"),
        "cannot_recovered": MessageLookupByLibrary.simpleMessage(
            "Your files will disappear forever and cannot be recovered."),
        "card": MessageLookupByLibrary.simpleMessage("Card:"),
        "change": MessageLookupByLibrary.simpleMessage("Change"),
        "change_Password":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "change_password":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "change_photo": MessageLookupByLibrary.simpleMessage("Change photo"),
        "changed": MessageLookupByLibrary.simpleMessage("Changed"),
        "contact_us": MessageLookupByLibrary.simpleMessage("contact us"),
        "continue_button": MessageLookupByLibrary.simpleMessage("Continue"),
        "count_of_files": m2,
        "create_a_folder":
            MessageLookupByLibrary.simpleMessage("Create a folder"),
        "create_album": MessageLookupByLibrary.simpleMessage("Create album"),
        "create_folder": MessageLookupByLibrary.simpleMessage("Create folder"),
        "created": MessageLookupByLibrary.simpleMessage("Created"),
        "currency": MessageLookupByLibrary.simpleMessage("\$"),
        "current_subscription_payment": m3,
        "current_subscription_title": m4,
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "date_format": MessageLookupByLibrary.simpleMessage("Date format"),
        "day": MessageLookupByLibrary.simpleMessage("day"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Delete account"),
        "delete_file": MessageLookupByLibrary.simpleMessage("Delete file"),
        "delete_permanently":
            MessageLookupByLibrary.simpleMessage("Delete permanently"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "earnings":
            MessageLookupByLibrary.simpleMessage("Your earnings will be"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "email_confirming":
            MessageLookupByLibrary.simpleMessage("Email confirmation"),
        "email_confirming_after": MessageLookupByLibrary.simpleMessage(
            " , to confirm the email address, follow the link inside the letter"),
        "email_confirming_confirm": MessageLookupByLibrary.simpleMessage(
            "To complete registration, please confirm your e-mail address."),
        "email_confirming_letter": MessageLookupByLibrary.simpleMessage(
            "We sent a letter to the mail "),
        "email_confirming_link": MessageLookupByLibrary.simpleMessage(
            "To confirm, follow the link inside the letter."),
        "email_confirming_reg": MessageLookupByLibrary.simpleMessage(
            "Confirmation of e-mail address"),
        "email_successfully": MessageLookupByLibrary.simpleMessage(
            "Your e-mail address has been successfully confirmed"),
        "enter_password":
            MessageLookupByLibrary.simpleMessage("Enter password"),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "file_sorting": MessageLookupByLibrary.simpleMessage("File sorting"),
        "files": MessageLookupByLibrary.simpleMessage("Files"),
        "filled_gb": m5,
        "finance": MessageLookupByLibrary.simpleMessage("Finance"),
        "folder": MessageLookupByLibrary.simpleMessage("Select a folder"),
        "folder_dir": MessageLookupByLibrary.simpleMessage("Folder"),
        "foldr": MessageLookupByLibrary.simpleMessage("Folder"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot your password?"),
        "format": MessageLookupByLibrary.simpleMessage("Format"),
        "free_sub": MessageLookupByLibrary.simpleMessage("Free subcription"),
        "funds": MessageLookupByLibrary.simpleMessage("Withdraw funds"),
        "further_use": MessageLookupByLibrary.simpleMessage(
            "You will be able to use the app free of charge from now on."),
        "gb": m6,
        "get_out": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to get out?"),
        "go_to": MessageLookupByLibrary.simpleMessage("Go to"),
        "go_to_authorization":
            MessageLookupByLibrary.simpleMessage("Go to authorization"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "how_work": MessageLookupByLibrary.simpleMessage("How it works?"),
        "in_StorageUp": MessageLookupByLibrary.simpleMessage("in StorageUp?"),
        "info": MessageLookupByLibrary.simpleMessage("Info"),
        "kb": m7,
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "latest_file": MessageLookupByLibrary.simpleMessage("Latest file"),
        "location": MessageLookupByLibrary.simpleMessage("Location"),
        "mail": MessageLookupByLibrary.simpleMessage("Mail"),
        "make_money": MessageLookupByLibrary.simpleMessage(
            "disk - rent space and make money on it!"),
        "management":
            MessageLookupByLibrary.simpleMessage("Subscription management"),
        "max_storage": MessageLookupByLibrary.simpleMessage(
            "Maximum size for your drive: 180 GB"),
        "mb": m8,
        "media": MessageLookupByLibrary.simpleMessage("Media"),
        "min_storage":
            MessageLookupByLibrary.simpleMessage("Minimum storage size: 32 GB"),
        "money":
            MessageLookupByLibrary.simpleMessage("can make money from it."),
        "money_two_step":
            MessageLookupByLibrary.simpleMessage("Start earning in two steps:"),
        "more_space": MessageLookupByLibrary.simpleMessage(
            "Get more space change your subscription!"),
        "move": MessageLookupByLibrary.simpleMessage("Move"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "new_password": MessageLookupByLibrary.simpleMessage("New password"),
        "new_password_8": MessageLookupByLibrary.simpleMessage(
            "The new password must be at least 8 characters long"),
        "non_existent_email":
            MessageLookupByLibrary.simpleMessage("Non-existent e-mail"),
        "not_space": MessageLookupByLibrary.simpleMessage("Not enough space?"),
        "not_storage": MessageLookupByLibrary.simpleMessage(
            "You have no storage locations yet"),
        "nothing_on_email":
            MessageLookupByLibrary.simpleMessage("Nothing came to Email?"),
        "offer": MessageLookupByLibrary.simpleMessage(
            "Advantageous offer - switch to an annual subscription"),
        "old_password":
            MessageLookupByLibrary.simpleMessage("Enter your old password"),
        "open": MessageLookupByLibrary.simpleMessage("Open"),
        "options": MessageLookupByLibrary.simpleMessage("Options"),
        "or_continue_with":
            MessageLookupByLibrary.simpleMessage("or continue with"),
        "other_sub":
            MessageLookupByLibrary.simpleMessage("Other subscriptions"),
        "our_tariff": MessageLookupByLibrary.simpleMessage(
            "Our tariff assumes payment of 0.2 rubles / day for 1 GB of surrendered space"),
        "overview": MessageLookupByLibrary.simpleMessage("Overview"),
        "parameters": MessageLookupByLibrary.simpleMessage("Common parameters"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "password_recovery":
            MessageLookupByLibrary.simpleMessage("Password recovery"),
        "password_recovery_enter_email": MessageLookupByLibrary.simpleMessage(
            "To recover your password, enter your email address in the field"),
        "payment": MessageLookupByLibrary.simpleMessage("Payment:"),
        "pb": m9,
        "permanently_delete": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to permanently delete your account"),
        "personal": MessageLookupByLibrary.simpleMessage(
            "Настоящая политика обработки персональных данных составлена в соответствии с требованиями Федерального закона от 27.07.2006. №152-ФЗ «О персональных данных» (далее - Закон о персональных данных) и определяет порядок обработки персональных данных и меры по обеспечению безопасности персональных данных, предпринимаемые Михайловым Иваном Сергеевичем (далее – Оператор).1.1. Оператор ставит своей важнейшей целью и условием осуществления своей деятельности соблюдение прав и свобод человека и гражданина при обработке его персональных данных, в том числе защиты прав на неприкосновенность частной жизни, личную и семейную тайну.1.2. Настоящая политика Оператора в отношении обработки персональных данных (далее – Политика) применяется ко всей информации, которую Оператор может получить о посетителях веб-сайта httpsː//thismywebsite·com."),
        "personal_data": MessageLookupByLibrary.simpleMessage("Personal data"),
        "photos": MessageLookupByLibrary.simpleMessage("Photos"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "profile_photo": MessageLookupByLibrary.simpleMessage("Profile photo"),
        "properties": MessageLookupByLibrary.simpleMessage("Properties"),
        "provisions":
            MessageLookupByLibrary.simpleMessage("1. General Provisions"),
        "reason_deleting":
            MessageLookupByLibrary.simpleMessage("Reason for deletion"),
        "recent": MessageLookupByLibrary.simpleMessage("Recent"),
        "register": MessageLookupByLibrary.simpleMessage("Register now"),
        "register_complete":
            MessageLookupByLibrary.simpleMessage("Registration completed"),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "regulations": MessageLookupByLibrary.simpleMessage("Regulations"),
        "remember_me": MessageLookupByLibrary.simpleMessage("Remember me"),
        "rent": MessageLookupByLibrary.simpleMessage("Rent"),
        "rent_space": MessageLookupByLibrary.simpleMessage(
            "You can use free space on your hard"),
        "repeat_passsword":
            MessageLookupByLibrary.simpleMessage("Repeat new password"),
        "restore_password_after_email": MessageLookupByLibrary.simpleMessage(
            ", to reset your password, follow the link inside the letter"),
        "restore_password_before_email": MessageLookupByLibrary.simpleMessage(
            "A letter has been sent to your e-mail "),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "select_folder": MessageLookupByLibrary.simpleMessage(
            "Select the folder on the drive where you have free space."),
        "select_storage":
            MessageLookupByLibrary.simpleMessage("Choose storage location"),
        "sell_space": MessageLookupByLibrary.simpleMessage("Renting a place"),
        "set_size": MessageLookupByLibrary.simpleMessage("Set storage size"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Login"),
        "sign_in_to_account":
            MessageLookupByLibrary.simpleMessage("Login to your account"),
        "size": MessageLookupByLibrary.simpleMessage("Size"),
        "size_of_space": MessageLookupByLibrary.simpleMessage(
            "Specify the size of the space for rent"),
        "something_goes_wrong": MessageLookupByLibrary.simpleMessage(
            "Something went wrong. Try again later"),
        "still_dont_have_account": MessageLookupByLibrary.simpleMessage(
            "Don\'t have an account yet? Hurry to join us!"),
        "store_files": MessageLookupByLibrary.simpleMessage(
            "We use this space to store files, and you "),
        "subscription_pay_mounth": m10,
        "tb": m11,
        "tell_us": MessageLookupByLibrary.simpleMessage(
            "Tell us why you decided to delete your account"),
        "term_of_use": MessageLookupByLibrary.simpleMessage("User Agreement"),
        "term_of_use_after": MessageLookupByLibrary.simpleMessage(
            " and give my consent to the processing of my personal data"),
        "term_of_use_before":
            MessageLookupByLibrary.simpleMessage("I accept the terms "),
        "to_send_letter":
            MessageLookupByLibrary.simpleMessage("Send email again"),
        "trust_level": MessageLookupByLibrary.simpleMessage("Trust level"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "unsubscribe": MessageLookupByLibrary.simpleMessage("Unsubscribe"),
        "upload": MessageLookupByLibrary.simpleMessage("Upload"),
        "upload_file": MessageLookupByLibrary.simpleMessage(
            "As soon as we upload the first files there, money will be credited "),
        "upload_files": MessageLookupByLibrary.simpleMessage("Upload file"),
        "upload_folder": MessageLookupByLibrary.simpleMessage("Upload folder"),
        "upload_media": MessageLookupByLibrary.simpleMessage("Upload media"),
        "upload_to_files":
            MessageLookupByLibrary.simpleMessage("Upload to files"),
        "upload_to_media":
            MessageLookupByLibrary.simpleMessage("Upload to media"),
        "user_name": MessageLookupByLibrary.simpleMessage("Username"),
        "video": MessageLookupByLibrary.simpleMessage("Video"),
        "viewed": MessageLookupByLibrary.simpleMessage("Viewed"),
        "we_can_help":
            MessageLookupByLibrary.simpleMessage(", maybe we can help you."),
        "welcome_to_upstorage":
            MessageLookupByLibrary.simpleMessage("Welcome to StorageUp"),
        "will_be_deleted": MessageLookupByLibrary.simpleMessage(
            "spaces will be deleted without the possibility of recovery."),
        "wrong_cred":
            MessageLookupByLibrary.simpleMessage("Invalid email or password!"),
        "wrong_email":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "Password must be more than 8 characters"),
        "wrong_username": MessageLookupByLibrary.simpleMessage(
            "Username must be more than 2 characters"),
        "you_rent": MessageLookupByLibrary.simpleMessage("You are renting"),
        "you_turn_in": MessageLookupByLibrary.simpleMessage("You turn in"),
        "your_balance":
            MessageLookupByLibrary.simpleMessage("to your balance."),
        "your_income": MessageLookupByLibrary.simpleMessage("Your income")
      };
}
