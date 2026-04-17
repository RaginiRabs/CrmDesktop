-- ============================================================================
-- Migration: Add reminder_sent column to lead_followups
-- Purpose: Track if push notification was sent for a followup
-- Run this on ALL client databases
-- ============================================================================

ALTER TABLE `lead_followups`
  ADD COLUMN `reminder_sent` tinyint(1) NOT NULL DEFAULT 0 AFTER `is_active`;

-- Index for the cron query performance
ALTER TABLE `lead_followups`
  ADD INDEX `idx_reminder_pending` (`status`, `is_active`, `reminder_sent`, `followup_dt`);
