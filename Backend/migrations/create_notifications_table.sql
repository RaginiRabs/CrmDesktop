-- Create notifications table for in-app notifications
CREATE TABLE IF NOT EXISTS notifications (
  n_id INT AUTO_INCREMENT PRIMARY KEY,
  u_id INT NOT NULL,
  type VARCHAR(30) NOT NULL DEFAULT 'general',
  title VARCHAR(200) NOT NULL,
  message TEXT,
  data TEXT DEFAULT NULL,
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_read (u_id, is_read),
  INDEX idx_user_dt (u_id, create_dt DESC)
);
