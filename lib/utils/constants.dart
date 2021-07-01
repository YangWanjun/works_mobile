const String HOST_API = "https://api.oa.e-business.co.jp";
// const String HOST_API = "http://10.0.2.2:8020";
// const String HOST_API = "http://127.0.0.1:8020";
const String API_LOGIN = "${HOST_API}/api/token-auth/";
const String API_TASK_STATS = "${HOST_API}/api/account/task/statistics/";
const String API_TASK_UNRESOLVED = "${HOST_API}/api/task/tasks/unresolved/";
const String API_TASK_FINISHED = "${HOST_API}/api/task/tasks/finished/";
const String API_TASK_APPROVAL = "${HOST_API}/api/task/tasks/approval/";
const String API_GOOGLE_LOGIN = "${HOST_API}/google-login/";

const String ACCESS_TOKEN = "access_token";
const String KEY_USER = "user";

const List CHOICE_RESIDENCE_TYPE = [
  {"value": "01", "text": "特定活動"},
  {"value": "02", "text": "企業内転勤"},
  {"value": "03", "text": "技術・人文知識・国際業務"},
  {"value": "10", "text": "高度専門職1号"},
  {"value": "11", "text": "高度専門職2号"},
  {"value": "20", "text": "永住者"},
  {"value": "21", "text": "永住者の配偶者"},
  {"value": "22", "text": "日本人の配偶者"},
  {"value": "90", "text": "日本籍"},
];

const List CHOICE_CERTIFICATE_TYPE = [
  {"value": "01", "text": "在職証明書(日本語)"},
  {"value": "02", "text": "在職証明書(英語)"},
  {"value": "10", "text": "給与証明書(年)"},
  {"value": "11", "text": "給与証明書(月)"},
];

const String SUCCESS_DELETED = '削除しました。';
const String SUCCESS_SUBMITTED = '承認しました。';
const String SUCCESS_UNDO_TASK = '差戻し成功しました。';
