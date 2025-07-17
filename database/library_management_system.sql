-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 17, 2025 at 12:25 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library_management_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSummary` (OUT `total` INT, OUT `student_count` INT, OUT `faculty_count` INT, OUT `totalCopies` INT, OUT `issuedCount` INT, OUT `reservedCount` INT, OUT `overdue_count` INT, OUT `notify_requests` INT, OUT `books_due_soon` INT)   BEGIN
    -- Total users
    SELECT COUNT(*) INTO total FROM user;
    
    -- Students
    SELECT COUNT(*) INTO student_count 
    FROM user
    WHERE role = 0;
    
    -- Faculty
    SELECT COUNT(*) INTO faculty_count 
    FROM user
    WHERE role = 1;
    
    -- Total book copies
    SELECT COUNT(*) INTO totalCopies 
    FROM book_copies;
    
    -- Issued books (status 2)
    SELECT COUNT(*) INTO issuedCount
    FROM book_copies
    WHERE book_reservation_status = 2;

    -- Reserved books (status 1)
    SELECT COUNT(*) INTO reservedCount
    FROM book_copies
    WHERE book_reservation_status = 1;
    
    -- Overdue books: return_date is NULL AND due_date < today
    SELECT COUNT(*) INTO overdue_count
    FROM transaction
    WHERE return_date IS NULL AND due_date < CURDATE();
    
  -- notify Request
    SELECT COUNT(*) INTO notify_requests FROM notify_requests WHERE notified=0 ;
    
-- soon due date
SELECT COUNT(*) INTO books_due_soon
FROM transaction t
WHERE t.return_date IS NULL AND DATEDIFF(t.due_date, CURDATE()) BETWEEN 0 AND 5;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `a_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  `joining_date` datetime NOT NULL DEFAULT current_timestamp(),
  `resignation_date` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL CHECK (`status` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`a_id`, `name`, `email`, `phone_num`, `joining_date`, `resignation_date`, `status`) VALUES
(1, 'jinal Vachheta', 'jinalvachheta@gmail.com', '1233556712', '2025-06-10 11:04:47', '2025-06-20 23:43:15', 0),
(2, 'aasima', 'aasimamansuri56@gmail.com', '2536695847', '2025-06-15 10:06:52', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `author_id` int(11) NOT NULL,
  `author_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`author_id`, `author_name`) VALUES
(19, 'Silberschatz Abraham'),
(20, 'Mark Allen Weiss'),
(21, 'James Kurose'),
(22, 'Ian Sommerville'),
(23, 'Bjarne Stroustrup'),
(24, 'Abraham Silberschatz'),
(25, 'E. Balagurusamy'),
(26, 'Sanjay Saxena'),
(27, 'Andrew S. Tanenbaum'),
(28, 'Michael T. Goodrich'),
(29, 'Stephen Prata'),
(30, 'Ramez A. Elmasri'),
(31, 'Rajesh Narang '),
(32, 'Bart Baesens '),
(33, ' Rajagopalan '),
(34, '  M Baranitharan  '),
(35, '  Majid Husain   '),
(36, ' S.N. Panday '),
(37, ' Acharya Tinku '),
(38, ' V. Rajaraman '),
(39, '  Reema Thareja '),
(40, '   Forouzan '),
(41, 'David mount'),
(42, 'Roberto Tamassia'),
(43, 'Herny F.Korth'),
(44, 'S.Sudarshan');

-- --------------------------------------------------------

--
-- Table structure for table `book`
--

CREATE TABLE `book` (
  `book_id` int(11) NOT NULL,
  `ISBN` varchar(13) NOT NULL,
  `title` varchar(70) NOT NULL,
  `edition` int(11) DEFAULT NULL,
  `subject_id` int(11) NOT NULL,
  `total_copies` tinyint(4) NOT NULL,
  `added_date` datetime DEFAULT current_timestamp(),
  `page_count` int(11) DEFAULT NULL,
  `book_cover_image` varchar(255) DEFAULT NULL,
  `publisher_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `book`
--

INSERT INTO `book` (`book_id`, `ISBN`, `title`, `edition`, `subject_id`, `total_copies`, `added_date`, `page_count`, `book_cover_image`, `publisher_id`) VALUES
(55, '9780134685991', 'Effective Java', 3, 1, 2, '2025-06-10 11:39:51', 678, 'images/2.jpg', 1),
(57, '9780133694140', 'Computer Networking  A Top-Down Approach ', 7, 3, 2, '2025-06-10 11:49:00', 230, 'images/computer_networking_7.jpg', 4),
(58, '9780470128725', 'Operating System Concepts', 10, 2, 1, '2025-06-10 11:53:49', 540, 'images/OSC_10.jpg', 4),
(59, '7343225473212', 'Effective Java', 3, 1, 1, '2025-06-15 10:36:55', 213, 'images/4.jpg', 2),
(60, '1234567898765', 'Environmental science ', 2, 2, 0, '2025-06-15 16:34:50', 34, 'images/2.jpg', 3),
(61, '9780321563842', 'The C++ Programming Language', 4, 12, 3, '2025-06-16 10:47:35', 1376, 'images/cpp1.jpg', 3),
(62, '9781259029936', 'Object Oriented Programming with C++', 6, 12, 3, '2025-06-16 10:48:38', 656, 'images/cpp2.jpg', 42),
(63, '9788131722821', '\'Data Structures and Algorithms in C++', 2, 12, 5, '2025-06-16 10:51:49', 784, 'images/cpp3.jpg', 2),
(64, '9780672335679', 'C++ Primer Plus', 6, 12, 2, '2025-06-16 10:59:09', 1360, 'images/cpp4.jpg', 1),
(65, '9780078022157', 'Database System Concepts', 7, 13, 1, '2025-06-16 11:03:04', 1376, 'images/dbms1.jpg', 4),
(66, '9780195686064', 'Fundamentals of Database Systems', 6, 13, 2, '2025-06-16 11:04:58', 345, 'images/dbms2.jpg', 43),
(67, '9780199459759', 'Environmental Studies', 3, 14, 2, '2025-06-16 11:06:13', 346, 'images/evs1.jpg', 37),
(68, '9788120345799', 'Information Technology: Principles and Applications', 2, 15, 3, '2025-06-16 12:25:39', 862, 'images/it1.jpg', 3),
(69, '9780132126953', 'Computer Networks', 5, 16, 3, '2025-06-16 12:29:56', 345, 'images/net1.jpg', 42),
(70, '9786208116149', 'Environmental Science', 2, 14, 2, '2025-06-16 12:33:17', 564, 'images/evs2.jpg', 39),
(71, '7878788787878', 'Kotlin', 1, 16, 1, '2025-06-21 00:17:49', 1000, 'images/1.jpg', 45);

-- --------------------------------------------------------

--
-- Table structure for table `book_author`
--

CREATE TABLE `book_author` (
  `book_id` int(5) NOT NULL,
  `author_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `book_author`
--

INSERT INTO `book_author` (`book_id`, `author_id`) VALUES
(55, 20),
(55, 21),
(55, 22),
(57, 21),
(57, 22),
(58, 22),
(59, 20),
(59, 21),
(59, 22),
(60, 21),
(61, 34),
(61, 40),
(62, 25),
(63, 28),
(63, 41),
(63, 42),
(64, 29),
(65, 24),
(65, 43),
(65, 44),
(66, 35),
(67, 33),
(67, 34),
(68, 25),
(69, 23),
(69, 32),
(70, 20),
(70, 28),
(71, 23),
(71, 25),
(71, 43);

-- --------------------------------------------------------

--
-- Table structure for table `book_copies`
--

CREATE TABLE `book_copies` (
  `copy_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `library_classification_number` varchar(20) NOT NULL,
  `cupboard_no` tinyint(3) UNSIGNED DEFAULT NULL,
  `rack_no` tinyint(3) UNSIGNED DEFAULT NULL,
  `book_condition_status` tinyint(1) NOT NULL,
  `book_reservation_status` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `book_copies`
--

INSERT INTO `book_copies` (`copy_id`, `book_id`, `category_id`, `library_classification_number`, `cupboard_no`, `rack_no`, `book_condition_status`, `book_reservation_status`) VALUES
(22, 55, 3, '121234567865363', 3, 4, 1, 0),
(23, 57, 2, '121234567865388', 3, 4, 1, 0),
(24, 58, 3, '124578934251256', 1, 2, 1, 0),
(25, 55, 2, '121234567865396', 3, 4, 1, 0),
(26, 59, 3, '121234567865389', 12, 3, 1, 0),
(27, 57, 3, '121234567865312', 23, 4, 1, 0),
(28, 61, 3, '152635485769245', 23, 2, 1, 0),
(29, 61, 3, '152635489669245', 23, 2, 1, 1),
(30, 61, 3, '152635489669252', 23, 2, 1, 0),
(31, 62, 1, '752635489669252', 2, 6, 1, 0),
(32, 62, 1, '152635489669252', 2, 6, 1, 0),
(33, 62, 3, '152635489669225', 2, 6, 1, 0),
(34, 63, 3, '121234567866666', 5, 3, 1, 0),
(35, 63, 3, '121234567866885', 5, 3, 1, 0),
(37, 64, 1, '121234567865766', 4, 5, 1, 0),
(38, 64, 3, '121234567865656', 4, 5, 1, 0),
(39, 65, 3, '121234567865096', 5, 5, 1, 1),
(40, 66, 3, '121234567865966', 23, 4, 1, 0),
(41, 66, 2, '121234567865985', 23, 4, 1, 0),
(42, 67, 1, '121224567865988', 23, 4, 1, 2),
(43, 67, 3, '457671234546678', 2, 2, 1, 0),
(44, 68, 3, '997671234546678', 2, 2, 1, 0),
(45, 68, 1, '998571234546678', 2, 2, 1, 0),
(46, 68, 2, '998571234549978', 2, 2, 1, 0),
(47, 69, 1, '998441234549978', 3, 2, 1, 1),
(48, 69, 3, '661664567865356', 4, 2, 1, 0),
(49, 69, 1, '991664567865357', 4, 2, 1, 0),
(50, 70, 3, '337843992245886', 3, 4, 1, 1),
(51, 70, 1, '998571234549955', 2, 2, 1, 0),
(52, 63, 3, '555571234549955', 2, 2, 0, 0),
(53, 63, 3, '556571234549955', 2, 2, 1, 0),
(54, 71, 1, '72537253472', 3, 3, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `book_request`
--

CREATE TABLE `book_request` (
  `request_id` int(11) NOT NULL,
  `copy_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  `request_date` date NOT NULL,
  `request_status` tinyint(1) NOT NULL DEFAULT 4,
  `approved_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `book_request`
--

INSERT INTO `book_request` (`request_id`, `copy_id`, `u_id`, `request_date`, `request_status`, `approved_at`) VALUES
(50, 28, 28, '2025-06-16', 4, '2025-06-16 11:49:34'),
(51, 40, 28, '2025-06-16', 4, '2025-03-16 11:50:11'),
(53, 28, 28, '2025-06-16', 4, '2025-06-16 11:58:45'),
(54, 42, 28, '2025-03-16', 4, '2025-03-16 12:12:11'),
(55, 31, 36, '2025-06-16', 4, '2025-06-16 12:53:37'),
(56, 34, 36, '2025-06-16', 4, '2025-02-16 12:54:12'),
(57, 44, 39, '2025-06-16', 4, '2025-06-16 13:23:42'),
(58, 50, 39, '2025-06-16', 2, '2025-06-16 13:24:21'),
(59, 47, 39, '2025-06-16', 2, '2025-06-16 13:28:17'),
(60, 39, 31, '2025-06-16', 2, '2025-06-16 14:22:33'),
(61, 29, 31, '2025-06-16', 2, '2025-06-16 14:50:21');

-- --------------------------------------------------------

--
-- Table structure for table `book_suggestions`
--

CREATE TABLE `book_suggestions` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `edition` varchar(100) DEFAULT NULL,
  `isbn` varchar(50) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT 0,
  `suggested_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `book_suggestions`
--

INSERT INTO `book_suggestions` (`id`, `title`, `author`, `edition`, `isbn`, `publisher`, `status`, `suggested_date`) VALUES
(2, 'web application development', 'Philip Ackermann', '', '', '', 0, '2025-06-16 07:56:45');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`) VALUES
(3, 'Centeral Transferred'),
(1, 'Complementary '),
(2, 'Donated');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `d_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  `joining_date` datetime NOT NULL DEFAULT current_timestamp(),
  `resignation_date` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1 CHECK (`status` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`d_id`, `name`, `email`, `phone_num`, `joining_date`, `resignation_date`, `status`) VALUES
(1, 'khushi shah', 'khushishah07022005@gmail.com', '2536695543', '2025-06-16 12:37:12', NULL, 1),
(2, 'aasima', 'aasimamansuri56@gmail.com', '2312343244', '2025-06-20 23:42:04', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `donor`
--

CREATE TABLE `donor` (
  `donor_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `copy_id` int(11) NOT NULL,
  `donation_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `donor`
--

INSERT INTO `donor` (`donor_id`, `name`, `copy_id`, `donation_date`) VALUES
(1, 'jigna', 23, '2025-06-10'),
(2, 'bhumika', 25, '2025-06-10'),
(3, 'Bhumika', 41, '2025-06-16'),
(4, 'jigna satani', 46, '2025-06-16');

-- --------------------------------------------------------

--
-- Table structure for table `grievances`
--

CREATE TABLE `grievances` (
  `grievance_id` int(11) NOT NULL,
  `copy_id` int(11) NOT NULL,
  `grievance_reason` varchar(255) NOT NULL,
  `grievance_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `resolved_status` tinyint(1) DEFAULT 0,
  `resolved_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `grievances`
--

INSERT INTO `grievances` (`grievance_id`, `copy_id`, `grievance_reason`, `grievance_date`, `resolved_status`, `resolved_date`) VALUES
(2, 52, 'Barcode is missing or damaged', '2025-06-16 08:33:52', 0, NULL),
(3, 54, 'damaged', '2025-06-20 18:52:12', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `notification_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  `msgtype` enum('request','return','general','reminder') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notify_requests`
--

CREATE TABLE `notify_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `book_id` int(11) DEFAULT NULL,
  `request_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `notified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `notify_requests`
--

INSERT INTO `notify_requests` (`id`, `user_id`, `book_id`, `request_time`, `notified`) VALUES
(6, 31, 65, '2025-06-16 08:53:51', 0),
(7, 39, 71, '2025-06-20 19:01:49', 0);

-- --------------------------------------------------------

--
-- Table structure for table `publisher`
--

CREATE TABLE `publisher` (
  `publisher_id` int(11) NOT NULL,
  `publisher_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `publisher`
--

INSERT INTO `publisher` (`publisher_id`, `publisher_name`) VALUES
(41, '  Drishti Publicatio'),
(42, ' CRC Press'),
(40, ' LAP Lambert Academi'),
(39, ' Oxford University P'),
(38, ' PHI Learning'),
(43, ' Prentice Hall India'),
(44, ' Vikas Publishing Ho'),
(3, 'Addison-Wesley'),
(37, 'Cambridge University'),
(45, 'HelloWorld'),
(4, 'McGraw-Hill'),
(1, 'Pearson'),
(2, 'Wiley');

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `subject_id` int(11) NOT NULL,
  `subject_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`subject_id`, `subject_name`) VALUES
(12, 'C++ Programming'),
(16, 'Computer Networking'),
(13, 'Database Management'),
(14, 'Environmental Studies'),
(15, 'Information Technology'),
(6, 'Web Technologies');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `return_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `request_id`, `issue_date`, `due_date`, `return_date`) VALUES
(13, 50, '2025-06-16', '2025-07-01', '2025-06-16'),
(14, 51, '2025-06-16', '2025-07-01', '2025-06-16'),
(16, 53, '2025-06-16', '2025-06-20', '2025-06-20'),
(17, 54, '2025-05-30', '2025-06-15', NULL),
(18, 55, '2025-02-16', '2025-03-03', '2025-03-05'),
(19, 57, '2025-06-16', '2025-12-16', '2025-06-16');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `u_id` int(11) NOT NULL,
  `registration_no` varchar(15) NOT NULL,
  `fname` varchar(10) NOT NULL,
  `lname` varchar(10) NOT NULL,
  `email` varchar(30) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  `role` tinyint(1) NOT NULL,
  `status` tinyint(1) DEFAULT 1,
  `create_date` datetime DEFAULT current_timestamp(),
  `update_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`u_id`, `registration_no`, `fname`, `lname`, `email`, `phone_num`, `role`, `status`, `create_date`, `update_date`) VALUES
(28, '121212123456', 'Aasima', 'Mansuri', 'aasimamansuri56@gmail.com', '1243675498', 0, 1, '2025-06-10 11:17:32', '2025-06-16 11:41:24'),
(31, '123456789876', 'khushi', 'shah', 'khushishah07022005@gmail.com', '8320796260', 0, 1, '2025-06-10 11:23:10', '2025-06-16 11:41:31'),
(32, '', 'krisa', 'shah', 'krisashah0510@gmail.com', '4565369874', 1, 0, '2025-06-16 11:23:47', '2025-06-16 14:13:47'),
(33, '456932145896', 'Devang', 'Shah', 'namyadevang@gmail.com', '4596871236', 0, 1, '2025-06-16 11:27:16', '2025-06-21 00:06:29'),
(34, '256399887744', 'Kinjal', 'shah', 'shahdevang3931@gmail.com', '5522663311', 0, 1, '2025-06-16 11:29:51', '2025-06-16 12:51:34'),
(35, '996655331144', 'Riya', 'Shah', 'nn5361798@gmail.com', '8855669123', 0, 1, '2025-06-16 11:29:51', '2025-06-16 12:51:26'),
(36, '663394521697', 'Jalpa', 'Shah', 'jalpashah7750@gmail.com', '4569321485', 0, 1, '2025-06-16 11:31:30', '2025-06-16 12:51:12'),
(37, '', 'pravin', 'vachheta', 'pravinvachheta@gmail.com', '4596223658', 1, 1, '2025-06-16 11:34:02', '2025-06-16 14:13:47'),
(38, '', 'urvish', 'joshi', 'urvishjoshi@gmail.com', '9937566398', 1, 1, '2025-06-16 11:35:05', '2025-06-16 14:13:47'),
(39, '', 'Riya', 'Modi', 'riya@yopmail.com', '4589632145', 1, 1, '2025-06-16 12:44:07', '2025-06-16 14:12:22');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `wishlist_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`wishlist_id`, `u_id`, `book_id`) VALUES
(1, 28, 57),
(2, 28, 58),
(3, 36, 62),
(4, 36, 63),
(7, 39, 71);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`a_id`);

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`author_id`);

--
-- Indexes for table `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`book_id`);

--
-- Indexes for table `book_author`
--
ALTER TABLE `book_author`
  ADD PRIMARY KEY (`book_id`,`author_id`),
  ADD KEY `author_id` (`author_id`);

--
-- Indexes for table `book_copies`
--
ALTER TABLE `book_copies`
  ADD PRIMARY KEY (`copy_id`);

--
-- Indexes for table `book_request`
--
ALTER TABLE `book_request`
  ADD PRIMARY KEY (`request_id`);

--
-- Indexes for table `book_suggestions`
--
ALTER TABLE `book_suggestions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`d_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone_num` (`phone_num`);

--
-- Indexes for table `donor`
--
ALTER TABLE `donor`
  ADD PRIMARY KEY (`donor_id`),
  ADD KEY `copy_id` (`copy_id`);

--
-- Indexes for table `grievances`
--
ALTER TABLE `grievances`
  ADD PRIMARY KEY (`grievance_id`),
  ADD KEY `copy_id` (`copy_id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `u_id` (`u_id`);

--
-- Indexes for table `notify_requests`
--
ALTER TABLE `notify_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `publisher`
--
ALTER TABLE `publisher`
  ADD PRIMARY KEY (`publisher_id`),
  ADD UNIQUE KEY `publisher_name` (`publisher_name`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`subject_id`),
  ADD UNIQUE KEY `subject_name` (`subject_name`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `request_id` (`request_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`u_id`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`wishlist_id`),
  ADD UNIQUE KEY `u_id` (`u_id`,`book_id`),
  ADD UNIQUE KEY `u_id_2` (`u_id`,`book_id`),
  ADD KEY `book_id` (`book_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `a_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `author`
--
ALTER TABLE `author`
  MODIFY `author_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `book`
--
ALTER TABLE `book`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `book_copies`
--
ALTER TABLE `book_copies`
  MODIFY `copy_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `book_request`
--
ALTER TABLE `book_request`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `book_suggestions`
--
ALTER TABLE `book_suggestions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `d_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `donor`
--
ALTER TABLE `donor`
  MODIFY `donor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `grievances`
--
ALTER TABLE `grievances`
  MODIFY `grievance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notify_requests`
--
ALTER TABLE `notify_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `publisher`
--
ALTER TABLE `publisher`
  MODIFY `publisher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `u_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `wishlist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `book_author`
--
ALTER TABLE `book_author`
  ADD CONSTRAINT `book_author_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `book_author_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`) ON DELETE CASCADE;

--
-- Constraints for table `donor`
--
ALTER TABLE `donor`
  ADD CONSTRAINT `donor_ibfk_1` FOREIGN KEY (`copy_id`) REFERENCES `book_copies` (`copy_id`);

--
-- Constraints for table `grievances`
--
ALTER TABLE `grievances`
  ADD CONSTRAINT `grievances_ibfk_1` FOREIGN KEY (`copy_id`) REFERENCES `book_copies` (`copy_id`) ON DELETE CASCADE;

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `book_request` (`request_id`) ON DELETE CASCADE;

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
