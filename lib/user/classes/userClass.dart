class UserData {

  static final UserData _instance = UserData._internal();

  String? _userID;
  String? _userName;
  String? _course;
  String? _yearLevel;
  String? _userEmail;
  int? _isVoted;
  String? _userProfile;



  // Private constructor
  UserData._internal();

  // Factory constructor to return the same instance
  factory UserData() {
    return _instance;
  }

  void setuserID(String id) {
    this._userID = id;
  }

  void setUsername(String username) {
    this._userName = username;
  }

  void setCourse(String course) {
    this._course  = course;
  }

  void setYearLevel(String yearLevel) {
    this._yearLevel = yearLevel;
  }

  void setuserEmail(String email) {
    this._userEmail = email;
  }

  void setIsVoted(int isVoted) {
    this._isVoted = isVoted;
  }

  void setuserProfile(String profile) {
    this._userProfile = profile;
  }

  String? getuserID() {
    return _userID!;
  }

  String getUsername() {
    return _userName!;
  }


  String getCourse() {
    return _course!;
  }

  String getYearLevel() {
    return _yearLevel!;
  }

  String getuserEmail() {
    return _userEmail!;
  }

  int getIsVoted() {
    return _isVoted!;
  }

  String getuserProfile() {
    return _userProfile!;
  }
}
