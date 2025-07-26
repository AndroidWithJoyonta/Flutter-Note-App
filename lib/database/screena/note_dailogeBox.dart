import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDailoge extends StatefulWidget {
  final int? noteID;
  final String? title;
  final String? content;
  final int colorIndex;
  final List<Color> noteColor;
  final Function onNoteSaved;

  const NoteDailoge({
    super.key,
    this.noteID,
    this.title,
    this.content,
    required this.colorIndex,
    required this.noteColor,
    required this.onNoteSaved,
  });

  @override
  State<NoteDailoge> createState() => _NoteDailogeState();
}

class _NoteDailogeState extends State<NoteDailoge> {
  late int _selectedColorIndex;

  @override
  void initState(){
    super.initState();
        _selectedColorIndex = widget.colorIndex;
  }



  @override
  Widget build(BuildContext context) {
  late  final titleController = TextEditingController(text: widget.title);
    final descriptionController = TextEditingController(text: widget.content);


    final currentdata = DateFormat('E D MMM').format(DateTime.now());

    return AlertDialog(
      backgroundColor: widget.noteColor[_selectedColorIndex],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.noteID == null ? 'Add Note' : 'Edit Note',
        style: TextStyle(color: Colors.black87),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentdata,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              children: List.generate(
                widget.noteColor.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: widget.noteColor[index],
                    child: _selectedColorIndex == index
                        ? const Icon(
                            Icons.check,
                            color: Colors.black54,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('cancel', style: TextStyle(color: Colors.black54)),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            final newTitle = titleController.text;
            final newDescription = descriptionController.text;

            widget.onNoteSaved(
              newTitle,
              newDescription,
              _selectedColorIndex,
              currentdata,
            );
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
