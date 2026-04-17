-- Allow multiple punch in/out sessions per day per user
-- Remove the unique constraint on (u_id, att_date)

ALTER TABLE `attendance`
  DROP INDEX `idx_unique_user_date`;

-- Add a session number column to track which session of the day
ALTER TABLE `attendance`
  ADD COLUMN `session_no` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 AFTER `att_date`;
