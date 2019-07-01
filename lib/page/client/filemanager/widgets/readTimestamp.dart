import 'package:timeago/timeago.dart' as TimeAgo;

String readTimestamp(int timestamp, {bool intoThousand = false}){

  var now = new DateTime.now();
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * (intoThousand ? 1000 : 1));
  var diff = now.difference(date);
  
  final timeago = new DateTime.now().subtract(diff);

  return TimeAgo.format(
    timeago,
  );

}