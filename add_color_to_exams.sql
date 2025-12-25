-- Migration: Add missing columns to exams table

-- Add exam_name column (Tên kỳ thi: Cuối kỳ, Giữa kỳ, Thường xuyên)
ALTER TABLE exams ADD COLUMN IF NOT EXISTS exam_name TEXT;

-- Add is_completed column
ALTER TABLE exams ADD COLUMN IF NOT EXISTS is_completed BOOLEAN DEFAULT false;

-- Add color column to store subject color
ALTER TABLE exams ADD COLUMN IF NOT EXISTS color TEXT;

-- Add exam_room column (Phòng thi)
ALTER TABLE exams ADD COLUMN IF NOT EXISTS exam_room TEXT;

-- Update existing records with default values
UPDATE exams SET exam_name = 'Cuối kỳ' WHERE exam_name IS NULL;
UPDATE exams SET is_completed = false WHERE is_completed IS NULL;
UPDATE exams SET color = '#2196F3' WHERE color IS NULL;

-- Add comments
COMMENT ON COLUMN exams.exam_name IS 'Tên kỳ thi: Cuối kỳ, Giữa kỳ, Thường xuyên';
COMMENT ON COLUMN exams.is_completed IS 'Whether this exam is completed';
COMMENT ON COLUMN exams.color IS 'Color of the exam (inherited from subject)';
COMMENT ON COLUMN exams.exam_room IS 'Phòng thi';
