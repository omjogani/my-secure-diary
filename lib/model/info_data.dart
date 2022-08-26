class Item {
  Item({
    required this.body,
    required this.header,
  });
  final String body;
  final String header;
}

final List<Item> allItems = [
  Item(
    header: "What is Secure Diary?",
    body:
        "     The Secure Diary App helps you to maintain information that you require frequently like Notes, Passwords etc.\n\n     Generally we don't trust password want and password manager due to Privacy and Security as well as Sometimes We don't even aware about what malicious code injected in the app to still password and data. That's Why I developed this Application to ensure privacy and security.",
  ),
  Item(
    header: "How this Dairy is Secure?",
    body:
        "     All the Data From MPIN to Passwords stores in encrypted form. So Original Information is not directly visible, It can only be decrypted by the key by which encrypted.\n\n     So, This specific feature of this app makes it SECURE!!",
  ),
  Item(
    header: "How to use Diary?",
    body:
        "     To Use this Application You will have to enter Phone Number for Authentication, After that It verify using OTP(One Time Password). Then You will be prompted with Name and MPIN Creation, Create New MPIN and whenever you have been ask to enter MPIN then enter MPIN you created.\n\n     You will see Two Sections(Notebook, Passwords), In Notebook you can store general things like TODOS and information which are not confidential & in Passwords You can store Passwords and Other Confidential Information.\nENJOY YOUR OWN SECURE DIARY!",
  ),
  Item(
    header: "Developer Info",
    body:
        "THE SECURE DIARY APP is developed by OM JOGANI for ensuring PRIVACY and SECURITY to store Confidential Information.\n\nHope you Enjoy the App\n\nContact: omjogani.code@gmail.com\nOM JOGANI (SURAT, GUJARAT)",
  ),
];
