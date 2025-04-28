import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('todos.db');

  // Create table if it doesn't exist
  db.execute('''
    CREATE TABLE IF NOT EXISTS todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      isCompleted INTEGER NOT NULL DEFAULT 0
    )
  ''');

  // Insert sample data if the table is empty
  insertSampleData(db);

  print("Chào mừng đến với ứng dụng Todo List!");
  while (true) {
    printMenu();
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        handleAddTodo(db);
        break;
      case '2':
        handleGetTodos(db);
        break;
      case '3':
        handleUpdateTodo(db);
        break;
      case '4':
        handleDeleteTodo(db);
        break;
      case '5':
        handleToggleTodoStatus(db);
        break;
      case '6':
        print("Thoát ứng dụng. Tạm biệt!");
        db.dispose();
        exit(0);
      default:
        print("Lựa chọn không hợp lệ. Vui lòng thử lại.");
    }
  }
}

void printMenu() {
  print("\n==============================");
  print("       TODO LIST MENU         ");
  print("==============================");
  print("1. ➕ Thêm công việc");
  print("2. 📋 Hiển thị danh sách công việc");
  print("3. ✏️  Cập nhật công việc");
  print("4. ❌ Xóa công việc");
  print("5. ✅ Đánh dấu Hoàn thành/Chưa hoàn thành");
  print("6. 🚪 Thoát");
  print("==============================\n");
}

void insertSampleData(Database db) {
  final count =
      db.select('SELECT COUNT(*) AS count FROM todos').first['count'] as int;
  if (count == 0) {
    db.execute('INSERT INTO todos (title, isCompleted) VALUES (?, ?)', [
      'Học Flutter',
      0,
    ]);
    db.execute('INSERT INTO todos (title, isCompleted) VALUES (?, ?)', [
      'Xem tài liệu SQLite',
      1,
    ]);
    db.execute('INSERT INTO todos (title, isCompleted) VALUES (?, ?)', [
      'Viết ứng dụng Todo List',
      0,
    ]);
    print("Đã thêm dữ liệu mẫu.");
  }
}

void handleAddTodo(Database db) {
  stdout.write("Nhập tiêu đề công việc: ");
  final title = stdin.readLineSync() ?? "";
  if (title.isEmpty) {
    print("Tiêu đề không được để trống.");
    return;
  }
  db.execute('INSERT INTO todos (title) VALUES (?)', [title]);
  print("Đã thêm công việc: $title");
}

void handleGetTodos(Database db) {
  final todos = db.select('SELECT * FROM todos');
  if (todos.isEmpty) {
    print("Danh sách công việc trống.");
  } else {
    print("Danh sách công việc:");
    for (final todo in todos) {
      final status =
          todo['isCompleted'] == 1 ? "Hoàn thành" : "Chưa hoàn thành";
      print("- ${todo['id']}: ${todo['title']} [${status}]");
    }
  }
}

void handleUpdateTodo(Database db) {
  stdout.write("Nhập ID công việc cần cập nhật: ");
  final id = int.tryParse(stdin.readLineSync() ?? "") ?? -1;
  stdout.write("Nhập tiêu đề mới: ");
  final newTitle = stdin.readLineSync() ?? "";
  if (newTitle.isEmpty) {
    print("Tiêu đề không được để trống.");
    return;
  }
  final result = db.select('SELECT id FROM todos WHERE id = ?', [id]);
  if (result.isEmpty) {
    print("Không tìm thấy công việc có ID $id.");
    return;
  }
  db.execute('UPDATE todos SET title = ? WHERE id = ?', [newTitle, id]);
  print("Đã cập nhật công việc có ID $id.");
}

void handleDeleteTodo(Database db) {
  stdout.write("Nhập ID công việc cần xóa: ");
  final id = int.tryParse(stdin.readLineSync() ?? "") ?? -1;
  final result = db.select('SELECT id FROM todos WHERE id = ?', [id]);
  if (result.isEmpty) {
    print("Không tìm thấy công việc có ID $id.");
    return;
  }
  db.execute('DELETE FROM todos WHERE id = ?', [id]);
  print("Đã xóa công việc có ID $id.");
}

void handleToggleTodoStatus(Database db) {
  stdout.write("Nhập ID công việc cần thay đổi trạng thái: ");
  final id = int.tryParse(stdin.readLineSync() ?? "") ?? -1;
  final result = db.select('SELECT isCompleted FROM todos WHERE id = ?', [id]);
  if (result.isEmpty) {
    print("Không tìm thấy công việc có ID $id.");
    return;
  }
  final currentStatus = result.first['isCompleted'] as int;
  final newStatus = currentStatus == 1 ? 0 : 1;
  db.execute('UPDATE todos SET isCompleted = ? WHERE id = ?', [newStatus, id]);
  print(
    "Đã cập nhật trạng thái công việc có ID $id thành: ${newStatus == 1 ? "Hoàn thành" : "Chưa hoàn thành"}.",
  );
}
