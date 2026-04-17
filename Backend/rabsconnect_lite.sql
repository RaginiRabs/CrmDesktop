-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 05, 2026 at 01:29 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rabsconnect_lite`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `att_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  `att_date` date NOT NULL,
  `session_no` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `punch_in_time` datetime DEFAULT NULL,
  `punch_in_image` varchar(255) DEFAULT NULL,
  `punch_in_lat` decimal(10,8) DEFAULT NULL,
  `punch_in_lng` decimal(11,8) DEFAULT NULL,
  `punch_in_address` varchar(500) DEFAULT NULL,
  `punch_out_time` datetime DEFAULT NULL,
  `punch_out_image` varchar(255) DEFAULT NULL,
  `punch_out_lat` decimal(10,8) DEFAULT NULL,
  `punch_out_lng` decimal(11,8) DEFAULT NULL,
  `punch_out_address` varchar(500) DEFAULT NULL,
  `total_hours` decimal(5,2) DEFAULT NULL,
  `status` enum('present','absent','halfday','leave','holiday','weekend') DEFAULT 'present',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`att_id`, `u_id`, `att_date`, `session_no`, `punch_in_time`, `punch_in_image`, `punch_in_lat`, `punch_in_lng`, `punch_in_address`, `punch_out_time`, `punch_out_image`, `punch_out_lat`, `punch_out_lng`, `punch_out_address`, `total_hours`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 2, '2026-02-23', 1, '2026-02-23 10:29:49', NULL, NULL, NULL, 'Office Location', '2026-02-23 10:30:15', NULL, NULL, NULL, 'Office Location', 5.51, 'present', NULL, '2026-02-23 10:29:49', '2026-02-23 10:30:15'),
(2, 1, '2026-02-28', 1, '2026-02-28 10:32:32', 'attendance/1/punch_in_1772274752125.jpeg', NULL, NULL, 'Office Location', NULL, NULL, NULL, NULL, NULL, NULL, 'present', NULL, '2026-02-28 10:32:32', '2026-02-28 10:32:32'),
(3, 1, '2026-03-05', 1, '2026-03-05 06:39:50', 'attendance/1/punch_in_1772692790936.jpeg', 37.42199830, -122.08400000, '37.421998, -122.084000', '2026-03-05 12:17:45', 'attendance/1/punch_out_1772693265346.jpeg', 37.42199830, -122.08400000, '37.421998, -122.084000', 5.63, 'present', NULL, '2026-03-05 06:39:50', '2026-03-05 06:47:45'),
(4, 1, '2026-03-05', 11, '2026-03-05 12:18:08', 'attendance/1/punch_in_1772693288355.jpeg', 37.42199830, -122.08400000, '37.421998, -122.084000', '2026-03-05 12:29:17', 'attendance/1/punch_out_1772693957130.jpeg', 37.42199830, -122.08400000, '37.421998, -122.084000', 0.19, 'halfday', NULL, '2026-03-05 06:48:08', '2026-03-05 06:59:17');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_policies`
--

CREATE TABLE `attendance_policies` (
  `ap_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL,
  `type` enum('full_day','half_day','late_mark','intime','week_off') NOT NULL,
  `threshold_hours` decimal(4,2) DEFAULT NULL,
  `threshold_minutes` int(10) UNSIGNED DEFAULT NULL,
  `threshold_time` time DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `week_offs` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attendance_policies`
--

INSERT INTO `attendance_policies` (`ap_id`, `title`, `type`, `threshold_hours`, `threshold_minutes`, `threshold_time`, `color`, `week_offs`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Full Day', 'full_day', 9.00, NULL, NULL, '#008000', NULL, 1, '2026-02-06 11:36:07', '2026-02-06 11:36:07'),
(2, 'Half Day', 'half_day', 4.00, NULL, NULL, '#0000FF', NULL, 1, '2026-02-06 11:36:07', '2026-02-06 11:36:07'),
(3, 'Failed to Logout', '', NULL, NULL, NULL, '#bd7f0d', NULL, 1, '2026-02-06 11:36:07', '2026-02-06 11:36:07'),
(4, 'Late Mark 15 min', 'late_mark', NULL, 15, NULL, '#fdac64', NULL, 1, '2026-02-06 11:36:07', '2026-02-06 11:36:07'),
(5, 'Late Mark 30 min', 'late_mark', NULL, 30, NULL, '#fdac64', NULL, 1, '2026-02-06 11:36:07', '2026-02-06 11:36:07'),
(6, 'Expected Intime', 'intime', NULL, NULL, '10:00:00', NULL, NULL, 1, '2026-02-06 11:36:07', '2026-02-06 11:36:07'),
(7, 'tester', 'week_off', 1.00, NULL, NULL, '#4CAF50', NULL, 1, '2026-03-05 14:40:55', '2026-03-05 14:40:55');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_policy_user_week_offs`
--

CREATE TABLE `attendance_policy_user_week_offs` (
  `apuwo_id` int(11) NOT NULL,
  `ap_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  `week_offs` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_policy_user_week_offs`
--

INSERT INTO `attendance_policy_user_week_offs` (`apuwo_id`, `ap_id`, `u_id`, `week_offs`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 7, 1, '4', 1, '2026-03-05 09:11:55', '2026-03-05 09:11:55'),
(2, 7, 2, '2', 1, '2026-03-05 09:11:55', '2026-03-05 09:11:55');

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `br_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `location` varchar(300) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `brokers`
--

CREATE TABLE `brokers` (
  `b_id` int(10) UNSIGNED NOT NULL,
  `broker_name` varchar(255) NOT NULL,
  `broker_email` varchar(255) DEFAULT NULL,
  `country_code` varchar(10) DEFAULT '+971',
  `mobile_no` varchar(20) NOT NULL,
  `company` varchar(255) NOT NULL,
  `rera_no` varchar(100) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `address` text NOT NULL,
  `remark` text DEFAULT NULL,
  `document_path` varchar(500) DEFAULT NULL,
  `document_name` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `commission_percentage` decimal(5,2) DEFAULT 0.00,
  `specialization` enum('residential','commercial','both') DEFAULT 'both',
  `profile_photo` varchar(500) DEFAULT NULL,
  `license_expiry_date` date DEFAULT NULL,
  `languages` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`languages`)),
  `experience_years` int(11) DEFAULT 0,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brokers`
--

INSERT INTO `brokers` (`b_id`, `broker_name`, `broker_email`, `country_code`, `mobile_no`, `company`, `rera_no`, `location`, `address`, `remark`, `document_path`, `document_name`, `status`, `commission_percentage`, `specialization`, `profile_photo`, `license_expiry_date`, `languages`, `experience_years`, `created_by`, `updated_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'tester', NULL, '+971', '999999999', 'RABS Net. Solutions', 'M3412412545', NULL, 'tester', NULL, NULL, NULL, 'active', 0.00, 'both', NULL, NULL, '[]', 0, 1, NULL, '2026-02-28 13:51:44', '2026-02-28 13:51:44', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `broker_documents`
--

CREATE TABLE `broker_documents` (
  `bd_id` int(10) UNSIGNED NOT NULL,
  `b_id` int(10) UNSIGNED NOT NULL,
  `document_type` enum('rera_certificate','id_proof','company_license','other') DEFAULT 'other',
  `document_name` varchar(255) DEFAULT NULL,
  `document_path` varchar(500) NOT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `broker_notes`
--

CREATE TABLE `broker_notes` (
  `bn_id` int(11) NOT NULL,
  `b_id` int(11) NOT NULL,
  `note` text NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `broker_notes`
--

INSERT INTO `broker_notes` (`bn_id`, `b_id`, `note`, `created_by`, `created_at`) VALUES
(1, 1, 'hii', 1, '2026-02-28 09:29:15'),
(2, 1, 'hii', 1, '2026-02-28 09:30:56');

-- --------------------------------------------------------

--
-- Table structure for table `crm_settings`
--

CREATE TABLE `crm_settings` (
  `cs_id` int(10) UNSIGNED NOT NULL,
  `client_code` int(10) UNSIGNED NOT NULL,
  `company_name` varchar(200) NOT NULL,
  `company_address` varchar(500) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `timezone` varchar(50) NOT NULL DEFAULT 'Asia/Dubai',
  `logo_url` varchar(500) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `app_version` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leads`
--

CREATE TABLE `leads` (
  `l_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(10) UNSIGNED NOT NULL,
  `source_type` enum('direct','broker','referral','import','api') DEFAULT 'direct',
  `src_id` int(10) UNSIGNED DEFAULT NULL,
  `broker_id` int(10) UNSIGNED DEFAULT NULL,
  `ref_name` varchar(100) DEFAULT NULL,
  `ref_country_code` varchar(5) DEFAULT NULL,
  `ref_mobile` varchar(20) DEFAULT NULL,
  `ref_email` varchar(100) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `country_code` varchar(5) DEFAULT '+91',
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `alt_country_code` varchar(5) DEFAULT NULL,
  `alt_mobile` varchar(20) DEFAULT NULL,
  `alt_email` varchar(100) DEFAULT NULL,
  `identity_type` enum('passport','aadhar','pan','driving_license','other') DEFAULT NULL,
  `identity_number` varchar(50) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `locality` varchar(200) DEFAULT NULL,
  `sub_locality` varchar(100) DEFAULT NULL,
  `buyer_type` varchar(100) DEFAULT NULL,
  `investment_type` varchar(100) DEFAULT NULL,
  `ls_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Current status',
  `lp_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Current priority',
  `has_followup` tinyint(1) DEFAULT 0,
  `followup_dt` datetime DEFAULT NULL,
  `initial_message` text DEFAULT NULL,
  `form_name` varchar(200) DEFAULT NULL,
  `assign_status` enum('unassigned','assigned','reassigned') DEFAULT 'unassigned',
  `is_locked` tinyint(1) DEFAULT 0,
  `is_archived` tinyint(1) DEFAULT 0,
  `notification_sent` tinyint(1) DEFAULT 0,
  `documents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`documents`)),
  `other_details` text DEFAULT NULL,
  `min_budget` decimal(15,2) DEFAULT NULL,
  `max_budget` decimal(15,2) DEFAULT NULL,
  `budget_currency` varchar(10) DEFAULT 'INR',
  `min_area` decimal(10,2) DEFAULT NULL,
  `max_area` decimal(10,2) DEFAULT NULL,
  `area_unit` varchar(20) DEFAULT 'sqft',
  `is_viewed` tinyint(1) DEFAULT 0 COMMENT '0=Fresh/Not viewed, 1=Viewed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leads`
--

INSERT INTO `leads` (`l_id`, `create_dt`, `update_dt`, `created_by`, `source_type`, `src_id`, `broker_id`, `ref_name`, `ref_country_code`, `ref_mobile`, `ref_email`, `name`, `country_code`, `mobile`, `email`, `alt_country_code`, `alt_mobile`, `alt_email`, `identity_type`, `identity_number`, `country`, `state`, `city`, `locality`, `sub_locality`, `buyer_type`, `investment_type`, `ls_id`, `lp_id`, `has_followup`, `followup_dt`, `initial_message`, `form_name`, `assign_status`, `is_locked`, `is_archived`, `notification_sent`, `documents`, `other_details`, `min_budget`, `max_budget`, `budget_currency`, `min_area`, `max_area`, `area_unit`, `is_viewed`) VALUES
(1, '2026-02-09 15:46:44', '2026-02-14 15:22:24', 1, 'direct', 1, NULL, NULL, NULL, NULL, NULL, 'tester', '+91', '9999999999', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, '2026-02-13 11:30:54', NULL, NULL, 'unassigned', 0, 1, 0, NULL, NULL, NULL, NULL, 'INR', NULL, NULL, 'sqft', 1),
(2, '2026-02-09 15:47:33', '2026-02-14 15:22:24', 1, 'direct', 4, NULL, NULL, NULL, NULL, NULL, 'Tester 5676', '+91', '9874561230', NULL, NULL, NULL, NULL, NULL, NULL, 'India', 'Maharashtra', 'Mumbai', 'dadar', NULL, 'Investor', 'Ready to Move', 6, 2, 1, '2026-02-13 12:30:50', NULL, NULL, 'unassigned', 0, 1, 0, NULL, 'gfsgsfg sfg sfgs fgs fgsf sdfg ', NULL, NULL, 'INR', NULL, NULL, 'sqft', 1),
(3, '2026-02-09 16:51:49', '2026-02-12 14:08:23', 1, 'direct', 3, NULL, NULL, NULL, NULL, NULL, 'Himanshu Pandey', '+91', '9874587878', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, NULL, NULL, NULL, 'assigned', 0, 1, 0, NULL, NULL, NULL, NULL, 'INR', NULL, NULL, 'sqft', 0),
(4, '2026-02-12 17:22:27', '2026-03-04 15:06:56', 1, 'direct', 2, NULL, NULL, NULL, NULL, NULL, 'himanshu', '+91', '9887788798', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, '2026-03-04 12:00:00', NULL, NULL, 'assigned', 0, 0, 0, NULL, 'tester ', NULL, NULL, 'INR', NULL, NULL, 'sqft', 1),
(5, '2026-02-13 14:07:22', '2026-02-14 18:01:34', 1, 'direct', 5, NULL, NULL, NULL, NULL, NULL, 'Rehmat Ali', '+91', '9898798798', NULL, '+91', '9876543210', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, 'assigned', 0, 0, 0, NULL, NULL, NULL, NULL, 'INR', NULL, NULL, 'sqft', 1),
(6, '2026-02-24 13:10:46', '2026-02-24 13:11:06', 2, 'direct', 4, NULL, NULL, NULL, NULL, NULL, 'Darshan Tiwari', '+91', '9326535852', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, 'unassigned', 0, 0, 0, NULL, NULL, NULL, NULL, 'INR', NULL, NULL, 'sqft', 1),
(7, '2026-02-24 13:24:46', '2026-03-02 16:03:18', 1, 'direct', 5, NULL, NULL, NULL, NULL, NULL, 'anshika sharama', '+91', '8865412972', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, NULL, NULL, NULL, 'unassigned', 0, 0, 0, NULL, NULL, NULL, NULL, 'INR', NULL, NULL, 'sqft', 1);

-- --------------------------------------------------------

--
-- Table structure for table `lead_activities`
--

CREATE TABLE `lead_activities` (
  `lac_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `l_id` int(10) UNSIGNED NOT NULL,
  `u_id` int(10) UNSIGNED NOT NULL COMMENT 'User who performed this activity',
  `la_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'If user is assigned, link to assignment',
  `activity_type` enum('status_update','followup_set','followup_done','followup_missed','comment','call','whatsapp','email','sms','meeting','site_visit','full_update','system') NOT NULL DEFAULT 'comment',
  `status_changed` tinyint(1) DEFAULT 0,
  `old_status_id` int(10) UNSIGNED DEFAULT NULL,
  `new_status_id` int(10) UNSIGNED DEFAULT NULL,
  `priority_changed` tinyint(1) DEFAULT 0,
  `old_priority_id` int(10) UNSIGNED DEFAULT NULL,
  `new_priority_id` int(10) UNSIGNED DEFAULT NULL,
  `followup_set` tinyint(1) DEFAULT 0,
  `followup_dt` datetime DEFAULT NULL,
  `followup_note` varchar(500) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `call_type` enum('incoming','outgoing','missed') DEFAULT NULL,
  `call_duration` int(10) UNSIGNED DEFAULT NULL COMMENT 'Seconds',
  `call_recording_url` varchar(500) DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '[{"name": "file.pdf", "url": "..."}]' CHECK (json_valid(`attachments`)),
  `source` enum('web','mobile','api','system') DEFAULT 'web'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lead_activities`
--

INSERT INTO `lead_activities` (`lac_id`, `create_dt`, `l_id`, `u_id`, `la_id`, `activity_type`, `status_changed`, `old_status_id`, `new_status_id`, `priority_changed`, `old_priority_id`, `new_priority_id`, `followup_set`, `followup_dt`, `followup_note`, `comment`, `call_type`, `call_duration`, `call_recording_url`, `attachments`, `source`) VALUES
(1, '2026-02-09 15:46:44', 1, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead created', NULL, NULL, NULL, NULL, 'mobile'),
(2, '2026-02-09 15:47:33', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead created', NULL, NULL, NULL, NULL, 'mobile'),
(3, '2026-02-09 16:51:49', 3, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead created', NULL, NULL, NULL, NULL, 'mobile'),
(4, '2026-02-10 14:13:49', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Priority changed to: Warm', NULL, NULL, NULL, NULL, 'mobile'),
(5, '2026-02-10 14:14:09', 3, 1, NULL, 'comment', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'gdhdgh', NULL, NULL, NULL, NULL, 'mobile'),
(6, '2026-02-10 16:03:26', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Not Interested', NULL, NULL, NULL, NULL, 'mobile'),
(7, '2026-02-10 16:03:40', 3, 1, NULL, 'comment', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'tester', NULL, NULL, NULL, NULL, 'mobile'),
(8, '2026-02-10 16:03:49', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead assigned to: Master Admin', NULL, NULL, NULL, NULL, 'mobile'),
(9, '2026-02-10 16:14:51', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: RNR More than 5 Times', NULL, NULL, NULL, NULL, 'mobile'),
(10, '2026-02-10 16:51:37', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Follow Up', NULL, NULL, NULL, NULL, 'mobile'),
(11, '2026-02-10 16:58:37', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Fresh Lead', NULL, NULL, NULL, NULL, 'mobile'),
(12, '2026-02-10 17:24:44', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Attempted', NULL, NULL, NULL, NULL, 'mobile'),
(13, '2026-02-11 12:52:45', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Attempted', NULL, NULL, NULL, NULL, 'mobile'),
(14, '2026-02-11 12:52:50', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Follow Up', NULL, NULL, NULL, NULL, 'mobile'),
(15, '2026-02-11 12:53:01', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Hot', NULL, NULL, NULL, NULL, 'mobile'),
(16, '2026-02-11 12:53:11', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Visit Proposed', NULL, NULL, NULL, NULL, 'mobile'),
(17, '2026-02-11 12:59:20', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Site Visit Done', NULL, NULL, NULL, NULL, 'mobile'),
(18, '2026-02-11 12:59:52', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Follow Up', NULL, NULL, NULL, NULL, 'mobile'),
(19, '2026-02-11 13:00:06', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Hot', NULL, NULL, NULL, NULL, 'mobile'),
(20, '2026-02-11 13:04:51', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Negotiation', NULL, NULL, NULL, NULL, 'mobile'),
(21, '2026-02-11 13:05:44', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Site Visit Done', NULL, NULL, NULL, NULL, 'mobile'),
(22, '2026-02-11 13:05:55', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: not budget', NULL, NULL, NULL, NULL, 'mobile'),
(23, '2026-02-11 13:06:08', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Callback Today', NULL, NULL, NULL, NULL, 'mobile'),
(24, '2026-02-11 13:06:22', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Hot', NULL, NULL, NULL, NULL, 'mobile'),
(25, '2026-02-11 13:25:41', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Dead', NULL, NULL, NULL, NULL, 'mobile'),
(26, '2026-02-11 13:26:19', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Negotiation', NULL, NULL, NULL, NULL, 'mobile'),
(27, '2026-02-11 13:26:34', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Priority changed to: Hot', NULL, NULL, NULL, NULL, 'mobile'),
(28, '2026-02-11 13:26:47', 3, 1, NULL, 'comment', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'tester', NULL, NULL, NULL, NULL, 'mobile'),
(29, '2026-02-12 13:06:21', 3, 1, NULL, 'comment', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'tester', NULL, NULL, NULL, NULL, 'mobile'),
(30, '2026-02-12 13:09:51', 3, 1, NULL, 'comment', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'tester', NULL, NULL, NULL, NULL, 'mobile'),
(31, '2026-02-12 13:10:58', 3, 1, NULL, 'comment', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'tester', NULL, NULL, NULL, NULL, 'mobile'),
(32, '2026-02-12 13:41:55', 3, 1, NULL, 'comment', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'testerefaf', NULL, NULL, NULL, NULL, 'mobile'),
(33, '2026-02-12 14:03:19', 3, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Fresh Lead', NULL, NULL, NULL, NULL, 'mobile'),
(34, '2026-02-12 14:08:23', 3, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead archived', NULL, NULL, NULL, NULL, 'mobile'),
(35, '2026-02-12 14:10:33', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(36, '2026-02-12 14:12:31', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 12 Feb 2026, 02:12 pm', NULL, NULL, NULL, NULL, 'mobile'),
(37, '2026-02-12 14:22:59', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 12 Feb 2026, 03:00 pm', NULL, NULL, NULL, NULL, 'mobile'),
(38, '2026-02-12 14:27:33', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 12 Feb 2026, 03:35 pm', NULL, NULL, NULL, NULL, 'mobile'),
(39, '2026-02-12 14:52:30', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(40, '2026-02-12 15:17:54', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(41, '2026-02-12 15:41:14', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(42, '2026-02-12 15:44:18', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(43, '2026-02-12 15:53:41', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead locked', NULL, NULL, NULL, NULL, 'mobile'),
(44, '2026-02-12 15:53:49', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead unlocked', NULL, NULL, NULL, NULL, 'mobile'),
(45, '2026-02-12 15:54:05', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(46, '2026-02-12 15:55:47', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(47, '2026-02-12 16:03:31', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(48, '2026-02-12 16:08:14', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(49, '2026-02-12 16:09:23', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Follow Up', NULL, NULL, NULL, NULL, 'mobile'),
(50, '2026-02-12 16:14:59', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Status changed to: Hot', NULL, NULL, NULL, NULL, 'mobile'),
(51, '2026-02-12 17:22:27', 4, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead created', NULL, NULL, NULL, NULL, 'mobile'),
(52, '2026-02-13 12:51:09', 4, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 13 Feb 2026, 12:50 pm', NULL, NULL, NULL, NULL, 'mobile'),
(53, '2026-02-13 13:21:08', 1, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 13 Feb 2026, 05:00 pm', NULL, NULL, NULL, NULL, 'mobile'),
(54, '2026-02-13 13:25:02', 2, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 13 Feb 2026, 06:00 pm', NULL, NULL, NULL, NULL, 'mobile'),
(55, '2026-02-13 13:25:31', 4, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 14 Feb 2026, 06:00 pm', NULL, NULL, NULL, NULL, 'mobile'),
(56, '2026-02-13 14:07:22', 5, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead created', NULL, NULL, NULL, NULL, 'mobile'),
(57, '2026-02-13 14:08:50', 5, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 13 Feb 2026, 05:00 pm', NULL, NULL, NULL, NULL, 'mobile'),
(58, '2026-02-13 14:18:20', 5, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 13 Feb 2026, 04:00 pm', NULL, NULL, NULL, NULL, 'mobile'),
(59, '2026-02-13 14:24:16', 5, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up removed', NULL, NULL, NULL, NULL, 'mobile'),
(60, '2026-02-14 15:22:24', 2, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead archived', NULL, NULL, NULL, NULL, 'mobile'),
(61, '2026-02-14 15:22:24', 1, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead archived', NULL, NULL, NULL, NULL, 'mobile'),
(62, '2026-02-14 18:01:34', 5, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead assigned to: shubham.sonkar', NULL, NULL, NULL, NULL, 'mobile'),
(63, '2026-02-14 18:01:34', 4, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead assigned to: shubham.sonkar', NULL, NULL, NULL, NULL, 'mobile'),
(64, '2026-02-14 18:01:46', 4, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead assigned to: shubham.sonkar', NULL, NULL, NULL, NULL, 'mobile'),
(65, '2026-02-24 13:10:46', 6, 2, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead created', NULL, NULL, NULL, NULL, 'mobile'),
(66, '2026-02-24 13:24:46', 7, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead created', NULL, NULL, NULL, NULL, 'mobile'),
(67, '2026-03-02 13:24:32', 4, 1, NULL, 'system', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Lead updated', NULL, NULL, NULL, NULL, 'mobile'),
(68, '2026-03-04 15:06:57', 4, 1, NULL, '', 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'Follow-up scheduled for: 4 Mar 2026, 12:00 pm', NULL, NULL, NULL, NULL, 'mobile');

--
-- Triggers `lead_activities`
--
DELIMITER $$
CREATE TRIGGER `trg_lead_activity_after_insert` AFTER INSERT ON `lead_activities` FOR EACH ROW BEGIN
    -- Update lead's status if changed
    IF NEW.status_changed = 1 AND NEW.new_status_id IS NOT NULL THEN
        UPDATE leads SET 
            ls_id = NEW.new_status_id,
            update_dt = NOW()
        WHERE l_id = NEW.l_id;
    END IF;
    
    -- Update lead's priority if changed
    IF NEW.priority_changed = 1 AND NEW.new_priority_id IS NOT NULL THEN
        UPDATE leads SET 
            lp_id = NEW.new_priority_id,
            update_dt = NOW()
        WHERE l_id = NEW.l_id;
    END IF;
    
    -- Update lead's followup if set
    IF NEW.followup_set = 1 AND NEW.followup_dt IS NOT NULL THEN
        UPDATE leads SET 
            has_followup = 1,
            followup_dt = NEW.followup_dt,
            update_dt = NOW()
        WHERE l_id = NEW.l_id;
        
        -- Also insert into lead_followups table
        INSERT INTO lead_followups (l_id, u_id, la_id, lac_id, followup_dt, followup_note)
        VALUES (NEW.l_id, NEW.u_id, NEW.la_id, NEW.lac_id, NEW.followup_dt, NEW.followup_note);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lead_assignments`
--

CREATE TABLE `lead_assignments` (
  `la_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `l_id` int(10) UNSIGNED NOT NULL,
  `u_id` int(10) UNSIGNED NOT NULL,
  `assigned_by` int(10) UNSIGNED NOT NULL,
  `assignment_type` enum('primary','secondary','viewer') DEFAULT 'primary',
  `assignment_notes` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `unassigned_dt` datetime DEFAULT NULL,
  `unassigned_by` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lead_assignments`
--

INSERT INTO `lead_assignments` (`la_id`, `create_dt`, `update_dt`, `l_id`, `u_id`, `assigned_by`, `assignment_type`, `assignment_notes`, `is_active`, `unassigned_dt`, `unassigned_by`) VALUES
(1, '2026-02-10 16:03:49', '2026-02-10 16:03:49', 3, 1, 1, 'primary', NULL, 1, NULL, NULL),
(2, '2026-02-14 18:01:34', '2026-02-14 18:01:34', 5, 2, 1, 'primary', NULL, 1, NULL, NULL),
(3, '2026-02-14 18:01:34', '2026-02-14 18:01:46', 4, 2, 1, 'primary', NULL, 0, NULL, NULL),
(4, '2026-02-14 18:01:46', '2026-02-14 18:01:46', 4, 2, 1, 'primary', NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lead_followups`
--

CREATE TABLE `lead_followups` (
  `lf_id` int(11) NOT NULL,
  `l_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  `followup_dt` datetime NOT NULL,
  `note` text DEFAULT NULL,
  `status` enum('pending','completed','cancelled') DEFAULT 'pending',
  `is_active` tinyint(1) DEFAULT 1,
  `reminder_sent` tinyint(1) NOT NULL DEFAULT 0,
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lead_followups`
--

INSERT INTO `lead_followups` (`lf_id`, `l_id`, `u_id`, `followup_dt`, `note`, `status`, `is_active`, `reminder_sent`, `create_dt`) VALUES
(1, 2, 1, '2026-02-12 08:42:25', NULL, 'pending', 0, 0, '2026-02-12 08:42:31'),
(2, 2, 1, '2026-02-12 09:30:33', NULL, 'pending', 0, 0, '2026-02-12 08:52:59'),
(3, 2, 1, '2026-02-12 10:05:16', NULL, 'pending', 0, 0, '2026-02-12 08:57:33'),
(4, 4, 1, '2026-02-13 07:20:54', NULL, 'pending', 0, 0, '2026-02-13 07:21:09'),
(5, 1, 1, '2026-02-13 11:30:54', NULL, 'pending', 1, 0, '2026-02-13 07:51:08'),
(6, 2, 1, '2026-02-13 12:30:50', NULL, 'pending', 1, 0, '2026-02-13 07:55:02'),
(7, 4, 1, '2026-02-14 12:30:20', NULL, 'pending', 0, 0, '2026-02-13 07:55:31'),
(8, 5, 1, '2026-02-13 11:30:18', NULL, 'cancelled', 0, 0, '2026-02-13 08:38:50'),
(9, 5, 1, '2026-02-13 16:00:00', NULL, 'cancelled', 0, 0, '2026-02-13 08:48:20'),
(10, 4, 1, '2026-03-04 12:00:00', NULL, 'pending', 1, 0, '2026-03-04 09:36:56');

-- --------------------------------------------------------

--
-- Table structure for table `lead_priorities`
--

CREATE TABLE `lead_priorities` (
  `lp_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(100) NOT NULL,
  `color` varchar(20) DEFAULT '#808080',
  `display_order` smallint(5) UNSIGNED DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lead_priorities`
--

INSERT INTO `lead_priorities` (`lp_id`, `create_dt`, `update_dt`, `name`, `color`, `display_order`, `is_active`) VALUES
(1, '2026-02-06 14:17:10', '2026-03-04 12:16:59', 'Hot', '#F44336', 1, 1),
(2, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Warm', '#FF9800', 2, 1),
(3, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Cold', '#2196F3', 3, 1),
(4, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Follow Up', '#9C27B0', 4, 1),
(5, '2026-03-04 11:54:31', '2026-03-04 11:54:38', 'tester', '#808080', 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `lead_requirements`
--

CREATE TABLE `lead_requirements` (
  `lr_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `l_id` int(10) UNSIGNED NOT NULL COMMENT 'FK to leads',
  `st_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to service_types (Buy/Rent/etc)',
  `project_name` varchar(200) DEFAULT NULL,
  `pt_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to property_types',
  `pc_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to property_configurations',
  `preferred_country` varchar(100) DEFAULT NULL,
  `preferred_state` varchar(100) DEFAULT NULL,
  `preferred_city` varchar(100) DEFAULT NULL,
  `preferred_locality` varchar(200) DEFAULT NULL,
  `preferred_sub_locality` varchar(100) DEFAULT NULL,
  `min_area` decimal(10,2) DEFAULT NULL,
  `max_area` decimal(10,2) DEFAULT NULL,
  `area_unit` enum('sqft','sqm','sqyd','acre','hectare') DEFAULT 'sqft',
  `min_budget` decimal(15,2) DEFAULT NULL,
  `max_budget` decimal(15,2) DEFAULT NULL,
  `budget_currency` char(3) DEFAULT 'INR',
  `handover_preference` varchar(100) DEFAULT NULL COMMENT 'Ready, 1 Year, 2 Years, etc.',
  `post_handover_plan` tinyint(1) DEFAULT 0,
  `other_details` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `project_id` int(11) DEFAULT NULL,
  `pc_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`pc_ids`)),
  `project_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`project_ids`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lead_requirements`
--

INSERT INTO `lead_requirements` (`lr_id`, `create_dt`, `update_dt`, `l_id`, `st_id`, `project_name`, `pt_id`, `pc_id`, `preferred_country`, `preferred_state`, `preferred_city`, `preferred_locality`, `preferred_sub_locality`, `min_area`, `max_area`, `area_unit`, `min_budget`, `max_budget`, `budget_currency`, `handover_preference`, `post_handover_plan`, `other_details`, `is_active`, `project_id`, `pc_ids`, `project_ids`) VALUES
(1, '2026-02-09 15:46:44', '2026-02-09 15:46:44', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sqft', NULL, NULL, 'INR', NULL, 0, NULL, 1, NULL, NULL, NULL),
(2, '2026-02-09 15:47:33', '2026-02-12 16:08:14', 2, 1, NULL, 1, NULL, 'India', 'Maharashtra', 'Mumbai', 'dadar', NULL, 300.00, 400.00, 'sqft', NULL, NULL, 'INR', NULL, 0, NULL, 1, NULL, '[1,2,5,6,7,4,3]', '[1,2,5]'),
(3, '2026-02-09 16:51:49', '2026-02-09 16:51:49', 3, NULL, 'Lodha woods', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sqft', NULL, NULL, 'INR', NULL, 0, NULL, 1, NULL, NULL, NULL),
(4, '2026-02-12 17:22:27', '2026-02-12 17:22:27', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sqft', NULL, NULL, 'INR', NULL, 0, NULL, 1, NULL, NULL, NULL),
(5, '2026-02-13 14:07:22', '2026-02-13 14:07:22', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sqft', NULL, NULL, 'INR', NULL, 0, NULL, 1, NULL, NULL, NULL),
(6, '2026-02-24 13:10:46', '2026-02-24 13:10:46', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sqft', NULL, NULL, 'INR', NULL, 0, NULL, 1, NULL, NULL, NULL),
(7, '2026-02-24 13:24:46', '2026-02-24 13:24:46', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sqft', NULL, NULL, 'INR', NULL, 0, NULL, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lead_sources`
--

CREATE TABLE `lead_sources` (
  `src_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(100) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `color` varchar(20) DEFAULT '#808080',
  `display_order` smallint(5) UNSIGNED DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lead_sources`
--

INSERT INTO `lead_sources` (`src_id`, `create_dt`, `update_dt`, `name`, `icon`, `color`, `display_order`, `is_active`) VALUES
(1, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Direct', 'user', '#4CAF50', 1, 1),
(2, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Facebook', 'facebook', '#1877F2', 2, 1),
(3, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Instagram', 'instagram', '#E4405F', 3, 1),
(4, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Google Ads', 'globe', '#4285F4', 4, 1),
(5, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '99acres', 'building', '#FF6B35', 5, 1),
(6, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Housing.com', 'home', '#00B98D', 6, 1),
(7, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'MagicBricks', 'building-2', '#E91E63', 7, 1),
(8, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Website', 'globe', '#2196F3', 8, 1),
(9, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Referral', 'users', '#9C27B0', 9, 1),
(10, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Walk-in', 'map-pin', '#FF9800', 10, 1),
(11, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Other', 'more-horizontal', '#607D8B', 99, 1);

-- --------------------------------------------------------

--
-- Table structure for table `lead_statuses`
--

CREATE TABLE `lead_statuses` (
  `ls_id` int(10) UNSIGNED NOT NULL COMMENT 'Primary key with table prefix',
  `name` varchar(100) NOT NULL COMMENT 'Status name: Fresh Lead, Hot, Dead, etc.',
  `color` varchar(20) NOT NULL DEFAULT '#808080' COMMENT 'Hex color code for UI',
  `is_positive` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = positive outcome (Hot, Booking Done)',
  `is_negative` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = negative outcome (Dead, Junk)',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = default status for new leads',
  `is_system` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = cannot be deleted (core statuses)',
  `include_in_all` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = include in All Leads list',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Sort order in UI',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0 = hidden from dropdown',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lead_statuses`
--

INSERT INTO `lead_statuses` (`ls_id`, `name`, `color`, `is_positive`, `is_negative`, `is_default`, `is_system`, `include_in_all`, `display_order`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Fresh Lead', '#fdac64', 0, 0, 1, 1, 1, 1, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(2, 'Attempted', '#43516c', 0, 0, 0, 1, 1, 2, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(3, 'Callback Today', '#0000CD', 0, 0, 0, 1, 1, 3, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(4, 'Follow Up', '#09daff', 0, 0, 0, 1, 1, 4, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(5, 'RNR More than 5 Times', '#FFFF00', 0, 0, 0, 0, 1, 5, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(6, 'Hot', '#fa4e64', 1, 0, 0, 1, 1, 6, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(7, 'Visit Proposed', '#800080', 1, 0, 0, 1, 1, 7, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(8, 'Site Visit Done', '#4CAF50', 1, 0, 0, 0, 1, 8, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(9, 'Negotiation', '#FF9800', 1, 0, 0, 0, 1, 9, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(10, 'Booking Done', '#3d7a44', 1, 0, 0, 1, 1, 10, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(11, 'VDNB', '#ab408b', 0, 0, 0, 1, 1, 11, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(12, 'Loan Case', '#006398', 0, 0, 0, 0, 1, 12, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(13, 'Junk', '#333333', 0, 1, 0, 1, 1, 13, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(14, 'Dead', '#ab4040', 0, 1, 0, 1, 1, 14, 1, '2026-02-06 11:36:27', '2026-02-06 11:36:27'),
(21, 'tester', '#FFA500', 0, 0, 0, 0, 1, 15, 1, '2026-02-06 12:22:31', '2026-02-06 12:22:31'),
(22, 'Not Interested', '#F44336', 0, 0, 0, 0, 1, 16, 1, '2026-02-06 12:29:00', '2026-02-06 12:29:00'),
(23, 'not budget', '#2196F3', 0, 0, 0, 0, 1, 17, 1, '2026-02-06 12:35:53', '2026-02-06 12:35:53'),
(24, 'no stock', '#1A237E', 0, 0, 0, 0, 1, 18, 1, '2026-02-06 12:41:42', '2026-02-06 12:41:42'),
(25, 'etywet ydshdgh', '#000000', 0, 0, 0, 0, 1, 19, 1, '2026-02-06 12:41:58', '2026-02-06 12:41:58'),
(26, 'Twartarthgh', '#CD853F', 0, 0, 0, 0, 1, 20, 1, '2026-02-06 12:49:25', '2026-02-06 12:49:25');

-- --------------------------------------------------------

--
-- Table structure for table `login_history`
--

CREATE TABLE `login_history` (
  `lh_id` int(10) UNSIGNED NOT NULL,
  `u_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to users (NULL if user not found)',
  `username_input` varchar(100) NOT NULL,
  `status` enum('success','wrong_password','user_not_found','account_locked','account_disabled') NOT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `device_platform` enum('android','ios','web') DEFAULT NULL,
  `login_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `login_history`
--

INSERT INTO `login_history` (`lh_id`, `u_id`, `username_input`, `status`, `ip_address`, `user_agent`, `device_platform`, `login_at`) VALUES
(1, NULL, 'tester', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:06:38'),
(2, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:06:48'),
(3, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:06:57'),
(4, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:07:09'),
(5, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:08:33'),
(6, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:08:34'),
(7, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:08:38'),
(8, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:08:39'),
(9, NULL, 'master', 'user_not_found', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:08:39'),
(10, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-09 15:16:48'),
(11, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-10 15:44:32'),
(12, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-11 12:52:32'),
(13, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-12 13:03:36'),
(14, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-13 13:04:36'),
(15, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-14 13:01:28'),
(16, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-16 11:32:21'),
(17, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-17 12:25:59'),
(18, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-23 15:24:32'),
(19, 2, 'shubham.sonkar', 'wrong_password', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-23 15:35:45'),
(20, 2, 'shubham.sonkar', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-23 15:35:49'),
(21, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-23 15:42:22'),
(22, 2, 'shubham.sonkar', 'wrong_password', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-23 15:43:46'),
(23, 2, 'shubham.sonkar', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-23 15:43:49'),
(24, 2, 'shubham.sonkar', 'wrong_password', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-24 13:14:13'),
(25, 2, 'shubham.sonkar', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-24 13:14:16'),
(26, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-24 13:24:03'),
(27, 2, 'shubham.sonkar', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-24 13:25:13'),
(28, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-24 13:32:32'),
(29, 1, 'master', 'success', '::ffff:192.168.1.51', 'okhttp/4.9.2', 'android', '2026-02-27 16:53:34'),
(30, 1, 'master', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-02 13:08:59'),
(31, 2, 'shubham.sonkar', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-02 13:09:54'),
(32, 1, 'master', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-02 13:10:25'),
(33, 1, 'master', 'wrong_password', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-02 14:24:38'),
(34, 1, 'master', 'wrong_password', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-02 14:24:48'),
(35, 1, 'master', 'wrong_password', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-02 14:35:22'),
(36, 1, 'master', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-02 14:35:29'),
(37, 1, 'master', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-04 10:45:01'),
(38, 1, 'master', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-04 14:52:04'),
(39, 1, 'master', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-04 14:54:33'),
(40, 1, 'master', 'success', '::ffff:192.168.1.48', 'okhttp/4.9.2', 'android', '2026-03-04 15:26:00');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `p_id` int(10) UNSIGNED NOT NULL,
  `module` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `code` varchar(100) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `display_order` int(11) DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`p_id`, `module`, `action`, `code`, `description`, `display_order`, `created_at`) VALUES
(1, 'leads', 'view', 'leads.view', 'View leads list', 1, '2026-02-06 11:36:06'),
(2, 'leads', 'add', 'leads.add', 'Add new leads', 2, '2026-02-06 11:36:06'),
(3, 'leads', 'edit', 'leads.edit', 'Edit lead details', 3, '2026-02-06 11:36:06'),
(4, 'leads', 'quick_edit', 'leads.quick_edit', 'Quick edit status/followup', 4, '2026-02-06 11:36:06'),
(5, 'leads', 'delete', 'leads.delete', 'Delete leads', 5, '2026-02-06 11:36:06'),
(6, 'leads', 'assign', 'leads.assign', 'Assign leads to users', 6, '2026-02-06 11:36:06'),
(7, 'leads', 'import', 'leads.import', 'Import from Excel/CSV', 7, '2026-02-06 11:36:06'),
(8, 'leads', 'export', 'leads.export', 'Export to Excel', 8, '2026-02-06 11:36:06'),
(9, 'leads', 'call', 'leads.call', 'Make calls to leads', 9, '2026-02-06 11:36:06'),
(10, 'leads', 'whatsapp', 'leads.whatsapp', 'WhatsApp to leads', 10, '2026-02-06 11:36:06'),
(11, 'leads', 'email', 'leads.email', 'Email to leads', 11, '2026-02-06 11:36:06'),
(12, 'followup', 'view', 'followup.view', 'View followup dashboard', 1, '2026-02-06 11:36:06'),
(13, 'status', 'view', 'status.view', 'View status dashboard', 1, '2026-02-06 11:36:06'),
(14, 'users', 'view', 'users.view', 'View users list', 1, '2026-02-06 11:36:06'),
(15, 'users', 'add', 'users.add', 'Add new users', 2, '2026-02-06 11:36:06'),
(16, 'users', 'edit', 'users.edit', 'Edit user details', 3, '2026-02-06 11:36:06'),
(17, 'users', 'view_crm', 'users.view_crm', 'View CRM as another user', 4, '2026-02-06 11:36:06'),
(18, 'users', 'view_location', 'users.view_location', 'View user GPS locations', 5, '2026-02-06 11:36:06'),
(19, 'users', 'view_statistics', 'users.view_statistics', 'View user statistics', 6, '2026-02-06 11:36:06'),
(20, 'dynamic_fields', 'view', 'dynamic_fields.view', 'View dynamic fields', 1, '2026-02-06 11:36:06'),
(21, 'dynamic_fields', 'add', 'dynamic_fields.add', 'Add dynamic fields', 2, '2026-02-06 11:36:06'),
(22, 'dynamic_fields', 'edit', 'dynamic_fields.edit', 'Edit dynamic fields', 3, '2026-02-06 11:36:06'),
(23, 'dynamic_fields', 'delete', 'dynamic_fields.delete', 'Delete dynamic fields', 4, '2026-02-06 11:36:06'),
(24, 'brokers', 'view', 'brokers.view', 'View brokers', 1, '2026-02-06 11:36:06'),
(25, 'brokers', 'add', 'brokers.add', 'Add brokers', 2, '2026-02-06 11:36:06'),
(26, 'brokers', 'edit', 'brokers.edit', 'Edit brokers', 3, '2026-02-06 11:36:06'),
(27, 'brokers', 'delete', 'brokers.delete', 'Delete brokers', 4, '2026-02-06 11:36:06'),
(28, 'brokers', 'assign', 'brokers.assign', 'Assign brokers', 5, '2026-02-06 11:36:06'),
(29, 'brokers', 'import', 'brokers.import', 'Import brokers', 6, '2026-02-06 11:36:06'),
(30, 'brokers', 'export', 'brokers.export', 'Export brokers', 7, '2026-02-06 11:36:06'),
(31, 'brokers', 'call', 'brokers.call', 'Call brokers', 8, '2026-02-06 11:36:06'),
(32, 'brokers', 'whatsapp', 'brokers.whatsapp', 'WhatsApp brokers', 9, '2026-02-06 11:36:06'),
(33, 'loans', 'view', 'loans.view', 'View loans', 1, '2026-02-06 11:36:06'),
(34, 'loans', 'add', 'loans.add', 'Add loans', 2, '2026-02-06 11:36:06'),
(35, 'loans', 'edit', 'loans.edit', 'Edit loans', 3, '2026-02-06 11:36:06'),
(36, 'loans', 'delete', 'loans.delete', 'Delete loans', 4, '2026-02-06 11:36:06'),
(37, 'loans', 'assign', 'loans.assign', 'Assign loans', 5, '2026-02-06 11:36:06'),
(38, 'loans', 'import', 'loans.import', 'Import loans', 6, '2026-02-06 11:36:06'),
(39, 'loans', 'export', 'loans.export', 'Export loans', 7, '2026-02-06 11:36:06'),
(40, 'loans', 'call', 'loans.call', 'Call loan clients', 8, '2026-02-06 11:36:06'),
(41, 'loans', 'whatsapp', 'loans.whatsapp', 'WhatsApp loan clients', 9, '2026-02-06 11:36:06'),
(42, 'hr', 'view', 'hr.view', 'View candidates', 1, '2026-02-06 11:36:06'),
(43, 'hr', 'add', 'hr.add', 'Add candidates', 2, '2026-02-06 11:36:06'),
(44, 'hr', 'edit', 'hr.edit', 'Edit candidates', 3, '2026-02-06 11:36:06'),
(45, 'hr', 'quick_edit', 'hr.quick_edit', 'Quick edit candidates', 4, '2026-02-06 11:36:06'),
(46, 'hr', 'delete', 'hr.delete', 'Delete candidates', 5, '2026-02-06 11:36:06'),
(47, 'hr', 'assign', 'hr.assign', 'Assign candidates', 6, '2026-02-06 11:36:06'),
(48, 'hr', 'import', 'hr.import', 'Import candidates', 7, '2026-02-06 11:36:06'),
(49, 'hr', 'export', 'hr.export', 'Export candidates', 8, '2026-02-06 11:36:06'),
(50, 'hr', 'call', 'hr.call', 'Call candidates', 9, '2026-02-06 11:36:06'),
(51, 'hr', 'whatsapp', 'hr.whatsapp', 'WhatsApp candidates', 10, '2026-02-06 11:36:06'),
(52, 'hr', 'email', 'hr.email', 'Email candidates', 11, '2026-02-06 11:36:06'),
(53, 'settings', 'change_password', 'settings.change_password', 'Change any user password', 1, '2026-02-06 11:36:06');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `developer` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`project_id`, `name`, `developer`, `location`, `is_active`, `create_dt`) VALUES
(1, 'ABC Towers', 'ABC Developers', 'Mumbai', 1, '2026-02-12 10:22:45'),
(2, 'Green Valley', 'XYZ Builders', 'Pune', 1, '2026-02-12 10:22:45'),
(3, 'Sky Heights', 'PQR Constructions', 'Delhi', 1, '2026-02-12 10:22:45'),
(4, 'Palm Residency', 'LMN Group', 'Bangalore', 1, '2026-02-12 10:22:45'),
(5, 'Ocean View', 'DEF Realty', 'Chennai', 1, '2026-02-12 10:22:45');

-- --------------------------------------------------------

--
-- Table structure for table `property_configurations`
--

CREATE TABLE `property_configurations` (
  `pc_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(100) NOT NULL,
  `display_order` smallint(5) UNSIGNED DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `property_configurations`
--

INSERT INTO `property_configurations` (`pc_id`, `create_dt`, `update_dt`, `name`, `display_order`, `is_active`) VALUES
(1, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Studio', 1, 1),
(2, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '1 BHK', 2, 1),
(3, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '1.5 BHK', 3, 1),
(4, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '2 BHK', 4, 1),
(5, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '2.5 BHK', 5, 1),
(6, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '3 BHK', 6, 1),
(7, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '3.5 BHK', 7, 1),
(8, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '4 BHK', 8, 1),
(9, '2026-02-06 14:17:10', '2026-02-06 14:17:10', '4+ BHK', 9, 1),
(10, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Duplex', 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `property_types`
--

CREATE TABLE `property_types` (
  `pt_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(100) NOT NULL,
  `display_order` smallint(5) UNSIGNED DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `property_types`
--

INSERT INTO `property_types` (`pt_id`, `create_dt`, `update_dt`, `name`, `display_order`, `is_active`) VALUES
(1, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Apartment', 1, 1),
(2, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Villa', 2, 1),
(3, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Townhouse', 3, 1),
(4, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Penthouse', 4, 1),
(5, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Studio', 5, 1),
(6, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Plot', 6, 1),
(7, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Commercial Office', 7, 1),
(8, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Commercial Shop', 8, 1),
(9, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Warehouse', 9, 1);

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `rt_id` int(10) UNSIGNED NOT NULL,
  `u_id` int(10) UNSIGNED NOT NULL COMMENT 'FK to users',
  `token_hash` varchar(500) NOT NULL,
  `device_name` varchar(200) DEFAULT NULL,
  `device_platform` enum('android','ios','web') DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `is_revoked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`rt_id`, `u_id`, `token_hash`, `device_name`, `device_platform`, `ip_address`, `expires_at`, `is_revoked`, `created_at`) VALUES
(1, 1, '1d33f5f006875829d540f8a88ab77ef5a2230326ae7efc913b7ba161efeb25c0', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-11 09:46:48', 0, '2026-02-09 15:16:48'),
(2, 1, '44527defad2f14deb44b1ce35881da0a25473bb03fd68b082184a27febcdba56', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-12 10:14:32', 0, '2026-02-10 15:44:32'),
(3, 1, '63e08a9151c707ba6d28b9315e8c692cc2e3385d34468a82f5de238ec6837fff', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-13 07:22:32', 0, '2026-02-11 12:52:32'),
(4, 1, '6643d31b7491de8443e4f6d72fd22f4a5f63323d530810fa61dd208826311aba', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-14 07:33:36', 0, '2026-02-12 13:03:36'),
(5, 1, 'f15fa427c5eaae8751aff0d64ee9e9bd58c9b8b8c7a54e12d79c63f01c729e33', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-15 07:34:36', 0, '2026-02-13 13:04:36'),
(6, 1, 'e77dcfd8e489e68b56bc7705b63c1f1532f7f76223ee7865f0b6e0f892c8f42f', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-16 07:31:28', 0, '2026-02-14 13:01:28'),
(7, 1, 'd94eafc6a4892df1860ae94c951b558b24e9fa19f4bb0230ed343e2f47571372', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-18 06:02:21', 0, '2026-02-16 11:32:21'),
(8, 1, 'eb5ca4d533b5cdf15d94d223fec949526ee902eef4681e625edd6ec644641956', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-19 06:55:59', 0, '2026-02-17 12:25:59'),
(9, 1, 'c9d9d2b41c7a0370b50d98b69fe37e2839984b03bcf4f4d69316d930f67ac25c', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-25 09:54:32', 1, '2026-02-23 15:24:32'),
(10, 2, '9edaed4d0692c10c5aa3469836ac4c0cd3a67e4f84bbf22c3f3ed5c49c5c2c53', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-25 10:05:49', 1, '2026-02-23 15:35:49'),
(11, 1, '9863e8969a0951abfe4c320f74d42b40e34c3d65f8ae6af3cd56283ba84620ac', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-25 10:12:22', 1, '2026-02-23 15:42:22'),
(12, 2, '4f9ce66edb8cfdbacfc9f2737726a449848a80a66268109ff2fa2018676afb17', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-25 10:13:49', 1, '2026-02-23 15:43:49'),
(13, 2, '24dca3f2af34c33d900ee103eaf5c01fca575abaee7284f32329fe7a72d43467', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-26 07:44:16', 1, '2026-02-24 13:14:16'),
(14, 1, '034a80eb54400f63045df94b84004ccd62663758b28cb698c94e9d9a0148798f', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-26 07:54:03', 1, '2026-02-24 13:24:03'),
(15, 2, 'c93dc2d13c4d60dd679be70786dca4703a785667af85532caa4c30ce8ee4e880', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-26 07:55:13', 1, '2026-02-24 13:25:13'),
(16, 1, '17bd22c612180b5561c6ea5edcdcb8c53b8dfacfe145bd0d2321c7ca8b33492c', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-26 08:02:32', 0, '2026-02-24 13:32:32'),
(17, 1, '5170c062422a35d1bdc3a771cf41af140dafafee080198a22a06d6f3bbe59d81', 'android - RABS Connect', 'android', '::ffff:192.168.1.51', '2026-03-29 11:23:34', 0, '2026-02-27 16:53:34'),
(18, 1, '2367171fa387da424a068873bb571ab636edf96156533c0cfc01cc90c555148c', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-01 07:38:59', 1, '2026-03-02 13:08:59'),
(19, 2, '294f4ab69cffe70e3c2cd277c4f6c810dc6965e87044f4968d9777145cf8b933', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-01 07:39:54', 1, '2026-03-02 13:09:54'),
(20, 1, 'bb8b4069737a6699dfc433badf3cc0134de21084712fed848a9467058a897642', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-01 07:40:25', 1, '2026-03-02 13:10:25'),
(21, 1, 'cc1b028b15c92ceeb587170509d347e98ee0cb56b018d56a072f03eecea03344', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-01 09:05:29', 0, '2026-03-02 14:35:29'),
(22, 1, 'b4d9c41bb468545d61aa0a59a8d4d827fcbfda0989c7c7e00469c0a9f0f5ae6c', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-03 05:15:01', 0, '2026-03-04 10:45:01'),
(23, 1, '4109d7c6aa8bf13de210de0a855d26614b347a4b679d63f34be3dbaef5783dd0', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-03 09:22:04', 1, '2026-03-04 14:52:04'),
(24, 1, '48cf0950e96a1d586df9fc8b5360ae21710fa9cdf11b153ba7862385c9e060f2', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-03 09:24:33', 1, '2026-03-04 14:54:33'),
(25, 1, '591b7bea3fb03805728adf99c017a86293c36376646027ef2244e9e1377569b8', 'android - RABS Connect', 'android', '::ffff:192.168.1.48', '2026-04-03 09:56:00', 0, '2026-03-04 15:26:00');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `r_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `level` tinyint(3) UNSIGNED NOT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`r_id`, `name`, `slug`, `description`, `level`, `is_system`, `is_active`, `created_at`) VALUES
(1, 'Master', 'master', 'Super admin - full access', 1, 1, 1, '2026-02-06 11:36:06'),
(2, 'Admin', 'admin', 'Company admin - manages all', 2, 1, 1, '2026-02-06 11:36:06'),
(3, 'Branch Admin', 'branch_admin', 'Branch-level admin', 3, 0, 1, '2026-02-06 11:36:06'),
(4, 'Team Leader', 'team_leader', 'Leads a team of SMs and TCs', 4, 0, 1, '2026-02-06 11:36:06'),
(5, 'Sales Manager', 'sales_manager', 'Manages sales pipeline', 5, 0, 1, '2026-02-06 11:36:06'),
(6, 'Tele Caller', 'tele_caller', 'Calls and lead qualification', 6, 0, 1, '2026-02-06 11:36:06'),
(7, 'HR Head', 'hr_head', 'Head of HR department', 4, 0, 1, '2026-02-06 11:36:06'),
(8, 'HR', 'hr', 'HR executive - recruitment', 5, 0, 1, '2026-02-06 11:36:06');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `r_id` int(10) UNSIGNED NOT NULL,
  `p_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`r_id`, `p_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 34),
(1, 35),
(1, 36),
(1, 37),
(1, 38),
(1, 39),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(1, 44),
(1, 45),
(1, 46),
(1, 47),
(1, 48),
(1, 49),
(1, 50),
(1, 51),
(1, 52),
(1, 53),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(2, 20),
(2, 21),
(2, 22),
(2, 23),
(2, 24),
(2, 25),
(2, 26),
(2, 27),
(2, 28),
(2, 29),
(2, 30),
(2, 31),
(2, 32),
(2, 33),
(2, 34),
(2, 35),
(2, 36),
(2, 37),
(2, 38),
(2, 39),
(2, 40),
(2, 41),
(2, 42),
(2, 43),
(2, 44),
(2, 45),
(2, 46),
(2, 47),
(2, 48),
(2, 49),
(2, 50),
(2, 51),
(2, 52),
(2, 53),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 6),
(4, 7),
(4, 9),
(4, 10),
(4, 11),
(4, 12),
(4, 13),
(4, 14),
(4, 15),
(4, 16),
(4, 17),
(4, 18),
(4, 19),
(4, 20),
(4, 21),
(4, 22),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 6),
(5, 9),
(5, 10),
(5, 11),
(5, 12),
(5, 13),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(6, 6),
(6, 9),
(6, 10),
(6, 11),
(6, 12),
(6, 13),
(7, 14),
(7, 42),
(7, 43),
(7, 44),
(7, 45),
(7, 46),
(7, 47),
(7, 48),
(7, 49),
(7, 50),
(7, 51),
(7, 52),
(8, 42),
(8, 43),
(8, 44),
(8, 45),
(8, 50),
(8, 51),
(8, 52);

-- --------------------------------------------------------

--
-- Table structure for table `service_types`
--

CREATE TABLE `service_types` (
  `st_id` int(10) UNSIGNED NOT NULL,
  `create_dt` datetime DEFAULT current_timestamp(),
  `update_dt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(100) NOT NULL,
  `display_order` smallint(5) UNSIGNED DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `service_types`
--

INSERT INTO `service_types` (`st_id`, `create_dt`, `update_dt`, `name`, `display_order`, `is_active`) VALUES
(1, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Buy', 1, 1),
(2, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Rent', 2, 1),
(3, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Resale', 3, 1),
(4, '2026-02-06 14:17:10', '2026-02-06 14:17:10', 'Lease', 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `u_id` int(10) UNSIGNED NOT NULL,
  `br_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to branches',
  `r_id` int(10) UNSIGNED NOT NULL COMMENT 'FK to roles',
  `reports_to` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to users (self-reference)',
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(500) NOT NULL,
  `email` varchar(300) DEFAULT NULL,
  `device_token` text DEFAULT NULL,
  `device_platform` enum('android','ios','web') DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_online` tinyint(1) NOT NULL DEFAULT 0,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip` varchar(50) DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `failed_login_attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to users',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_type` enum('admin','employee') DEFAULT 'employee',
  `team_leader_id` int(11) DEFAULT NULL,
  `sales_manager_id` int(11) DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`u_id`, `br_id`, `r_id`, `reports_to`, `username`, `password_hash`, `email`, `device_token`, `device_platform`, `is_active`, `is_online`, `last_login_at`, `last_login_ip`, `password_changed_at`, `failed_login_attempts`, `locked_until`, `created_by`, `created_at`, `updated_at`, `user_type`, `team_leader_id`, `sales_manager_id`, `permissions`) VALUES
(1, NULL, 1, NULL, 'master', '$2a$10$ayapO2UZoV5Aadb8plXdcOeloYMqsw6/VpVS9DYbatoab7yzmNjuu', 'master@rabsconnect.com', 'enKdC7d1RSmELolWlR3ZPF:APA91bG588BAVUUMcH22nnAogKhwN6spWuj4FP9Vwy3f8WtMyX7EZeJ4EvWd_6IvSqy8iF2Trtvl7RFALnhfz_WEOyeYJcnJPGu4QO1KNze1_dmoEC_CiRk', 'android', 1, 1, '2026-03-04 15:26:00', '::ffff:192.168.1.48', NULL, 0, NULL, NULL, '2026-02-09 15:16:44', '2026-03-04 15:26:00', 'employee', NULL, NULL, NULL),
(2, NULL, 6, NULL, 'shubham.sonkar', '$2a$10$E3KrdoUNdZ.jMIW2gRP.zOzqoKRPItflFAmdWpH9.Ht3DvLbmJiHC', NULL, NULL, NULL, 1, 0, '2026-03-02 13:09:54', '::ffff:192.168.1.48', NULL, 0, NULL, 1, '2026-02-13 16:45:15', '2026-03-02 13:10:16', 'employee', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_column_prefs`
--

CREATE TABLE `user_column_prefs` (
  `ucp_id` int(10) UNSIGNED NOT NULL,
  `u_id` int(10) UNSIGNED NOT NULL COMMENT 'FK to users',
  `module` varchar(50) NOT NULL,
  `visible_columns` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`visible_columns`)),
  `hidden_columns` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`hidden_columns`)),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_locations`
--

CREATE TABLE `user_locations` (
  `ul_id` int(10) UNSIGNED NOT NULL,
  `u_id` int(10) UNSIGNED NOT NULL COMMENT 'FK to users',
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `accuracy` decimal(8,2) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `battery_level` int(11) DEFAULT NULL,
  `tracked_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_locations`
--

INSERT INTO `user_locations` (`ul_id`, `u_id`, `latitude`, `longitude`, `accuracy`, `address`, `battery_level`, `tracked_at`) VALUES
(1, 1, 37.42199830, -122.08400000, 5.00, NULL, NULL, '2026-03-05 12:14:28'),
(2, 1, 37.42199830, -122.08400000, 5.00, NULL, NULL, '2026-03-05 12:17:29'),
(3, 1, 37.42199830, -122.08400000, 5.00, NULL, NULL, '2026-03-05 12:20:29'),
(4, 1, 37.42199830, -122.08400000, 5.00, NULL, NULL, '2026-03-05 12:23:29'),
(5, 1, 37.42199830, -122.08400000, 5.00, NULL, NULL, '2026-03-05 12:26:28');

-- --------------------------------------------------------

--
-- Table structure for table `user_permissions`
--

CREATE TABLE `user_permissions` (
  `u_id` int(10) UNSIGNED NOT NULL,
  `p_id` int(10) UNSIGNED NOT NULL,
  `granted` tinyint(1) NOT NULL DEFAULT 1,
  `granted_by` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to users',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `up_id` int(10) UNSIGNED NOT NULL,
  `u_id` int(10) UNSIGNED NOT NULL COMMENT 'FK to users',
  `first_name` varchar(150) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(150) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `personal_email` varchar(200) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `marital_status` enum('Single','Married','Divorced','Widowed','Other') DEFAULT NULL,
  `religion` varchar(50) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `join_date` date DEFAULT NULL,
  `location` varchar(300) DEFAULT NULL,
  `aadhar_no` char(12) DEFAULT NULL,
  `pan_no` char(10) DEFAULT NULL,
  `bank_name` varchar(200) DEFAULT NULL,
  `bank_branch` varchar(200) DEFAULT NULL,
  `account_name` varchar(200) DEFAULT NULL,
  `account_no` varchar(30) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `pf_no` varchar(30) DEFAULT NULL,
  `has_health_issue` tinyint(1) NOT NULL DEFAULT 0,
  `health_notes` text DEFAULT NULL,
  `profile_image` varchar(500) DEFAULT NULL,
  `emergency_name` varchar(150) DEFAULT NULL,
  `emergency_phone` varchar(20) DEFAULT NULL,
  `emergency_relation` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`up_id`, `u_id`, `first_name`, `middle_name`, `last_name`, `phone_code`, `phone`, `personal_email`, `gender`, `date_of_birth`, `marital_status`, `religion`, `designation`, `department`, `join_date`, `location`, `aadhar_no`, `pan_no`, `bank_name`, `bank_branch`, `account_name`, `account_no`, `ifsc_code`, `pf_no`, `has_health_issue`, `health_notes`, `profile_image`, `emergency_name`, `emergency_phone`, `emergency_relation`, `created_at`, `updated_at`) VALUES
(1, 1, 'Bilal', NULL, 'Hali', '+91', '9999999999', NULL, 'Male', NULL, NULL, NULL, 'System Administrator', 'IT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '2026-02-09 15:16:44', '2026-03-04 11:12:56');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_role_counts`
-- (See below for the actual view)
--
CREATE TABLE `v_role_counts` (
`r_id` int(10) unsigned
,`role_name` varchar(50)
,`level` tinyint(3) unsigned
,`user_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_team_direct`
-- (See below for the actual view)
--
CREATE TABLE `v_team_direct` (
`manager_id` int(10) unsigned
,`manager_name` varchar(100)
,`manager_role` varchar(50)
,`subordinate_id` int(10) unsigned
,`subordinate_name` varchar(100)
,`subordinate_role` varchar(50)
,`is_active` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_today_attendance`
-- (See below for the actual view)
--
CREATE TABLE `v_today_attendance` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_today_followups`
-- (See below for the actual view)
--
CREATE TABLE `v_today_followups` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_users_full`
-- (See below for the actual view)
--
CREATE TABLE `v_users_full` (
`u_id` int(10) unsigned
,`br_id` int(10) unsigned
,`branch_name` varchar(200)
,`r_id` int(10) unsigned
,`role_name` varchar(50)
,`role_level` tinyint(3) unsigned
,`username` varchar(100)
,`email` varchar(300)
,`reports_to` int(10) unsigned
,`manager_name` varchar(100)
,`is_active` tinyint(1)
,`is_online` tinyint(1)
,`last_login_at` datetime
,`first_name` varchar(150)
,`last_name` varchar(150)
,`phone` varchar(20)
,`profile_image` varchar(500)
,`designation` varchar(100)
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_permissions`
-- (See below for the actual view)
--
CREATE TABLE `v_user_permissions` (
`u_id` int(10) unsigned
,`username` varchar(100)
,`permission_code` varchar(100)
,`module` varchar(50)
,`action` varchar(50)
,`has_permission` int(1)
,`source` varchar(8)
);

-- --------------------------------------------------------

--
-- Structure for view `v_role_counts`
--
DROP TABLE IF EXISTS `v_role_counts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_role_counts`  AS SELECT `r`.`r_id` AS `r_id`, `r`.`name` AS `role_name`, `r`.`level` AS `level`, count(`u`.`u_id`) AS `user_count` FROM (`roles` `r` left join `users` `u` on(`u`.`r_id` = `r`.`r_id` and `u`.`is_active` = 1)) GROUP BY `r`.`r_id`, `r`.`name`, `r`.`level` ORDER BY `r`.`level` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `v_team_direct`
--
DROP TABLE IF EXISTS `v_team_direct`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_team_direct`  AS SELECT `mgr`.`u_id` AS `manager_id`, `mgr`.`username` AS `manager_name`, `r1`.`name` AS `manager_role`, `sub`.`u_id` AS `subordinate_id`, `sub`.`username` AS `subordinate_name`, `r2`.`name` AS `subordinate_role`, `sub`.`is_active` AS `is_active` FROM (((`users` `mgr` join `users` `sub` on(`sub`.`reports_to` = `mgr`.`u_id`)) left join `roles` `r1` on(`mgr`.`r_id` = `r1`.`r_id`)) left join `roles` `r2` on(`sub`.`r_id` = `r2`.`r_id`)) WHERE `mgr`.`is_active` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_today_attendance`
--
DROP TABLE IF EXISTS `v_today_attendance`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_today_attendance`  AS SELECT `u`.`u_id` AS `u_id`, `u`.`username` AS `username`, `up`.`first_name` AS `first_name`, `up`.`last_name` AS `last_name`, `r`.`name` AS `role_name`, `a`.`login_time` AS `login_time`, `a`.`logout_time` AS `logout_time`, `a`.`total_minutes` AS `total_minutes`, `a`.`status` AS `attendance_status`, `a`.`login_image` AS `login_image`, `a`.`logout_image` AS `logout_image` FROM (((`users` `u` left join `user_profiles` `up` on(`u`.`u_id` = `up`.`u_id`)) left join `roles` `r` on(`u`.`r_id` = `r`.`r_id`)) left join `attendance` `a` on(`u`.`u_id` = `a`.`u_id` and `a`.`date` = curdate())) WHERE `u`.`is_active` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_today_followups`
--
DROP TABLE IF EXISTS `v_today_followups`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_today_followups`  AS SELECT `lf`.`lf_id` AS `lf_id`, `lf`.`create_dt` AS `create_dt`, `lf`.`update_dt` AS `update_dt`, `lf`.`l_id` AS `l_id`, `lf`.`u_id` AS `u_id`, `lf`.`la_id` AS `la_id`, `lf`.`lac_id` AS `lac_id`, `lf`.`followup_dt` AS `followup_dt`, `lf`.`followup_note` AS `followup_note`, `lf`.`status` AS `status`, `lf`.`completed_dt` AS `completed_dt`, `lf`.`completed_lac_id` AS `completed_lac_id`, `lf`.`reminder_sent` AS `reminder_sent`, `l`.`name` AS `lead_name`, `l`.`mobile` AS `lead_mobile`, `ls`.`name` AS `status_name`, `ls`.`color` AS `status_color` FROM ((`lead_followups` `lf` join `leads` `l` on(`lf`.`l_id` = `l`.`l_id`)) left join `lead_statuses` `ls` on(`l`.`ls_id` = `ls`.`ls_id`)) WHERE `lf`.`status` = 'pending' AND cast(`lf`.`followup_dt` as date) = curdate() ;

-- --------------------------------------------------------

--
-- Structure for view `v_users_full`
--
DROP TABLE IF EXISTS `v_users_full`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_users_full`  AS SELECT `u`.`u_id` AS `u_id`, `u`.`br_id` AS `br_id`, `b`.`name` AS `branch_name`, `u`.`r_id` AS `r_id`, `r`.`name` AS `role_name`, `r`.`level` AS `role_level`, `u`.`username` AS `username`, `u`.`email` AS `email`, `u`.`reports_to` AS `reports_to`, `mgr`.`username` AS `manager_name`, `u`.`is_active` AS `is_active`, `u`.`is_online` AS `is_online`, `u`.`last_login_at` AS `last_login_at`, `up`.`first_name` AS `first_name`, `up`.`last_name` AS `last_name`, `up`.`phone` AS `phone`, `up`.`profile_image` AS `profile_image`, `up`.`designation` AS `designation`, `u`.`created_at` AS `created_at` FROM ((((`users` `u` left join `branches` `b` on(`u`.`br_id` = `b`.`br_id`)) left join `roles` `r` on(`u`.`r_id` = `r`.`r_id`)) left join `users` `mgr` on(`u`.`reports_to` = `mgr`.`u_id`)) left join `user_profiles` `up` on(`u`.`u_id` = `up`.`u_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_permissions`
--
DROP TABLE IF EXISTS `v_user_permissions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_permissions`  AS SELECT `u`.`u_id` AS `u_id`, `u`.`username` AS `username`, `p`.`code` AS `permission_code`, `p`.`module` AS `module`, `p`.`action` AS `action`, CASE WHEN `up2`.`granted` = 0 THEN 0 WHEN `up2`.`granted` = 1 THEN 1 WHEN `rp`.`r_id` is not null THEN 1 ELSE 0 END AS `has_permission`, CASE WHEN `up2`.`granted` is not null THEN 'override' WHEN `rp`.`r_id` is not null THEN 'role' ELSE 'none' END AS `source` FROM (((`users` `u` join `permissions` `p`) left join `role_permissions` `rp` on(`rp`.`r_id` = `u`.`r_id` and `rp`.`p_id` = `p`.`p_id`)) left join `user_permissions` `up2` on(`up2`.`u_id` = `u`.`u_id` and `up2`.`p_id` = `p`.`p_id`)) WHERE `u`.`is_active` = 1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`att_id`),
  ADD KEY `idx_attendance_user` (`u_id`),
  ADD KEY `idx_attendance_date` (`att_date`);

--
-- Indexes for table `attendance_policies`
--
ALTER TABLE `attendance_policies`
  ADD PRIMARY KEY (`ap_id`),
  ADD KEY `idx_type` (`type`);

--
-- Indexes for table `attendance_policy_user_week_offs`
--
ALTER TABLE `attendance_policy_user_week_offs`
  ADD PRIMARY KEY (`apuwo_id`),
  ADD UNIQUE KEY `unique_policy_user` (`ap_id`,`u_id`);

--
-- Indexes for table `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`br_id`);

--
-- Indexes for table `brokers`
--
ALTER TABLE `brokers`
  ADD PRIMARY KEY (`b_id`),
  ADD UNIQUE KEY `unique_rera` (`rera_no`),
  ADD UNIQUE KEY `unique_mobile` (`country_code`,`mobile_no`),
  ADD KEY `idx_mobile` (`mobile_no`),
  ADD KEY `idx_company` (`company`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `fk_broker_created_by` (`created_by`),
  ADD KEY `fk_broker_updated_by` (`updated_by`);

--
-- Indexes for table `broker_documents`
--
ALTER TABLE `broker_documents`
  ADD PRIMARY KEY (`bd_id`),
  ADD KEY `idx_broker_id` (`b_id`);

--
-- Indexes for table `broker_notes`
--
ALTER TABLE `broker_notes`
  ADD PRIMARY KEY (`bn_id`),
  ADD KEY `idx_broker_notes_b_id` (`b_id`);

--
-- Indexes for table `crm_settings`
--
ALTER TABLE `crm_settings`
  ADD PRIMARY KEY (`cs_id`);

--
-- Indexes for table `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`l_id`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `idx_source` (`src_id`),
  ADD KEY `idx_status` (`ls_id`),
  ADD KEY `idx_priority` (`lp_id`),
  ADD KEY `idx_followup` (`has_followup`,`followup_dt`),
  ADD KEY `idx_mobile` (`mobile`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_assign_status` (`assign_status`),
  ADD KEY `idx_created` (`create_dt`),
  ADD KEY `idx_archived` (`is_archived`),
  ADD KEY `idx_leads_is_viewed` (`is_viewed`),
  ADD KEY `fk_leads_broker` (`broker_id`);

--
-- Indexes for table `lead_activities`
--
ALTER TABLE `lead_activities`
  ADD PRIMARY KEY (`lac_id`),
  ADD KEY `idx_lead` (`l_id`),
  ADD KEY `idx_user` (`u_id`),
  ADD KEY `idx_assignment` (`la_id`),
  ADD KEY `idx_type` (`activity_type`),
  ADD KEY `idx_created` (`create_dt`),
  ADD KEY `idx_status_change` (`status_changed`,`new_status_id`),
  ADD KEY `idx_followup` (`followup_set`,`followup_dt`),
  ADD KEY `old_status_id` (`old_status_id`),
  ADD KEY `new_status_id` (`new_status_id`),
  ADD KEY `old_priority_id` (`old_priority_id`),
  ADD KEY `new_priority_id` (`new_priority_id`);

--
-- Indexes for table `lead_assignments`
--
ALTER TABLE `lead_assignments`
  ADD PRIMARY KEY (`la_id`),
  ADD UNIQUE KEY `uk_lead_user_active` (`l_id`,`u_id`,`is_active`),
  ADD KEY `idx_lead` (`l_id`),
  ADD KEY `idx_user` (`u_id`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `lead_followups`
--
ALTER TABLE `lead_followups`
  ADD PRIMARY KEY (`lf_id`),
  ADD KEY `idx_lead` (`l_id`),
  ADD KEY `idx_followup_dt` (`followup_dt`),
  ADD KEY `idx_reminder_pending` (`status`,`is_active`,`reminder_sent`,`followup_dt`);

--
-- Indexes for table `lead_priorities`
--
ALTER TABLE `lead_priorities`
  ADD PRIMARY KEY (`lp_id`),
  ADD UNIQUE KEY `uk_priority_name` (`name`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `lead_requirements`
--
ALTER TABLE `lead_requirements`
  ADD PRIMARY KEY (`lr_id`),
  ADD KEY `idx_lead` (`l_id`),
  ADD KEY `idx_service` (`st_id`),
  ADD KEY `idx_ptype` (`pt_id`),
  ADD KEY `idx_budget` (`min_budget`,`max_budget`),
  ADD KEY `fk_req_pconfig` (`pc_id`);

--
-- Indexes for table `lead_sources`
--
ALTER TABLE `lead_sources`
  ADD PRIMARY KEY (`src_id`),
  ADD UNIQUE KEY `uk_source_name` (`name`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `lead_statuses`
--
ALTER TABLE `lead_statuses`
  ADD PRIMARY KEY (`ls_id`),
  ADD UNIQUE KEY `uk_name` (`name`),
  ADD KEY `idx_active` (`is_active`),
  ADD KEY `idx_order` (`display_order`);

--
-- Indexes for table `login_history`
--
ALTER TABLE `login_history`
  ADD PRIMARY KEY (`lh_id`),
  ADD KEY `idx_user` (`u_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_login_at` (`login_at`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`p_id`),
  ADD UNIQUE KEY `uk_code` (`code`),
  ADD UNIQUE KEY `uk_module_action` (`module`,`action`),
  ADD KEY `idx_module` (`module`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`project_id`);

--
-- Indexes for table `property_configurations`
--
ALTER TABLE `property_configurations`
  ADD PRIMARY KEY (`pc_id`),
  ADD UNIQUE KEY `uk_config_name` (`name`);

--
-- Indexes for table `property_types`
--
ALTER TABLE `property_types`
  ADD PRIMARY KEY (`pt_id`),
  ADD UNIQUE KEY `uk_ptype_name` (`name`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`rt_id`),
  ADD KEY `idx_user` (`u_id`),
  ADD KEY `idx_token` (`token_hash`(255)),
  ADD KEY `idx_expires` (`expires_at`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`r_id`),
  ADD UNIQUE KEY `uk_name` (`name`),
  ADD UNIQUE KEY `uk_slug` (`slug`),
  ADD KEY `idx_level` (`level`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`r_id`,`p_id`),
  ADD KEY `fk_rp_permission` (`p_id`);

--
-- Indexes for table `service_types`
--
ALTER TABLE `service_types`
  ADD PRIMARY KEY (`st_id`),
  ADD UNIQUE KEY `uk_service_name` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`u_id`),
  ADD UNIQUE KEY `uk_username` (`username`),
  ADD KEY `idx_role` (`r_id`),
  ADD KEY `idx_reports_to` (`reports_to`),
  ADD KEY `idx_branch` (`br_id`),
  ADD KEY `idx_active` (`is_active`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `fk_users_created_by` (`created_by`),
  ADD KEY `idx_users_team_leader` (`team_leader_id`),
  ADD KEY `idx_users_sales_manager` (`sales_manager_id`),
  ADD KEY `idx_users_user_type` (`user_type`);

--
-- Indexes for table `user_column_prefs`
--
ALTER TABLE `user_column_prefs`
  ADD PRIMARY KEY (`ucp_id`),
  ADD UNIQUE KEY `uk_user_module` (`u_id`,`module`);

--
-- Indexes for table `user_locations`
--
ALTER TABLE `user_locations`
  ADD PRIMARY KEY (`ul_id`),
  ADD KEY `idx_user_time` (`u_id`,`tracked_at`),
  ADD KEY `idx_tracked` (`tracked_at`);

--
-- Indexes for table `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD PRIMARY KEY (`u_id`,`p_id`),
  ADD KEY `fk_up_permission` (`p_id`),
  ADD KEY `fk_up_granted_by` (`granted_by`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`up_id`),
  ADD UNIQUE KEY `uk_user` (`u_id`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_name` (`first_name`,`last_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `att_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `attendance_policies`
--
ALTER TABLE `attendance_policies`
  MODIFY `ap_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `attendance_policy_user_week_offs`
--
ALTER TABLE `attendance_policy_user_week_offs`
  MODIFY `apuwo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `branches`
--
ALTER TABLE `branches`
  MODIFY `br_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `brokers`
--
ALTER TABLE `brokers`
  MODIFY `b_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `broker_documents`
--
ALTER TABLE `broker_documents`
  MODIFY `bd_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `broker_notes`
--
ALTER TABLE `broker_notes`
  MODIFY `bn_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `crm_settings`
--
ALTER TABLE `crm_settings`
  MODIFY `cs_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leads`
--
ALTER TABLE `leads`
  MODIFY `l_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `lead_activities`
--
ALTER TABLE `lead_activities`
  MODIFY `lac_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `lead_assignments`
--
ALTER TABLE `lead_assignments`
  MODIFY `la_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `lead_followups`
--
ALTER TABLE `lead_followups`
  MODIFY `lf_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `lead_priorities`
--
ALTER TABLE `lead_priorities`
  MODIFY `lp_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `lead_requirements`
--
ALTER TABLE `lead_requirements`
  MODIFY `lr_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `lead_sources`
--
ALTER TABLE `lead_sources`
  MODIFY `src_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `lead_statuses`
--
ALTER TABLE `lead_statuses`
  MODIFY `ls_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key with table prefix', AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `login_history`
--
ALTER TABLE `login_history`
  MODIFY `lh_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `p_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `property_configurations`
--
ALTER TABLE `property_configurations`
  MODIFY `pc_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `property_types`
--
ALTER TABLE `property_types`
  MODIFY `pt_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `rt_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `r_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `service_types`
--
ALTER TABLE `service_types`
  MODIFY `st_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `u_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_column_prefs`
--
ALTER TABLE `user_column_prefs`
  MODIFY `ucp_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_locations`
--
ALTER TABLE `user_locations`
  MODIFY `ul_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `up_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `brokers`
--
ALTER TABLE `brokers`
  ADD CONSTRAINT `fk_broker_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`u_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_broker_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`u_id`) ON DELETE SET NULL;

--
-- Constraints for table `broker_documents`
--
ALTER TABLE `broker_documents`
  ADD CONSTRAINT `fk_bd_broker` FOREIGN KEY (`b_id`) REFERENCES `brokers` (`b_id`) ON DELETE CASCADE;

--
-- Constraints for table `leads`
--
ALTER TABLE `leads`
  ADD CONSTRAINT `fk_leads_broker` FOREIGN KEY (`broker_id`) REFERENCES `brokers` (`b_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `leads_ibfk_1` FOREIGN KEY (`ls_id`) REFERENCES `lead_statuses` (`ls_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `leads_ibfk_2` FOREIGN KEY (`lp_id`) REFERENCES `lead_priorities` (`lp_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `leads_ibfk_3` FOREIGN KEY (`src_id`) REFERENCES `lead_sources` (`src_id`) ON DELETE SET NULL;

--
-- Constraints for table `lead_activities`
--
ALTER TABLE `lead_activities`
  ADD CONSTRAINT `lead_activities_ibfk_1` FOREIGN KEY (`l_id`) REFERENCES `leads` (`l_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `lead_activities_ibfk_2` FOREIGN KEY (`la_id`) REFERENCES `lead_assignments` (`la_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `lead_activities_ibfk_3` FOREIGN KEY (`old_status_id`) REFERENCES `lead_statuses` (`ls_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `lead_activities_ibfk_4` FOREIGN KEY (`new_status_id`) REFERENCES `lead_statuses` (`ls_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `lead_activities_ibfk_5` FOREIGN KEY (`old_priority_id`) REFERENCES `lead_priorities` (`lp_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `lead_activities_ibfk_6` FOREIGN KEY (`new_priority_id`) REFERENCES `lead_priorities` (`lp_id`) ON DELETE SET NULL;

--
-- Constraints for table `lead_assignments`
--
ALTER TABLE `lead_assignments`
  ADD CONSTRAINT `lead_assignments_ibfk_1` FOREIGN KEY (`l_id`) REFERENCES `leads` (`l_id`) ON DELETE CASCADE;

--
-- Constraints for table `lead_requirements`
--
ALTER TABLE `lead_requirements`
  ADD CONSTRAINT `fk_req_lead` FOREIGN KEY (`l_id`) REFERENCES `leads` (`l_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_req_pconfig` FOREIGN KEY (`pc_id`) REFERENCES `property_configurations` (`pc_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_req_ptype` FOREIGN KEY (`pt_id`) REFERENCES `property_types` (`pt_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_req_service` FOREIGN KEY (`st_id`) REFERENCES `service_types` (`st_id`) ON DELETE SET NULL;

--
-- Constraints for table `login_history`
--
ALTER TABLE `login_history`
  ADD CONSTRAINT `fk_login_user` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`) ON DELETE SET NULL;

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `fk_refresh_user` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_rp_permission` FOREIGN KEY (`p_id`) REFERENCES `permissions` (`p_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rp_role` FOREIGN KEY (`r_id`) REFERENCES `roles` (`r_id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_branch` FOREIGN KEY (`br_id`) REFERENCES `branches` (`br_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_users_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`u_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_users_reports_to` FOREIGN KEY (`reports_to`) REFERENCES `users` (`u_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`r_id`) REFERENCES `roles` (`r_id`);

--
-- Constraints for table `user_column_prefs`
--
ALTER TABLE `user_column_prefs`
  ADD CONSTRAINT `fk_colpref_user` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_locations`
--
ALTER TABLE `user_locations`
  ADD CONSTRAINT `fk_location_user` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD CONSTRAINT `fk_up_granted_by` FOREIGN KEY (`granted_by`) REFERENCES `users` (`u_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_up_permission` FOREIGN KEY (`p_id`) REFERENCES `permissions` (`p_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_up_user` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `fk_profile_user` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
