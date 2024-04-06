import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HadafiHadafItem extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHadaf;
  final void Function(BuildContext)? deleteHadaf;

  const HadafiHadafItem({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    required this.editHadaf,
    required this.deleteHadaf,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // edit option
          SlidableAction(
            onPressed: editHadaf,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(width: 5),

          // delete option
          SlidableAction(
            onPressed: deleteHadaf,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            // toggle completion status
            onChanged!(!isCompleted);
          }
        },
        // Hadaf tile
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ListTile(
            // Text
            title: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: isCompleted
                    ? Colors.white
                    : Theme.of(context).colorScheme.inversePrimary,
                fontWeight: isCompleted ? FontWeight.w800 : FontWeight.w500,
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.white,
                decorationThickness: 3,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),

            // Checkbox
            leading: Checkbox(
              activeColor: Colors.green,
              checkColor: Colors.white,
              value: isCompleted,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
