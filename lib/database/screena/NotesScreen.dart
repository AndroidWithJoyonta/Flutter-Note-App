import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/database/notes_database.dart';
import 'package:notepad/database/screena/note_card.dart';
import 'package:notepad/database/screena/note_dailogeBox.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }


  Future<void> fetchNotes() async {
    final fetchedNotes = await Notesdatabase.instance.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    Colors.white,         // Default or blank
    Colors.redAccent,     // Urgent or important
    Colors.greenAccent,   // Completed or positive
    Colors.blueAccent,    // Calm or reference notes
    Colors.yellowAccent,  // Reminder or highlight
    Colors.orangeAccent,  // Priority or attention
    Colors.purpleAccent,  // Creative or inspirational
    Colors.pinkAccent,    // Personal or emotional
    Colors.tealAccent,    // Ideas or tech notes
    Colors.indigoAccent,  // Deep thoughts or archive
    Colors.limeAccent,    // Tasks or checklists
    Colors.cyanAccent,    // Cool tone for code or logic
    Colors.amberAccent,   // Warnings or caution
    Colors.grey,          // Neutral or archived
    Colors.brown,         // Serious or grounded
  ];

  void showNoteDailoge(
      {int? id, String?title, String? content, int colorIndex = 0}) {
    showDialog(
      context: context,
      builder: (context) {
        return NoteDailoge(colorIndex: colorIndex,
            noteColor: noteColors,

        noteID: id ,
        title: title,
        content: content,
            onNoteSaved: (newTitle, newDescription, selectedColorIndex, currentdate) async {
              if (id == null) {
                await Notesdatabase.instance.addNote(newTitle, newDescription, currentdate, selectedColorIndex);
              } else {
                await Notesdatabase.instance.updateNote(newTitle, newDescription, currentdate, selectedColorIndex, id);
              }
              fetchNotes(); // 🔥 এটাও যোগ করো যেন UI রিফ্রেশ হয়
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes App',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        showNoteDailoge();
      },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black,),),
      body: notes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notes_outlined, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 20),
            Text(
              'No Notes Found',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85
          )
          , itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];

            return NoteCard(note: note, onDelete: () async {
              await Notesdatabase.instance.deleteNote(note['id']);
              fetchNotes();
            }
            , onTap: () {

                  showNoteDailoge(
                    id: note['id'],
                    title: note['title'],
                    content: note['description'],
                    colorIndex: note['color']
                  );
                }

             , noteColor: noteColors);
          },
        ),
      ),
    );
  }
}
