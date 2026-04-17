-- Drop existing table if exists
DROP TABLE IF EXISTS attendance;

-- Attendance Table
CREATE TABLE attendance (
  att_id INT AUTO_INCREMENT PRIMARY KEY,
  u_id INT NOT NULL,
  att_date DATE NOT NULL,
  
  -- Punch In
  punch_in_time DATETIME NULL,
  punch_in_image VARCHAR(255) NULL,
  punch_in_lat DECIMAL(10, 8) NULL,
  punch_in_lng DECIMAL(11, 8) NULL,
  punch_in_address VARCHAR(500) NULL,
  
  -- Punch Out
  punch_out_time DATETIME NULL,
  punch_out_image VARCHAR(255) NULL,
  punch_out_lat DECIMAL(10, 8) NULL,
  punch_out_lng DECIMAL(11, 8) NULL,
  punch_out_address VARCHAR(500) NULL,
  
  -- Calculated
  total_hours DECIMAL(5, 2) NULL,
  status ENUM('present', 'absent', 'halfday', 'leave', 'holiday', 'weekend') DEFAULT 'present',
  
  -- Meta
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- Indexes
  INDEX idx_attendance_user (u_id),
  INDEX idx_attendance_date (att_date),
  
  -- Unique constraint: One attendance record per user per day
  UNIQUE INDEX idx_unique_user_date (u_id, att_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
