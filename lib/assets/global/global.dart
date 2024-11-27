import 'package:voting_system/assets/global/global_variable.dart';

var IpAddress = "192.168.1.5";

var BaseUrl = Uri.http(IpAddress, "/Voting_system/query.php");
var LoginUrl = BaseUrl.replace(queryParameters: {"action": "LoginEmail"});
var LoginQR = BaseUrl.replace(queryParameters: {"action": "LoginQR"});

var FetchUsers = BaseUrl.replace(queryParameters: {"action": "UsersList"});
var ShowUser = BaseUrl.replace(queryParameters: {"action": "ShowUser"});


// DROPDOWN
var FetchYearLevel = BaseUrl.replace(queryParameters: {"action": "fetchYearLevel"});
var FetchCourse = BaseUrl.replace(queryParameters: {"action": "fetchCourse"});
var AddUsers = BaseUrl.replace(queryParameters: {"action": "AddUser"});
var DeleteUser = BaseUrl.replace(queryParameters: {"action": "DeleteUser"});
var FetchPosition = BaseUrl.replace(queryParameters: {"action": "FetchPosition"});
var FetchCandidates = BaseUrl.replace(queryParameters: {"action": "FetchCandidates"});
var FetchApplication = BaseUrl.replace(queryParameters: {"action": "Application"});
var AcceptCandidate = BaseUrl.replace(queryParameters: {"action": "AcceptCandidate"});
var RejectCandidate = BaseUrl.replace(queryParameters: {"action": "RejectCandidate"});
var FetchSchedules = BaseUrl.replace(queryParameters: {"action": "FetchSchedules"});
var SaveCandidacySched = BaseUrl.replace(queryParameters: {"action": "SaveCandidacySched"});
var SaveVotingSched = BaseUrl.replace(queryParameters: {"action": "SaveVotingSched"});
var Login_QR_FACE = BaseUrl.replace(queryParameters: {"action": "login_QR_FACE"});
var fetchResult = BaseUrl.replace(queryParameters: {"action": "fetchCounting"});
var fetchSched = BaseUrl.replace(queryParameters: {"action": "fetchSchedule"});
var AddCandidateURL = BaseUrl.replace(queryParameters: {"action": "AddCandidate"});
var updateVoteCount = BaseUrl.replace(queryParameters: {"action": "updateVoteCount"});
var FetchPartyList = BaseUrl.replace(queryParameters: {"action": "FetchPartyList"});
var ShowPartylist = BaseUrl.replace(queryParameters: {"action": "ShowPartylist"});
var fetchCandidateForVote = BaseUrl.replace(queryParameters: {"action": "fetchCandidatesForVote"});
var submitVote = BaseUrl.replace(queryParameters: {"action": "SubmitVote"});


// Python
var Facial_Recognition = Uri.http(IpAddress + ':5000', '/authenticate');


// No PHP

var AddPartyList = BaseUrl.replace(queryParameters: {"action": "AddPartyList"});

var DeletePartyList = BaseUrl.replace(queryParameters: {"action": "DeletePartyList"});



