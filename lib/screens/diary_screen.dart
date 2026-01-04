import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // 🗂 Saved diary entries (local)
  final List<Map<String, String>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadDiaryEntries(); // ⭐ load on start
  }

  // 🔹 LOAD from SharedPreferences
  Future<void> _loadDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('diary_entries');

    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _entries.clear();
        _entries.addAll(
          decoded.map((e) => Map<String, String>.from(e)),
        );
      });
    }
  }

  // 🔹 SAVE to SharedPreferences
  Future<void> _saveDiaryToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_entries);
    await prefs.setString('diary_entries', encoded);
  }

  // ✍️ SAVE ENTRY
  void _saveEntry() {
    if (_titleController.text.isEmpty ||
        _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _entries.add({
        "title": _titleController.text,
        "note": _noteController.text,
        "date": DateTime.now().toString().substring(0, 16),
      });
    });

    _saveDiaryToStorage(); // ⭐ VERY IMPORTANT

    _titleController.clear();
    _noteController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Diary entry saved")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC56D),
        title: const Text(
          "Farm Diary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // ✍️ ADD ENTRY SECTION
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "New Diary Entry",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Title (e.g. Wheat – Day 10)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        "Write today’s activity, irrigation, fertilizer, issues...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveEntry,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Entry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1),

          // 📚 SAVED ENTRIES LIST
          Expanded(
            child: _entries.isEmpty
                ? const Center(
                    child: Text(
                      "No diary entries yet",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return Card(
                        color: const Color(0xFFFFE1A1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            entry["title"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            entry["note"]!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            entry["date"]!,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(entry["title"]!),
                                content: Text(entry["note"]!),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
