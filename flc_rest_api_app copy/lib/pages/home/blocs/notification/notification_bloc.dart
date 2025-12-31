import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repo/notifications_repo.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationsState> {
  NotificationBloc(this.notificationsRepo)
      : super(const NotificationsState([])) {
    on<GetNotifications>(_getNotifications);

    add(GetNotifications());
  }

  final NotificationsRepo notificationsRepo;

  Future<void> _getNotifications(
      GetNotifications event, Emitter<NotificationsState> emit) async {
    final list = await notificationsRepo.getNotifications();
    emit(NotificationsState(list));
  }
}
