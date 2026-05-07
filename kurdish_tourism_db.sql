-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 28, 2026 at 09:19 AM
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
-- Database: `kurdish_tourism_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(120) NOT NULL,
  `email` varchar(150) DEFAULT '',
  `role` enum('super_admin','admin') NOT NULL DEFAULT 'admin',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password_hash`, `full_name`, `email`, `role`, `active`, `last_login`, `created_at`) VALUES
(1, 'admin', '$2y$10$azThZpeAsnsGsE2Xp5DCuuuxPEr9b69Em8dJZ4bMP14yOiO/oDYZK', 'System Administrator', 'admin@example.com', 'super_admin', 1, '2026-03-10 15:21:32', '2026-03-10 12:10:54');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name_ku` varchar(120) NOT NULL,
  `name_en` varchar(120) NOT NULL,
  `name_ar` varchar(120) NOT NULL,
  `icon` varchar(50) NOT NULL DEFAULT 'map-marker-alt',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name_ku`, `name_en`, `name_ar`, `icon`, `created_at`) VALUES
(1, 'مێژوویی', 'Historical', 'تاريخي', 'landmark', '2026-03-10 12:10:55'),
(2, 'سروشتی', 'Natural', 'طبيعي', 'mountain', '2026-03-10 12:10:55'),
(3, 'هۆتێل', 'Hotel', 'فندق', 'hotel', '2026-03-10 12:10:55'),
(4, 'خواردنگە', 'Restaurant', 'مطعم', 'utensils', '2026-03-10 12:10:55'),
(5, 'پارک', 'Park', 'حديقة', 'tree', '2026-03-10 12:10:55');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `visitor_name` varchar(120) NOT NULL,
  `visitor_email` varchar(150) DEFAULT '',
  `rating` int(11) NOT NULL,
  `comment` text NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `governments`
--

CREATE TABLE `governments` (
  `id` int(11) NOT NULL,
  `name_ku` varchar(120) NOT NULL,
  `name_en` varchar(120) NOT NULL,
  `name_ar` varchar(120) NOT NULL,
  `color` varchar(20) NOT NULL DEFAULT '#3498db',
  `lat` decimal(10,7) DEFAULT NULL,
  `lng` decimal(10,7) DEFAULT NULL,
  `zoom_level` int(11) NOT NULL DEFAULT 10,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `governments`
--

INSERT INTO `governments` (`id`, `name_ku`, `name_en`, `name_ar`, `color`, `lat`, `lng`, `zoom_level`, `created_at`) VALUES
(1, 'دهۆک', 'Duhok', 'دهوك', '#e74c3c', 36.8665000, 43.0000000, 10, '2026-03-10 12:10:54'),
(2, 'هەولێر', 'Erbil', 'أربيل', '#2ecc71', 36.1901000, 44.0090000, 10, '2026-03-10 12:10:54'),
(3, 'سلێمانی', 'Sulaymaniyah', 'السليمانية', '#3498db', 35.5576000, 45.4359000, 10, '2026-03-10 12:10:54');

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `name_ku` varchar(150) NOT NULL,
  `name_en` varchar(150) NOT NULL,
  `name_ar` varchar(150) NOT NULL,
  `description_ku` text DEFAULT NULL,
  `description_en` text DEFAULT NULL,
  `description_ar` text DEFAULT NULL,
  `lat` decimal(10,7) NOT NULL,
  `lng` decimal(10,7) NOT NULL,
  `government_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `address` varchar(255) DEFAULT '',
  `phone` varchar(80) DEFAULT '',
  `email` varchar(150) DEFAULT '',
  `website` varchar(255) DEFAULT '',
  `directions_url` varchar(255) DEFAULT '',
  `opening_hours` varchar(150) DEFAULT '',
  `ticket_price` varchar(120) DEFAULT '',
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('published','draft') NOT NULL DEFAULT 'published',
  `total_visits` int(11) NOT NULL DEFAULT 0,
  `average_rating` decimal(3,2) NOT NULL DEFAULT 0.00,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `name_ku`, `name_en`, `name_ar`, `description_ku`, `description_en`, `description_ar`, `lat`, `lng`, `government_id`, `category_id`, `address`, `phone`, `email`, `website`, `directions_url`, `opening_hours`, `ticket_price`, `featured`, `status`, `total_visits`, `average_rating`, `created_by`, `created_at`, `updated_at`) VALUES
(2, 'حوشکێ', 'Hawshke', 'حوشکی', '', '', '', 36.8691549, 42.8909740, 1, 5, 'Tanahi', '7511130503', 'abdullah@abdullahamedi.com', 'abdullahamedi.com', 'https://maps.app.goo.gl/xs4mQ3D9EPGyviL28', '7', '5000', 1, 'published', 1, 0.00, 1, '2026-03-10 12:54:31', '2026-03-10 15:30:20');

-- --------------------------------------------------------

--
-- Table structure for table `location_images`
--

CREATE TABLE `location_images` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `location_visits`
--

CREATE TABLE `location_visits` (
  `id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT '',
  `user_agent` varchar(255) DEFAULT '',
  `visited_at` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `idx_visits_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `location_visits`
--

INSERT INTO `location_visits` (`id`, `location_id`, `ip_address`, `user_agent`, `visited_at`) VALUES
(1, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 12:54:37'),
(2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 15:25:11'),
(3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 15:29:53'),
(4, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 15:30:20');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('allow_feedback', '1'),
('allow_registration', '1'),
('default_language', 'ku'),
('email_notifications', '0'),
('feedback_moderation', '1'),
('locations_per_page', '12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_feedback_location` (`location_id`);

--
-- Indexes for table `governments`
--
ALTER TABLE `governments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_locations_government` (`government_id`),
  ADD KEY `fk_locations_category` (`category_id`),
  ADD KEY `fk_locations_admin` (`created_by`);

--
-- Indexes for table `location_images`
--
ALTER TABLE `location_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_location_images_location` (`location_id`);

--
-- Indexes for table `location_visits`
--
ALTER TABLE `location_visits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_visits_location` (`location_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_key`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `governments`
--
ALTER TABLE `governments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `location_images`
--
ALTER TABLE `location_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `location_visits`
--
ALTER TABLE `location_visits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `fk_feedback_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `locations`
--
ALTER TABLE `locations`
  ADD CONSTRAINT `fk_locations_admin` FOREIGN KEY (`created_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_locations_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `fk_locations_government` FOREIGN KEY (`government_id`) REFERENCES `governments` (`id`);

--
-- Constraints for table `location_images`
--
ALTER TABLE `location_images`
  ADD CONSTRAINT `fk_location_images_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `location_visits`
--
ALTER TABLE `location_visits`
  ADD CONSTRAINT `fk_visits_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
