import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:finaltest/helpers/api_caller.dart';
import 'package:finaltest/helpers/dialog_utils.dart';
import 'package:finaltest/models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoItems = [];
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  Future<void> _loadTodoItems() async {
    try {
      final data = await ApiCaller().get("todos");
      final List<dynamic> jsonData = jsonDecode(data);
      final List<TodoItem> todoItems =
          jsonData.map((item) => TodoItem.fromJson(item)).toList();
      setState(() {
        _todoItems = todoItems;
      });
    } catch (e) {
      print("Error loading todo items: $e");
    }
  }

  Future<void> _postData() async {
    try {
      final postData = {
        "URL": _urlController.text,
        "รายละเอียด": _detailController.text,
        // สามารถเพิ่มข้อมูลเพิ่มเติมตามต้องการ
      };

      final response = await ApiCaller().post("report_web", params: postData);

      if (response != null) {
        showOkDialog(
          context: context,
          title: "Success",
          message: "บันทึกข้อมูลสำเร็จ",
        );
      } else {
        showOkDialog(
          context: context,
          title: "Error",
          message: "ไม่สามารถบันทึกข้อมูลได้",
        );
      }
    } catch (e) {
      print("Error sending data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Webby Fondue',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'ระบบรายงานเว็บเลวๆ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '*ต้องกรอกข้อมูล',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL*',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.1,
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: TextField(
                controller: _detailController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'รายละเอียด',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'ระบุประเภทเว็บเลว*',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final item = _todoItems[index];
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: item.image != null
                              ? Image.network(item.image!, fit: BoxFit.cover)
                              : Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                        SizedBox(
                            width: 16), // Add spacing between image and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item.subtitle ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _postData,
              child: Text(
                'ส่งข้อมูล',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
