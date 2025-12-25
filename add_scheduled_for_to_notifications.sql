-- Migration: Add scheduled_for to notifications table

-- scheduled_for = when the notification is intended to be shown (trigger time)
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS scheduled_for TIMESTAMPTZ DEFAULT NOW();

-- Backfill existing rows
UPDATE notifications
SET scheduled_for = created_at
WHERE scheduled_for IS NULL;

-- Helpful index
CREATE INDEX IF NOT EXISTS idx_notifications_scheduled_for ON notifications(scheduled_for DESC);

COMMENT ON COLUMN notifications.scheduled_for IS 'When the notification is scheduled to be shown (trigger time)';
