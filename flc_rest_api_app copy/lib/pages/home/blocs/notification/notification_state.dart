part of 'notification_bloc.dart';

class NotificationsState extends Equatable {
  const NotificationsState(this.notifications);

  final List<NotificationDetails> notifications;

  @override
  List<Object> get props => [notifications];
}
