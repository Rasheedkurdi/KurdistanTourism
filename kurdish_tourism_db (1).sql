-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 07, 2026 at 08:53 PM
-- Server version: 8.0.17
-- PHP Version: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
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
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `full_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_general_ci DEFAULT '',
  `role` enum('super_admin','admin') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'admin',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password_hash`, `full_name`, `email`, `role`, `active`, `last_login`, `created_at`) VALUES
(1, 'admin', '$2y$10$azThZpeAsnsGsE2Xp5DCuuuxPEr9b69Em8dJZ4bMP14yOiO/oDYZK', 'System Administrator', 'admin@example.com', 'super_admin', 1, '2026-05-07 23:48:51', '2026-03-10 12:10:54'),
(4, 'RasheedAdmin', '$2y$10$oFnBd4ZPk4d7rajEjDybM.sL/yOWALvaaadcLGM1wUNK/zUsR5wMW', 'rasheed', 'rasheedkurdi80@gmail.com', 'super_admin', 1, '2026-05-05 19:07:52', '2026-05-02 21:37:31');

-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE `businesses` (
  `id` int(11) NOT NULL,
  `name_ku` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `name_en` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `name_ar` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `description_ku` text COLLATE utf8mb4_general_ci,
  `description_en` text COLLATE utf8mb4_general_ci,
  `description_ar` text COLLATE utf8mb4_general_ci,
  `type` enum('hotel','restaurant','transport','tour_guide','shopping','other') COLLATE utf8mb4_general_ci NOT NULL,
  `lat` decimal(10,7) NOT NULL,
  `lng` decimal(10,7) NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `phone` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '',
  `mobile` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '',
  `email` varchar(150) COLLATE utf8mb4_general_ci DEFAULT '',
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `facebook` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `instagram` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `price_range` enum('$','$$','$$$','$$$$') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '$$',
  `rating` decimal(3,2) NOT NULL DEFAULT '0.00',
  `review_count` int(11) NOT NULL DEFAULT '0',
  `opening_hours` json DEFAULT NULL,
  `features` json DEFAULT NULL,
  `photos` json DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `featured` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('published','draft','deleted') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `businesses`
--

INSERT INTO `businesses` (`id`, `name_ku`, `name_en`, `name_ar`, `description_ku`, `description_en`, `description_ar`, `type`, `lat`, `lng`, `address`, `phone`, `mobile`, `email`, `website`, `facebook`, `instagram`, `price_range`, `rating`, `review_count`, `opening_hours`, `features`, `photos`, `verified`, `featured`, `status`, `created_at`) VALUES
(1, 'مەلەوانی هەولێر', 'Hawler Restaurant', '', 'خواردنیەکی کوردی دێکی و بەرزێکر', NULL, NULL, 'restaurant', '36.1911000', '44.0092000', 'شاری هەولێر، نزیک قەڵای هەولێر', '07501234567', '', '', '', '', '', '$$', '4.50', 0, NULL, NULL, NULL, 0, 0, 'published', '2026-05-06 23:20:09'),
(2, 'هۆتێلی قەندیل', 'Kandil Hotel', '', 'هۆتێلێکێکی لوکس لەگەنەران بەرزێکر', NULL, NULL, 'hotel', '35.5576000', '45.4359000', 'شاری سلێمانی، نزیخ مەڵەباز', '07501234568', '', '', '', '', '', '$$', '4.20', 0, NULL, NULL, NULL, 0, 0, 'published', '2026-05-06 23:20:09'),
(3, 'فرۆشەگەی دەوخ', 'Duhok Souvenir Shop', '', 'فرۆشەگەی کوردی و دەستکاری دەستی', NULL, NULL, 'shopping', '36.8667000', '42.9833000', 'شاری دهۆک، بازاڕی قەڵای', '07501234569', '', '', '', '', '', '$$', '4.80', 0, NULL, NULL, NULL, 0, 0, 'published', '2026-05-06 23:20:09');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name_ku` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `name_en` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `name_ar` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `icon` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'map-marker-alt',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name_ku`, `name_en`, `name_ar`, `icon`, `created_at`) VALUES
(1, 'مێژوویی', 'Historical', 'تاريخي', 'landmark', '2026-03-10 12:10:55'),
(2, 'سروشتی', 'Natural', 'طبيعي', 'mountain', '2026-03-10 12:10:55'),
(3, 'هۆتێل', 'Hotel', 'فندق', 'hotel', '2026-03-10 12:10:55'),
(4, 'خواردنگە', 'Restaurant', 'مطعم', 'utensils', '2026-03-10 12:10:55'),
(5, 'پارک', 'Park', 'حديقة', 'tree', '2026-03-10 12:10:55'),
(6, 'گەشت و گوزار', 'tourism', 'سياحة', 'mountain', '2026-04-12 10:02:51'),
(7, 'دەریا و ریبار', 'Sea and River', 'البحر والنهر', 'water', '2026-05-02 21:35:48'),
(8, 'مزگەفت', 'Mosque', 'مسجد (جامع)', 'mosque', '2026-05-04 20:24:55');

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(11) NOT NULL,
  `full_name` varchar(120) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(80) DEFAULT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `status` enum('unread','read','replied') NOT NULL DEFAULT 'unread',
  `admin_reply` text,
  `replied_at` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `full_name`, `email`, `phone`, `subject`, `message`, `status`, `admin_reply`, `replied_at`, `ip_address`, `created_at`) VALUES
(1, 'Test User', 'test@example.com', '+9647501234567', 'Test Subject', 'This is a test message to verify the contact system is working.', 'read', NULL, NULL, NULL, '2026-05-05 15:49:24'),
(2, 'ranj', 'redkurd77@gmail.com', '2356890', 'wetryugih', 'ertf yubv6f', 'read', NULL, NULL, '::1', '2026-05-05 15:57:05'),
(3, 'Kurdirang21', 'Kurd@gmail.com', '7502252222', 'ftyguuniui', 'xcrvtby8un9', 'read', NULL, NULL, '::1', '2026-05-05 15:57:59'),
(5, 'a', 'kurderasheed33@gmail.com', '07500000000', 'feffe', '3wetryuiorty', 'read', NULL, NULL, '::1', '2026-05-05 16:07:40'),
(6, 'Rayan', 'kurderasheed33@gmail.com', '07500000000', 'Jha zeds bka', 'Wake the galleys Ali bag', 'replied', 'rtyui', '2026-05-05 17:19:04', '::1', '2026-05-05 16:41:04'),
(7, 'fww', 'fewwq@gmai.com', '1235633253', 'wefewf', 'efwcwee', 'read', NULL, NULL, '::1', '2026-05-07 00:19:31');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `title_ku` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `title_en` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `title_ar` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `description_ku` text COLLATE utf8mb4_general_ci,
  `description_en` text COLLATE utf8mb4_general_ci,
  `description_ar` text COLLATE utf8mb4_general_ci,
  `location_id` int(11) DEFAULT NULL,
  `custom_location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `is_recurring` tinyint(1) NOT NULL DEFAULT '0',
  `recurrence_pattern` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '',
  `category` enum('festival','cultural','religious','sport','concert','other') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'cultural',
  `organizer` varchar(150) COLLATE utf8mb4_general_ci DEFAULT '',
  `contact_phone` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '',
  `contact_email` varchar(150) COLLATE utf8mb4_general_ci DEFAULT '',
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `ticket_price` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '',
  `is_free` tinyint(1) NOT NULL DEFAULT '0',
  `photos` json DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('published','draft','cancelled') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `visitor_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `visitor_email` varchar(150) COLLATE utf8mb4_general_ci DEFAULT '',
  `rating` int(11) NOT NULL,
  `comment` text COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `location_id`, `user_id`, `visitor_name`, `visitor_email`, `rating`, `comment`, `status`, `created_at`) VALUES
(1, 2, NULL, 'rasheed', '', 4, 'galak jhake xosha', 'approved', '2026-03-31 08:54:48'),
(2, 4, NULL, 'kurd', '', 4, 'galak xosha', 'approved', '2026-04-12 11:00:33'),
(4, 4, NULL, 'kurd', '', 4, 'galak xosha', 'rejected', '2026-04-12 11:00:37'),
(5, 4, NULL, 'kurd', '', 4, 'galak xosha', 'approved', '2026-04-12 11:00:37'),
(6, 4, NULL, 'kurd', '', 4, 'galak xosha', 'approved', '2026-04-12 11:00:38'),
(7, 4, NULL, 'kurd', '', 4, 'galak xosha', 'rejected', '2026-04-12 11:00:38'),
(9, 4, NULL, 'mohammad', '', 4, 'jegayake jwana', 'approved', '2026-04-12 19:23:09'),
(10, 6, NULL, 'king', '', 5, 'zor jwana', 'approved', '2026-04-24 10:30:37'),
(11, 7, NULL, 'lawen', '', 4, 'It is a very beutefual valley', 'approved', '2026-04-26 17:39:09'),
(12, 3, NULL, 'بڕوا هەلەبجەیی', '', 4, 'جێگایەکی زۆر خوشە', 'approved', '2026-04-27 13:21:11'),
(13, 4, NULL, 'tarq', '', 5, 'aasjoaskosc', 'rejected', '2026-04-29 20:16:18'),
(14, 3, NULL, 'mohammad', '', 5, 'مزگەفتەکا جوانە', 'approved', '2026-05-02 12:04:14'),
(20, 4, 2, 'Kurdirang21', 'Kurdirang@gmail.com', 2, 'Jake naxosha', 'approved', '2026-05-07 16:21:32'),
(23, 3, 10, 'tofo', 'ttt@gm.com', 5, 'jhe mejoye', 'pending', '2026-05-07 20:42:50');

-- --------------------------------------------------------

--
-- Table structure for table `governments`
--

CREATE TABLE `governments` (
  `id` int(11) NOT NULL,
  `name_ku` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `name_en` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `name_ar` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `color` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '#3498db',
  `lat` decimal(10,7) DEFAULT NULL,
  `lng` decimal(10,7) DEFAULT NULL,
  `zoom_level` int(11) NOT NULL DEFAULT '10',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `governments`
--

INSERT INTO `governments` (`id`, `name_ku`, `name_en`, `name_ar`, `color`, `lat`, `lng`, `zoom_level`, `created_at`) VALUES
(1, 'دهۆک', 'Duhok', 'دهوك', '#e74c3c', '36.8665000', '43.0000000', 10, '2026-03-10 12:10:54'),
(2, 'هەولێر', 'Erbil', 'أربيل', '#2ecc71', '36.1901000', '44.0090000', 10, '2026-03-10 12:10:54'),
(3, 'سلێمانی', 'Sulaymaniyah', 'السليمانية', '#3498db', '35.5576000', '45.4359000', 10, '2026-03-10 12:10:54'),
(4, 'كرکوک', 'Karkok', 'كركوك', '#3498db', '35.4702790', '44.3955590', 8, '2026-03-31 09:59:41'),
(5, 'ئاکرێ', 'Akre', 'عقرة', '#50a832', '36.7413900', '43.8933330', 10, '2026-04-12 09:50:18'),
(6, 'حەلەبچە', 'Halabja', 'حەلەبجة', '#3498df', '35.1783200', '45.9900200', 8, '2026-05-02 21:42:26');

-- --------------------------------------------------------

--
-- Table structure for table `itineraries`
--

CREATE TABLE `itineraries` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_days` int(11) NOT NULL DEFAULT '1',
  `budget` decimal(10,2) DEFAULT NULL,
  `travelers_count` int(11) NOT NULL DEFAULT '1',
  `transport_type` enum('car','bus','walking','mixed') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'mixed',
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `likes_count` int(11) NOT NULL DEFAULT '0',
  `views_count` int(11) NOT NULL DEFAULT '0',
  `status` enum('draft','published','deleted') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `itineraries`
--

INSERT INTO `itineraries` (`id`, `user_id`, `title`, `description`, `start_date`, `end_date`, `total_days`, `budget`, `travelers_count`, `transport_type`, `is_public`, `likes_count`, `views_count`, `status`, `created_at`) VALUES
(1, 1, 'Erbil Weekend Trip', '', '2026-05-05', '2026-05-06', 1, NULL, 2, 'mixed', 0, 0, 0, 'published', '2026-05-05 21:35:38'),
(2, 3, 'Erbil Weekend Trip', '', '2026-05-05', '2026-05-06', 1, NULL, 11, 'mixed', 0, 0, 0, 'published', '2026-05-05 22:10:31'),
(3, 2, 'Erbil Weekend Trip', '', '2026-05-06', '2026-05-09', 3, NULL, 5, 'mixed', 0, 0, 0, 'published', '2026-05-06 22:45:54'),
(6, 2, 'ertyu', '', '2026-05-07', '2026-05-08', 1, NULL, 1, 'mixed', 0, 0, 0, 'deleted', '2026-05-07 16:40:37');

-- --------------------------------------------------------

--
-- Table structure for table `itinerary_items`
--

CREATE TABLE `itinerary_items` (
  `id` int(11) NOT NULL,
  `itinerary_id` int(11) NOT NULL,
  `day_number` int(11) NOT NULL,
  `item_type` enum('location','business','transport','rest') NOT NULL DEFAULT 'location',
  `item_id` int(11) DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `description` text,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT '0',
  `order_number` int(11) NOT NULL DEFAULT '0',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `itinerary_items`
--

INSERT INTO `itinerary_items` (`id`, `itinerary_id`, `day_number`, `item_type`, `item_id`, `title`, `description`, `start_time`, `end_time`, `duration_minutes`, `order_number`, `notes`, `created_at`) VALUES
(1, 1, 1, 'transport', NULL, 'eqq', '', '02:35:00', '02:35:00', 0, 0, NULL, '2026-05-05 21:35:38'),
(2, 2, 1, 'business', NULL, 'wewr', '', '00:00:00', '00:00:00', 0, 0, NULL, '2026-05-05 22:10:31'),
(3, 3, 1, 'business', NULL, 'vvv', '', '00:00:00', '00:00:00', 0, 0, NULL, '2026-05-06 22:45:54'),
(4, 3, 2, 'transport', NULL, 'ccc', '', '00:00:00', '00:00:00', 0, 0, NULL, '2026-05-06 22:45:54'),
(5, 3, 3, 'rest', NULL, 'wwqw', '', '00:00:00', '00:00:00', 0, 0, NULL, '2026-05-06 22:45:54'),
(6, 4, 1, 'location', NULL, '', '', '00:00:00', '00:00:00', 0, 0, NULL, '2026-05-06 23:11:09'),
(7, 5, 1, 'location', NULL, '', '', '00:00:00', '00:00:00', 0, 0, NULL, '2026-05-07 00:20:49'),
(8, 6, 1, 'location', NULL, '', '', '00:00:00', '00:00:00', 0, 0, NULL, '2026-05-07 16:40:37');

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `name_ku` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `name_en` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `name_ar` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `description_ku` text COLLATE utf8mb4_general_ci,
  `description_en` text COLLATE utf8mb4_general_ci,
  `description_ar` text COLLATE utf8mb4_general_ci,
  `lat` decimal(10,7) NOT NULL,
  `lng` decimal(10,7) NOT NULL,
  `government_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `phone` varchar(80) COLLATE utf8mb4_general_ci DEFAULT '',
  `email` varchar(150) COLLATE utf8mb4_general_ci DEFAULT '',
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `directions_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `opening_hours` varchar(150) COLLATE utf8mb4_general_ci DEFAULT '',
  `ticket_price` varchar(120) COLLATE utf8mb4_general_ci DEFAULT '',
  `featured` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('published','draft') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'published',
  `total_visits` int(11) NOT NULL DEFAULT '0',
  `average_rating` decimal(3,2) NOT NULL DEFAULT '0.00',
  `created_by` int(11) DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `name_ku`, `name_en`, `name_ar`, `description_ku`, `description_en`, `description_ar`, `lat`, `lng`, `government_id`, `category_id`, `address`, `phone`, `email`, `website`, `directions_url`, `opening_hours`, `ticket_price`, `featured`, `status`, `total_visits`, `average_rating`, `created_by`, `image_path`, `created_at`) VALUES
(2, 'حوشکێ', 'Hawshke', 'حوشکی', '', '', '', '36.8691549', '42.8909740', 1, 5, 'Tanahi', '7511130503', 'abdullah@abdullahamedi.com', 'abdullahamedi.com', 'https://maps.app.goo.gl/xs4mQ3D9EPGyviL28', '7', '5000', 1, 'published', 22, '4.00', 1, NULL, '2026-03-10 12:54:31'),
(3, 'مزگەفتا دانیال پێغەمبەر', 'Masjed danyal', 'مسجد دانيال', 'ئەفە مزگەفتەکا مێژوییە', 'it is a historical masjed', 'مسجد تاریخی', '35.4687625', '44.3955958', 4, 8, 'karkok', '2345678', 'omed@gmail.com', 'https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://ar.wikipedia.org/wiki/%25D8%25AC%25D8%25A7%25D9%2585%25D8%25B9_%25D8%25A7%25D9%2584%25D9%2586%25D8%25A8%25D9%258A_%25D8%25AF%25D8%25A7%25D9%2586%25D9%258A%25D8%25A7%25D9%2584_(%25D9', 'https://maps.app.goo.gl/6FgNmpNSit7VTsTy5', '24', '0', 0, 'published', 26, '4.50', NULL, 'uploads/loc_69fce87d6b2ae0.23786996.jpg', '2026-03-31 10:13:02'),
(4, 'سیپێ ئاکرێ', 'sepi Akre', 'شلال عقرة', 'سیپێ ئاکرێ', 'sepi akre', 'شلال عقرة', '36.7595304', '43.9011807', 5, 6, 'duhok - akre', '07500000000', 'rasheed@gmail.com', 'www.akre.com', 'https://maps.app.goo.gl/AsPyWu9zCq29qqja8', '24 hours', '3000', 1, 'published', 15, '3.60', 1, NULL, '2026-04-12 10:08:10'),
(5, 'پارکا سەیرانگە', 'parka sayranga', 'بارك سياحة', 'پارک', 'park', 'حديقة', '36.7328234', '43.8813986', 5, 5, 'akre', '75011111111', 'a@gmail.com', 'aaaa', 'sdfs', '24 hours', '5000', 1, 'published', 43, '0.00', 1, NULL, '2026-04-12 19:50:25'),
(6, 'باشقال ئاغا', 'bashqal aga', 'بشقل اغا', 'جهەکێ سروشتی و جوانە', 'it is beautiful, natural place', 'انه مكان طبعي و جميل', '36.7445860', '43.9168682', 5, 2, 'akre', '07500000000', 'aram@gmail.com', 'www.akre.com', 'https://maps.app.goo.gl/NCSJrchDe6brcXBg9', '24 hours', '0', 1, 'published', 6, '5.00', 1, NULL, '2026-04-19 19:18:40'),
(7, 'گەلیێ زنتا', 'zenta valley', 'وادي زنتا', 'گەلیێ زنتا گەلیەکە دکەڤیتە سەر باژێرێ ئاکرێ جهەکێ گەشتیاریە وبتایبەتی دوەرزێ هاڤینێ دا خەلک گەلەک سەرە دانێ بو دکەن', 'The Gali Zinta waterfalls are located above the city of Aqrah, and it is a tourist destination, especially in the summer when many people visit it.', 'تقع شلالات كَلي زِنتا فوق مدينة عقرة، وهي مكان سياحي، وخاصة في فصل الصيف حيث يزورها الكثير من الناس.', '36.7340700', '43.9717200', 5, 6, 'Akre', '0750123456', 'GaliZenta@mail.com', 'www.akre.com', 'https://maps.app.goo.gl/ANZypjuyd3agAktZA', '24', '0', 1, 'published', 16, '4.00', 1, 'uploads/loc_69fcea8f85c3a7.36449161.jpg', '2026-04-26 17:36:15'),
(8, 'گەلیێ شێخ عبدالعزیز', 'sheikh abdolaziz valley', 'وادي شيخ عبدالعزير', 'تێدا گۆڕێ موجاهید شێخ عەبدولعەزیزە، ئەو موجاهیدێ کو دگەل سەلاحەدینێ ئەیوبی چووتیە قودسێ بۆ جیهادکرنا دژی خاچپەرستان و فەتحا وێ بۆ موسلمانان کرین، و پێکڤە د هەمی شەڕان دا پشکدار بووینە. ل دووماهیێ زڤڕیە کوردستانێ و ل دەڤەرا ئاکرێ وەفات کریە، کو جهەکێ بەرنیاسە ب دەروێشێن تەریقەتا قادری و خەلک ژ هەمی لایێن عیراقێ قەستا وێرێ دکەن و سەرەدانا وی دکەن.', 'There is the grave of the mujahid Sheikh Abdulaziz, who was one of the fighters that went with Salah ad-Din al-Ayyubi to wage jihad against the Crusaders in Jerusalem, and together they liberated it for the Muslims. He took part in all the battles, and in the end he returned to Kurdistan and died in the region of Akre. This place is well known for the dervishes of the Qadiri order, and people from all Iraq visit it.', 'فيه قبر المجاهد الشيخ عبدالعزيز وهو المجاهد الذي ذهب مع صلاح الدين الايوبي إلى جهاد الصليبيين في القدس وفتحوها للمسلمين وخاضوا المعارك جميعا وفي الاخير عاد إلى كردستان ومات في منطقة عقرة وهو مكان مشهور بدراويش الطريقة القادرية و يزوره  الناس جميعا في جميع أنحاء العراق', '36.7683800', '43.8940100', 5, 1, 'دکەڤیتە باژێرێ ئاکرێ', '07514341386', 'Abdolaziz@gmail.com', 'no web', 'https://maps.app.goo.gl/L6vnyLLZgnR5igLq8', '24 hours', '-', 1, 'published', 6, '0.00', 1, NULL, '2026-05-02 21:33:04'),
(10, 'گەلی علی بەگ', 'Ali bag valley', 'وادي علي بك', 'جهەکێ سروشتیە', 'nice valley', 'مكان جميل', '36.6410300', '44.4520900', 2, 2, 'hawler', '075502698301', 'aram@gmail.com', 'non', 'https://maps.app.goo.gl/NCSJrchDe6brcXBg9', '24 hours', '0', 0, 'published', 1, '0.00', 1, 'uploads/loc_69fceada8e37b0.96068939.jpg', '2026-05-05 23:03:13'),
(12, 'درێم ستی', 'Dream city', 'دریم ستی', 'پارکەکا پێشکەفتیە و چەندین جهێن یاریکرنێ تێدا هەنە', 'is great  park', 'مدينة العاب', '36.8588058', '42.9808480', 1, 5, 'پارێزگەها دهوک', '07828388910', 'dreamcity@gmail.com', 'https://www.al-amingroup.com/dream-city', 'https://maps.app.goo.gl/AsPyWu9zCq29qqja8', '24 hours', '5000', 0, 'published', 9, '0.00', 1, 'uploads/loc_69fce9ac607b60.35216787.jpg', '2026-05-06 22:25:43');

-- --------------------------------------------------------

--
-- Table structure for table `location_images`
--

CREATE TABLE `location_images` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `location_images`
--

INSERT INTO `location_images` (`id`, `location_id`, `image_path`, `sort_order`, `created_at`) VALUES
(21, 3, 'uploads/loc_69fce87d6b2ae0.23786996.jpg', 0, '2026-05-07 19:31:09'),
(22, 12, 'uploads/loc_69fce9ac607b60.35216787.jpg', 0, '2026-05-07 19:36:12'),
(23, 7, 'uploads/loc_69fcea8f85c3a7.36449161.jpg', 0, '2026-05-07 19:39:59'),
(24, 10, 'uploads/loc_69fceada8e37b0.96068939.jpg', 0, '2026-05-07 19:41:14');

-- --------------------------------------------------------

--
-- Table structure for table `location_suggestions`
--

CREATE TABLE `location_suggestions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name_ku` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `name_en` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name_ar` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description_ku` text COLLATE utf8mb4_general_ci,
  `description_en` text COLLATE utf8mb4_general_ci,
  `description_ar` text COLLATE utf8mb4_general_ci,
  `lat` decimal(10,7) NOT NULL,
  `lng` decimal(10,7) NOT NULL,
  `government_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `website` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `directions_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `opening_hours` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ticket_price` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image_path` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image_base64` longtext COLLATE utf8mb4_general_ci,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
  `admin_note` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `location_suggestions`
--

INSERT INTO `location_suggestions` (`id`, `user_id`, `name_ku`, `name_en`, `name_ar`, `description_ku`, `description_en`, `description_ar`, `lat`, `lng`, `government_id`, `category_id`, `address`, `phone`, `email`, `website`, `directions_url`, `opening_hours`, `ticket_price`, `image_path`, `image_base64`, `status`, `admin_note`, `created_at`, `reviewed_at`) VALUES
(1, 3, 'گەلی علی بەگ', 'Ali bag valley', '', 'جهەکێ سروشتیە', '', '', '36.6410300', '44.4520900', 2, 2, 'hawler', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'approved', 'Auto-approved: added to map', '2026-05-05 22:09:30', '2026-05-05 23:03:13'),
(2, 2, 'tyu', 'rtyu', '', 'ertfyuuio', '', '', '36.6410300', '44.4520900', 6, 8, 'new yurk', NULL, NULL, NULL, NULL, NULL, NULL, 'uploads/suggestions/suggestion_2_1778019777_69fa6dc1a0aa1.jpg', 'data:image/jpeg;base64,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', 'rejected', 'Rejected by admin', '2026-05-05 22:22:57', '2026-05-05 23:01:17'),
(3, 2, 'uijasik yfghj', 'uijasik yfghj', '', 'ewfrthyju', '', '', '36.6410300', '44.4520900', 3, 1, 'new yurk', NULL, NULL, NULL, NULL, NULL, NULL, 'uploads/suggestions/suggestion_2_1778020346_69fa6ffac2b2e.jpg', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAABgAAAAQACAIAAACoEwUVAABnL2NhQlgAAGcvanVtYgAAAB5qdW1kYzJwYQARABCAAACqADibcQNjMnBhAAAAZwlqdW1iAAAAR2p1bWRjMm1hABEAEIAAAKoAOJtxA3VybjpjMnBhOmM0NzFmM2M4LWExM2MtNGE2Mi1hNDc2LTAwMjQxOWQxOGIxNAAAABblanVtYgAAAClqdW1kYzJhcwARABCAAACqADibcQNjMnBhLmFzc2VydGlvbnMAAAAJ0Wp1bWIAAAA7anVtZEDLDDK7ikidpwsq1vR/Q2kTYzJwYS5pY29uAAAAABhjMnNozX16MdmVajIT5GDDX2u1wAAAABdiZmRiAGltYWdlL3N2Zyt4bWwAAAAJd2JpZGI8c3ZnIHdpZHRoPSI3MTYiIGhlaWdodD0iNzE2IiB2aWV3Qm94PSIwIDAgNzE2IDcxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTUwOC43NDkgMzE3LjM5OUM1MTYuNzc3IDI4Ny4zMTQgNTA4Ljk5MSAyNTMuODg0IDQ4NS4zODkgMjMwLjI4MkM0NjEuNzg4IDIwNi42ODEgNDI4LjM2IDE5OC44OTUgMzk4LjI3MyAyMDYuOTIzQzM3Ni4yMzEgMTg0LjkyOCAzNDMuMzkgMTc0Ljk1NiAzMTEuMTQ4IDE4My41OTZDMjc4LjkwNiAxOTIuMjM0IDI1NS40NSAyMTcuMjkyIDI0Ny4zNiAyNDcuMzYxQzIxNy4yOTEgMjU1LjQ1MSAxOTIuMjMzIDI3OC45MSAxODMuNTk1IDMxMS4xNDlDMTc0Ljk1NyAzNDMuMzkxIDE4NC45MjcgMzc2LjIzMiAyMDYuOTI0IDM5OC4yNzRDMTk4Ljg5NiA0MjguMzU5IDIwNi42ODMgNDYxLjc4OSAyMzAuMjg0IDQ4NS4zOTFDMjUzLjg4NSA1MDguOTkyIDI4Ny4zMTMgNTE2Ljc3OSAzMTcuNDAxIDUwOC43NUMzMzkuNDQyIDUzMC43NDUgMzcyLjI4NiA1NDAuNzE3IDQwNC41MjUgNTMyLjA3OUM0MzYuNzY3IDUyMy40NDEgNDYwLjIyMyA0OTguMzg0IDQ2OC4zMTMgNDY4LjMxNUM0OTguMzgzIDQ2MC4yMjQgNTIzLjQ0IDQzNi43NjYgNTMyLjA3OCA0MDQuNTI2QzU0MC43MTYgMzcyLjI4NSA1MzAuNzQ3IDMzOS40NDMgNTA4Ljc0OSAzMTcuNDAyVjMxNy4zOTlaTTQ3MC44OTkgMjQ0Ljc3NkM0ODYuODkyIDI2MC43NyA0OTMuNDg4IDI4Mi42MDEgNDkwLjY4NyAzMDMuNDEyTDQxNS41NzcgMjYwLjA0NkM0MTIuNDExIDI1OC4yMTggNDA4LjUwOSAyNTguMjE4IDQwNS4zNDUgMjYwLjA0NkwzMTcuNDAxIDMxMC44MlYyNzcuNTI2QzMxNy40MDEgMjc1LjE5MSAzMTguNjUyIDI3My4wMDUgMzIwLjY3NiAyNzEuODM3TDM4Ny42NDQgMjMzLjE3NEM0MTQuMTc4IDIxOC4zNTMgNDQ4LjM0NiAyMjIuMjIzIDQ3MC45MDEgMjQ0Ljc3Nkg0NzAuODk5Wk0zNTcuODM3IDMxMS4xNDRMMzk4LjI3NSAzMzQuNDkxVjM4MS4xODVMMzU3LjgzNyA0MDQuNTMyTDMxNy4zOTggMzgxLjE4NVYzMzQuNDkxTDM1Ny44MzcgMzExLjE0NFpNMjY0Ljc3NiAyNjkuNjkzQzI2NS4yMDcgMjM5LjMwNSAyODUuNjQ0IDIxMS42NDkgMzE2LjQ1MyAyMDMuMzkzQzMzOC4zIDE5Ny41NCAzNjAuNTA1IDIwMi43NDQgMzc3LjEyNyAyMTUuNTczTDMwMi4wMTQgMjU4LjkzN0MyOTguODQ4IDI2MC43NjQgMjk2Ljg5OCAyNjQuMTQ0IDI5Ni44OTggMjY3Ljc5OFYzNjkuMzQ2TDI2OC4wNjUgMzUyLjY5OUMyNjYuMDQzIDM1MS41MzEgMjY0Ljc3NiAzNDkuMzUzIDI2NC43NzYgMzQ3LjAxN1YyNjkuNjkxVjI2OS42OTNaTTIwMy4zOTEgMzE2LjQ1NEMyMDkuMjQ0IDI5NC42MDggMjI0Ljg1NCAyNzcuOTc4IDI0NC4yNzYgMjY5Ljk5OVYzNTYuNzNDMjQ0LjI3NiAzNjAuMzg0IDI0Ni4yMjYgMzYzLjc2MyAyNDkuMzkyIDM2NS41OTFMMzM3LjMzNyA0MTYuMzY1TDMwOC41MDMgNDMzLjAxM0MzMDYuNDgxIDQzNC4xODEgMzAzLjk2MSA0MzQuMTg4IDMwMS45MzkgNDMzLjAyTDIzNC45NzEgMzk0LjM1N0MyMDguODY4IDM3OC43ODkgMTk1LjEzOCAzNDcuMjYxIDIwMy4zOTEgMzE2LjQ1NFpNMjQ0Ljc3NSA0NzAuOUMyMjguNzgxIDQ1NC45MDYgMjIyLjE4NiA0MzMuMDc1IDIyNC45ODYgNDEyLjI2NEwzMDAuMDk2IDQ1NS42M0MzMDMuMjYzIDQ1Ny40NTcgMzA3LjE2NCA0NTcuNDU3IDMxMC4zMjggNDU1LjYzTDM5OC4yNzMgNDA0Ljg1NlY0MzguMTQ5QzM5OC4yNzMgNDQwLjQ4NSAzOTcuMDIyIDQ0Mi42NzEgMzk0Ljk5NyA0NDMuODM5TDMyOC4wMjkgNDgyLjUwMkMzMDEuNDk1IDQ5Ny4zMjIgMjY3LjMyNyA0OTMuNDUyIDI0NC43NzIgNDcwLjlIMjQ0Ljc3NVpNNDUwLjg5NyA0NDUuOTgyQzQ1MC40NjYgNDc2LjM3MSA0MzAuMDI5IDUwNC4wMjcgMzk5LjIyIDUxMi4yODNDMzc3LjM3MyA1MTguMTM2IDM1NS4xNjggNTEyLjkzMiAzMzguNTQ3IDUwMC4xMDJMNDEzLjY1OSA0NTYuNzM4QzQxNi44MjYgNDU0LjkxMSA0MTguNzc1IDQ1MS41MzIgNDE4Ljc3NSA0NDcuODc3VjM0Ni4zMjlMNDQ3LjYwOSAzNjIuOTc3QzQ0OS42MzEgMzY0LjE0NSA0NTAuODk3IDM2Ni4zMjMgNDUwLjg5NyAzNjguNjU5VjQ0NS45ODVWNDQ1Ljk4MlpNNTEyLjI4MiAzOTkuMjIxQzUwNi40MjkgNDIxLjA2OCA0OTAuODE5IDQzNy42OTcgNDcxLjM5NyA0NDUuNjc2VjM1OC45NDZDNDcxLjM5NyAzNTUuMjkyIDQ2OS40NDggMzUxLjkxMiA0NjYuMjgxIDM1MC4wODVMMzc4LjMzNiAyOTkuMzExTDQwNy4xNyAyODIuNjYzQzQwOS4xOTIgMjgxLjQ5NSA0MTEuNzEyIDI4MS40ODcgNDEzLjczNCAyODIuNjU1TDQ4MC43MDIgMzIxLjMxOEM1MDYuODA1IDMzNi44ODcgNTIwLjUzNiAzNjguNDE1IDUxMi4yODIgMzk5LjIyMVoiIGZpbGw9ImJsYWNrIi8+Cjwvc3ZnPgoAAAFFanVtYgAAAEFqdW1kY2JvcgARABCAAACqADibcRNjMnBhLmFjdGlvbnMudjIAAAAAGGMyc2gAQigqHrNLq7mli/4f0Oz/AAAA/GNib3KhZ2FjdGlvbnOCpGZhY3Rpb25sYzJwYS5jcmVhdGVkZHdoZW7AdDIwMjYtMDQtMjdUMDA6MDA6MDBabXNvZnR3YXJlQWdlbnSiZG5hbWVpZ3B0LWltYWdlZ3ZlcnNpb25ncHJlLTIuMHFkaWdpdGFsU291cmNlVHlwZXhGaHR0cDovL2N2LmlwdGMub3JnL25ld3Njb2Rlcy9kaWdpdGFsc291cmNldHlwZS90cmFpbmVkQWxnb3JpdGhtaWNNZWRpYaJmYWN0aW9ubmMycGEuY29udmVydGVkZHdoZW7AdDIwMjYtMDQtMjdUMDA6MDA6MDBaAAAK22p1bWIAAABJanVtZGNib3IAEQAQgAAAqgA4m3ETYzJwYS5jZXJ0aWZpY2F0ZS1zdGF0dXMAAAAAGGMyc2iR9MqZoEMl00hLQU6PZkliAAAKimNib3KhaG9jc3BWYWxzgXkKdE1JSUgwd29CQUtDQ0I4d3dnZ2ZJQmdrckJnRUZCUWN3QVFFRWdnZTVNSUlIdFRDQjZhSVdCQlFjKzFlaXdCdEx4cmVlaTFWMWVqMVVmbVJEWFJnUE1qQXlOakEwTWpZd016TTJNRE5hTUlHWU1JR1ZNRWt3Q1FZRkt3NERBaG9GQUFRVTM0STNVMTVUMkRPeDRBUTlKRFh4ZGViaENoa0VGRGs5RUVmY2w0K3ZpSHROY3hnZHplWHVwS1VxQWhBTHBmenBEbkNNOGdXQU1lNUVIR1J6Z0FBWUR6SXdNall3TkRJMk1ETXpOakF6V3FBUkdBOHlNREkyTURVd016QXpNell3TWxxaElqQWdNQjRHQ1NzR0FRVUZCekFCQmdRUkdBOHlNREUyTURReU9EQXpNell3TTFxaEl6QWhNQjhHQ1NzR0FRVUZCekFCQWdRU0JCQ3c4WGpNeEYwR3V3dm92aTJGdWs5Vk1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQmdRQ2w2MHRZQ0ZWN1BYSUJYanZNUEpiVlVwSWdsajRvd1ZzVmlhVTNKU2grd0U2OGI3a2p5MnVkOS9lTlBqWWFpaEFsQzhxdDhTeHJSakwxa0VPeUYxMDgyVnU0bjVxL0JzMG1iRGt1bDF0Rk9ySDlsdm1EK25OMGZDditMeHBWUG1Jd3cwL0tMNkZwTEtjWmpHYVhwKzczK3R2OTlIaFpTSjZhOEIzRnVNUE5hNE92dE90VzRYT2RKV1NDbWN2K1FVUk4wTm83OSs0YWR5ajZTWEU2bVNGTHkvVFd2bnVSM09nYThWQUJGdUlTU2MydE4ycTR1bjdwNGZBRHc0UzllRzV1NytpRnJVV1FaSjJsUEpEZEx4bjQxVHBzL1ZEbE1VRXVOMGk2SlhVQ2lab1E0dGxlWlcvSkpaNHNiYnBONFlidGlZNDhxdC9DWDlGMzZ2eG1nS3U5NGNtS0gzT0VaSGEvN1A3SjYyc2JLU2ZySmdxUW5sS0FMaXhRZDR4NFNmd1pVbUd2dzUzZGtPWGpTRzh3K0Vpd2dFTGhiSzZsajRQRWhJbDlBVWVYT2lGd3RxS0FrblkwMkNuTC9aTkxUdVlTUWt5STNHVFFpOGdLSkF0Mks3ZWYweEs4ZjJlRjUwakpxMW9XMjMzTFlNYVN4Syt5MlZlTDZSQmhJUDFSVktPZ2dnVXhNSUlGTFRDQ0JTa3dnZ01Sb0FNQ0FRSUNFR055NnZkY0hFMnhKNlZmZDkyZmRoc3dEUVlKS29aSWh2Y05BUUVMQlFBd1NqRWhNQjhHQTFVRUF3d1lVMU5NTG1OdmJTQkRNbEJCSUVsRFFTQlNNU0F5TURJMU1SZ3dGZ1lEVlFRS0RBOVRVMHdnUTI5eWNHOXlZWFJwYjI0eEN6QUpCZ05WQkFZVEFsVlRNQjRYRFRJMk1ERXdNakl4TVRFMU5Wb1hEVEkzTURFd01qSXhNVEUxTkZvd1RURUxNQWtHQTFVRUJoTUNWVk14RVRBUEJnTlZCQW9NQ0ZOVGJDQkRiM0p3TVNzd0tRWURWUVFERENKVFUwd3VZMjl0SUVNeVVFRWdTVU5CSUZJeElFOURVMUFnVW1WemNHOXVaR1Z5TUlJQm9qQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FZOEFNSUlCaWdLQ0FZRUF6NEp2aXlOdDJhcVBaRTMyR0Y3LzRLcHhzcXlPSExMY3BhWEllR1FxbjVvMXJGZXJLSGJEMmx3SG5pYXlGTUxoYUVGMFVTQ1JTZUFZRXNnWThNWFYyM1Qwd2RSemZuZ1VQV2ZvSVR0b09pWW5IYVRrNllpbm50dFpZMGUvSnpmcVBnc1BUaUg4c3NMdnNpS0VZZmYzS3VPdDZRa1VJQ1pYWVdUemFvQ3NmbVU2cm5QZFROMm9hUmM3eFhkWTZkU3R5UFVGbnpTU1Q5MFZFcFIra0UySW9BSlBUNVQzMUhZbkdhWVlwdGpUb3lydDYyRGplVllKQVI5SmxLVmdjOHZDYkVIenozcDVsSzBSOVArUmVPZlRzMXR3Mi9LT2dkd0xpc3hINHFKS3ZCSU11cVZTVldWWlBhZUhnL1Y2dzFMOHpuWDA2SG5Fa1ZyMGM1VExkQnIrZllPTm55QWg5VWYrUTF2UERGNHRybnI2WFFMVVdjMnI1NmxMMk5VWmx3d3MwV01ZdmVvNkhOdjRWMThwV3RMTnJtUlFuc1AwZ0NMVGlxMml1NHR4bmVHNEpiUmVVblhsK3B3c0p3aTF3a3hjTzFETnJLMmdHRUtlZUpMZFpEc3RQclphT3BTSGNJMmFNeXZYN2dwUU15ekY0MjZ3a0Fvb2EzRmR4OVo1NE9ZbkFnTUJBQUdqZ1ljd2dZUXdEQVlEVlIwVEFRSC9CQUl3QURBZkJnTlZIU01FR0RBV2dCUTVQUkJIM0plUHI0aDdUWE1ZSGMzbDdxU2xLakFQQmdrckJnRUZCUWN3QVFVRUFnVUFNQk1HQTFVZEpRUU1NQW9HQ0NzR0FRVUZCd01KTUIwR0ExVWREZ1FXQkJRYysxZWl3QnRMeHJlZWkxVjFlajFVZm1SRFhUQU9CZ05WSFE4QkFmOEVCQU1DQjRBd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dJQkFESGx0V3QvZGh2WHd0c3FmZWtmajY3Y215L3YzaDdtZ1hqbk5hYWhVbHNNYm10Y2kzUnBHU29BZ00yV2lPR0diYm5YVnFDVHFXOGludFJXVkNtVTJyOHlMTUtNNmlSVVh6UXExMU5td3I5SDl2L3NuWWRSbmpSQkQ4dGtEMEY0ZmpHc05oeUhUSFVieHBNWnhyUk5BZTBhaC9HQU5mdFFCNC9IVDFvViszRUp2cHBqL3N1SGZvWWhsajhLZ2N4WGgvQlVKbmJkcUtYc2NhMGRsd1E2TjVubzBhWFNJY0NUby90djNrbGsvZG0xV3JBc09yOC92bEtpR0NuVTdiQXVpaXdiU2lNeCtxZXdocmFJbGJEYWtEeDcwbVpCTEs1cUZVdks5MU1DUHBpOWZMTEV0ZWtITkw4VUs1WkpLNmxDTWQ4Vndza3RucFc5RG1XNitYc3llMWpCOGF0V0ppbFFlRHMzQ29RcVFvZmhidlBmZkxzTElGSmZnMzFFbmRqRnNrcTE1Um5RZ01NRThkbkhBWmdnWlpyL2tVZnlyY3Q1VDE5SlFXWEN2QXhQcTFkMGpWdkgySWtZaTZZTjRCcStPWkptejdQNG5OdHltOXdJcU9COC95RE5na1hqUzQ3eFFkaitxWVBTZ3B5U2FYMHVWbkJwaThtNDlITHQrUDBlNnp2TXlPcTFVazhJcVNPVFpTNkJXOTZUQWNVZDJGZVBRTWNpR2xEak9YcUgrc1RCL0NGTGh2eCt2NUxjVDRaamlnVzlYa05FaEZjeUFlRHVpTis0UWhoVHAzclg1UGpaV21tVm55L0V6TWR4R0U3WWo2MVhYUnR0bSt4ODBlOUFFSzd3UXVpejA4a3l4Rk1XYVRuSE51N3luRVQ4UGNMbkF2bm4ybmxreHhVVQAAAMNqdW1iAAAAQGp1bWRjYm9yABEAEIAAAKoAOJtxE2MycGEuaGFzaC5kYXRhAAAAABhjMnNoMAqjUDg+qAG2EInG+lmIfwAAAHtjYm9ypWpleGNsdXNpb25zgaJlc3RhcnQYIWZsZW5ndGgZZztkbmFtZW5qdW1iZiBtYW5pZmVzdGNhbGdmc2hhMjU2ZGhhc2hYIE+KQDN4UlxmmeTORiiKi4AoBpY5Luxoq3rukL3dhobvY3BhZEgAAAAAAAAAAAAAAxpqdW1iAAAAJ2p1bWRjMmNsABEAEIAAAKoAOJtxA2MycGEuY2xhaW0udjIAAAAC62Nib3Kmamluc3RhbmNlSUR4LHhtcDppaWQ6MjkzYjY4ZWUtYzMyMS00NTkxLTkyYjktZDIxYWI2ZDIyOGZmdGNsYWltX2dlbmVyYXRvcl9pbmZvpGRuYW1leBhPcGVuQUkgTWVkaWEgU2VydmljZSBBUElkaWNvbqJjdXJseCRzZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmljb25kaGFzaFggyoOh4K4nVHQHuDZttsgnt15HWk1M8e9Urf350NjVnJ93b3JnLmNvbnRlbnRhdXRoLmMycGFfcnNmMC43OS4ya3NwZWNWZXJzaW9uZTIuMi4waXNpZ25hdHVyZXhNc2VsZiNqdW1iZj0vYzJwYS91cm46YzJwYTpjNDcxZjNjOC1hMTNjLTRhNjItYTQ3Ni0wMDI0MTlkMThiMTQvYzJwYS5zaWduYXR1cmVyY3JlYXRlZF9hc3NlcnRpb25zhKJjdXJseCRzZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmljb25kaGFzaFggyoOh4K4nVHQHuDZttsgnt15HWk1M8e9Urf350NjVnJ+iY3VybHgqc2VsZiNqdW1iZj1jMnBhLmFzc2VydGlvbnMvYzJwYS5hY3Rpb25zLnYyZGhhc2hYINHQ+tRla7jOBcTwZbLXJkgR9GknqJuSwVzZ5ZjOfDI2omN1cmx4MnNlbGYjanVtYmY9YzJwYS5hc3NlcnRpb25zL2MycGEuY2VydGlmaWNhdGUtc3RhdHVzZGhhc2hYIK/QqSoJPyHnH6MUdXHuxcsFXZEF7HVCPJ2gFSBvhIOfomN1cmx4KXNlbGYjanVtYmY9YzJwYS5hc3NlcnRpb25zL2MycGEuaGFzaC5kYXRhZGhhc2hYIAZqMRhyJfWsrUS/Kebz1qGKIVqCcBU2jZUMs7ajj9kbaGRjOnRpdGxlaWltYWdlLnBuZ2NhbGdmc2hhMjU2AABMu2p1bWIAAAAoanVtZGMyY3MAEQAQgAAAqgA4m3EDYzJwYS5zaWduYXR1cmUAAABMi2Nib3LShFkRg6IBOCQYIYNZBYgwggWEMIIDbKADAgECAhALpfzpDnCM8gWAMe5EHGRzMA0GCSqGSIb3DQEBCwUAMEoxITAfBgNVBAMMGFNTTC5jb20gQzJQQSBJQ0EgUjEgMjAyNTEYMBYGA1UECgwPU1NMIENvcnBvcmF0aW9uMQswCQYDVQQGEwJVUzAeFw0yNjA0MjIxNTUxMDVaFw0yNzA0MjMxNTUxMDRaMEcxCzAJBgNVBAYTAlVTMRkwFwYDVQQKDBBPcGVuQUkgT3BDbywgTExDMR0wGwYDVQQDDBRPcGVuQUkgTWVkaWEgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ26ahRMTQKX6oGJthbRvl5YThMDcqGZ32kUcXzlISPTgR+iNZxMoxJKPO9uK7/mZK7XhEtpJFpjz+p2CpCyZdt8ATyN4f7BBTN3ryfeOyA6tA9jh5gbzU2cGr+0fzMRRKpUMDdGuAf9mnlEC3NXVaMDYxF8HRLdrFgv5nqu3qWYwxOTTkjwWvjgfKSSS9VsusrCBSrIkr511JRntVcNqmqabTAwLNdVYYxq0lO2AHgdXkVDnk6SowOA8a9b0bLr/osZ7xa61zcJlatkLZnJh5r4HL8u0OdjgJYamnmgN5M2ozXJSMksmGMF6USbNR6suQinU2wdnGhzyAoeOcwGSfMCAwEAAaOCAWcwggFjMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUOT0QR9yXj6+Ie01zGB3N5e6kpSowbwYIKwYBBQUHAQEEYzBhMDkGCCsGAQ', 'approved', 'Auto-approved: added to map', '2026-05-05 22:32:26', '2026-05-05 22:59:57'),
(4, 2, 'درێم ستی', 'Dream city', 'دریم ستی', 'پارکەکا پێشکەفتیە و چەندین جهێن یاریکرنێ تێدا هەنە', 'is great  park', 'مدينة العاب', '36.8588058', '42.9808480', 1, 5, 'پارێزگەها دهوک', '07828388910', 'dreamcity@gmail.com', 'https://www.al-amingroup.com/dream-city', 'https://maps.app.goo.gl/dhTWZndtrCyXvX7i7', '24 hours', '5000', 'uploads/suggestions/suggestion_2_1778091183_69fb84af55fb9.jpg', 'data:image/jpeg;base64,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', 'approved', 'Auto-approved: added to map', '2026-05-06 18:13:03', '2026-05-06 22:25:43'),
(5, 2, '5rtyu', 'erty', 'ertgyhu', '5r658y8', 'ertgyui', 'w3er5t6', '35.5734958', '45.4413389', 3, 5, 'erytyui', '7502252222', 'admin@example.com', 'https://www.al-amingroup.com/dream-city', 'https://maps.app.goo.gl/AsPyWu9zCq29qqja8', '24 hours', '0', 'uploads/suggestions/suggestion_2_1778152959_69fc75ff1d67d.jpg', 'data:image/jpeg;base64,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', 'approved', 'Auto-approved: added to map', '2026-05-07 11:22:39', '2026-05-07 16:56:00');

-- --------------------------------------------------------

--
-- Table structure for table `location_visits`
--

CREATE TABLE `location_visits` (
  `id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_general_ci DEFAULT '',
  `user_agent` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `visited_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `location_visits`
--

INSERT INTO `location_visits` (`id`, `location_id`, `user_id`, `ip_address`, `user_agent`, `visited_at`) VALUES
(1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 12:54:37'),
(2, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 15:25:11'),
(3, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 15:29:53'),
(4, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 15:30:20'),
(5, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 08:51:04'),
(6, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 08:51:41'),
(7, 2, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 08:54:10'),
(8, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 08:54:53'),
(9, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 08:56:43'),
(10, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 08:57:12'),
(11, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 08:58:14'),
(12, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:04:21'),
(13, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:05:56'),
(14, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:06:40'),
(15, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:07:05'),
(16, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:07:15'),
(17, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:07:29'),
(18, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:08:25'),
(19, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:08:58'),
(20, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:09:24'),
(21, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:09:40'),
(22, 2, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:09:47'),
(23, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:36:57'),
(24, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:37:22'),
(25, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:37:59'),
(26, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:38:35'),
(27, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:39:35'),
(28, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:40:06'),
(29, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:41:06'),
(30, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:44:18'),
(31, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:47:46'),
(32, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:48:14'),
(33, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 09:49:09'),
(34, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 09:56:27'),
(35, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 10:00:23'),
(36, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 10:13:13'),
(37, 3, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 10:13:27'),
(38, 2, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 10:15:22'),
(39, 2, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-03-31 10:15:45'),
(40, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 20:59:47'),
(41, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 21:01:44'),
(42, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 21:03:40'),
(43, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 21:06:43'),
(44, 2, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-31 21:09:02'),
(45, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 21:12:14'),
(46, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 21:30:46'),
(47, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-31 21:34:55'),
(48, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-12 07:41:59'),
(49, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-12 07:43:11'),
(50, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-12 07:43:24'),
(51, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-12 07:43:29'),
(52, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-12 07:43:48'),
(53, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-12 07:45:53'),
(54, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 09:19:35'),
(55, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 09:32:47'),
(56, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 09:50:24'),
(57, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 10:08:18'),
(58, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 10:08:29'),
(59, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 10:16:43'),
(60, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 10:24:42'),
(61, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 10:36:15'),
(62, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 10:36:37'),
(63, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-12 11:00:02'),
(64, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-12 17:27:18'),
(65, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:29:22'),
(66, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:29:30'),
(67, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:36:58'),
(68, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:47:14'),
(69, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:47:17'),
(70, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:48:12'),
(71, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:48:21'),
(72, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:48:22'),
(73, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:49:28'),
(74, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:49:33'),
(75, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:49:40'),
(76, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 17:49:58'),
(77, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 18:35:37'),
(78, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 18:40:03'),
(79, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 18:40:18'),
(80, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 18:43:35'),
(81, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 18:48:26'),
(82, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 18:56:45'),
(83, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:03:22'),
(84, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:05:34'),
(85, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:17:19'),
(86, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:20:46'),
(87, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:23:23'),
(88, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:24:06'),
(89, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:24:19'),
(90, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:24:32'),
(91, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:50:43'),
(92, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-12 19:51:04'),
(93, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19 19:05:45'),
(94, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19 19:18:51'),
(95, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19 19:19:45'),
(96, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21 12:01:32'),
(97, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21 12:06:44'),
(98, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21 12:07:11'),
(99, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21 12:08:07'),
(100, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21 12:14:41'),
(101, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 09:59:15'),
(102, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:29:36'),
(103, 6, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:29:56'),
(104, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:32:11'),
(105, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:41:02'),
(106, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:41:45'),
(107, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:41:59'),
(108, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:56:20'),
(109, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:57:05'),
(110, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:59:32'),
(111, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 10:59:49'),
(112, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:03:41'),
(113, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:08:38'),
(114, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:29:42'),
(115, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:31:09'),
(116, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:49:21'),
(117, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:50:41'),
(118, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:51:46'),
(119, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:53:08'),
(120, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:57:21'),
(121, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:57:29'),
(122, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 11:57:35'),
(123, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:09:24'),
(124, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:16:10'),
(125, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:16:25'),
(126, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:17:59'),
(127, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:18:53'),
(128, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:19:17'),
(129, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:19:52'),
(130, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:20:04'),
(131, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:20:04'),
(132, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:20:05'),
(133, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:20:05'),
(134, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:20:48'),
(135, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:22:41'),
(136, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:23:00'),
(137, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:23:04'),
(138, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:23:06'),
(139, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:23:09'),
(140, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:23:16'),
(141, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:30:14'),
(142, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:30:24'),
(143, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-24 12:30:37'),
(144, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:10:07'),
(145, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:16:21'),
(146, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:17:30'),
(147, 6, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:18:10'),
(148, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:18:26'),
(149, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:18:46'),
(150, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:19:05'),
(151, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:19:11'),
(152, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:29:45'),
(153, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:33:00'),
(154, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 12:34:48'),
(155, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:35:12'),
(156, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 12:35:30'),
(157, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 12:36:05'),
(158, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 12:45:56'),
(159, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 12:48:43'),
(160, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 12:51:34'),
(161, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:01:15'),
(162, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:01:22'),
(163, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:02:22'),
(164, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:07:37'),
(165, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:09:30'),
(166, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:19:01'),
(167, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:27:28'),
(168, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:33:55'),
(169, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 13:35:39'),
(170, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 15:06:53'),
(171, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:07:55'),
(172, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:27:34'),
(173, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:27:36'),
(174, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:28:19'),
(175, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:30:06'),
(176, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:31:06'),
(177, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:32:00'),
(178, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:32:22'),
(179, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:32:32'),
(180, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:33:04'),
(181, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:33:16'),
(182, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:33:37'),
(183, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:34:37'),
(184, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:37:34'),
(185, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:38:59'),
(186, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:39:44'),
(187, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:42:14'),
(188, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:42:46'),
(189, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:43:02'),
(190, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:43:14'),
(191, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:43:49'),
(192, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 15:45:08'),
(193, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:01:25'),
(194, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:01:49'),
(195, 4, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:08:54'),
(196, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:13:04'),
(197, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:37:34'),
(198, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:41:22'),
(199, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:42:14'),
(200, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:42:33'),
(201, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:43:04'),
(202, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:45:13'),
(203, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:46:24'),
(204, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:46:32'),
(205, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:46:57'),
(206, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 16:48:04'),
(207, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 16:48:16'),
(208, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 16:48:20'),
(209, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 16:48:46'),
(210, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 16:49:09'),
(211, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-04-26 16:49:25'),
(212, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-04-26 16:49:48'),
(213, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:36:23'),
(214, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:36:34'),
(215, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:36:57'),
(216, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:39:30'),
(217, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:39:48'),
(218, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:40:00'),
(219, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:40:15'),
(220, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:40:56'),
(221, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:41:38'),
(222, 7, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:42:31'),
(223, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:43:25'),
(224, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 17:43:49'),
(225, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:44:28'),
(226, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:48:20'),
(227, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:48:43'),
(228, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:49:38'),
(229, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:50:09'),
(230, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:50:23'),
(231, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:50:43'),
(232, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:51:20'),
(233, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:51:32'),
(234, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:51:36'),
(235, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:52:11'),
(236, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:53:22'),
(237, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:56:10'),
(238, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:56:48'),
(239, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 17:59:03'),
(240, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:00:30'),
(241, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:00:45'),
(242, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:08:25'),
(243, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:10:15'),
(244, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:14:44'),
(245, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:15:00'),
(246, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:17:22'),
(247, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:19:02'),
(248, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:19:57'),
(249, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:21:00'),
(250, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:21:19'),
(251, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:22:41'),
(252, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:26:21'),
(253, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:27:25'),
(254, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:27:32'),
(255, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:28:28'),
(256, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:28:46'),
(257, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:29:28'),
(258, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:30:11'),
(259, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:30:18'),
(260, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:30:28'),
(261, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:31:02'),
(262, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:31:16'),
(263, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:31:33'),
(264, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:31:51'),
(265, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-26 18:32:29'),
(266, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-26 18:32:48'),
(267, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-26 18:32:59'),
(268, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-27 07:35:56'),
(269, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-27 07:36:24'),
(270, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:37:04'),
(271, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:42:09'),
(272, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:42:43'),
(273, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:42:59'),
(274, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:43:37'),
(275, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:46:00'),
(276, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:50:37'),
(277, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:54:09'),
(278, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:55:57'),
(279, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:56:23'),
(280, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:56:33'),
(281, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:56:37'),
(282, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 07:58:31'),
(283, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:07:12'),
(284, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:07:18'),
(285, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:12:44'),
(286, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:18:30'),
(287, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:21:19'),
(288, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:26:36'),
(289, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:39:37'),
(290, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:39:44'),
(291, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:40:48'),
(292, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:41:06'),
(293, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 08:48:33'),
(294, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:00:13'),
(295, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:00:41'),
(296, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:05:35'),
(297, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:05:45'),
(298, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:06:01'),
(299, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:10:10'),
(300, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:10:41'),
(301, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:15:02'),
(302, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:16:49'),
(303, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:17:09'),
(304, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:18:20'),
(305, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:21:09'),
(306, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:24:25'),
(307, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:26:43'),
(308, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:26:50'),
(309, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:27:25'),
(310, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:27:53'),
(311, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:28:14'),
(312, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:46:50'),
(313, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:47:44'),
(314, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:47:54');
INSERT INTO `location_visits` (`id`, `location_id`, `user_id`, `ip_address`, `user_agent`, `visited_at`) VALUES
(315, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:48:21'),
(316, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:50:05'),
(317, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:51:32'),
(318, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:52:16'),
(319, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:52:22'),
(320, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:52:53'),
(321, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:54:22'),
(322, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:54:59'),
(323, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:55:22'),
(324, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:55:35'),
(325, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:56:33'),
(326, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:56:51'),
(327, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:56:57'),
(328, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:57:20'),
(329, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:57:36'),
(330, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 09:57:49'),
(331, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:01:03'),
(332, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:02:42'),
(333, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:03:05'),
(334, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:04:15'),
(335, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:05:48'),
(336, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:06:17'),
(337, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:06:24'),
(338, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:06:29'),
(339, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:06:34'),
(340, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-27 10:07:38'),
(341, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-27 10:07:52'),
(342, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-27 10:08:21'),
(343, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-27 10:08:57'),
(344, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:12:20'),
(345, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:26:37'),
(346, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:27:15'),
(347, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:29:15'),
(348, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:31:39'),
(349, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:32:17'),
(350, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:42:44'),
(351, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:43:14'),
(352, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:43:53'),
(353, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:57:44'),
(354, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:58:07'),
(355, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:58:16'),
(356, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:58:27'),
(357, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:58:35'),
(358, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:58:40'),
(359, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:58:45'),
(360, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 10:58:57'),
(361, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:16:25'),
(362, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:17:19'),
(363, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:17:26'),
(364, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:17:26'),
(365, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:17:26'),
(366, 6, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:17:59'),
(367, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:19:29'),
(368, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:20:44'),
(369, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:21:24'),
(370, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-27 11:23:08'),
(371, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:28:40'),
(372, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:29:28'),
(373, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-27 11:30:05'),
(374, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:31:01'),
(375, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:31:11'),
(376, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:31:24'),
(377, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:31:36'),
(378, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:32:31'),
(379, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:33:35'),
(380, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:35:00'),
(381, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:35:58'),
(382, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:37:44'),
(383, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:39:09'),
(384, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 11:39:25'),
(385, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:16:00'),
(386, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:17:13'),
(387, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:18:47'),
(388, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:26:21'),
(389, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:27:01'),
(390, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:27:47'),
(391, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:29:16'),
(392, 4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:29:25'),
(393, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:31:25'),
(394, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:32:34'),
(395, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:33:06'),
(396, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:34:23'),
(397, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:36:32'),
(398, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:36:56'),
(399, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:37:32'),
(400, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:38:57'),
(401, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:47:50'),
(402, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:47:58'),
(403, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 12:50:55'),
(404, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 13:19:08'),
(405, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 13:49:29'),
(406, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 13:49:57'),
(407, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 14:00:35'),
(408, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 14:00:51'),
(409, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 14:00:51'),
(410, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-27 14:01:08'),
(411, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-28 13:33:41'),
(412, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:34:03'),
(413, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:34:49'),
(414, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:35:14'),
(415, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:35:45'),
(416, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:36:19'),
(417, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:36:19'),
(418, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:36:20'),
(419, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:36:20'),
(420, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:36:37'),
(421, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:36:51'),
(422, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:37:05'),
(423, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:37:47'),
(424, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:38:25'),
(425, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:38:36'),
(426, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:41:57'),
(427, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:44:41'),
(428, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:45:33'),
(429, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:46:34'),
(430, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:47:01'),
(431, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:48:00'),
(432, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:49:11'),
(433, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:49:20'),
(434, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:49:20'),
(435, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:51:14'),
(436, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:52:16'),
(437, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:52:38'),
(438, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:53:49'),
(439, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:54:26'),
(440, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 13:55:53'),
(441, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:03:31'),
(442, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:05:39'),
(443, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:05:49'),
(444, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:07:08'),
(445, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:10:59'),
(446, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:12:13'),
(447, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:13:22'),
(448, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:16:46'),
(449, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:22:04'),
(450, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:27:38'),
(451, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:27:52'),
(452, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:28:36'),
(453, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:28:53'),
(454, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:29:30'),
(455, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:29:49'),
(456, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:31:23'),
(457, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:32:05'),
(458, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:33:11'),
(459, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:33:45'),
(460, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:35:12'),
(461, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:36:23'),
(462, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:38:22'),
(463, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:39:25'),
(464, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:43:24'),
(465, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:45:13'),
(466, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:47:06'),
(467, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:50:09'),
(468, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 14:59:15'),
(469, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:02:56'),
(470, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:06:04'),
(471, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:07:50'),
(472, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:09:54'),
(473, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:12:55'),
(474, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:19:12'),
(475, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:22:21'),
(476, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:42:35'),
(477, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:48:38'),
(478, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:50:20'),
(479, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:50:45'),
(480, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:52:37'),
(481, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:57:36'),
(482, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 15:58:27'),
(483, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:00:58'),
(484, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:02:43'),
(485, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:03:03'),
(486, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:03:12'),
(487, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:03:46'),
(488, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:05:31'),
(489, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:05:53'),
(490, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:12:34'),
(491, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-28 16:16:32'),
(492, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 16:58:58'),
(493, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 16:59:18'),
(494, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 16:59:25'),
(495, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 17:01:31'),
(496, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-29 17:03:11'),
(497, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 17:13:59'),
(498, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 17:14:24'),
(499, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 18:20:19'),
(500, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 18:45:17'),
(501, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 19:03:00'),
(502, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 19:03:11'),
(503, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 19:06:43'),
(504, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 19:09:26'),
(505, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:09:25'),
(506, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:11:07'),
(507, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:13:28'),
(508, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:15:37'),
(509, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:20:12'),
(510, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:23:58'),
(511, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:26:39'),
(512, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:27:24'),
(513, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:27:49'),
(514, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:27:49'),
(515, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:27:49'),
(516, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:27:58'),
(517, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:28:02'),
(518, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:30:17'),
(519, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:32:13'),
(520, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:34:23'),
(521, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:34:55'),
(522, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:39:01'),
(523, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:45:59'),
(524, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:50:10'),
(525, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:52:37'),
(526, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:56:48'),
(527, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 20:58:55'),
(528, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:04:12'),
(529, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:04:35'),
(530, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:05:37'),
(531, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:06:11'),
(532, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:16:10'),
(533, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:18:15'),
(534, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:25:07'),
(535, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:25:16'),
(536, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-29 21:35:17'),
(537, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:35:40'),
(538, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:42:50'),
(539, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:42:52'),
(540, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:45:04'),
(541, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:45:22'),
(542, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:48:39'),
(543, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:48:57'),
(544, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:52:47'),
(545, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:53:21'),
(546, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:53:50'),
(547, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:54:03'),
(548, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:55:13'),
(549, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 21:56:10'),
(550, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:01:13'),
(551, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:02:10'),
(552, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:02:18'),
(553, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:02:33'),
(554, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:02:35'),
(555, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:09:12'),
(556, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:09:25'),
(557, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:09:31'),
(558, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:12:02'),
(559, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:17:27'),
(560, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:24:21'),
(561, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:24:23'),
(562, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:25:39'),
(563, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:26:19'),
(564, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:26:26'),
(565, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:26:33'),
(566, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:26:37'),
(567, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:31:59'),
(568, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:32:05'),
(569, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:32:34'),
(570, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:32:37'),
(571, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:33:20'),
(572, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:33:26'),
(573, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:47:32'),
(574, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:52:33'),
(575, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-29 22:59:15'),
(576, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 09:17:57'),
(577, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 09:18:38'),
(578, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 10:58:06'),
(579, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 10:59:41'),
(580, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:05:37'),
(581, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:10:36'),
(582, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:13:01'),
(583, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:30:16'),
(584, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:30:49'),
(585, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:36:00'),
(586, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:36:48'),
(587, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:36:48'),
(588, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:36:48'),
(589, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:36:48'),
(590, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 11:36:49'),
(591, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-04-30 16:40:07'),
(592, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 16:41:01'),
(593, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 16:41:28'),
(594, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 16:42:28'),
(595, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 16:49:34'),
(596, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 17:05:56'),
(597, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 17:45:35'),
(598, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 21:07:05');
INSERT INTO `location_visits` (`id`, `location_id`, `user_id`, `ip_address`, `user_agent`, `visited_at`) VALUES
(599, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 21:07:37'),
(600, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 21:07:47'),
(601, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 21:14:16'),
(602, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 21:14:47'),
(603, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 21:21:38'),
(604, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:16:39'),
(605, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:47:44'),
(606, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:47:56'),
(607, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:49:56'),
(608, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:51:17'),
(609, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:51:18'),
(610, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:51:18'),
(611, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-04-30 22:51:18'),
(612, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:12:05'),
(613, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:13:19'),
(614, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:16:30'),
(615, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-01 22:20:09'),
(616, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-01 22:20:14'),
(617, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-01 22:21:13'),
(618, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:33:24'),
(619, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:33:26'),
(620, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:33:52'),
(621, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:33:59'),
(622, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:34:20'),
(623, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:34:26'),
(624, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:34:41'),
(625, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:39:25'),
(626, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:39:52'),
(627, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:40:29'),
(628, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:41:47'),
(629, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:45:21'),
(630, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-01 22:45:25'),
(631, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:45:52'),
(632, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:49:46'),
(633, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:51:20'),
(634, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:51:34'),
(635, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:52:41'),
(636, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-01 22:53:37'),
(637, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 23:02:09'),
(638, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-01 23:04:19'),
(639, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:14:56'),
(640, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:23:00'),
(641, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:25:48'),
(642, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:27:38'),
(643, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:32:47'),
(644, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:37:32'),
(645, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:40:46'),
(646, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:46:49'),
(647, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:51:43'),
(648, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:55:17'),
(649, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:56:18'),
(650, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:58:56'),
(651, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:59:12'),
(652, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:59:41'),
(653, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 07:59:53'),
(654, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 08:20:38'),
(655, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 08:26:28'),
(656, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 08:32:55'),
(657, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-02 08:36:36'),
(658, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-02 08:37:14'),
(659, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 08:38:05'),
(660, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1', '2026-05-02 08:41:23'),
(661, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1', '2026-05-02 08:50:21'),
(662, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1', '2026-05-02 08:50:25'),
(663, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 08:56:05'),
(664, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1', '2026-05-02 08:59:11'),
(665, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1', '2026-05-02 08:59:59'),
(666, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:00:13'),
(667, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-02 09:00:50'),
(668, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:01:04'),
(669, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:01:18'),
(670, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:01:28'),
(671, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-02 09:01:50'),
(672, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:02:52'),
(673, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:06:17'),
(674, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:06:58'),
(675, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-02 09:08:37'),
(676, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-02 09:11:33'),
(677, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-02 09:12:01'),
(678, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-02 09:13:14'),
(679, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 09:14:04'),
(680, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 09:14:50'),
(681, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-02 09:26:53'),
(682, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:27:12'),
(683, 6, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 09:29:02'),
(684, 6, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 09:29:08'),
(685, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:31:41'),
(686, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:33:55'),
(687, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:34:04'),
(688, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:35:23'),
(689, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:39:35'),
(690, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:47:56'),
(691, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:48:20'),
(692, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:49:49'),
(693, 3, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:50:21'),
(694, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 09:50:34'),
(695, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:50:54'),
(696, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 09:55:03'),
(697, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 10:02:20'),
(698, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 10:02:22'),
(699, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 10:06:41'),
(700, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 10:07:31'),
(701, 2, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 10:48:14'),
(702, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 10:52:12'),
(703, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 10:59:58'),
(704, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:03:46'),
(705, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:11:06'),
(706, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:11:53'),
(707, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:12:21'),
(708, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:12:52'),
(709, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:13:19'),
(710, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:14:06'),
(711, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:16:20'),
(712, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:18:02'),
(713, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:22:09'),
(714, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:22:14'),
(715, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:22:23'),
(716, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:22:50'),
(717, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:23:32'),
(718, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:23:56'),
(719, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:23:58'),
(720, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:24:12'),
(721, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:25:17'),
(722, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:26:26'),
(723, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:26:29'),
(724, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:26:55'),
(725, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:26:58'),
(726, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:27:03'),
(727, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:27:47'),
(728, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:28:26'),
(729, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:28:29'),
(730, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:28:41'),
(731, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:28:51'),
(732, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:29:20'),
(733, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:29:26'),
(734, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:30:06'),
(735, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:30:14'),
(736, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:30:18'),
(737, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:30:51'),
(738, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:30:57'),
(739, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:32:01'),
(740, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:32:45'),
(741, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:33:18'),
(742, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:34:40'),
(743, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:34:42'),
(744, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:36:03'),
(745, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:36:06'),
(746, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:42:29'),
(747, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:43:56'),
(748, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:43:58'),
(749, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:45:26'),
(750, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:45:29'),
(751, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:45:33'),
(752, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:47:15'),
(753, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:47:18'),
(754, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:49:49'),
(755, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:50:37'),
(756, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 11:50:39'),
(757, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:57:24'),
(758, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 11:57:45'),
(759, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 12:01:38'),
(760, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:02:12'),
(761, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:02:16'),
(762, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:04:54'),
(763, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:05:11'),
(764, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:05:20'),
(765, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:05:33'),
(766, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:05:49'),
(767, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 12:05:51'),
(768, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 12:06:48'),
(769, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 12:09:38'),
(770, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:10:00'),
(771, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:10:19'),
(772, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:11:11'),
(773, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:12:02'),
(774, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:12:13'),
(775, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:13:21'),
(776, 5, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:13:32'),
(777, 3, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:13:41'),
(778, 2, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-02 12:13:53'),
(779, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 13:37:05'),
(780, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 13:37:09'),
(781, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 13:37:09'),
(782, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 20:11:03'),
(783, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 20:11:54'),
(784, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:08:05'),
(785, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:08:25'),
(786, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:13:11'),
(787, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:42:42'),
(788, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:47:12'),
(789, 8, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:49:40'),
(790, 8, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:50:56'),
(791, 8, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-02 21:51:11'),
(792, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 21:51:54'),
(793, 8, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 21:52:38'),
(794, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 22:00:12'),
(795, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 22:00:59'),
(796, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 22:02:39'),
(797, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 22:10:49'),
(798, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:16:14'),
(799, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:19:55'),
(800, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:23:19'),
(801, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:31:41'),
(802, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:37:03'),
(803, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:46:37'),
(804, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:51:03'),
(805, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-02 22:57:09'),
(806, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:03:55'),
(807, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:05:15'),
(808, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:05:31'),
(809, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:10:18'),
(810, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:19:52'),
(811, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:20:09'),
(812, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:20:40'),
(813, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:23:17'),
(814, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:23:29'),
(815, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:27:13'),
(816, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:29:04'),
(817, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:29:16'),
(818, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:34:03'),
(819, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-02 23:35:13'),
(820, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 09:52:51'),
(821, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 09:59:48'),
(822, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:00:11'),
(823, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:08:02'),
(824, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:18:36'),
(825, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 10:30:19'),
(826, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:33:36'),
(827, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:41:43'),
(828, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:48:50'),
(829, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:51:57'),
(830, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 10:54:44'),
(831, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 11:02:00'),
(832, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 11:04:37'),
(833, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 11:15:22'),
(834, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 11:32:57'),
(835, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 11:38:47'),
(836, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 11:40:06'),
(837, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 11:46:19'),
(838, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 11:52:39'),
(839, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 11:59:23'),
(840, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:05:05'),
(841, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 12:11:05'),
(842, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:11:10'),
(843, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:11:24'),
(844, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:11:49'),
(845, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:12:31'),
(846, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 12:13:26'),
(847, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:14:41'),
(848, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:31:35'),
(849, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:33:39'),
(850, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:41:22'),
(851, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:44:39'),
(852, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:56:43'),
(853, 5, NULL, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 12:57:14'),
(854, NULL, NULL, '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Safari/605.1.15', '2026-05-03 13:12:34'),
(855, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:18:45'),
(856, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:20:36'),
(857, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:25:19'),
(858, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 13:25:36'),
(859, 5, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 13:25:53'),
(860, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:26:17'),
(861, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:30:17'),
(862, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 13:30:51'),
(863, 3, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 13:31:57'),
(864, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:32:42'),
(865, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:47:51'),
(866, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:54:36'),
(867, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 13:55:48'),
(868, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 13:58:22'),
(869, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 13:59:20'),
(870, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 14:03:16'),
(871, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 14:05:11'),
(872, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 14:12:26'),
(873, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 14:13:03'),
(874, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 14:13:33'),
(875, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-05-03 14:15:22'),
(876, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 21:41:24'),
(877, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 21:41:59'),
(878, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-03 21:57:12'),
(879, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:11:07'),
(880, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:11:58'),
(881, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:12:17'),
(882, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:20:28'),
(883, 8, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:20:45'),
(884, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:21:01'),
(885, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:21:04'),
(886, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:21:05');
INSERT INTO `location_visits` (`id`, `location_id`, `user_id`, `ip_address`, `user_agent`, `visited_at`) VALUES
(887, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:27:30'),
(888, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:34:07'),
(889, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:40:57'),
(890, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:44:51'),
(891, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-03 22:48:14'),
(892, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:05:13'),
(893, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:05:30'),
(894, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:06:42'),
(895, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:08:50'),
(896, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:20:56'),
(897, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:21:07'),
(898, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:21:22'),
(899, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:21:35'),
(900, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:22:33'),
(901, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:22:48'),
(902, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:25:03'),
(903, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:25:28'),
(904, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:25:30'),
(905, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 10:37:49'),
(906, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:06:13'),
(907, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:07:18'),
(908, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:07:22'),
(909, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:07:35'),
(910, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:07:36'),
(911, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:07:37'),
(912, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-04 11:08:16'),
(913, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-04 11:08:18'),
(914, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-04 11:08:25'),
(915, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-04 11:08:26'),
(916, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:08:38'),
(917, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:08:41'),
(918, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:08:42'),
(919, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:08:43'),
(920, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:13:22'),
(921, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:13:41'),
(922, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:16:13'),
(923, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:20:12'),
(924, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:20:39'),
(925, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:29:47'),
(926, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:30:52'),
(927, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:32:21'),
(928, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:33:34'),
(929, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:44:11'),
(930, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:45:16'),
(931, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:46:18'),
(932, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:46:25'),
(933, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:46:38'),
(934, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:46:46'),
(935, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:47:21'),
(936, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:47:34'),
(937, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:47:40'),
(938, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:47:41'),
(939, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:48:11'),
(940, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:52:44'),
(941, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:54:20'),
(942, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:55:01'),
(943, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:56:07'),
(944, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:56:31'),
(945, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:58:56'),
(946, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:00:12'),
(947, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:03:58'),
(948, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:04:59'),
(949, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:05:06'),
(950, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:05:10'),
(951, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:05:14'),
(952, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:28:28'),
(953, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:38:55'),
(954, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:38:59'),
(955, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:39:55'),
(956, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:50:53'),
(957, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:51:22'),
(958, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:51:39'),
(959, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:54:47'),
(960, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:54:52'),
(961, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:55:02'),
(962, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:55:07'),
(963, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:55:51'),
(964, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:56:26'),
(965, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:56:36'),
(966, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:58:33'),
(967, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:58:47'),
(968, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:00:12'),
(969, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:00:27'),
(970, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:00:33'),
(971, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:09:47'),
(972, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:09:58'),
(973, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:06'),
(974, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:22'),
(975, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:27'),
(976, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:32'),
(977, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:44'),
(978, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:48'),
(979, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:12:23'),
(980, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:15:06'),
(981, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:15:15'),
(982, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:15:19'),
(983, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:15:23'),
(984, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:18:32'),
(985, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:18:37'),
(986, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:18:42'),
(987, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:18:43'),
(988, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:18:59'),
(989, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:19:07'),
(990, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:19:17'),
(991, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:28:56'),
(992, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:29:12'),
(993, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:29:18'),
(994, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:29:31'),
(995, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:29:42'),
(996, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:30:03'),
(997, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:30:12'),
(998, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:31:33'),
(999, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:32:13'),
(1000, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:32:41'),
(1001, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:37:57'),
(1002, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:04:54'),
(1003, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:04:56'),
(1004, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:05:01'),
(1005, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:05:03'),
(1006, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:05:11'),
(1007, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:05:20'),
(1008, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:44:38'),
(1009, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:44:43'),
(1010, NULL, 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:46:15'),
(1011, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:47:21'),
(1012, NULL, 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:47:28'),
(1013, 3, 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:47:40'),
(1014, 5, 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:47:49'),
(1015, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:17:56'),
(1016, NULL, 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:18:19'),
(1017, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:18:34'),
(1018, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:20:55'),
(1019, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:21:37'),
(1020, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:21:45'),
(1021, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:21:55'),
(1022, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:22:03'),
(1023, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:26:48'),
(1024, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:26:56'),
(1025, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:30:46'),
(1026, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:39:08'),
(1027, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:44:00'),
(1028, NULL, 7, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:55:41'),
(1029, NULL, 7, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:01:12'),
(1030, 5, 7, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:02:27'),
(1031, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:13:01'),
(1032, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:14:12'),
(1033, 5, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:14:43'),
(1034, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:15:28'),
(1035, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:24:41'),
(1036, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:25:10'),
(1037, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:26:12'),
(1038, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:31:36'),
(1039, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:31:48'),
(1040, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:32:33'),
(1041, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:32:37'),
(1042, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:32:39'),
(1043, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:32:50'),
(1044, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:34:33'),
(1045, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:37:38'),
(1046, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:38:02'),
(1047, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:38:44'),
(1048, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:46:44'),
(1049, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:47:17'),
(1050, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:52:03'),
(1051, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:52:21'),
(1052, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:52:23'),
(1053, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:52:44'),
(1054, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:52:54'),
(1055, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:53:15'),
(1056, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:53:35'),
(1057, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:53:53'),
(1058, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 22:00:24'),
(1059, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 22:00:37'),
(1060, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 22:01:40'),
(1061, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 22:01:43'),
(1062, 3, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 22:01:56'),
(1063, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 22:02:38'),
(1064, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 22:03:58'),
(1065, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:22:16'),
(1066, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:22:31'),
(1067, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:23:19'),
(1068, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:23:27'),
(1069, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:24:29'),
(1070, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:24:45'),
(1071, 2, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:24:57'),
(1072, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:27:30'),
(1073, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:27:53'),
(1074, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:35:30'),
(1075, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:35:48'),
(1076, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:36:37'),
(1077, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:36:42'),
(1078, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:38:54'),
(1079, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:50:29'),
(1080, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:50:43'),
(1081, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 13:53:05'),
(1082, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 13:56:22'),
(1083, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:56:55'),
(1084, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:16:17'),
(1085, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:16:43'),
(1086, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:16:58'),
(1087, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:17:20'),
(1088, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:18:14'),
(1089, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:18:28'),
(1090, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:18:51'),
(1091, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:20:43'),
(1092, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:21:02'),
(1093, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:24:35'),
(1094, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:39:20'),
(1095, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:41:23'),
(1096, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:41:52'),
(1097, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:42:32'),
(1098, NULL, 6, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:43:38'),
(1099, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:44:10'),
(1100, NULL, 6, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:44:19'),
(1101, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:44:36'),
(1102, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:45:16'),
(1103, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:45:44'),
(1104, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:46:01'),
(1105, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:55:41'),
(1106, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:56:10'),
(1107, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 15:06:27'),
(1108, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 15:30:01'),
(1109, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 15:31:54'),
(1110, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 15:32:29'),
(1111, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 15:57:36'),
(1112, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 16:06:37'),
(1113, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 16:06:39'),
(1114, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:07:14'),
(1115, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:07:16'),
(1116, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:07:19'),
(1117, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:20:08'),
(1118, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:21:20'),
(1119, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:22:35'),
(1120, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:22:44'),
(1121, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:32:09'),
(1122, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:33:43'),
(1123, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:33:55'),
(1124, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:34:10'),
(1125, NULL, 8, '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 Edg/147.0.0.0', '2026-05-05 16:39:46'),
(1126, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-05 16:41:18'),
(1127, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-05 16:42:25'),
(1128, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-05 16:42:53'),
(1129, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:06:24'),
(1130, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:06:30'),
(1131, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:06:46'),
(1132, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:07:11'),
(1133, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:08:17'),
(1134, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:08:28'),
(1135, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:50:01'),
(1136, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:53:08'),
(1137, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:06:23'),
(1138, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:07:00'),
(1139, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:08:04'),
(1140, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:08:06'),
(1141, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:08:07'),
(1142, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:11:51'),
(1143, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:25:48'),
(1144, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:28:40'),
(1145, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:28:50'),
(1146, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:28:56'),
(1147, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:29:36'),
(1148, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:30:34'),
(1149, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:32:53'),
(1150, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:35:04'),
(1151, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:39:22'),
(1152, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:41:03'),
(1153, NULL, 1, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 21:42:13'),
(1154, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:45:33'),
(1155, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:52:05'),
(1156, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 21:55:06'),
(1157, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:00:49'),
(1158, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:00:55'),
(1159, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:01:01'),
(1160, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:01:20'),
(1161, NULL, 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:09:58'),
(1162, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:22:01'),
(1163, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:22:04'),
(1164, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:22:13'),
(1165, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:23:15'),
(1166, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:31:28'),
(1167, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:31:39'),
(1168, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:32:45'),
(1169, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:00:13'),
(1170, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:00:19'),
(1171, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:01:01'),
(1172, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:03:23'),
(1173, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:03:28'),
(1174, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:03:59'),
(1175, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:10:34'),
(1176, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:11:03'),
(1177, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:14:48'),
(1178, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:14:54'),
(1179, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 17:50:41'),
(1180, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 17:51:29'),
(1181, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 17:51:35'),
(1182, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 17:51:51'),
(1183, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 17:52:06'),
(1184, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:13:20'),
(1185, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:14:01'),
(1186, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:14:54'),
(1187, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:15:02'),
(1188, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:15:46'),
(1189, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:15:50'),
(1190, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:16:06'),
(1191, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:16:20'),
(1192, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:24:30');
INSERT INTO `location_visits` (`id`, `location_id`, `user_id`, `ip_address`, `user_agent`, `visited_at`) VALUES
(1193, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:25:56'),
(1194, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:25:58'),
(1195, 5, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:26:36'),
(1196, 12, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:26:45'),
(1197, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:43:51'),
(1198, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:44:44'),
(1199, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:50:27'),
(1200, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:56:59'),
(1201, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 22:57:19'),
(1202, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 23:00:03'),
(1203, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 23:00:39'),
(1204, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 23:04:59'),
(1205, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 23:09:01'),
(1206, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:10:40'),
(1207, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:10:53'),
(1208, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:13:20'),
(1209, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:23:43'),
(1210, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:23:45'),
(1211, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:23:46'),
(1212, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:23:46'),
(1213, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:27:26'),
(1214, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:35:42'),
(1215, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:36:08'),
(1216, 12, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:36:16'),
(1217, 12, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:36:28'),
(1218, 2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:36:50'),
(1219, 5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:36:59'),
(1220, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:37:14'),
(1221, NULL, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:39:31'),
(1222, NULL, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:39:41'),
(1223, NULL, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:39:42'),
(1224, NULL, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:43:44'),
(1225, 12, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:43:57'),
(1226, NULL, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:44:20'),
(1227, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:44:29'),
(1228, NULL, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:44:35'),
(1229, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:44:40'),
(1230, NULL, 9, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:44:48'),
(1231, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:44:53'),
(1232, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:45:02'),
(1233, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:45:24'),
(1234, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:45:28'),
(1235, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:45:40'),
(1236, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:46:06'),
(1237, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:46:25'),
(1238, 5, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:46:28'),
(1239, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:46:34'),
(1240, 7, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:46:39'),
(1241, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:50:05'),
(1242, 6, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:50:19'),
(1243, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:51:08'),
(1244, 7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:51:15'),
(1245, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:51:34'),
(1246, 3, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:51:40'),
(1247, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:51:53'),
(1248, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:51:53'),
(1249, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:51:54'),
(1250, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:57:49'),
(1251, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:58:44'),
(1252, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-06 23:58:51'),
(1253, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:04:46'),
(1254, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:06:46'),
(1255, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:06:54'),
(1256, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:09:54'),
(1257, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:15:17'),
(1258, 5, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:15:26'),
(1259, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:15:36'),
(1260, 5, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:15:45'),
(1261, 7, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:15:54'),
(1262, NULL, NULL, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:19:53'),
(1263, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:20:09'),
(1264, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:21:54'),
(1265, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:22:30'),
(1266, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:23:26'),
(1267, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:23:43'),
(1268, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:23:54'),
(1269, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:25:24'),
(1270, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:25:26'),
(1271, NULL, 8, '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 Edg/147.0.0.0', '2026-05-07 00:25:56'),
(1272, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:31:04'),
(1273, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:32:01'),
(1274, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:32:01'),
(1275, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 00:32:47'),
(1276, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:34:32'),
(1277, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:41:11'),
(1278, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:41:45'),
(1279, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:41:46'),
(1280, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:41:46'),
(1281, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:41:46'),
(1282, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:41:47'),
(1283, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:41:47'),
(1284, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:49:33'),
(1285, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:50:39'),
(1286, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 00:57:38'),
(1287, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 10:45:12'),
(1288, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 10:45:44'),
(1289, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 10:46:04'),
(1290, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 11:10:36'),
(1291, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 11:19:11'),
(1292, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 12:16:31'),
(1293, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 12:17:50'),
(1294, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 12:18:14'),
(1295, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 12:18:55'),
(1296, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 12:28:54'),
(1297, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 12:41:39'),
(1298, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 13:17:15'),
(1299, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 13:17:37'),
(1300, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 13:18:18'),
(1301, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 13:19:04'),
(1302, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 13:19:19'),
(1303, NULL, 2, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 16:10:54'),
(1304, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:11:19'),
(1305, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:17:14'),
(1306, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:20:03'),
(1307, 4, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:20:54'),
(1308, 8, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:21:42'),
(1309, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:30:09'),
(1310, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:33:57'),
(1311, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:39:38'),
(1312, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:39:45'),
(1313, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:40:08'),
(1314, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:53:56'),
(1315, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:54:42'),
(1316, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:54:59'),
(1317, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:56:05'),
(1318, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:56:32'),
(1319, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:56:36'),
(1320, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:57:07'),
(1321, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:57:12'),
(1322, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:57:12'),
(1323, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:57:15'),
(1324, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:57:57'),
(1325, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:58:36'),
(1326, 12, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:58:40'),
(1327, 12, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 16:58:44'),
(1328, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:02:59'),
(1329, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:21'),
(1330, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:24'),
(1331, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:29'),
(1332, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:30'),
(1333, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:30'),
(1334, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:30'),
(1335, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:31'),
(1336, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:31'),
(1337, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:31'),
(1338, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:33'),
(1339, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:37'),
(1340, 12, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:03:42'),
(1341, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:01'),
(1342, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:05'),
(1343, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:13'),
(1344, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:18'),
(1345, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:18'),
(1346, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:18'),
(1347, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:22'),
(1348, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 17:10:33'),
(1349, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:44'),
(1350, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:45'),
(1351, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:45'),
(1352, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:50'),
(1353, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:51'),
(1354, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:53'),
(1355, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:10:59'),
(1356, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:11:40'),
(1357, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:19:01'),
(1358, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:19:36'),
(1359, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:19:39'),
(1360, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:19:48'),
(1361, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:20:42'),
(1362, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:24:24'),
(1363, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:24:28'),
(1364, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:25:01'),
(1365, 12, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:25:05'),
(1366, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:25:11'),
(1367, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:25:11'),
(1368, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:25:12'),
(1369, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:25:17'),
(1370, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 17:25:48'),
(1371, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 17:26:05'),
(1372, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 17:26:06'),
(1373, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:02:23'),
(1374, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 18:14:20'),
(1375, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 18:25:17'),
(1376, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:25:28'),
(1377, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:25:39'),
(1378, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:28:45'),
(1379, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:28:57'),
(1380, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:28:58'),
(1381, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:28:58'),
(1382, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:29:04'),
(1383, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:34:47'),
(1384, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:35:02'),
(1385, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:35:26'),
(1386, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:46:17'),
(1387, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 18:47:01'),
(1388, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:48:03'),
(1389, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:48:38'),
(1390, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 18:51:33'),
(1391, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 18:52:01'),
(1392, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:07:12'),
(1393, NULL, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:13:06'),
(1394, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:14:13'),
(1395, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:15:22'),
(1396, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:15:34'),
(1397, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:16:29'),
(1398, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:16:55'),
(1399, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:18:19'),
(1400, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:18:57'),
(1401, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:19:28'),
(1402, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:24:48'),
(1403, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:25:30'),
(1404, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:26:09'),
(1405, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:26:27'),
(1406, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0', '2026-05-07 19:26:56'),
(1407, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:29:59'),
(1408, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:30:44'),
(1409, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:30:51'),
(1410, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:31:13'),
(1411, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:31:27'),
(1412, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:36:18'),
(1413, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:40:04'),
(1414, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:41:20'),
(1415, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:54:46'),
(1416, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:02:54'),
(1417, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:07:23'),
(1418, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:07:47'),
(1419, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:09:52'),
(1420, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:09:55'),
(1421, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:14:31'),
(1422, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:16:28'),
(1423, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:16:36'),
(1424, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:16:48'),
(1425, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:17:13'),
(1426, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:17:20'),
(1427, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:18:21'),
(1428, 12, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:19:07'),
(1429, 10, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:19:20'),
(1430, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:32:44'),
(1431, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:32:56'),
(1432, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:33:29'),
(1433, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:33:36'),
(1434, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:38:00'),
(1435, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:38:27'),
(1436, NULL, NULL, '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 20:39:27'),
(1437, NULL, 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:39:38'),
(1438, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:39:43'),
(1439, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:39:53'),
(1440, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:40:16'),
(1441, 3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:40:28'),
(1442, NULL, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:40:34'),
(1443, 3, 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:40:40'),
(1444, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:41:27'),
(1445, NULL, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:42:29'),
(1446, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:43:35'),
(1447, NULL, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:46:20'),
(1448, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:46:25'),
(1449, NULL, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:46:29'),
(1450, 3, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:46:35'),
(1451, NULL, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:48:23'),
(1452, NULL, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:49:22');

-- --------------------------------------------------------

--
-- Table structure for table `photos`
--

CREATE TABLE `photos` (
  `id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '',
  `description` text COLLATE utf8mb4_general_ci,
  `image_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `thumbnail_path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `file_size` int(11) DEFAULT '0',
  `width` int(11) DEFAULT '0',
  `height` int(11) DEFAULT '0',
  `likes_count` int(11) NOT NULL DEFAULT '0',
  `views_count` int(11) NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('published','pending','rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'published',
  `exif_data` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '',
  `comment` text COLLATE utf8mb4_general_ci NOT NULL,
  `photos` json DEFAULT NULL,
  `helpful_count` int(11) NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('published','pending','rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `setting_key` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_value` text COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('allow_feedback', '1'),
('allow_registration', '1'),
('default_language', 'ku'),
('email_notifications', '1'),
('feedback_moderation', '1'),
('locations_per_page', '12');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(80) DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT 'ku',
  `bio` text,
  `avatar` varchar(255) DEFAULT NULL,
  `status` enum('active','suspended','deleted') NOT NULL DEFAULT 'active',
  `marked_for_deletion_at` timestamp NULL DEFAULT NULL,
  `deletion_reason` varchar(255) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` enum('user','guide','admin') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `verification_code` varchar(10) DEFAULT NULL,
  `verification_token` varchar(64) DEFAULT NULL,
  `code_expires_at` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `login_count` int(11) NOT NULL DEFAULT '0',
  `reset_token` varchar(64) DEFAULT NULL,
  `reset_expires` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `phone`, `language`, `bio`, `avatar`, `status`, `marked_for_deletion_at`, `deletion_reason`, `full_name`, `role`, `created_at`, `is_verified`, `verification_code`, `verification_token`, `code_expires_at`, `last_login`, `login_count`, `reset_token`, `reset_expires`) VALUES
(1, 'Kurd@gmail.com', 'Kurd@gmail.com', '$2y$10$Q/618PTOoSMysyFJriinjOdTBVsQjoZIuw2K45tBVnIrHvruAS/US', '1234567890', 'en', 'This is a test bio update', NULL, 'active', NULL, NULL, 'kurd test', 'user', '2026-05-03 22:34:52', 0, '667068', NULL, '2026-05-03 22:49:52', '2026-05-07 20:40:33', 5, NULL, NULL),
(2, 'Kurdirang21@gmail.com', 'Kurdirang@gmail.com', '$2y$10$26imt9lRQX1kav1ELuJHI.Nj4EKT8E5jKCjGQ0jTQ8JxkLI3023La', '07500000000', 'ku', 'wufiewivjci', NULL, 'active', NULL, NULL, 'Kurdirang21', 'user', '2026-05-03 22:36:00', 1, NULL, NULL, NULL, '2026-05-07 20:39:37', 30, '79abef385b9b95b2faff00828a8923a1a7336d5623881c94117eeddd47b1247c', '2026-05-04 13:55:43'),
(3, 'rasheed@gmail.com', 'rasheed@gmail.com', '$2y$10$gS0C3xZZED9hm9WZMYWjaOsjARAVTbYx2Sr1RtU4uzE8XLRZNCxku', '075502698301', 'ku', 'Kurdim', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQVFhUWFxYYGBgYFhkaHRsbGBoaFxgYGBYbHyogGRolHh8eITEiJykrLi4uGh8zODMsNygtLisBCgoKDg0OGxAQGi0lHyUtLS0rMC0tLS0tLS0tMC0tLS0tLy0tLS0tLy0tLS0tLS0tLy0tLS0tLS0tLS0tLS0tLf/AABEIAMIBAwMBIgACEQEDEQH/', 'active', NULL, NULL, 'rasheed@gmail.com', 'user', '2026-05-03 22:42:14', 1, NULL, NULL, NULL, '2026-05-04 13:10:05', 3, NULL, NULL),
(10, 'qqq', 'ttt@gm.com', '$2y$10$aPHgl2a3TLkkCXUuPx9.A.rT8FvSJakyWJmwESV5KcNrI/SC6uanK', '07828388910', 'ku', NULL, NULL, 'active', NULL, NULL, 'tofo', 'user', '2026-05-07 20:42:28', 0, NULL, '0f6bf22db61a9c907826f5268d6cd03eabc270f662dcf80cf00df9ace6ed027b', NULL, '2026-05-07 20:46:29', 3, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_activities`
--

CREATE TABLE `user_activities` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `activity_type` varchar(50) NOT NULL,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(50) DEFAULT '',
  `ip_address` varchar(45) DEFAULT '',
  `user_agent` varchar(255) DEFAULT '',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_activities`
--

INSERT INTO `user_activities` (`id`, `user_id`, `activity_type`, `target_id`, `target_type`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 3, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:07:16'),
(2, 3, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:07:20'),
(3, 1, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:46:46'),
(4, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 11:52:44'),
(5, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:05:09'),
(6, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:05:13'),
(7, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:38:54'),
(8, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:38:59'),
(9, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:51:39'),
(10, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:54:46'),
(11, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:54:52'),
(12, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:55:07'),
(13, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:55:50'),
(14, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:56:25'),
(15, 3, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 12:56:36'),
(16, 3, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:00:33'),
(17, 3, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:09:58'),
(18, 3, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:05'),
(19, 3, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:10:44'),
(22, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:15:06'),
(23, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:15:15'),
(24, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:29:31'),
(25, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:29:42'),
(26, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 13:30:02'),
(30, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:05:00'),
(31, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:05:11'),
(32, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 14:32:27'),
(33, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-04 14:37:31'),
(39, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:18:33'),
(40, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 20:20:54'),
(43, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:14:08'),
(44, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:26:11'),
(45, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:31:48'),
(46, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:32:50'),
(49, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-04 21:38:02'),
(50, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:23:26'),
(51, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 13:24:28'),
(58, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:18:27'),
(59, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-05 14:39:18'),
(62, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 14:45:43'),
(67, 1, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:06:44'),
(68, 1, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:08:16'),
(69, 1, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 20:08:27'),
(70, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:22:13'),
(71, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 22:31:38'),
(72, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-05 23:00:19'),
(73, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 17:51:49'),
(74, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 18:16:19'),
(96, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 10:46:04'),
(97, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 12:18:53'),
(98, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:30:08'),
(99, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 16:40:07'),
(101, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 19:54:55'),
(102, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:07:46'),
(103, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:17:12'),
(104, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:17:20'),
(105, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:38:26'),
(106, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '2026-05-07 20:39:25'),
(107, 2, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:39:37'),
(108, 2, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:39:42'),
(109, 1, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:39:53'),
(110, 1, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:40:15'),
(111, 1, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:40:33'),
(112, 1, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:41:27'),
(113, 10, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:42:28'),
(114, 10, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:42:28'),
(115, 10, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:43:34'),
(116, 10, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:46:19'),
(117, 10, 'logout', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:46:25'),
(118, 10, 'login', NULL, '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-07 20:46:29');

-- --------------------------------------------------------

--
-- Table structure for table `user_favorites`
--

CREATE TABLE `user_favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_favorites`
--

INSERT INTO `user_favorites` (`id`, `user_id`, `location_id`, `created_at`) VALUES
(1, 2, 4, '2026-05-04 14:44:53'),
(2, 7, 2, '2026-05-04 20:55:59'),
(8, 2, 8, '2026-05-04 21:53:26'),
(10, 8, 2, '2026-05-05 13:27:45'),
(13, 8, 8, '2026-05-05 16:39:07'),
(14, 1, 8, '2026-05-05 20:06:57'),
(15, 1, 5, '2026-05-05 20:07:17'),
(16, 2, 10, '2026-05-05 23:15:54');

-- --------------------------------------------------------

--
-- Table structure for table `weather_cache`
--

CREATE TABLE `weather_cache` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `temperature` decimal(4,1) DEFAULT NULL,
  `humidity` int(11) DEFAULT NULL,
  `wind_speed` decimal(4,1) DEFAULT NULL,
  `wind_direction` int(11) DEFAULT NULL,
  `pressure` decimal(6,2) DEFAULT NULL,
  `visibility` decimal(4,1) DEFAULT NULL,
  `uv_index` decimal(3,1) DEFAULT NULL,
  `condition_code` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '',
  `condition_text` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '',
  `icon_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '',
  `forecast_data` json DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Indexes for table `businesses`
--
ALTER TABLE `businesses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_businesses_type` (`type`),
  ADD KEY `idx_businesses_rating` (`rating`),
  ADD KEY `idx_businesses_featured` (`featured`),
  ADD KEY `idx_businesses_status` (`status`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact_status` (`status`),
  ADD KEY `idx_contact_email` (`email`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_events_dates` (`start_date`,`end_date`),
  ADD KEY `idx_events_location` (`location_id`),
  ADD KEY `idx_events_category` (`category`),
  ADD KEY `idx_events_featured` (`featured`),
  ADD KEY `idx_events_status` (`status`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_feedback_location` (`location_id`),
  ADD KEY `fk_feedback_user` (`user_id`);

--
-- Indexes for table `governments`
--
ALTER TABLE `governments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `itineraries`
--
ALTER TABLE `itineraries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_itineraries_user` (`user_id`),
  ADD KEY `idx_itineraries_dates` (`start_date`,`end_date`),
  ADD KEY `idx_itineraries_public` (`is_public`);

--
-- Indexes for table `itinerary_items`
--
ALTER TABLE `itinerary_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_itinerary_items_itinerary` (`itinerary_id`),
  ADD KEY `idx_itinerary_items_day` (`day_number`),
  ADD KEY `idx_itinerary_items_order` (`order_number`);

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
-- Indexes for table `location_suggestions`
--
ALTER TABLE `location_suggestions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_suggestions_user` (`user_id`),
  ADD KEY `idx_suggestions_status` (`status`);

--
-- Indexes for table `location_visits`
--
ALTER TABLE `location_visits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_visits_location` (`location_id`),
  ADD KEY `idx_visits_user` (`user_id`);

--
-- Indexes for table `photos`
--
ALTER TABLE `photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_photos_location` (`location_id`),
  ADD KEY `idx_photos_user` (`user_id`),
  ADD KEY `idx_photos_status` (`status`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reviews_location` (`location_id`),
  ADD KEY `idx_reviews_user` (`user_id`),
  ADD KEY `idx_reviews_rating` (`rating`),
  ADD KEY `idx_reviews_status` (`status`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_activities`
--
ALTER TABLE `user_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_activities_user` (`user_id`);

--
-- Indexes for table `user_favorites`
--
ALTER TABLE `user_favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_favorite` (`user_id`,`location_id`),
  ADD KEY `idx_favorites_user` (`user_id`),
  ADD KEY `idx_favorites_location` (`location_id`);

--
-- Indexes for table `weather_cache`
--
ALTER TABLE `weather_cache`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_weather_location` (`location_id`),
  ADD KEY `idx_weather_expires` (`expires_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `businesses`
--
ALTER TABLE `businesses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `governments`
--
ALTER TABLE `governments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `itineraries`
--
ALTER TABLE `itineraries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `itinerary_items`
--
ALTER TABLE `itinerary_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `location_images`
--
ALTER TABLE `location_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `location_suggestions`
--
ALTER TABLE `location_suggestions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `location_visits`
--
ALTER TABLE `location_visits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1453;

--
-- AUTO_INCREMENT for table `photos`
--
ALTER TABLE `photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user_activities`
--
ALTER TABLE `user_activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `user_favorites`
--
ALTER TABLE `user_favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `weather_cache`
--
ALTER TABLE `weather_cache`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `fk_events_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `fk_feedback_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_feedback_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `itineraries`
--
ALTER TABLE `itineraries`
  ADD CONSTRAINT `fk_itineraries_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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

--
-- Constraints for table `photos`
--
ALTER TABLE `photos`
  ADD CONSTRAINT `fk_photos_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_photos_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_activities`
--
ALTER TABLE `user_activities`
  ADD CONSTRAINT `fk_user_activities_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `weather_cache`
--
ALTER TABLE `weather_cache`
  ADD CONSTRAINT `fk_weather_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
