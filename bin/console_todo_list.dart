import 'package:sqlite3/sqlite3.dart';

void main() {
  // Open the database (or create it if it doesn't exist)
  final db = sqlite3.open('todos.db');

  // Create the table if it doesn't exist
  db.execute('''
    CREATE TABLE IF NOT EXISTS todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL
    )
  ''');

  try {
    // Add tasks
    addTodo(db, "Học Flutter");
    addTodo(db, "Xem tài liệu SQLite");

    // Handle empty title gracefully
    try {
      addTodo(db, ""); // Attempt to add an empty title
    } catch (e) {
      print("Không thể thêm công việc: $e");
    }

    // Get and print all tasks
    getTodos(db);

    // Update a task
    updateTodo(db, 1, "Học Flutter nâng cao");

    // Get and print all tasks after update
    getTodos(db);

    // Delete a task
    deleteTodo(db, 2);

    // Get and print all tasks after deletion
    getTodos(db);
  } catch (e) {
    print("Lỗi: $e");
  } finally {
    // Close the database
    db.dispose();
  }
}

// Create (Add a new task)
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

// Read (Get all tasks)
void getTodos(Database db) {
  try {
    final result = db.select('SELECT * FROM todos');

    if (result.isEmpty) {
      print("Danh sách công việc trống.");
    } else {
      print("Danh sách công việc:");
      for (final row in result) {
        print("- ${row['id']}: ${row['title']}");
      }
    }
  } catch (e) {
    throw Exception("Lỗi khi lấy danh sách công việc: $e");
  }
}

// Update (Modify an existing task)
void updateTodo(Database db, int id, String newTitle) {
  if (newTitle.isEmpty) {
    throw Exception("Title không được để trống.");
  }

  try {
    db.execute(
      'UPDATE todos SET title = ? WHERE id = ?',
      [newTitle, id],
    );

    // ignore: deprecated_member_use
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

// Delete (Remove a task)
void deleteTodo(Database db, int id) {
  try {
    db.execute(
      'DELETE FROM todos WHERE id = ?',
      [id],
    );

    // ignore: deprecated_member_use
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