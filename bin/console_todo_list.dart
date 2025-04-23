import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void insertSampleData(Database db) {
  try {
    // Kiểm tra xem bảng có dữ liệu hay chưa
    final result = db.select('SELECT COUNT(*) AS count FROM todos');
    final count = result.first['count'] as int;

    if (count == 0) {
      // Thêm dữ liệu mẫu
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
    } else {
      print("Dữ liệu đã tồn tại, không cần thêm dữ liệu mẫu.");
    }
  } catch (e) {
    print("Lỗi khi thêm dữ liệu mẫu: $e");
  }
}

void main() {
  final db = sqlite3.open('todos.db');

  db.execute('''
    CREATE TABLE IF NOT EXISTS todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      isCompleted INTEGER NOT NULL DEFAULT 0
    )
  ''');

  // Thêm dữ liệu mẫu
  insertSampleData(db);

  print("Chào mừng đến với ứng dụng Todo List!");
  while (true) {
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

    stdout.write("Nhập lựa chọn của bạn: ");
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write("Nhập tiêu đề công việc: ");
        final title = stdin.readLineSync() ?? "";
        try {
          addTodo(db, title);
        } catch (e) {
          print("Không thể thêm công việc: $e");
        }
        break;

      case '2':
        getTodos(db);
        break;

      case '3':
        stdout.write("Nhập ID công việc cần cập nhật: ");
        final id = int.tryParse(stdin.readLineSync() ?? "") ?? -1;
        stdout.write("Nhập tiêu đề mới: ");
        final newTitle = stdin.readLineSync() ?? "";
        try {
          updateTodo(db, id, newTitle);
        } catch (e) {
          print("Không thể cập nhật công việc: $e");
        }
        break;

      case '4':
        stdout.write("Nhập ID công việc cần xóa: ");
        final id = int.tryParse(stdin.readLineSync() ?? "") ?? -1;
        try {
          deleteTodo(db, id);
        } catch (e) {
          print("Không thể xóa công việc: $e");
        }
        break;

      case '5':
        stdout.write("Nhập ID công việc cần thay đổi trạng thái: ");
        final id = int.tryParse(stdin.readLineSync() ?? "") ?? -1;
        try {
          toggleTodoStatus(db, id);
        } catch (e) {
          print("Không thể thay đổi trạng thái công việc: $e");
        }
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

void addTodo(Database db, String title) {
  if (title.isEmpty) {
    throw Exception("Title không được để trống.");
  }

  try {
    db.execute('INSERT INTO todos (title) VALUES (?)', [title]);
    print("Đã thêm công việc: $title");
  } catch (e) {
    throw Exception("Lỗi khi thêm công việc: $e");
  }
}

void getTodos(Database db) {
  try {
    final result = db.select('SELECT * FROM todos');

    if (result.isEmpty) {
      print("Danh sách công việc trống.");
    } else {
      print("Danh sách công việc:");
      for (final row in result) {
        final status =
            row['isCompleted'] == 1 ? "Hoàn thành" : "Chưa hoàn thành";
        print("- ${row['id']}: ${row['title']} [${status}]");
      }
    }
  } catch (e) {
    throw Exception("Lỗi khi lấy danh sách công việc: $e");
  }
}

void updateTodo(Database db, int id, String newTitle) {
  if (newTitle.isEmpty) {
    throw Exception("Title không được để trống.");
  }

  try {
    db.execute('UPDATE todos SET title = ? WHERE id = ?', [newTitle, id]);

    final changes = db.getUpdatedRows();

    if (changes > 0) {
      print("Đã cập nhật công việc có ID $id thành: $newTitle");
    } else {
      print("Không tìm thấy công việc có ID $id để cập nhật.");
    }
  } catch (e) {
    throw Exception("Lỗi khi cập nhật công việc: $e");
  }
}

void deleteTodo(Database db, int id) {
  try {
    db.execute('DELETE FROM todos WHERE id = ?', [id]);

    final changes = db.getUpdatedRows();

    if (changes > 0) {
      print("Đã xóa công việc có ID $id.");
    } else {
      print("Không tìm thấy công việc có ID $id để xóa.");
    }
  } catch (e) {
    throw Exception("Lỗi khi xóa công việc: $e");
  }
}

void toggleTodoStatus(Database db, int id) {
  try {
    final result = db.select('SELECT isCompleted FROM todos WHERE id = ?', [
      id,
    ]);

    if (result.isEmpty) {
      print("Không tìm thấy công việc có ID $id.");
      return;
    }

    final currentStatus = result.first['isCompleted'] as int;
    final newStatus = currentStatus == 1 ? 0 : 1;

    db.execute('UPDATE todos SET isCompleted = ? WHERE id = ?', [
      newStatus,
      id,
    ]);

    final statusText = newStatus == 1 ? "Hoàn thành" : "Chưa hoàn thành";
    print("Đã cập nhật trạng thái công việc có ID $id thành: $statusText");
  } catch (e) {
    throw Exception("Lỗi khi cập nhật trạng thái công việc: $e");
  }
}
