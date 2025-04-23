# Console Todo List Application

## Giới thiệu

Đây là một ứng dụng quản lý danh sách công việc (Todo List) chạy trên dòng lệnh, được xây dựng bằng ngôn ngữ lập trình Dart và sử dụng SQLite làm cơ sở dữ liệu. Ứng dụng hỗ trợ các chức năng cơ bản như thêm, hiển thị, cập nhật, xóa và đánh dấu trạng thái hoàn thành/chưa hoàn thành cho các công việc.

## Chức năng chính

1. **Thêm công việc**: Cho phép người dùng thêm một công việc mới vào danh sách.
2. **Hiển thị danh sách công việc**: Hiển thị tất cả các công việc trong cơ sở dữ liệu cùng với trạng thái của chúng.
3. **Cập nhật công việc**: Cập nhật tiêu đề của một công việc dựa trên ID.
4. **Xóa công việc**: Xóa một công việc khỏi danh sách dựa trên ID.
5. **Đánh dấu trạng thái**: Thay đổi trạng thái của công việc giữa "Hoàn thành" và "Chưa hoàn thành".
6. **Thêm dữ liệu mẫu**: Tự động thêm dữ liệu mẫu khi khởi động ứng dụng nếu cơ sở dữ liệu trống.

## Cách sử dụng

1. **Chạy ứng dụng**:
   Sử dụng lệnh sau để chạy ứng dụng:

   ```bash
   dart run bin/console_todo_list.dart
   ```

    Hoặc

    ```bash
    dart run
    ```

2. **Menu chính**: Sau khi chạy, ứng dụng sẽ hiển thị menu với các tùy chọn:

    ```bash
    ==============================
        TODO LIST MENU
    ==============================

    1. ➕ Thêm công việc
    2. 📋 Hiển thị danh sách công việc
    3. ✏️  Cập nhật công việc
    4. ❌ Xóa công việc
    5. ✅ Đánh dấu Hoàn thành/Chưa hoàn thành
    6. 🚪 Thoát
    ==============================

3. **Thao tác**:

Nhập số tương ứng với tùy chọn trong menu để thực hiện các chức năng.  
Làm theo hướng dẫn trên màn hình để thêm, xem, cập nhật, xóa hoặc thay đổi trạng thái công việc.

## Cấu trúc dự án

- `bin/console_todo_list.dart`: File chính chứa mã nguồn của ứng dụng.
- `lib/`: Thư mục dành cho các thư viện (nếu cần mở rộng).

## Yêu cầu hệ thống

- Dart SDK phiên bản 3.0 trở lên.
- SQLite3 để quản lý cơ sở dữ liệu.
