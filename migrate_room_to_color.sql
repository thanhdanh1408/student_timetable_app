-- Migration: Thay đổi cột 'room' thành 'color' trong bảng subjects
-- Chạy script này trong Supabase SQL Editor

-- Bước 1: Thêm cột 'color' mới
ALTER TABLE subjects ADD COLUMN IF NOT EXISTS color TEXT;

-- Bước 2: Set giá trị mặc định cho color (màu xanh dương)
UPDATE subjects SET color = '#2196F3' WHERE color IS NULL;

-- Bước 3: Xóa cột 'room' cũ
ALTER TABLE subjects DROP COLUMN IF EXISTS room;

-- Kết quả: Bảng subjects giờ có cột 'color' thay vì 'room'
