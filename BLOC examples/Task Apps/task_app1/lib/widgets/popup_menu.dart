import 'package:flutter/material.dart';
import '../models/task.dart';

class PopUpMenu extends StatelessWidget {
  // const PopupMenu({super.key});
  final VoidCallback cancelOrDeleteCallBack;
  final VoidCallback likeOrDislike;
  final VoidCallback editVoidCallback;
  final VoidCallback restoreCallBack;
  Task task;

  PopUpMenu({
    super.key,
    required this.task,
    required this.cancelOrDeleteCallBack,
    required this.likeOrDislike,
    required this.editVoidCallback,
    required this.restoreCallBack
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: task.isDeleted == false
          ? ((context) => [
              PopupMenuItem(
                onTap: editVoidCallback,
                child: TextButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.edit),
                  label: Text("Edit"),
                ),
              ),

              PopupMenuItem(
                onTap: likeOrDislike,
                child: TextButton.icon(
                  onPressed: null,//() {},
                  icon: task.isFavorite == false
                      ? Icon(Icons.bookmark_add_outlined)
                      : Icon(Icons.bookmark_remove),
                  label: task.isFavorite == false
                      ? Text("Add to \nBookmark")
                      : Text("Remove from \nbookmark"),
                ),
              ),

              PopupMenuItem(
                onTap: cancelOrDeleteCallBack,
                child: TextButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.delete),
                  label: Text("Delete"),
                ),
              ),
            ])
          : ((context) => [
              PopupMenuItem(
                onTap: restoreCallBack,
                child: TextButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.restore_from_trash),
                  label: Text("Restore"),
                ),
              ),
              PopupMenuItem(
                onTap: () {},
                child: TextButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.delete_forever),
                  label: Text("Delete Forever"),
                ),
              ),
            ]),
    );
  }
}
