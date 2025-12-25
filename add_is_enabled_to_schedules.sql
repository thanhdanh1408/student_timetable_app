-- Migration: Add is_enabled and color columns to schedules table

-- Add is_enabled column with default value true
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS is_enabled BOOLEAN DEFAULT true;

-- Add color column to store subject color
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS color TEXT;

-- Update existing records to be enabled
UPDATE schedules SET is_enabled = true WHERE is_enabled IS NULL;

-- Update existing records with default color
UPDATE schedules SET color = '#2196F3' WHERE color IS NULL;

-- Add comments
COMMENT ON COLUMN schedules.is_enabled IS 'Whether this schedule entry is enabled or disabled';
COMMENT ON COLUMN schedules.color IS 'Color of the schedule (inherited from subject)';
