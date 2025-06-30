-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 30, 2025 at 02:18 PM
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
-- Database: `db_warehouse`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
(9, 'Raw Material Bahan Aktif', '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(10, 'Raw Material Supporting', '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(11, 'Barang Dalam Proses', '2025-06-25 06:26:19', '2025-06-27 21:29:12'),
(12, 'Barang Jadi', '2025-06-26 21:07:32', '2025-06-26 21:07:32');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sku` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `sub_category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `unit` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `sku`, `name`, `category_id`, `sub_category_id`, `location`, `stock`, `unit`, `description`, `user_id`, `created_at`, `updated_at`) VALUES
(22, 'SKU001', 'Barang A', 9, 1, 'Malang', 105, 'Box', 'Ada di Gudang A', 1, '2025-06-25 20:32:03', '2025-06-29 20:37:04'),
(25, 'SKU002', 'Barang B', 10, 6, 'Malang', 10, 'Box', 'Barang diterima dari supplier A', 2, '2025-06-28 21:27:06', '2025-06-28 21:27:06'),
(26, 'SKU003', 'Barang C', 12, 10, 'Kediri', 50, 'Pcs', 'Persediaan tambahan', 2, '2025-06-28 21:27:06', '2025-06-28 21:27:06'),
(28, 'SKU005', 'Barang E', 9, 3, 'Surabaya', 50, 'Box', 'Mencoba dashboard approver web', 1, '2025-06-29 17:53:05', '2025-06-29 20:32:52'),
(29, 'SKU006', 'Barang F', 10, 7, 'Surabaya', 0, 'Pcs', 'Mencoba lagi', 1, '2025-06-29 20:48:00', '2025-06-29 20:48:00');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_06_14_000001_create_categories_table', 1),
(5, '2025_06_14_022812_create_personal_access_tokens_table', 1),
(6, '2025_06_14_022933_create_items_table', 1),
(7, '2025_06_15_013303_create_item_logs_table', 2),
(8, '2025_06_16_010427_create_item_outs_table', 3),
(9, '2025_06_16_022344_create_item_outs_table', 4),
(10, '2025_06_17_120347_create_stock_requests_table', 5),
(11, '2025_06_25_102706_add_sub_category_and_unit_to_items_table', 6),
(12, '2025_06_25_123234_create_sub_categories_table', 7),
(13, '2025_06_25_123325_add_sub_category_id_to_items_table', 7),
(14, '2025_06_25_123907_remove_sub_category_column_from_items_table', 8),
(15, '2025_06_25_131822_add_name_to_sub_categories_table', 9),
(16, '2025_06_25_132431_add_category_id_to_sub_categories_table', 10),
(17, '2025_06_27_100613_update_type_enum_in_stock_requests_table', 11),
(18, '2025_06_27_134956_create_sub_category_requests_table', 12);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'api-token', 'af04f3d751b2da4ec9db1284af3990f01d62d2e50337569242184587d5188ea6', '[\"*\"]', '2025-06-14 04:13:46', NULL, '2025-06-14 04:13:18', '2025-06-14 04:13:46'),
(2, 'App\\Models\\User', 1, 'api-token', 'fe0679ef4a98ff99b438bf147709276bd8410cc56c7833e117848577c9caf008', '[\"*\"]', '2025-06-14 04:17:54', NULL, '2025-06-14 04:17:53', '2025-06-14 04:17:54'),
(3, 'App\\Models\\User', 1, 'api-token', '28ebf5a1e8e62db6a8bacd118fd4bf9e63764baad79d7bc4ee271d3d940aec48', '[\"*\"]', '2025-06-14 04:20:48', NULL, '2025-06-14 04:20:48', '2025-06-14 04:20:48'),
(4, 'App\\Models\\User', 1, 'api-token', '0184925c5a532d6b58eef8d8d0ccef196faf8bbacdddd0beddc56fc8e28992e6', '[\"*\"]', '2025-06-14 04:22:32', NULL, '2025-06-14 04:22:31', '2025-06-14 04:22:32'),
(5, 'App\\Models\\User', 1, 'api-token', '2000cd88069e6f091ca441a29292e9b8d0b505c81bb53281948b235800be9c6b', '[\"*\"]', '2025-06-14 04:25:00', NULL, '2025-06-14 04:25:00', '2025-06-14 04:25:00'),
(6, 'App\\Models\\User', 1, 'api-token', '7f104d42e25f953b0d4b59930cd6517b89ef2896230927daa7a727eb99e1e29a', '[\"*\"]', '2025-06-14 04:26:46', NULL, '2025-06-14 04:26:45', '2025-06-14 04:26:46'),
(7, 'App\\Models\\User', 1, 'api-token', '4b4831cc8ef628e907e7e7f3669ef0357e3965538d7a20d36b6f943702ac660d', '[\"*\"]', '2025-06-14 04:29:22', NULL, '2025-06-14 04:29:21', '2025-06-14 04:29:22'),
(8, 'App\\Models\\User', 1, 'api-token', '2020940a06e874636ee410bf1d5f0e095d23ff06afab4daae05b3c4c07bf05b3', '[\"*\"]', '2025-06-14 04:33:50', NULL, '2025-06-14 04:33:49', '2025-06-14 04:33:50'),
(9, 'App\\Models\\User', 1, 'api-token', 'de5b9cd6208158cfd273910c6cf9687624b6a20a727fb1e1c6f8490676cd28ac', '[\"*\"]', '2025-06-14 04:34:58', NULL, '2025-06-14 04:34:57', '2025-06-14 04:34:58'),
(10, 'App\\Models\\User', 1, 'api-token', '332d82a04ea46829b529aa308d9a6dc3a54b9ddaec45beebbe096175487b75bc', '[\"*\"]', '2025-06-14 04:38:04', NULL, '2025-06-14 04:38:03', '2025-06-14 04:38:04'),
(11, 'App\\Models\\User', 1, 'api-token', 'bdc220a1e160fa917a3a55452a3661afb64851a706684a116d3310b3cf86acd4', '[\"*\"]', '2025-06-14 04:41:00', NULL, '2025-06-14 04:40:59', '2025-06-14 04:41:00'),
(12, 'App\\Models\\User', 1, 'api-token', '8558d836beaba5c8229abc4fff16e5d0ab852f8d0993dab3e79555265ffba62b', '[\"*\"]', '2025-06-14 04:44:04', NULL, '2025-06-14 04:44:03', '2025-06-14 04:44:04'),
(13, 'App\\Models\\User', 1, 'api-token', '9a94c60182b6bd6e3086ffbe3da82d6a7c47c7e809609651cfcb6cf165cf7fdb', '[\"*\"]', '2025-06-14 04:49:05', NULL, '2025-06-14 04:49:04', '2025-06-14 04:49:05'),
(14, 'App\\Models\\User', 1, 'api-token', '1a1713810a9541616b4b4995f4bb052e72dad0c32e66a125b1bbaa1d74bbeb93', '[\"*\"]', '2025-06-14 04:55:26', NULL, '2025-06-14 04:54:56', '2025-06-14 04:55:26'),
(15, 'App\\Models\\User', 1, 'api-token', '80c1b302666870551b1b0a4075461bbd5edd7f0f66de397674dff217718de6a2', '[\"*\"]', '2025-06-14 05:02:26', NULL, '2025-06-14 05:02:17', '2025-06-14 05:02:26'),
(16, 'App\\Models\\User', 1, 'api-token', 'fe2107a6bdcc98847bbcc24f84df2237156be3fe9131ff4cdad966dfc7366860', '[\"*\"]', '2025-06-14 05:05:23', NULL, '2025-06-14 05:05:20', '2025-06-14 05:05:23'),
(17, 'App\\Models\\User', 1, 'api-token', '7a86a88684b40dff90ccd910f7e17873a3378e85960433cd1d1cc75544e79beb', '[\"*\"]', '2025-06-14 05:18:20', NULL, '2025-06-14 05:18:16', '2025-06-14 05:18:20'),
(18, 'App\\Models\\User', 1, 'api-token', '7cf617d70af443eaf678617216f04814b84fc8b5571a7dde3b5d2e62f3411df7', '[\"*\"]', '2025-06-14 05:19:20', NULL, '2025-06-14 05:19:17', '2025-06-14 05:19:20'),
(19, 'App\\Models\\User', 1, 'api-token', '91e489e0cfa9138db3b2667132da4c925c8f1a4adbf02e0059631c60c3796dc1', '[\"*\"]', '2025-06-14 05:24:01', NULL, '2025-06-14 05:23:58', '2025-06-14 05:24:01'),
(20, 'App\\Models\\User', 1, 'api-token', 'b9a75665b86e77507000d15db3cb0e3ecdeedbcb3fdeda369f7f79580c32fa4b', '[\"*\"]', '2025-06-14 05:26:27', NULL, '2025-06-14 05:26:00', '2025-06-14 05:26:27'),
(21, 'App\\Models\\User', 1, 'api-token', '18faf8cde1c4763491f5c174412d4f7bb07bf7e0d3883817819c94126e663e2f', '[\"*\"]', '2025-06-14 05:36:13', NULL, '2025-06-14 05:36:10', '2025-06-14 05:36:13'),
(22, 'App\\Models\\User', 1, 'api-token', '18f38f439b62aabb8850152c753149b45217ba78eca5ad543a725b3c7cd23ae5', '[\"*\"]', '2025-06-14 05:44:45', NULL, '2025-06-14 05:41:11', '2025-06-14 05:44:45'),
(23, 'App\\Models\\User', 1, 'api-token', '71a60c48304c2e8c7d73dea414c98aa088e27090deafddb80f7db96b4775b0c4', '[\"*\"]', '2025-06-14 05:53:44', NULL, '2025-06-14 05:53:41', '2025-06-14 05:53:44'),
(24, 'App\\Models\\User', 1, 'api-token', 'fa6309db9e76aeb3cf0df1187d5fd511a026ab835e665a604146cf3e6c88b2cd', '[\"*\"]', '2025-06-14 06:15:46', NULL, '2025-06-14 06:15:44', '2025-06-14 06:15:46'),
(25, 'App\\Models\\User', 1, 'api-token', '018137054de5a33cd70649c427c79c0962dca11ddacf992bb8e01f6ab35c7d86', '[\"*\"]', '2025-06-14 06:25:56', NULL, '2025-06-14 06:25:52', '2025-06-14 06:25:56'),
(26, 'App\\Models\\User', 1, 'api-token', '59b61dec65f50cf2add1fa4dceeb29b890ec0c034242269020620a7a4fe63764', '[\"*\"]', '2025-06-14 06:30:16', NULL, '2025-06-14 06:30:12', '2025-06-14 06:30:16'),
(27, 'App\\Models\\User', 1, 'api-token', '57a5a335b8a9936150cb42725c7128762b11e02243546a73c9f7957726695427', '[\"*\"]', '2025-06-14 06:31:40', NULL, '2025-06-14 06:31:34', '2025-06-14 06:31:40'),
(28, 'App\\Models\\User', 1, 'api-token', '74ab49b4295fc5ffdc0135995b2fa5e6feaf606ea10dc48389469c84ae51eb60', '[\"*\"]', '2025-06-14 06:36:36', NULL, '2025-06-14 06:35:01', '2025-06-14 06:36:36'),
(29, 'App\\Models\\User', 1, 'api-token', '40598a665af51ba216b25087390d9cd3d62654123c01c3095d6b64e297e2d5fd', '[\"*\"]', '2025-06-14 06:41:21', NULL, '2025-06-14 06:40:49', '2025-06-14 06:41:21'),
(30, 'App\\Models\\User', 1, 'api-token', '5c01253feb953a72ab054b9d70723c18b02b2d68692f9d719da976936d0c9072', '[\"*\"]', '2025-06-14 06:47:49', NULL, '2025-06-14 06:47:08', '2025-06-14 06:47:49'),
(31, 'App\\Models\\User', 1, 'api-token', 'bed096431f80fd2e3372a564cfe10c3d088a7b7ab876ea4194b20fa0337dd199', '[\"*\"]', '2025-06-14 06:52:06', NULL, '2025-06-14 06:51:35', '2025-06-14 06:52:06'),
(32, 'App\\Models\\User', 1, 'api-token', '5891bb563c7e88f3cc6a1ccc9849ec0109620d517dbcbd8d9951e441a3c79c4f', '[\"*\"]', '2025-06-14 06:56:01', NULL, '2025-06-14 06:55:32', '2025-06-14 06:56:01'),
(33, 'App\\Models\\User', 1, 'api-token', '575eddfd693b29a39c872b27d773112e76a2fb746c20d051dacd2a88d94af27f', '[\"*\"]', '2025-06-14 07:01:16', NULL, '2025-06-14 07:00:47', '2025-06-14 07:01:16'),
(34, 'App\\Models\\User', 1, 'api-token', '07b35cc424b536734204232076ead6babefb3f34c5ec7c29e8614a880b7bf39c', '[\"*\"]', '2025-06-14 07:03:56', NULL, '2025-06-14 07:03:23', '2025-06-14 07:03:56'),
(35, 'App\\Models\\User', 1, 'api-token', 'aede0fca263f404a473d4aa9f68f11373f524c318cb5ee0c116a91d7f47f6a91', '[\"*\"]', '2025-06-14 07:10:17', NULL, '2025-06-14 07:09:24', '2025-06-14 07:10:17'),
(36, 'App\\Models\\User', 1, 'api-token', '2ecb2c3249e8244741d8b98de7d8e81f793c15cd79804b0e7ff499db6045a255', '[\"*\"]', '2025-06-14 07:12:48', NULL, '2025-06-14 07:11:58', '2025-06-14 07:12:48'),
(37, 'App\\Models\\User', 1, 'api-token', 'ab8f258344d92c64c3800a3869794ec1bfecdf66b30b4847d58602dbe3b0d68f', '[\"*\"]', '2025-06-14 07:14:38', NULL, '2025-06-14 07:14:29', '2025-06-14 07:14:38'),
(38, 'App\\Models\\User', 1, 'api-token', '007de19dc6b6fc0a04963d0c323d715379366118b33df710c34eece04799ff85', '[\"*\"]', '2025-06-14 07:15:30', NULL, '2025-06-14 07:15:19', '2025-06-14 07:15:30'),
(39, 'App\\Models\\User', 1, 'api-token', '8d580b16d92ad50836522a63444d670ee9270c839ff9c1207a1892e82d15e213', '[\"*\"]', '2025-06-14 18:20:22', NULL, '2025-06-14 18:20:07', '2025-06-14 18:20:22'),
(40, 'App\\Models\\User', 1, 'api-token', '4e1736c7b335f547d6e3f5027b53df29d9b6043fea547c952377eea2253462f3', '[\"*\"]', '2025-06-14 18:21:34', NULL, '2025-06-14 18:21:29', '2025-06-14 18:21:34'),
(41, 'App\\Models\\User', 1, 'api-token', '6cf6c72c2e17b660b4fdc8f5c88ba0a96e26c969c66da6b891f465508f58b4df', '[\"*\"]', '2025-06-14 18:25:26', NULL, '2025-06-14 18:24:43', '2025-06-14 18:25:26'),
(42, 'App\\Models\\User', 1, 'api-token', 'd6516afb7a09faa3d45994ed1c1f98fc90f65f12b319ce32b64ac1ad5177259c', '[\"*\"]', '2025-06-14 18:27:41', NULL, '2025-06-14 18:27:40', '2025-06-14 18:27:41'),
(43, 'App\\Models\\User', 1, 'api-token', 'ace8a01b502e9291c1f24bf27a0bb199c66064844547b69904b32dc11044095f', '[\"*\"]', '2025-06-14 18:48:27', NULL, '2025-06-14 18:48:24', '2025-06-14 18:48:27'),
(44, 'App\\Models\\User', 1, 'api-token', 'ddee77c9aac1bd0478133d44ed826c7c5b2970015395c68593d329cf59289b66', '[\"*\"]', '2025-06-14 18:50:52', NULL, '2025-06-14 18:50:47', '2025-06-14 18:50:52'),
(45, 'App\\Models\\User', 1, 'api-token', '5e1c462e34c6351d7fe3fd5c1e347d7c7546b8cdb93c0adefb6a46bd86eca73f', '[\"*\"]', '2025-06-14 18:56:27', NULL, '2025-06-14 18:53:51', '2025-06-14 18:56:27'),
(46, 'App\\Models\\User', 1, 'api-token', 'd8692e3dc0037e9ce69627ab0024100fdfb6f59ad57533db2ecc4d4190f64671', '[\"*\"]', '2025-06-14 18:59:52', NULL, '2025-06-14 18:59:46', '2025-06-14 18:59:52'),
(47, 'App\\Models\\User', 1, 'api-token', '3f47a6f89b46f7323cba67d1155abee0deaf5190ecb388d6918f256787f48aef', '[\"*\"]', '2025-06-14 19:07:44', NULL, '2025-06-14 19:07:43', '2025-06-14 19:07:44'),
(48, 'App\\Models\\User', 1, 'api-token', '92ab5ad1679496afdba9486facb2854dbb107b7897510eafbf470bb731328c58', '[\"*\"]', '2025-06-14 19:10:14', NULL, '2025-06-14 19:10:03', '2025-06-14 19:10:14'),
(49, 'App\\Models\\User', 1, 'api-token', 'e6e0031c0f1a6ed46f9bdf13c685a5cb5824f85d8f868e1ff2caf5eb12b44182', '[\"*\"]', '2025-06-14 19:15:22', NULL, '2025-06-14 19:15:21', '2025-06-14 19:15:22'),
(50, 'App\\Models\\User', 1, 'api-token', '7c17114d0866ce1810b5a648887c90100ad347ce93a8832a0f9120ddec51edb2', '[\"*\"]', '2025-06-14 19:16:00', NULL, '2025-06-14 19:15:59', '2025-06-14 19:16:00'),
(51, 'App\\Models\\User', 1, 'api-token', '1edf45bbd4a0a39e214d31973b8c57084877a445180ea82b8f690d56abd7c7aa', '[\"*\"]', '2025-06-14 19:25:22', NULL, '2025-06-14 19:25:07', '2025-06-14 19:25:22'),
(52, 'App\\Models\\User', 1, 'api-token', 'de64c6eea81ccef6fa005d5a291f23b539e1c2620eac8b3c77b446dbf9269777', '[\"*\"]', '2025-06-14 19:26:26', NULL, '2025-06-14 19:26:20', '2025-06-14 19:26:26'),
(53, 'App\\Models\\User', 1, 'api-token', '92b8ce0f200842dcab3e6f4123f3d408471b433ad535d1e9d53b2c4b2e9e2965', '[\"*\"]', '2025-06-14 19:27:33', NULL, '2025-06-14 19:27:20', '2025-06-14 19:27:33'),
(54, 'App\\Models\\User', 1, 'api-token', '09e34d21dfb66df6b9590ed2ff0bf5683a615a37e2636519ed86098ed177d773', '[\"*\"]', '2025-06-14 19:28:57', NULL, '2025-06-14 19:28:53', '2025-06-14 19:28:57'),
(55, 'App\\Models\\User', 1, 'api-token', '2bd7d70e54cfef86bc5604c2389e945a37a47dc5c9dc4f164501bc2c42c6f2e7', '[\"*\"]', '2025-06-14 20:17:26', NULL, '2025-06-14 20:17:06', '2025-06-14 20:17:26'),
(56, 'App\\Models\\User', 1, 'api-token', '6c8986a51c4e5cee6a71e1fc95ba60667f179041c47614ad70585914ffb216cb', '[\"*\"]', '2025-06-14 20:19:37', NULL, '2025-06-14 20:19:26', '2025-06-14 20:19:37'),
(57, 'App\\Models\\User', 1, 'api-token', '3902b3142c0a77ec731469760923885d2b2f139a320ed5aff4df1096dbc92c77', '[\"*\"]', '2025-06-14 20:22:18', NULL, '2025-06-14 20:22:11', '2025-06-14 20:22:18'),
(58, 'App\\Models\\User', 1, 'api-token', '3038d72aa87b25ae9eb0b5ca9e883324165abf3f7a3706d140f673923c8b7802', '[\"*\"]', '2025-06-14 20:27:29', NULL, '2025-06-14 20:27:27', '2025-06-14 20:27:29'),
(59, 'App\\Models\\User', 1, 'api-token', 'ba9f7f216c71be256f03fa0df1ed83c252ce4787b1961a2a17bb2c3d6f5a620c', '[\"*\"]', '2025-06-14 20:36:00', NULL, '2025-06-14 20:35:05', '2025-06-14 20:36:00'),
(60, 'App\\Models\\User', 1, 'api-token', '6052abea05e7f5a2d40769cbd33ebc5c4aec56fd6df524bd321382d28c8ba1c4', '[\"*\"]', '2025-06-14 20:38:04', NULL, '2025-06-14 20:37:31', '2025-06-14 20:38:04'),
(61, 'App\\Models\\User', 1, 'api-token', 'c10b44ad04ae0d15feee06e3abab061efcc0053f0b9e468f9e15eae3a63687a5', '[\"*\"]', '2025-06-14 20:39:14', NULL, '2025-06-14 20:39:01', '2025-06-14 20:39:14'),
(62, 'App\\Models\\User', 1, 'api-token', '65469e0f7271dc5867d8f258164d47364dfa5beb21133195eb4f5b86c9b438f0', '[\"*\"]', '2025-06-14 20:47:10', NULL, '2025-06-14 20:47:09', '2025-06-14 20:47:10'),
(63, 'App\\Models\\User', 1, 'api-token', 'c74d378ee270ebbd0ed1639f5c20772d2b04567b7d93a0f1403d6049ce6e5051', '[\"*\"]', '2025-06-14 20:54:50', NULL, '2025-06-14 20:50:33', '2025-06-14 20:54:50'),
(64, 'App\\Models\\User', 1, 'api-token', 'c9281b49b50c5dd0d0526d54cbb66dfe81b94d63d2892556be417076ae486473', '[\"*\"]', '2025-06-14 21:04:55', NULL, '2025-06-14 21:04:42', '2025-06-14 21:04:55'),
(65, 'App\\Models\\User', 1, 'api-token', 'cebb7ff0b7295b3d2462ea1589d6367591d908718652782c4e1c8f858ba28744', '[\"*\"]', '2025-06-14 21:08:00', NULL, '2025-06-14 21:07:52', '2025-06-14 21:08:00'),
(66, 'App\\Models\\User', 1, 'api-token', '6386308c844bf9ac40ca54b83b9866d9ddff43587eaf988307dfe677c5f1a16f', '[\"*\"]', '2025-06-14 21:11:58', NULL, '2025-06-14 21:11:51', '2025-06-14 21:11:58'),
(67, 'App\\Models\\User', 1, 'api-token', '4164a0e2e195086b9b272a7471a8bc5215b4957715b5d17b821e4a97ee070664', '[\"*\"]', '2025-06-14 21:14:36', NULL, '2025-06-14 21:14:22', '2025-06-14 21:14:36'),
(68, 'App\\Models\\User', 1, 'api-token', 'cecb0206ac4ee1641a1ef1a8f017a6d4902004fc5c36659fdbf1e9ed296da442', '[\"*\"]', '2025-06-14 21:15:44', NULL, '2025-06-14 21:15:43', '2025-06-14 21:15:44'),
(69, 'App\\Models\\User', 1, 'api-token', 'c4067357e19e891e05df167f874633d130424f223fcee94fb30f786814d80599', '[\"*\"]', '2025-06-14 21:16:41', NULL, '2025-06-14 21:16:32', '2025-06-14 21:16:41'),
(70, 'App\\Models\\User', 1, 'api-token', '8e355482d5793dfad5d90d40609c95fb3244856bb1ea6f1d127733587fa59093', '[\"*\"]', '2025-06-14 21:17:28', NULL, '2025-06-14 21:17:28', '2025-06-14 21:17:28'),
(71, 'App\\Models\\User', 1, 'api-token', 'c627f3afa67b3d96a6593108eaf428eb397dfc2789dad6d089991e698d983276', '[\"*\"]', '2025-06-15 03:27:01', NULL, '2025-06-15 03:26:38', '2025-06-15 03:27:01'),
(72, 'App\\Models\\User', 1, 'api-token', '2503ef7ca21dae99176a26ea88444a3fdd54e48fc042f850f350814dfcda3609', '[\"*\"]', '2025-06-15 03:30:11', NULL, '2025-06-15 03:29:53', '2025-06-15 03:30:11'),
(73, 'App\\Models\\User', 1, 'api-token', '9e4c26b9d771a923b7f8a73003e3c32ea8a77b8dbb38bb65aaa444be0a5d515f', '[\"*\"]', '2025-06-15 03:45:44', NULL, '2025-06-15 03:45:43', '2025-06-15 03:45:44'),
(74, 'App\\Models\\User', 1, 'api-token', '2aee5ba2ed9ed7b72f3c423890fa47410b584f169db80b390ae612e855d7546b', '[\"*\"]', '2025-06-15 03:49:39', NULL, '2025-06-15 03:49:35', '2025-06-15 03:49:39'),
(75, 'App\\Models\\User', 1, 'api-token', '68bbb312a9c5236f3918922a46d487859f519d05740e7577954d0a4252172224', '[\"*\"]', '2025-06-15 03:52:55', NULL, '2025-06-15 03:51:40', '2025-06-15 03:52:55'),
(76, 'App\\Models\\User', 1, 'api-token', 'f3934b9ac3c70f8d5ffd945c90aaac7771b7849a4471d32d8ed58cf7fc68500a', '[\"*\"]', '2025-06-15 04:00:17', NULL, '2025-06-15 03:58:18', '2025-06-15 04:00:17'),
(77, 'App\\Models\\User', 1, 'api-token', '2b3966c005c42dcc981114e86a0ada677b98e7d5cd2f529000fcd25ac8a485a0', '[\"*\"]', '2025-06-15 04:01:58', NULL, '2025-06-15 04:01:18', '2025-06-15 04:01:58'),
(78, 'App\\Models\\User', 1, 'api-token', 'c8805c69fc5fecb3ef9767d11bd1bf7589bde31fb0039d901a2b1540131229af', '[\"*\"]', '2025-06-15 04:12:58', NULL, '2025-06-15 04:11:45', '2025-06-15 04:12:58'),
(79, 'App\\Models\\User', 1, 'api-token', 'a1fa8ac1919eff56def855b7ba6201cbc7dad9529a64a01533fa73b8854f6026', '[\"*\"]', '2025-06-15 04:14:30', NULL, '2025-06-15 04:14:26', '2025-06-15 04:14:30'),
(80, 'App\\Models\\User', 1, 'api-token', '34f70bd4e7b79f7b565c5b66683fc32a2e3595169afbe377ea280b3242a18cd6', '[\"*\"]', '2025-06-15 04:15:08', NULL, '2025-06-15 04:15:05', '2025-06-15 04:15:08'),
(81, 'App\\Models\\User', 1, 'api-token', 'ef25662e043c785fa841a84d8ba22f5efe5cc1de77e25ed30b49a176c57cef9f', '[\"*\"]', '2025-06-15 04:17:55', NULL, '2025-06-15 04:17:43', '2025-06-15 04:17:55'),
(82, 'App\\Models\\User', 1, 'api-token', 'a736c551e64ed0f24c1162d7d03a7824fdb74a6ab1cb6e453c002f9b62b1b40b', '[\"*\"]', '2025-06-15 17:47:02', NULL, '2025-06-15 17:46:42', '2025-06-15 17:47:02'),
(83, 'App\\Models\\User', 1, 'api-token', '4c499a936382d4f22d600819266120469818a65f7663a444626cdff4ce2afab1', '[\"*\"]', '2025-06-15 17:50:11', NULL, '2025-06-15 17:50:10', '2025-06-15 17:50:11'),
(84, 'App\\Models\\User', 1, 'api-token', 'a6db95a3507cc12ee174b847df9dc3828bb50dbb3a3e67cf26500618f478c580', '[\"*\"]', '2025-06-15 17:53:29', NULL, '2025-06-15 17:53:28', '2025-06-15 17:53:29'),
(85, 'App\\Models\\User', 1, 'api-token', '2e51f8697247ef6df60ac9f7143275b5ed66d7d45fcd63f3d7da5c255170206f', '[\"*\"]', '2025-06-15 17:54:09', NULL, '2025-06-15 17:54:08', '2025-06-15 17:54:09'),
(86, 'App\\Models\\User', 1, 'api-token', 'fb64b7669aa38c85ae8bd25867eb4cdeba24e6570c26aedc72da6298b6fa5ada', '[\"*\"]', '2025-06-15 18:01:18', NULL, '2025-06-15 17:59:09', '2025-06-15 18:01:18'),
(87, 'App\\Models\\User', 1, 'api-token', '44455a254daeae98da77a1170ee37098c0c9029c3891106820d7d7197e739b8f', '[\"*\"]', '2025-06-15 18:11:40', NULL, '2025-06-15 18:11:32', '2025-06-15 18:11:40'),
(88, 'App\\Models\\User', 1, 'api-token', 'f5781c1f353d306495a5e68e6f5d54c63ad036dd7fc88cf465bb350a0a329fd7', '[\"*\"]', '2025-06-15 18:13:29', NULL, '2025-06-15 18:13:25', '2025-06-15 18:13:29'),
(89, 'App\\Models\\User', 1, 'api-token', '558e47579fa58f2267400e7c0ce800e3c583b08723cee78edd6ff398374b216e', '[\"*\"]', '2025-06-15 18:16:35', NULL, '2025-06-15 18:16:30', '2025-06-15 18:16:35'),
(90, 'App\\Models\\User', 1, 'api-token', '95e9d4c9c187f107e9a381cfab78591ed798052762a98070344d91ced0a1fd01', '[\"*\"]', '2025-06-15 18:17:17', NULL, '2025-06-15 18:17:13', '2025-06-15 18:17:17'),
(91, 'App\\Models\\User', 1, 'api-token', '635d14482ad140230ac59898ea8d3f01e34cb7c5510b1d14e6ed4cee6d96eae2', '[\"*\"]', '2025-06-15 18:19:41', NULL, '2025-06-15 18:19:37', '2025-06-15 18:19:41'),
(92, 'App\\Models\\User', 1, 'api-token', '4a38fc8fb598175db89caad48978bcc424f071004c7f814fe1fe60016584477f', '[\"*\"]', '2025-06-15 18:22:59', NULL, '2025-06-15 18:22:55', '2025-06-15 18:22:59'),
(93, 'App\\Models\\User', 1, 'api-token', 'e4d5b712c071dacb721330372629bd0e1fa58ad756c7b126fff738002d714946', '[\"*\"]', '2025-06-15 18:33:23', NULL, '2025-06-15 18:33:22', '2025-06-15 18:33:23'),
(94, 'App\\Models\\User', 1, 'api-token', '2429cafb93c3cbc34227c09e152517675462162ddf10f94b9d0e93737f0eb727', '[\"*\"]', '2025-06-15 18:34:51', NULL, '2025-06-15 18:34:44', '2025-06-15 18:34:51'),
(95, 'App\\Models\\User', 1, 'api-token', '1c3d8295131af322c28b5edc7e7ed7694d3a4913bad0a11698a82a519cb3a6d0', '[\"*\"]', '2025-06-15 18:38:07', NULL, '2025-06-15 18:37:12', '2025-06-15 18:38:07'),
(96, 'App\\Models\\User', 1, 'api-token', '9848178d534d543efcb5cdf41b66da33ff8fbd7758796d1711294a60a5ab737a', '[\"*\"]', '2025-06-15 18:45:12', NULL, '2025-06-15 18:45:08', '2025-06-15 18:45:12'),
(97, 'App\\Models\\User', 1, 'api-token', 'e3470a8a30a23ba5f9e8891614f99a8ba420f6d56d22ba0a7b060a525936bd12', '[\"*\"]', '2025-06-15 18:47:11', NULL, '2025-06-15 18:47:08', '2025-06-15 18:47:11'),
(98, 'App\\Models\\User', 1, 'api-token', '44bec790ed564aaaea45250e2253c31c1e3e8ecaa65a03320f8de34de06dacae', '[\"*\"]', '2025-06-15 18:48:35', NULL, '2025-06-15 18:48:31', '2025-06-15 18:48:35'),
(99, 'App\\Models\\User', 1, 'api-token', 'f6df4feee6e19e6f291dfda74400ad497d7d4babe521c8e4da05bb2615b0d842', '[\"*\"]', '2025-06-15 18:55:48', NULL, '2025-06-15 18:55:44', '2025-06-15 18:55:48'),
(100, 'App\\Models\\User', 1, 'api-token', '6c7553065aae080b5c52dc45c1d9ae3feb7835256dc1975819e0df36a08347e3', '[\"*\"]', '2025-06-15 18:56:51', NULL, '2025-06-15 18:56:47', '2025-06-15 18:56:51'),
(101, 'App\\Models\\User', 1, 'api-token', '539b31faac0cddbb48d834150eaa07c32765c643e948b7739a3f07b6a5f17e0a', '[\"*\"]', '2025-06-15 19:04:05', NULL, '2025-06-15 19:04:04', '2025-06-15 19:04:05'),
(102, 'App\\Models\\User', 1, 'api-token', 'b9852674da9581941c637dcb6e709d3cc4d82ff8173d532099e9fd3b1feb7621', '[\"*\"]', '2025-06-15 19:09:13', NULL, '2025-06-15 19:08:54', '2025-06-15 19:09:13'),
(103, 'App\\Models\\User', 1, 'api-token', 'b24aba22063ff5904ad3c7b908d1939adbfefe059eab029d82eb481e8cead74b', '[\"*\"]', '2025-06-15 19:11:03', NULL, '2025-06-15 19:10:49', '2025-06-15 19:11:03'),
(104, 'App\\Models\\User', 1, 'api-token', '37f6f33ff6c275cbc356cf3030e57b97d0f46b2a0ac4a646590b0c9f78cb9d55', '[\"*\"]', '2025-06-15 19:16:24', NULL, '2025-06-15 19:16:09', '2025-06-15 19:16:24'),
(105, 'App\\Models\\User', 1, 'api-token', '9928d461d433a96132bc0ea74b2678c20ba1a7378d729ce3682a4d798bd4c319', '[\"*\"]', '2025-06-15 19:20:36', NULL, '2025-06-15 19:20:13', '2025-06-15 19:20:36'),
(106, 'App\\Models\\User', 1, 'api-token', '74cd4cd5c1e46248329688f9b150ba5be3f84683e7c2ae61a7fab90f72908d77', '[\"*\"]', '2025-06-15 19:21:32', NULL, '2025-06-15 19:21:21', '2025-06-15 19:21:32'),
(107, 'App\\Models\\User', 1, 'api-token', '3778acb7bbb8c3bde062a8a1b6aeb714b8c93af786d7b4614740df8afa739910', '[\"*\"]', '2025-06-15 19:27:42', NULL, '2025-06-15 19:27:30', '2025-06-15 19:27:42'),
(108, 'App\\Models\\User', 1, 'api-token', 'c7bc8ee5cf70abb14531f02778a63e2a01fe55a24932a841c96ca3cc7379e449', '[\"*\"]', '2025-06-15 19:39:18', NULL, '2025-06-15 19:38:54', '2025-06-15 19:39:18'),
(109, 'App\\Models\\User', 1, 'api-token', '473a66cc8f69faff6609a63003647bab9e9d47d0a7445aff741f1293a3b3bde1', '[\"*\"]', '2025-06-15 19:40:43', NULL, '2025-06-15 19:40:28', '2025-06-15 19:40:43'),
(110, 'App\\Models\\User', 1, 'api-token', 'dcf4f82d38c2e19b8f5acd9329173ad57dbe082c527d2284e925767fed7736c9', '[\"*\"]', '2025-06-15 19:43:13', NULL, '2025-06-15 19:43:08', '2025-06-15 19:43:13'),
(111, 'App\\Models\\User', 1, 'api-token', 'ae51dbc239f46262e000e3882dddfd845ced34bd8d22d374a03c10b6a5a57654', '[\"*\"]', '2025-06-15 19:49:16', NULL, '2025-06-15 19:49:11', '2025-06-15 19:49:16'),
(112, 'App\\Models\\User', 1, 'api-token', 'cfeecd61eced2151913b8aa9af3e545022ef4ccb038881dd941c99af57fe2b31', '[\"*\"]', '2025-06-15 19:50:23', NULL, '2025-06-15 19:49:55', '2025-06-15 19:50:23'),
(113, 'App\\Models\\User', 1, 'api-token', '96456098941fc69dda72bd63b0162f5a41ae5b93991ec2f6a943a739cc3f1769', '[\"*\"]', '2025-06-15 19:59:17', NULL, '2025-06-15 19:55:05', '2025-06-15 19:59:17'),
(114, 'App\\Models\\User', 1, 'api-token', 'e39c79cc500685b8c0a07379ca7d686833038a2a0dd339de9a6f5544628f2859', '[\"*\"]', '2025-06-15 20:11:12', NULL, '2025-06-15 20:04:34', '2025-06-15 20:11:12'),
(115, 'App\\Models\\User', 1, 'api-token', '7ad557a3a1612d85fd29a97c89eeb484fb3f8244297e66c003bd50897f10bdbe', '[\"*\"]', '2025-06-15 21:15:19', NULL, '2025-06-15 21:15:18', '2025-06-15 21:15:19'),
(116, 'App\\Models\\User', 1, 'api-token', 'fad4a4f2ef3ae735e035e5d54692e08163e4ca21f35dd32e9757ce7f84c10f82', '[\"*\"]', '2025-06-15 21:18:20', NULL, '2025-06-15 21:18:19', '2025-06-15 21:18:20'),
(117, 'App\\Models\\User', 1, 'api-token', 'bf6bacb17c6c1cf5aa171735c83b64d890a5d05319a83be4636c663694897c81', '[\"*\"]', '2025-06-15 21:21:51', NULL, '2025-06-15 21:21:40', '2025-06-15 21:21:51'),
(118, 'App\\Models\\User', 1, 'api-token', '3cb23c1ace6ff653535bb1f12d51e454dd870244712f8e7ad325def5b018ee4b', '[\"*\"]', '2025-06-15 21:38:54', NULL, '2025-06-15 21:38:47', '2025-06-15 21:38:54'),
(119, 'App\\Models\\User', 1, 'api-token', '831a68cc303686782318b41e21754680b1c49b9df8deea3359095a26be4d49c3', '[\"*\"]', '2025-06-15 21:42:30', NULL, '2025-06-15 21:42:08', '2025-06-15 21:42:30'),
(120, 'App\\Models\\User', 1, 'api-token', '248f4d8598300dac782126135e18c808f2c6793883a4011e105a8a31506d8fbd', '[\"*\"]', '2025-06-15 21:53:13', NULL, '2025-06-15 21:51:37', '2025-06-15 21:53:13'),
(121, 'App\\Models\\User', 1, 'api-token', '41aaa2efd91045da1656d529dfa94d3e1631ed5ea10ae9a9b15716e0e58300d0', '[\"*\"]', '2025-06-16 03:00:57', NULL, '2025-06-16 03:00:41', '2025-06-16 03:00:57'),
(122, 'App\\Models\\User', 1, 'api-token', '64d2ae4d8445608fb853e11b0310940f238c631d8e4d029bc0c7f5b03fab380c', '[\"*\"]', '2025-06-16 03:01:20', NULL, '2025-06-16 03:01:15', '2025-06-16 03:01:20'),
(123, 'App\\Models\\User', 1, 'api-token', '3b4d3190fa6dcaae23cd33cdcde7f4476559b1f5291fedca836d7c3ae2eb040b', '[\"*\"]', '2025-06-16 03:07:41', NULL, '2025-06-16 03:07:37', '2025-06-16 03:07:41'),
(124, 'App\\Models\\User', 1, 'api-token', 'c8569e5d99cacedbdc95797ba3db2dc74bf5c8aef28f99696c655779ef4ba3ba', '[\"*\"]', '2025-06-16 03:12:23', NULL, '2025-06-16 03:11:02', '2025-06-16 03:12:23'),
(125, 'App\\Models\\User', 1, 'api-token', '309dbe3f42c968580576ef73c5ff0eb9afb783ec94e19dabeade5b1e330aaf21', '[\"*\"]', '2025-06-16 03:17:47', NULL, '2025-06-16 03:12:47', '2025-06-16 03:17:47'),
(126, 'App\\Models\\User', 1, 'api-token', 'f594bd62d328bc25f2451a344178cdab61aaef93d5ff8fb6465cf240a1af8b10', '[\"*\"]', '2025-06-16 03:19:08', NULL, '2025-06-16 03:18:48', '2025-06-16 03:19:08'),
(127, 'App\\Models\\User', 1, 'api-token', 'b8c7ff039131f1e73dc937cab930be23f093088b4b52317e57d80495eb64d5ff', '[\"*\"]', '2025-06-16 04:57:15', NULL, '2025-06-16 04:56:02', '2025-06-16 04:57:15'),
(128, 'App\\Models\\User', 1, 'api-token', '90a9b1da15cd517c9ead461b07bdacafa345d3df46996573132fcef3bac60dca', '[\"*\"]', '2025-06-16 05:10:19', NULL, '2025-06-16 05:10:18', '2025-06-16 05:10:19'),
(129, 'App\\Models\\User', 1, 'api-token', '32b63e448f1d3de88dbd92b01fcc189f1d83c54caf431d170c36532f3ec1ce2c', '[\"*\"]', '2025-06-16 05:11:55', NULL, '2025-06-16 05:11:50', '2025-06-16 05:11:55'),
(130, 'App\\Models\\User', 1, 'api-token', '0eda9e3b658d47822b96409ef5743a027d7221f04f002fb4d407c960b317cc2f', '[\"*\"]', '2025-06-16 05:12:55', NULL, '2025-06-16 05:12:38', '2025-06-16 05:12:55'),
(131, 'App\\Models\\User', 1, 'api-token', 'e9415de47ee891f74f7b99607340952d3f95e5bd733e23fec270187a143e5cdd', '[\"*\"]', '2025-06-16 05:15:15', NULL, '2025-06-16 05:15:13', '2025-06-16 05:15:15'),
(132, 'App\\Models\\User', 1, 'api-token', '40fa1c0d2ca6fde3aa5d16efdfb5097058199997e8ef7453a961a4ec7d56cf7c', '[\"*\"]', '2025-06-16 05:17:40', NULL, '2025-06-16 05:17:39', '2025-06-16 05:17:40'),
(133, 'App\\Models\\User', 1, 'api-token', '37fe8a48bd566bc5d79240601b76a74ae0b8386cd8e0cdcd76189f0b49dafb92', '[\"*\"]', '2025-06-16 05:29:17', NULL, '2025-06-16 05:23:12', '2025-06-16 05:29:17'),
(134, 'App\\Models\\User', 1, 'api-token', 'f2a30a665c65b13b259ee91e33c688bf35cec4a9d03f15b9054ce4e568000f1f', '[\"*\"]', '2025-06-16 05:33:27', NULL, '2025-06-16 05:33:26', '2025-06-16 05:33:27'),
(135, 'App\\Models\\User', 1, 'api-token', '51a8e09fe69c2fcac6df8facffdf2b664a605fd8cf57c460e21d0a2b2feb14d0', '[\"*\"]', '2025-06-16 05:53:53', NULL, '2025-06-16 05:53:51', '2025-06-16 05:53:53'),
(136, 'App\\Models\\User', 1, 'api-token', '7473f187d563533207c6e7a62173e3caffa1e73306f8fc7074825b5591c37d55', '[\"*\"]', '2025-06-16 06:05:04', NULL, '2025-06-16 06:05:03', '2025-06-16 06:05:04'),
(137, 'App\\Models\\User', 1, 'api-token', 'cdfe3ca335374544b320da4ca2d35bf436ef625641450768dbbddbd9f25e9ee0', '[\"*\"]', '2025-06-16 06:09:48', NULL, '2025-06-16 06:09:46', '2025-06-16 06:09:48'),
(138, 'App\\Models\\User', 1, 'api-token', '91bfc5ad926bab05d05b66ad298686ac9a606adef2e85366882e87db1888adac', '[\"*\"]', '2025-06-16 06:13:36', NULL, '2025-06-16 06:13:34', '2025-06-16 06:13:36'),
(139, 'App\\Models\\User', 1, 'api-token', 'e1e8f53ab21742d9fa3a4a54f78b33e79c4510fed9206b49b20519b31ab75279', '[\"*\"]', '2025-06-16 06:14:56', NULL, '2025-06-16 06:14:27', '2025-06-16 06:14:56'),
(140, 'App\\Models\\User', 1, 'api-token', '79a9dd6cf4cd2c9544ab4576c3f9c8728b88d1a68825c80f61f2c67e025be2df', '[\"*\"]', '2025-06-16 06:19:23', NULL, '2025-06-16 06:19:22', '2025-06-16 06:19:23'),
(141, 'App\\Models\\User', 1, 'api-token', 'ac69f1758cb6e4882753108efea9d5cfa188cb9390c65b6b261d7a5284e553e6', '[\"*\"]', '2025-06-16 06:21:51', NULL, '2025-06-16 06:21:49', '2025-06-16 06:21:51'),
(142, 'App\\Models\\User', 2, 'api-token', '2fcc56da0704c28e9a01b1943ed7942d114d06518d4b74c774005089521cac62', '[\"*\"]', '2025-06-16 06:22:38', NULL, '2025-06-16 06:22:11', '2025-06-16 06:22:38'),
(143, 'App\\Models\\User', 2, 'api-token', '7117a0ae79f37a78e6e89386244d609d70082dfa6d92fd6e740b38f96a0bf03d', '[\"*\"]', '2025-06-16 06:28:49', NULL, '2025-06-16 06:28:21', '2025-06-16 06:28:49'),
(144, 'App\\Models\\User', 2, 'api-token', '2257343ad2501057af65ac6464a259c224d0253a5ac8d4c8df3d6455ccabd4ff', '[\"*\"]', '2025-06-16 06:36:27', NULL, '2025-06-16 06:35:01', '2025-06-16 06:36:27'),
(145, 'App\\Models\\User', 2, 'api-token', '709ba2f96710ba4cc55c8b2ba291cd92b04f4f8e2d7a4d264236b6b93f357fe7', '[\"*\"]', '2025-06-16 06:43:20', NULL, '2025-06-16 06:43:18', '2025-06-16 06:43:20'),
(146, 'App\\Models\\User', 2, 'api-token', 'c1d4bda491ac3f8055dd0d1b7d142bdb0a1368c09e8fcff84992369bd6428cdd', '[\"*\"]', '2025-06-16 06:46:56', NULL, '2025-06-16 06:46:39', '2025-06-16 06:46:56'),
(147, 'App\\Models\\User', 1, 'api-token', 'db944911f2c8493eaf0576d16f10f92f54dd9121bb40dd560c32b32300f9c8d6', '[\"*\"]', '2025-06-16 06:47:18', NULL, '2025-06-16 06:47:17', '2025-06-16 06:47:18'),
(148, 'App\\Models\\User', 1, 'api-token', 'fd3d66e6a4bb77829c0347e87783558d439f4f209730a4b819106338e9734306', '[\"*\"]', '2025-06-16 06:51:15', NULL, '2025-06-16 06:51:13', '2025-06-16 06:51:15'),
(149, 'App\\Models\\User', 1, 'api-token', '233758d7ee099f651f3bc0bcbc33bef67d298d2526357d376b212f05caaca659', '[\"*\"]', '2025-06-16 06:54:31', NULL, '2025-06-16 06:54:29', '2025-06-16 06:54:31'),
(150, 'App\\Models\\User', 1, 'api-token', '4176daef26dfb7e0f850a62f3cd9b30a3dc8ed6fbdcaea0f79e5ba698640b8ea', '[\"*\"]', '2025-06-16 06:57:01', NULL, '2025-06-16 06:57:00', '2025-06-16 06:57:01'),
(151, 'App\\Models\\User', 1, 'api-token', '72b2c378a4cab3ba0e648d840d06bf3d4f4abeeffa3347d7c4b1e3f3f12228ca', '[\"*\"]', '2025-06-16 06:59:44', NULL, '2025-06-16 06:59:42', '2025-06-16 06:59:44'),
(152, 'App\\Models\\User', 1, 'api-token', '717e35897f59071a98c3a66e8dd595cc8d387b358130a8c9700238f3d59aff1e', '[\"*\"]', '2025-06-16 07:00:58', NULL, '2025-06-16 07:00:57', '2025-06-16 07:00:58'),
(153, 'App\\Models\\User', 1, 'api-token', 'ca01dcbda5f3e103450fc415deed5c52ce5c22558a86f364e98c7a907d22cc99', '[\"*\"]', '2025-06-16 07:09:38', NULL, '2025-06-16 07:09:36', '2025-06-16 07:09:38'),
(154, 'App\\Models\\User', 1, 'api-token', '13ada5c56e71c0a775670fb1d4c6673e5fd33709b94e9c5fd9d49f1a420d4e69', '[\"*\"]', '2025-06-16 07:13:57', NULL, '2025-06-16 07:13:53', '2025-06-16 07:13:57'),
(155, 'App\\Models\\User', 1, 'api-token', 'ab3fd57885869275a883fa31d3aa7552bee5c4c4e305ea471752391e084dfa5f', '[\"*\"]', '2025-06-16 07:15:54', NULL, '2025-06-16 07:15:51', '2025-06-16 07:15:54'),
(156, 'App\\Models\\User', 1, 'api-token', '78a1edcc95dbedf4c2d47ed55fbf857bde6e06892bc12414302d76c15a8bbc2c', '[\"*\"]', '2025-06-16 19:31:06', NULL, '2025-06-16 19:30:30', '2025-06-16 19:31:06'),
(157, 'App\\Models\\User', 2, 'api-token', 'd7d55e9da15686742f42fecfb8a144b6fd104e91b9f291362e6ab7702d2af365', '[\"*\"]', '2025-06-16 19:32:04', NULL, '2025-06-16 19:31:39', '2025-06-16 19:32:04'),
(158, 'App\\Models\\User', 2, 'api-token', 'a3c20f895b2c04302428fbf1a089b3da820f62bb9cec92b3078ab5ab193e6e76', '[\"*\"]', '2025-06-16 19:37:50', NULL, '2025-06-16 19:37:48', '2025-06-16 19:37:50'),
(159, 'App\\Models\\User', 2, 'api-token', 'a07cd2a4b11fa01037d0d4e5b51ed6c33342b407771a10a8be853ad11764b24d', '[\"*\"]', NULL, NULL, '2025-06-16 19:44:28', '2025-06-16 19:44:28'),
(160, 'App\\Models\\User', 1, 'api-token', 'cf16428ea4fce291c27ff56f4708958db6c542a382bc774154e8d5432f76fa19', '[\"*\"]', '2025-06-16 19:47:57', NULL, '2025-06-16 19:47:47', '2025-06-16 19:47:57'),
(161, 'App\\Models\\User', 2, 'api-token', '0519792cefa45a1399c9c4521e6da73fde043739900eaab44052c45e096dd3b1', '[\"*\"]', '2025-06-16 19:50:33', NULL, '2025-06-16 19:50:32', '2025-06-16 19:50:33'),
(162, 'App\\Models\\User', 2, 'api-token', 'c8b2243b589196350f92fb48c11951fa0eaddce2b049e9811bd518cb83ebb798', '[\"*\"]', '2025-06-16 19:51:43', NULL, '2025-06-16 19:51:42', '2025-06-16 19:51:43'),
(163, 'App\\Models\\User', 2, 'api-token', '9e779b66749d682a8cafe6821b2ddca9a064674217404b362cfce208d42084d7', '[\"*\"]', '2025-06-16 19:54:17', NULL, '2025-06-16 19:54:16', '2025-06-16 19:54:17'),
(164, 'App\\Models\\User', 2, 'api-token', 'ba393d598e1881c794a9463f8aec2f2afb064c91f87dea61c0a1501612a35236', '[\"*\"]', '2025-06-16 19:58:09', NULL, '2025-06-16 19:58:08', '2025-06-16 19:58:09'),
(165, 'App\\Models\\User', 2, 'api-token', 'fc9546ba8e0574a1b5b101942f4a4794d722f047b6be63779a9e3c780d03c526', '[\"*\"]', '2025-06-16 19:59:57', NULL, '2025-06-16 19:59:57', '2025-06-16 19:59:57'),
(166, 'App\\Models\\User', 2, 'api-token', 'd086c93c073543f26cf08c678b9a6bdc3e16587c988f87b98e1fd41967cb1171', '[\"*\"]', '2025-06-16 20:03:22', NULL, '2025-06-16 20:03:21', '2025-06-16 20:03:22'),
(167, 'App\\Models\\User', 2, 'api-token', 'f09f8b28054843d5d7104b4ee1f074948ece00f46e38ec9d5e698a90b38fb794', '[\"*\"]', '2025-06-16 20:05:51', NULL, '2025-06-16 20:05:50', '2025-06-16 20:05:51'),
(168, 'App\\Models\\User', 2, 'api-token', '43c9ce33447a96ec7e643898a38c6f0184530f137283a46a538b1daa3babd816', '[\"*\"]', '2025-06-16 20:10:00', NULL, '2025-06-16 20:10:00', '2025-06-16 20:10:00'),
(169, 'App\\Models\\User', 2, 'api-token', '3f5c4ad01a20c7c591c005d8a7ec22dcc2a54306860a07a9b0413293a6c26c61', '[\"*\"]', '2025-06-16 20:10:59', NULL, '2025-06-16 20:10:58', '2025-06-16 20:10:59'),
(170, 'App\\Models\\User', 2, 'api-token', '5bc8ff58f0ccfd76a5339b8efd03c37a3d38c2795f9206837b0bc61961a6c268', '[\"*\"]', '2025-06-16 20:11:39', NULL, '2025-06-16 20:11:38', '2025-06-16 20:11:39'),
(171, 'App\\Models\\User', 2, 'api-token', '830b9b5404d00deb2e00bbc8bbaaa56226b9691cb03184b5392133e90ab7929f', '[\"*\"]', '2025-06-16 20:12:32', NULL, '2025-06-16 20:12:31', '2025-06-16 20:12:32'),
(172, 'App\\Models\\User', 2, 'api-token', '4e7be36b4bb7fb212102f824a969b516c40d9d78c6f168cc42dd0c572a0f3e43', '[\"*\"]', '2025-06-16 20:22:55', NULL, '2025-06-16 20:22:41', '2025-06-16 20:22:55'),
(173, 'App\\Models\\User', 2, 'api-token', 'e4a2c9bec5da0a309108f0333d7cac0c99c550a4a323d29c5c9d45f4d1da4c36', '[\"*\"]', '2025-06-16 20:25:43', NULL, '2025-06-16 20:25:36', '2025-06-16 20:25:43'),
(174, 'App\\Models\\User', 2, 'api-token', 'a21422222b0e1532fb7327a499a90aca2577c8ed486fa136b95e546db4c120ce', '[\"*\"]', '2025-06-16 20:27:15', NULL, '2025-06-16 20:27:00', '2025-06-16 20:27:15'),
(175, 'App\\Models\\User', 2, 'api-token', '89c7067684bb291ea7b5c15b07b67cde63ffdcd45305486b434ecd07866b7ded', '[\"*\"]', '2025-06-16 20:28:53', NULL, '2025-06-16 20:28:49', '2025-06-16 20:28:53'),
(176, 'App\\Models\\User', 2, 'api-token', 'bbed23dbdb076859085f24d3f329f959029f9dd2205eca0ff6bc5be2e667c6df', '[\"*\"]', '2025-06-16 20:31:05', NULL, '2025-06-16 20:30:33', '2025-06-16 20:31:05'),
(177, 'App\\Models\\User', 2, 'api-token', '29ea4c699f9eda31afc11e8a302ac244d8c71e3ecf4efbb2b8dc77def64170ce', '[\"*\"]', '2025-06-16 20:31:50', NULL, '2025-06-16 20:31:46', '2025-06-16 20:31:50'),
(178, 'App\\Models\\User', 2, 'api-token', '5550b6f35df754efd564b87a7ad8ce2843494cc75d3a8d811873cf961aa6052e', '[\"*\"]', '2025-06-16 20:32:41', NULL, '2025-06-16 20:32:31', '2025-06-16 20:32:41'),
(179, 'App\\Models\\User', 2, 'api-token', '8b3a87a91d007e89c9f899f13fdb80331b607dc4863caf1e9fde1630bb29cfd2', '[\"*\"]', '2025-06-16 20:33:30', NULL, '2025-06-16 20:33:29', '2025-06-16 20:33:30'),
(180, 'App\\Models\\User', 2, 'api-token', '6d7a8775da94cd22fa59536ed0434cd0d658d598694639d9acd8fe50d29004c3', '[\"*\"]', '2025-06-16 20:34:04', NULL, '2025-06-16 20:34:03', '2025-06-16 20:34:04'),
(181, 'App\\Models\\User', 2, 'api-token', '4d7d446cd8a054dbac47d6f3f00fce07e8034658aa31761045d8043e6fa886e4', '[\"*\"]', '2025-06-16 20:38:02', NULL, '2025-06-16 20:37:06', '2025-06-16 20:38:02'),
(182, 'App\\Models\\User', 1, 'api-token', 'adb032c642812f0bcdc540cd00bc72c533e3ac8e41d1a71134c55a75aed8c0b0', '[\"*\"]', '2025-06-16 20:59:35', NULL, '2025-06-16 20:54:12', '2025-06-16 20:59:35'),
(183, 'App\\Models\\User', 2, 'api-token', '659393580378c82c708b9983b44fdac955a9f341e9a8937ec149ec23fcccfd04', '[\"*\"]', '2025-06-16 21:03:24', NULL, '2025-06-16 21:00:31', '2025-06-16 21:03:24'),
(184, 'App\\Models\\User', 1, 'api-token', 'c93627865a1b1bca9e12e134449a1f056850c2439e169991a0e68e3c9acec22a', '[\"*\"]', '2025-06-17 05:10:01', NULL, '2025-06-17 05:08:59', '2025-06-17 05:10:01'),
(185, 'App\\Models\\User', 1, 'api-token', 'b65ccb79b93979f7210f20c3a363192a6699609a52cbdcda2d24fcd872bdf57e', '[\"*\"]', '2025-06-17 05:34:37', NULL, '2025-06-17 05:34:09', '2025-06-17 05:34:37'),
(186, 'App\\Models\\User', 1, 'api-token', 'ad1776e13142f0c9e1b800611406894258f0d858aa8cb4309cabfec282e64ca5', '[\"*\"]', '2025-06-17 05:40:40', NULL, '2025-06-17 05:39:45', '2025-06-17 05:40:40'),
(187, 'App\\Models\\User', 1, 'api-token', 'bd53a564d4228fa69ff492b4294d66709e430e3be04b65755fc3240005d9672c', '[\"*\"]', '2025-06-17 05:43:52', NULL, '2025-06-17 05:43:44', '2025-06-17 05:43:52'),
(188, 'App\\Models\\User', 1, 'api-token', '341d846d982f9dd4babe5150b9eeaeeabb37c08194d63e88d41964efb05eb832', '[\"*\"]', '2025-06-17 05:46:47', NULL, '2025-06-17 05:46:32', '2025-06-17 05:46:47'),
(189, 'App\\Models\\User', 1, 'api-token', '50bcc7b42c54eb15dd7bc3a8f568b9bedb56e360b8526b5431ec6179b3b0dfee', '[\"*\"]', '2025-06-17 06:24:48', NULL, '2025-06-17 05:49:33', '2025-06-17 06:24:48'),
(190, 'App\\Models\\User', 1, 'api-token', '23d8946bc241103909f218ee18f1d69cdcba9b6654195398d30bc72557d692af', '[\"*\"]', '2025-06-17 06:40:32', NULL, '2025-06-17 06:40:09', '2025-06-17 06:40:32'),
(191, 'App\\Models\\User', 1, 'api-token', '200bf353fa13afe473931ac38bfbae26d1a63fac238695250549f87d72632664', '[\"*\"]', '2025-06-17 06:47:16', NULL, '2025-06-17 06:46:38', '2025-06-17 06:47:16'),
(192, 'App\\Models\\User', 1, 'api-token', '9c46ebbadaf8a21804a178f600cd1be02c661e33efb97ae363fc41e073a46a5f', '[\"*\"]', '2025-06-17 06:51:55', NULL, '2025-06-17 06:51:40', '2025-06-17 06:51:55'),
(193, 'App\\Models\\User', 1, 'api-token', 'af551e2436ebaecd2d48e75f0d339f0e7129ac30db8defac1d1424de2d07faf3', '[\"*\"]', '2025-06-17 07:16:48', NULL, '2025-06-17 07:11:25', '2025-06-17 07:16:48'),
(194, 'App\\Models\\User', 1, 'api-token', '25529bebe13e6feded5f26f9880ba96c29ddc8cca78be4f499fd3865987ed972', '[\"*\"]', '2025-06-17 07:24:11', NULL, '2025-06-17 07:23:24', '2025-06-17 07:24:11'),
(195, 'App\\Models\\User', 1, 'api-token', '5ce57674904fcf8f38f2878518f5431b5c1781352f8c8cb133c0c4b02ce93d7b', '[\"*\"]', '2025-06-17 07:28:50', NULL, '2025-06-17 07:28:11', '2025-06-17 07:28:50'),
(196, 'App\\Models\\User', 1, 'api-token', 'fff96f27fddac41e7eac772af42edff48c72017be48d3d91d35725c550f2c27f', '[\"*\"]', '2025-06-17 07:31:02', NULL, '2025-06-17 07:30:32', '2025-06-17 07:31:02'),
(197, 'App\\Models\\User', 1, 'api-token', 'c2f3c916468cefd19b9e3a4771ecebfcc1e61433ca885e84fb26b44fa954280d', '[\"*\"]', '2025-06-17 07:35:04', NULL, '2025-06-17 07:32:22', '2025-06-17 07:35:04'),
(198, 'App\\Models\\User', 1, 'api-token', 'a5cba0122980b7d47e9de332f3239dead3380e06604a856755050aafe7a4a902', '[\"*\"]', '2025-06-17 07:36:39', NULL, '2025-06-17 07:36:10', '2025-06-17 07:36:39'),
(199, 'App\\Models\\User', 1, 'api-token', 'e6d8edab04e3c08a33c945e1de39cc960c0bbac375fd58cbfecdc67bdd79fb36', '[\"*\"]', '2025-06-17 07:39:30', NULL, '2025-06-17 07:38:36', '2025-06-17 07:39:30'),
(200, 'App\\Models\\User', 1, 'api-token', '589b47b455b081b84147a75a8d1f064f0749b3a46c30ee64d6ad141c1a393e26', '[\"*\"]', '2025-06-17 07:40:18', NULL, '2025-06-17 07:40:12', '2025-06-17 07:40:18'),
(201, 'App\\Models\\User', 1, 'api-token', '19af61958714d609012181c383ffd999184830dab59239c96aa1092c89bda01f', '[\"*\"]', '2025-06-17 19:52:04', NULL, '2025-06-17 19:51:13', '2025-06-17 19:52:04'),
(202, 'App\\Models\\User', 1, 'api-token', '2f6bcc3ae87efde7fa4c34a986f57a7112109066d8d4e349c6f89beabb07c971', '[\"*\"]', '2025-06-17 19:58:23', NULL, '2025-06-17 19:58:18', '2025-06-17 19:58:23'),
(203, 'App\\Models\\User', 1, 'api-token', 'f1427e298234c48c67ceb5f7a0e68e4ce97f2d69d597268605634bfcfefd460e', '[\"*\"]', '2025-06-17 20:00:17', NULL, '2025-06-17 20:00:11', '2025-06-17 20:00:17'),
(204, 'App\\Models\\User', 1, 'api-token', '62f6789bb4706138fcddb915fe75907ae79a840581909d69a4eb6caa517b6a87', '[\"*\"]', '2025-06-17 20:03:55', NULL, '2025-06-17 20:03:50', '2025-06-17 20:03:55'),
(205, 'App\\Models\\User', 1, 'api-token', '6f980e97056f2c5a0a4f2b4a03d9ad532c26d3c4b2a5bf9731a6ecf04dc25ea9', '[\"*\"]', '2025-06-17 20:18:53', NULL, '2025-06-17 20:18:31', '2025-06-17 20:18:53'),
(206, 'App\\Models\\User', 1, 'api-token', '9e69ef94c6de2ea63744e3e2606bf706a15e6066eac5bdd86243aabffdd957da', '[\"*\"]', '2025-06-17 20:25:14', NULL, '2025-06-17 20:24:55', '2025-06-17 20:25:14'),
(207, 'App\\Models\\User', 1, 'api-token', 'b33772e5ce6703eb311068245b35d23d314f8263f26feea651e16ebb3d4d3112', '[\"*\"]', '2025-06-17 20:29:53', NULL, '2025-06-17 20:29:52', '2025-06-17 20:29:53'),
(208, 'App\\Models\\User', 1, 'api-token', '7ae80bfdb3ed736ad51c85ed87839aa9da82b07d0f3c32fb9ca82fc3db2eecae', '[\"*\"]', '2025-06-17 20:34:38', NULL, '2025-06-17 20:34:36', '2025-06-17 20:34:38'),
(209, 'App\\Models\\User', 1, 'api-token', '7eb9767a6d1563897c02b66747be7b275de46f99740e2aad04f693742734ffdf', '[\"*\"]', '2025-06-17 20:39:10', NULL, '2025-06-17 20:39:08', '2025-06-17 20:39:10'),
(210, 'App\\Models\\User', 1, 'api-token', '34ec9c4bc3fb45cfa6fa6467c644435009ffd879d6b4f0ecaf2f5bc36f9fb233', '[\"*\"]', '2025-06-17 20:40:28', NULL, '2025-06-17 20:40:26', '2025-06-17 20:40:28'),
(211, 'App\\Models\\User', 1, 'api-token', 'ad8c06112e613cda712041dd19d19ae0892ff1cc50b45057304f45dec16dcb64', '[\"*\"]', '2025-06-17 20:41:06', NULL, '2025-06-17 20:41:04', '2025-06-17 20:41:06'),
(212, 'App\\Models\\User', 1, 'api-token', '5c7abd9a1ff51e1719f2f8a01fd04755016332a4357da2d80f6bb270915ef27c', '[\"*\"]', '2025-06-17 20:45:16', NULL, '2025-06-17 20:45:15', '2025-06-17 20:45:16'),
(213, 'App\\Models\\User', 1, 'api-token', '6d434e354cdb78a60bb747cfb4a9087a1c28e195d4fc9b9379bf33c8980d917f', '[\"*\"]', '2025-06-17 20:47:00', NULL, '2025-06-17 20:46:59', '2025-06-17 20:47:00'),
(214, 'App\\Models\\User', 1, 'api-token', '703ccfd2a7c6fe6d167897623fadee747d31fcd8162a30cdbf673cdc050af105', '[\"*\"]', '2025-06-17 20:48:02', NULL, '2025-06-17 20:48:01', '2025-06-17 20:48:02'),
(215, 'App\\Models\\User', 1, 'api-token', '5c181d6e9d06b6da8a9a148d7891442b710012c900bd4ae24d369f72fe2c7e32', '[\"*\"]', '2025-06-17 20:52:33', NULL, '2025-06-17 20:51:57', '2025-06-17 20:52:33'),
(216, 'App\\Models\\User', 2, 'api-token', 'd9b4facc8c2e22683bae22bbd11023a5d95040d0a757d092c19696f16fe98477', '[\"*\"]', '2025-06-17 21:01:28', NULL, '2025-06-17 21:01:27', '2025-06-17 21:01:28'),
(217, 'App\\Models\\User', 2, 'api-token', 'e211381080d689bb4a10a0b8501f0892c482238097d53249fd79eaee317591ff', '[\"*\"]', '2025-06-17 21:05:23', NULL, '2025-06-17 21:05:14', '2025-06-17 21:05:23'),
(218, 'App\\Models\\User', 2, 'api-token', 'c0dae587fc79fb1c2263069e0b24a740c2955aea3d0d765955216b176d8964d3', '[\"*\"]', '2025-06-17 21:09:54', NULL, '2025-06-17 21:09:48', '2025-06-17 21:09:54'),
(219, 'App\\Models\\User', 2, 'api-token', 'd830b3a04b95aab2f05dd43b51dc3860bb0d10c386e060f6df11e6791d09ff54', '[\"*\"]', '2025-06-17 21:14:45', NULL, '2025-06-17 21:13:54', '2025-06-17 21:14:45'),
(220, 'App\\Models\\User', 2, 'api-token', '1b914e80aa25f9ba49a03694cd773f0cac02c9afbfd6c49ef94bbe4a834927f9', '[\"*\"]', '2025-06-17 21:19:24', NULL, '2025-06-17 21:18:14', '2025-06-17 21:19:24'),
(221, 'App\\Models\\User', 2, 'api-token', '4888abafb9cd66ac9e0f5fa114b7ed101725e36b410ecc2e165701932b84fa03', '[\"*\"]', '2025-06-17 21:24:08', NULL, '2025-06-17 21:24:03', '2025-06-17 21:24:08'),
(222, 'App\\Models\\User', 2, 'api-token', 'b723b2f0a1bf1e16b0274b07bdfd8cf9078b999b8f56278857f8cd3da5f12a92', '[\"*\"]', '2025-06-17 21:26:08', NULL, '2025-06-17 21:26:04', '2025-06-17 21:26:08'),
(223, 'App\\Models\\User', 2, 'api-token', '689da61a38e03e652b8ec8cac0d7068052ef11fe3c38c035306b269e80834349', '[\"*\"]', '2025-06-17 21:28:50', NULL, '2025-06-17 21:28:28', '2025-06-17 21:28:50'),
(224, 'App\\Models\\User', 2, 'api-token', '214700eb859bccd87615b5c94adee0acf2507542f4d1a1387a0a98485665fe89', '[\"*\"]', '2025-06-17 21:34:40', NULL, '2025-06-17 21:33:35', '2025-06-17 21:34:40'),
(225, 'App\\Models\\User', 2, 'api-token', '8e43599e88a2f90fcf2aa5e2c9eae866a046d51e88ac135e90216b1f80cc62fe', '[\"*\"]', '2025-06-17 21:36:23', NULL, '2025-06-17 21:36:01', '2025-06-17 21:36:23'),
(226, 'App\\Models\\User', 2, 'api-token', '97e18a7ef866ae36983fc4a3f004f761731ecce7e5a88c22ee90bbed45386a86', '[\"*\"]', '2025-06-17 21:38:46', NULL, '2025-06-17 21:37:23', '2025-06-17 21:38:46'),
(227, 'App\\Models\\User', 2, 'api-token', 'ff14c2fd250554cdc72dfea502be03f4a69214396a08cf9fdd9a54bb6fdf04c9', '[\"*\"]', '2025-06-17 21:40:08', NULL, '2025-06-17 21:39:56', '2025-06-17 21:40:08'),
(228, 'App\\Models\\User', 2, 'api-token', '5c65fa2e0e14d733b1bcc47d71725ffa2e7c476fef0d87b5251aa150a2b7974c', '[\"*\"]', '2025-06-17 21:41:27', NULL, '2025-06-17 21:41:04', '2025-06-17 21:41:27'),
(229, 'App\\Models\\User', 1, 'api-token', '586755478bbcd72f75818b71ac8fb603114d228e43eda3888def14279bafd639', '[\"*\"]', '2025-06-17 21:42:04', NULL, '2025-06-17 21:42:03', '2025-06-17 21:42:04'),
(230, 'App\\Models\\User', 1, 'api-token', '2b2fd137d6da864007b0e015b5df63ece91fe307fa16299c21bf32c6c4370dd5', '[\"*\"]', '2025-06-17 21:45:14', NULL, '2025-06-17 21:44:10', '2025-06-17 21:45:14'),
(231, 'App\\Models\\User', 2, 'api-token', '0861d38add2eb0e63a64d230ab16128c2313681d2ee584a97663d8b65843bd3a', '[\"*\"]', '2025-06-18 05:26:09', NULL, '2025-06-18 05:25:44', '2025-06-18 05:26:09'),
(232, 'App\\Models\\User', 2, 'api-token', '6f0ccccb8239ef77a23521f4be92324e54629340410d92c2eb13f79b89478937', '[\"*\"]', '2025-06-18 05:33:16', NULL, '2025-06-18 05:30:23', '2025-06-18 05:33:16'),
(233, 'App\\Models\\User', 1, 'api-token', '056cdec525b0a63e3fcd99c41709e1da829ef73e8240c64fdc7eed89f9af5af3', '[\"*\"]', '2025-06-18 05:35:07', NULL, '2025-06-18 05:34:10', '2025-06-18 05:35:07'),
(234, 'App\\Models\\User', 1, 'api-token', 'a98af9040f00b958ec50c216134d6aa3771ab7834f80176b56b78d05cede8b0b', '[\"*\"]', '2025-06-18 05:36:33', NULL, '2025-06-18 05:36:03', '2025-06-18 05:36:33'),
(235, 'App\\Models\\User', 1, 'api-token', '38b48ccf870f064173e4a78b95641e4b978956e2912be38c6696e97114f2be2f', '[\"*\"]', '2025-06-18 05:43:32', NULL, '2025-06-18 05:43:17', '2025-06-18 05:43:32'),
(236, 'App\\Models\\User', 1, 'api-token', 'bb94f2a367b057e65f0104791e80958fe6fadf3a287440f5819049451f2c8766', '[\"*\"]', '2025-06-18 06:51:20', NULL, '2025-06-18 05:46:26', '2025-06-18 06:51:20'),
(237, 'App\\Models\\User', 1, 'api-token', 'a9f3dabd722925e7d5211c6a5b401547f1f951075684b43b8975c06cbf7c0e97', '[\"*\"]', '2025-06-18 18:37:20', NULL, '2025-06-18 18:37:15', '2025-06-18 18:37:20'),
(238, 'App\\Models\\User', 1, 'api-token', 'b300d7f64f27d87a794dd2387e88ec2862d945aa84bdbd14d29860bd3962e0f0', '[\"*\"]', '2025-06-18 18:38:55', NULL, '2025-06-18 18:38:53', '2025-06-18 18:38:55'),
(239, 'App\\Models\\User', 1, 'api-token', '752fb6708cc7f240e47757a63a1bc21f2dcf36b246cdb7e4eaf76dd3bb1c34e7', '[\"*\"]', '2025-06-18 18:41:07', NULL, '2025-06-18 18:41:06', '2025-06-18 18:41:07'),
(240, 'App\\Models\\User', 1, 'api-token', '35d31c8d2713700dd29ead692ba309a5502857f9604718925f58920f0af7d600', '[\"*\"]', '2025-06-18 18:42:35', NULL, '2025-06-18 18:42:33', '2025-06-18 18:42:35'),
(241, 'App\\Models\\User', 1, 'api-token', 'a8d3ca92f2a863ad615d7b72fc3326ddc51af1c5194eac6960a1605c4c1423e2', '[\"*\"]', '2025-06-18 18:45:33', NULL, '2025-06-18 18:45:32', '2025-06-18 18:45:33'),
(242, 'App\\Models\\User', 1, 'api-token', '7ee2a2a63359f28ec4efa55f884e681ebf540386f53fa90f5a1b4bbb4b1c90d7', '[\"*\"]', '2025-06-18 18:51:29', NULL, '2025-06-18 18:47:24', '2025-06-18 18:51:29'),
(243, 'App\\Models\\User', 1, 'api-token', 'ee210d58dd5b0d29e550d0c636a6a9811146daa666350d2bca8c6755766bc4a2', '[\"*\"]', '2025-06-18 18:56:27', NULL, '2025-06-18 18:53:15', '2025-06-18 18:56:27'),
(244, 'App\\Models\\User', 1, 'api-token', 'fc95c2005ad50372ed10910cb62786a77000446e8077ee46368ebbeb4cf39fac', '[\"*\"]', '2025-06-18 19:03:02', NULL, '2025-06-18 19:00:59', '2025-06-18 19:03:02'),
(245, 'App\\Models\\User', 1, 'api-token', '6882bf3f736945f5c2090536a4ae9448f7a36e7006dd8aaa888df5c456327ce2', '[\"*\"]', '2025-06-18 19:09:20', NULL, '2025-06-18 19:09:18', '2025-06-18 19:09:20'),
(246, 'App\\Models\\User', 1, 'api-token', '7df09cc49e51b5c8e72d3f653d13d5b5be1e98ba5ff64adf1e4357f5ce4abd5f', '[\"*\"]', '2025-06-18 19:15:24', NULL, '2025-06-18 19:15:23', '2025-06-18 19:15:24'),
(247, 'App\\Models\\User', 1, 'api-token', '63ce0d72b2ea5c12c88f9c424aeafb2df6fec46ac11d2688067cae18c303f94a', '[\"*\"]', '2025-06-18 19:19:17', NULL, '2025-06-18 19:18:48', '2025-06-18 19:19:17'),
(248, 'App\\Models\\User', 1, 'api-token', '7dc967b809cf959d560f40b60b063ec05f1d8e51eba799ecf366b504f37e29fa', '[\"*\"]', '2025-06-18 19:21:02', NULL, '2025-06-18 19:21:00', '2025-06-18 19:21:02'),
(249, 'App\\Models\\User', 1, 'api-token', '3a5959ea00bec68aeae155987f5acb897f028357720b6d5f45c285e7b639f727', '[\"*\"]', '2025-06-18 19:23:54', NULL, '2025-06-18 19:23:52', '2025-06-18 19:23:54'),
(250, 'App\\Models\\User', 1, 'api-token', 'f2148bc431080a17b322a435cf63c86ebac0d8f35adb3eeb1fa927de0e183216', '[\"*\"]', '2025-06-18 19:26:49', NULL, '2025-06-18 19:26:48', '2025-06-18 19:26:49'),
(251, 'App\\Models\\User', 1, 'api-token', '5b09cc65afde3a07966aa6abb561630cb418f39c461b3e331c5007ec0fef88b3', '[\"*\"]', '2025-06-18 19:27:47', NULL, '2025-06-18 19:27:45', '2025-06-18 19:27:47'),
(252, 'App\\Models\\User', 1, 'api-token', '7d088cb802c7cc43fce03bb884a824e7443a22a4c889647d66b0c2845a50ddc2', '[\"*\"]', '2025-06-18 19:29:09', NULL, '2025-06-18 19:29:07', '2025-06-18 19:29:09'),
(253, 'App\\Models\\User', 1, 'api-token', '74786cc571c403e7f4948ec7a2d7c4d3a9bf9467e543bc7366d292fc1bc08e57', '[\"*\"]', '2025-06-18 19:34:14', NULL, '2025-06-18 19:33:52', '2025-06-18 19:34:14'),
(254, 'App\\Models\\User', 1, 'api-token', 'caa64f9a8bcd7b7442de70cd47db45697063b4f1130065e885efba67152d337a', '[\"*\"]', '2025-06-18 19:37:43', NULL, '2025-06-18 19:37:41', '2025-06-18 19:37:43');
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(255, 'App\\Models\\User', 1, 'api-token', '799f05199046e599324e4ecdd052c93bfe2c0e11d01e02f5a9dfcecff8d35469', '[\"*\"]', '2025-06-18 19:39:24', NULL, '2025-06-18 19:39:23', '2025-06-18 19:39:24'),
(256, 'App\\Models\\User', 1, 'api-token', 'ee4e8494deda6d38b09c98a934239b60d0ed836577366efdeb9c267018c3efd4', '[\"*\"]', '2025-06-18 19:40:29', NULL, '2025-06-18 19:40:27', '2025-06-18 19:40:29'),
(257, 'App\\Models\\User', 1, 'api-token', '97db4f2ae420a95cbb9dba426cd717f13d52836f74682023707d6556cc576123', '[\"*\"]', '2025-06-18 19:44:38', NULL, '2025-06-18 19:44:37', '2025-06-18 19:44:38'),
(258, 'App\\Models\\User', 1, 'api-token', '8e72500a48471e89e4af58cca1de4fbc18e078272850b93dda495f7a3b3b46d3', '[\"*\"]', '2025-06-18 19:46:58', NULL, '2025-06-18 19:46:56', '2025-06-18 19:46:58'),
(259, 'App\\Models\\User', 1, 'api-token', '1ec3360d3b587658e0bbbbf6fe8084c2185c618e0aa86763b379c5f1e5a21680', '[\"*\"]', '2025-06-18 19:47:47', NULL, '2025-06-18 19:47:45', '2025-06-18 19:47:47'),
(260, 'App\\Models\\User', 1, 'api-token', 'f1c53d05e1d692c1da55604f088583dbb041da8dbde3dd82b0701f742707a5d7', '[\"*\"]', '2025-06-18 19:48:56', NULL, '2025-06-18 19:48:55', '2025-06-18 19:48:56'),
(261, 'App\\Models\\User', 1, 'api-token', '7349b5ef9fa1cb75793f74584acffbe0dede437ea1cea4a463dac18af5ca2f70', '[\"*\"]', '2025-06-18 19:49:52', NULL, '2025-06-18 19:49:50', '2025-06-18 19:49:52'),
(262, 'App\\Models\\User', 1, 'api-token', '1f7ab154c5afca24f2e079cc50dfa1eb79378781302e2084cac1298cd48e00bc', '[\"*\"]', '2025-06-18 19:51:27', NULL, '2025-06-18 19:51:26', '2025-06-18 19:51:27'),
(263, 'App\\Models\\User', 1, 'api-token', 'f0013c740215f68f646191d76ec5d9a80907c3bf75293f1f78e09073ce78a736', '[\"*\"]', '2025-06-18 19:52:32', NULL, '2025-06-18 19:52:30', '2025-06-18 19:52:32'),
(264, 'App\\Models\\User', 1, 'api-token', 'b3a3c926c77e6801d6001600427b5806e661ccbacaccefd9bfde5e1ff87e38f4', '[\"*\"]', '2025-06-18 19:56:13', NULL, '2025-06-18 19:56:12', '2025-06-18 19:56:13'),
(265, 'App\\Models\\User', 1, 'api-token', 'd2085c482043596728a393f9a156482678bbb965c58aca2a1519543f52ba39ff', '[\"*\"]', '2025-06-18 19:56:43', NULL, '2025-06-18 19:56:41', '2025-06-18 19:56:43'),
(266, 'App\\Models\\User', 1, 'api-token', 'd44de73fd008712a411924d6492260910d6247b755580d62c462e216d3f3499d', '[\"*\"]', '2025-06-18 20:20:39', NULL, '2025-06-18 20:19:22', '2025-06-18 20:20:39'),
(267, 'App\\Models\\User', 2, 'api-token', '190d5174390579e27b4543ae106e308184bbc510e6e5de3c07fb5c1aac378f95', '[\"*\"]', '2025-06-18 20:21:58', NULL, '2025-06-18 20:21:28', '2025-06-18 20:21:58'),
(268, 'App\\Models\\User', 1, 'api-token', '408e1ae0ff511a040431c1a99fabafa69376173fe0044bc7ac07fde1adac634a', '[\"*\"]', '2025-06-18 20:23:29', NULL, '2025-06-18 20:22:30', '2025-06-18 20:23:29'),
(269, 'App\\Models\\User', 2, 'api-token', 'ff421872ba852da060fc5f0202594fb72dace96fe772e867e4641e9f95fdf810', '[\"*\"]', '2025-06-18 20:25:44', NULL, '2025-06-18 20:24:06', '2025-06-18 20:25:44'),
(270, 'App\\Models\\User', 1, 'api-token', 'c3bf1b3abc27f1dc8e57fb39adb0157c0ef28125df3f7bca5afbb7d66b9354db', '[\"*\"]', '2025-06-18 20:29:03', NULL, '2025-06-18 20:26:09', '2025-06-18 20:29:03'),
(271, 'App\\Models\\User', 1, 'api-token', '2722038afcf5d32472d22bdc9fd5dea4b26c443793aaf58e748a58afa3fbe796', '[\"*\"]', '2025-06-18 20:38:35', NULL, '2025-06-18 20:38:12', '2025-06-18 20:38:35'),
(272, 'App\\Models\\User', 1, 'api-token', 'b0fbb9a2be4a6aad587bb168acae05ff25e4f00c6effac253b89a907a88fcad2', '[\"*\"]', '2025-06-18 20:45:18', NULL, '2025-06-18 20:44:53', '2025-06-18 20:45:18'),
(273, 'App\\Models\\User', 2, 'api-token', '1f42c4ae40380028857c2db3ad56fe57428b76c4d39d479d45c5cb534da9f71a', '[\"*\"]', '2025-06-18 20:45:40', NULL, '2025-06-18 20:45:35', '2025-06-18 20:45:40'),
(274, 'App\\Models\\User', 1, 'api-token', 'ab21419fc1d29bef6fc300548a2acd38d4c86a78f3bf5cabeb6b83a0f1264f25', '[\"*\"]', '2025-06-18 21:24:57', NULL, '2025-06-18 21:24:55', '2025-06-18 21:24:57'),
(275, 'App\\Models\\User', 1, 'api-token', '57c315d078ea47cfb00777f4f1d96b0494f81464be89f1a8c43c6a32d1b72b83', '[\"*\"]', '2025-06-18 21:26:18', NULL, '2025-06-18 21:26:16', '2025-06-18 21:26:18'),
(276, 'App\\Models\\User', 2, 'api-token', 'f74bd37092d37b989b71e4a8410bc21bf1cc463d35b8331cb96eb3f5ef43a851', '[\"*\"]', '2025-06-18 21:31:15', NULL, '2025-06-18 21:29:20', '2025-06-18 21:31:15'),
(277, 'App\\Models\\User', 2, 'api-token', 'fa517935a0d7a53e19a02a2939b0da6f1a2a51cef5e1b21cba497301f5c32e43', '[\"*\"]', '2025-06-18 21:32:11', NULL, '2025-06-18 21:32:09', '2025-06-18 21:32:11'),
(278, 'App\\Models\\User', 2, 'api-token', 'b2bee51e4bae558adde639867dabba4f8a7c675770d26a848f2828a5a7444e21', '[\"*\"]', '2025-06-18 21:33:16', NULL, '2025-06-18 21:32:44', '2025-06-18 21:33:16'),
(279, 'App\\Models\\User', 1, 'api-token', '79ffa7437ee79543b33ad3e510fc63c30f6d8c38dd36a69be9df17845e439bc5', '[\"*\"]', '2025-06-18 21:34:20', NULL, '2025-06-18 21:33:50', '2025-06-18 21:34:20'),
(280, 'App\\Models\\User', 2, 'api-token', '6dbf8da242e5ebf4dcfb144ad6b9515c79f30d22d9a24d88a8452b6b8df86a6d', '[\"*\"]', '2025-06-18 21:39:13', NULL, '2025-06-18 21:34:36', '2025-06-18 21:39:14'),
(281, 'App\\Models\\User', 1, 'api-token', '96893ad767d99e187f88c41978e7dbf97971c6b74088c233a0f448c346a8f21c', '[\"*\"]', '2025-06-18 21:39:53', NULL, '2025-06-18 21:39:36', '2025-06-18 21:39:53'),
(282, 'App\\Models\\User', 2, 'api-token', '65643d31644cf57706f163b861b8a5a6dd870f45f9eca3e9d197354300b91a0d', '[\"*\"]', '2025-06-18 21:40:33', NULL, '2025-06-18 21:40:12', '2025-06-18 21:40:33'),
(283, 'App\\Models\\User', 2, 'api-token', 'eb89efad3f1502794f54c2523a9b2087124adcc7e34927f1e8e6e667ea71b60a', '[\"*\"]', '2025-06-18 21:42:08', NULL, '2025-06-18 21:41:09', '2025-06-18 21:42:08'),
(284, 'App\\Models\\User', 1, 'api-token', '6a1fd5e7cc1a5ae97c147fa4c5223bced9cc3c7df733e2f5b31a74f84deb520b', '[\"*\"]', '2025-06-18 21:44:12', NULL, '2025-06-18 21:43:47', '2025-06-18 21:44:12'),
(285, 'App\\Models\\User', 2, 'api-token', 'f2f7b70da2c5129cd389bf37a506fca81ab0a0b4dd9ab414857a14d0a91af5ef', '[\"*\"]', '2025-06-18 21:45:11', NULL, '2025-06-18 21:44:30', '2025-06-18 21:45:11'),
(286, 'App\\Models\\User', 1, 'api-token', '3cd5bd48e3aed0d02a5afceaf263a126dacdb20115b05f24ace2960e398b22c0', '[\"*\"]', '2025-06-18 21:45:38', NULL, '2025-06-18 21:45:33', '2025-06-18 21:45:38'),
(287, 'App\\Models\\User', 2, 'api-token', '64a26a01ab3d09164dc6e85d5ecc0c15d44ed6aab453fcba795ff2ac31a3cf0f', '[\"*\"]', '2025-06-18 21:48:09', NULL, '2025-06-18 21:46:01', '2025-06-18 21:48:09'),
(288, 'App\\Models\\User', 1, 'api-token', '7e78c09e9c2be611ead93765bbadfcb343f68cebba73f291727434678a1005b6', '[\"*\"]', '2025-06-18 21:52:38', NULL, '2025-06-18 21:52:20', '2025-06-18 21:52:38'),
(289, 'App\\Models\\User', 2, 'api-token', 'b538130cd33709f492d0a3f8cbc20931e42b228b557a8ce271db861a56df1686', '[\"*\"]', '2025-06-18 21:59:29', NULL, '2025-06-18 21:52:58', '2025-06-18 21:59:29'),
(290, 'App\\Models\\User', 1, 'api-token', '877ad1fd8613414f385df98fc36457e5d6f7c888ee2e2192856c94eb50b3032f', '[\"*\"]', '2025-06-18 21:56:52', NULL, '2025-06-18 21:56:34', '2025-06-18 21:56:52'),
(291, 'App\\Models\\User', 1, 'api-token', 'abec815376a2fa16917403b5374e9f6ca8fb32d57cd8dd86b164219bd4e03e82', '[\"*\"]', '2025-06-18 22:03:29', NULL, '2025-06-18 22:01:34', '2025-06-18 22:03:29'),
(292, 'App\\Models\\User', 2, 'api-token', '2a2ad33c18a72070823e4d77f55d37a87cc513c6ee70d62be144abebe6f22b92', '[\"*\"]', '2025-06-18 22:03:10', NULL, '2025-06-18 22:02:28', '2025-06-18 22:03:10'),
(293, 'App\\Models\\User', 2, 'api-token', 'a0237b5eeed19622246bfb87f0afafeede8ea6813c64520190604b0f45def676', '[\"*\"]', '2025-06-19 04:59:53', NULL, '2025-06-19 04:59:34', '2025-06-19 04:59:53'),
(294, 'App\\Models\\User', 2, 'api-token', 'e89db44375d2648aa5439153d7b422da05d1f5589588e2ffa79b663baf73080a', '[\"*\"]', '2025-06-19 05:05:30', NULL, '2025-06-19 05:02:29', '2025-06-19 05:05:30'),
(295, 'App\\Models\\User', 1, 'api-token', '75e626ed2a3e30ab533935a4994db9b2553815df5ce2894f33634c5a4f7bf83d', '[\"*\"]', '2025-06-19 05:07:41', NULL, '2025-06-19 05:05:51', '2025-06-19 05:07:41'),
(296, 'App\\Models\\User', 2, 'api-token', '11ed90f36df8f27335a237b82a16a7ed854104877bd71967b96adb213b79f079', '[\"*\"]', '2025-06-19 05:17:49', NULL, '2025-06-19 05:06:48', '2025-06-19 05:17:49'),
(297, 'App\\Models\\User', 1, 'api-token', '6e6b1e8ccf4d574d504740cbebc949db598ba9764637614d0fb8d1019b8990bb', '[\"*\"]', '2025-06-19 05:19:34', NULL, '2025-06-19 05:18:08', '2025-06-19 05:19:34'),
(298, 'App\\Models\\User', 1, 'api-token', '571eb279d44f30e7e06af5f7a60d5fc34e20d27ba9f4e2d4e3a4807fb2a30c82', '[\"*\"]', '2025-06-19 05:28:12', NULL, '2025-06-19 05:25:09', '2025-06-19 05:28:12'),
(299, 'App\\Models\\User', 1, 'api-token', '9afa902b081724532980f22a8c35ab3e41d8edb015f9aa24f715ab150a779b96', '[\"*\"]', '2025-06-19 06:40:11', NULL, '2025-06-19 06:34:15', '2025-06-19 06:40:11'),
(300, 'App\\Models\\User', 1, 'api-token', 'a699316620ebb755ad09baf9b819113c82d262ffb7847b9fad21e0613384d97a', '[\"*\"]', '2025-06-19 06:44:20', NULL, '2025-06-19 06:41:09', '2025-06-19 06:44:20'),
(301, 'App\\Models\\User', 2, 'api-token', '3dc65fc240a256d39095602dd850fe76d8277d6848303c7606c37dfe4396366f', '[\"*\"]', '2025-06-19 06:47:46', NULL, '2025-06-19 06:45:44', '2025-06-19 06:47:46'),
(302, 'App\\Models\\User', 1, 'api-token', 'f211cfe8a6cdb8f8c7ca5ce6917d0ce22505d44162d594ce20a877c47d7f0d04', '[\"*\"]', '2025-06-19 18:31:40', NULL, '2025-06-19 18:20:54', '2025-06-19 18:31:40'),
(303, 'App\\Models\\User', 1, 'api-token', '0eef5244b7ce742b2767bff1bda58dc735522484a56ac169ed62f9d0647f449b', '[\"*\"]', '2025-06-19 18:51:35', NULL, '2025-06-19 18:51:13', '2025-06-19 18:51:35'),
(304, 'App\\Models\\User', 2, 'api-token', 'c85d045c7c1c639c10540e942352f10e2f9c2f104575a2739ea98fb372321258', '[\"*\"]', '2025-06-19 18:52:14', NULL, '2025-06-19 18:51:56', '2025-06-19 18:52:14'),
(305, 'App\\Models\\User', 1, 'api-token', '0570c861342550df5940ad98bcc24d7a6f04d91f089bb4da75b14b9a40d5458a', '[\"*\"]', '2025-06-25 06:27:52', NULL, '2025-06-25 06:27:22', '2025-06-25 06:27:52'),
(306, 'App\\Models\\User', 1, 'api-token', 'cf7f1ca085882600fbfacfa329484fed97bd137ce7d4a7de8b1234235b3955ea', '[\"*\"]', '2025-06-25 06:38:53', NULL, '2025-06-25 06:38:52', '2025-06-25 06:38:53'),
(307, 'App\\Models\\User', 1, 'api-token', '227119026230bc82d0b90c62eb85387cc1ef1d70ea3f5ce075006560d66f52f4', '[\"*\"]', '2025-06-25 07:05:36', NULL, '2025-06-25 07:05:34', '2025-06-25 07:05:36'),
(308, 'App\\Models\\User', 1, 'api-token', '5ec53ec7ecd2115669a92591499b35ce8a6cfcf9a927d84751aaa0cb90acdb57', '[\"*\"]', '2025-06-25 07:12:13', NULL, '2025-06-25 07:12:11', '2025-06-25 07:12:13'),
(309, 'App\\Models\\User', 1, 'api-token', '302b71f1fc84f4f5d0be26632c0ee8e8ad5d1ecdc00dc03246dae3210a9780eb', '[\"*\"]', '2025-06-25 07:42:02', NULL, '2025-06-25 07:42:00', '2025-06-25 07:42:02'),
(310, 'App\\Models\\User', 1, 'api-token', '848b9279bdb4b6f25036ca6ee59aa3d4d7411cbb8e551255122f2f4eeace4f81', '[\"*\"]', '2025-06-25 18:19:46', NULL, '2025-06-25 18:18:47', '2025-06-25 18:19:46'),
(311, 'App\\Models\\User', 1, 'api-token', 'f4dc06bcc79ab55c0f230c451c84b567bb7ce3c7de5bbb4818c9aca879983390', '[\"*\"]', '2025-06-25 18:31:51', NULL, '2025-06-25 18:31:28', '2025-06-25 18:31:51'),
(312, 'App\\Models\\User', 1, 'api-token', '7c892a37a79129ab5ebdaee8912f91c79745aa2784e5b01e8f9a61216802e34d', '[\"*\"]', '2025-06-25 18:46:28', NULL, '2025-06-25 18:46:20', '2025-06-25 18:46:28'),
(313, 'App\\Models\\User', 1, 'api-token', '06f4ae81a505227dea9691ff9563ee90a92344fc7f91b1c6baa96c2e6fad2b9f', '[\"*\"]', '2025-06-25 18:51:33', NULL, '2025-06-25 18:51:28', '2025-06-25 18:51:33'),
(314, 'App\\Models\\User', 1, 'api-token', 'bd09ebb246e6eb0a7ef941cac8fdb22e8df54850167c5b887a444fdecca0e528', '[\"*\"]', '2025-06-25 18:56:34', NULL, '2025-06-25 18:56:31', '2025-06-25 18:56:34'),
(315, 'App\\Models\\User', 1, 'api-token', 'ac86f25ea4b798c351dc86a7646a34a87aac166908e96a3e254de3cd95576057', '[\"*\"]', '2025-06-25 19:02:22', NULL, '2025-06-25 19:02:18', '2025-06-25 19:02:22'),
(316, 'App\\Models\\User', 1, 'api-token', 'd81d605f9cc139ec018fa0d8428e32f42531c0082294695fdec80d42272ab14a', '[\"*\"]', '2025-06-25 19:07:59', NULL, '2025-06-25 19:07:55', '2025-06-25 19:07:59'),
(317, 'App\\Models\\User', 1, 'api-token', '2e7bb099b7702c3769044fdf3745b16db9f6f8a41bf848e2b60ab0a9d4e57e4f', '[\"*\"]', '2025-06-25 19:12:58', NULL, '2025-06-25 19:12:34', '2025-06-25 19:12:58'),
(318, 'App\\Models\\User', 1, 'api-token', '9cf94a4672478f0ef7ff0d358ab314c2fb7729b1be0e16c315e822de4d509da8', '[\"*\"]', '2025-06-25 20:00:34', NULL, '2025-06-25 19:59:48', '2025-06-25 20:00:34'),
(319, 'App\\Models\\User', 1, 'api-token', '9052bc599b3f7831dca1af1a672e7f04d872c23189f62dc54ac12b79b8501185', '[\"*\"]', '2025-06-25 20:02:51', NULL, '2025-06-25 20:02:33', '2025-06-25 20:02:51'),
(320, 'App\\Models\\User', 1, 'api-token', '84d359ea68cf5ca6296e87a8567dea5c6a48f3a1eb02d609c2cbf40dff3be787', '[\"*\"]', '2025-06-25 20:04:46', NULL, '2025-06-25 20:04:34', '2025-06-25 20:04:46'),
(321, 'App\\Models\\User', 1, 'api-token', '19afa8292bfc43df526edaf198ca7c30a6494dd7735cc7324ef5d67881ee80ea', '[\"*\"]', '2025-06-25 20:07:49', NULL, '2025-06-25 20:07:27', '2025-06-25 20:07:49'),
(322, 'App\\Models\\User', 1, 'api-token', '3980a7865267b07cb6b2ce7b893d8899d771ad0969b97778ee3bd1b226063f7f', '[\"*\"]', '2025-06-25 20:16:40', NULL, '2025-06-25 20:16:26', '2025-06-25 20:16:40'),
(323, 'App\\Models\\User', 1, 'api-token', '35c18dcd294aaac864efdc6e7af190e2ad948b4605ca87ade544cec3823d8675', '[\"*\"]', '2025-06-25 20:19:29', NULL, '2025-06-25 20:19:18', '2025-06-25 20:19:29'),
(324, 'App\\Models\\User', 1, 'api-token', '53376b0957778992e9f9c7ffd00849a7bfa4e8d69c4e81b6938051fdfb417160', '[\"*\"]', '2025-06-25 20:32:28', NULL, '2025-06-25 20:31:16', '2025-06-25 20:32:28'),
(325, 'App\\Models\\User', 1, 'api-token', 'b9f35a8d052470ceb115349e3cc5a05b3d6119f0255b1de6e702c863c67090bc', '[\"*\"]', '2025-06-25 20:51:42', NULL, '2025-06-25 20:51:26', '2025-06-25 20:51:42'),
(326, 'App\\Models\\User', 1, 'api-token', '3536193be518de79c5e07ac9acbc04c5d73a6a717465d2e91c0e14a6fa99f434', '[\"*\"]', '2025-06-25 20:56:56', NULL, '2025-06-25 20:56:35', '2025-06-25 20:56:56'),
(327, 'App\\Models\\User', 1, 'api-token', 'e134fe1456f59d09b255f8ef34bf4679c164e4a38467466485b6240a39a04aeb', '[\"*\"]', '2025-06-25 21:17:35', NULL, '2025-06-25 21:15:39', '2025-06-25 21:17:35'),
(328, 'App\\Models\\User', 1, 'api-token', '98616ccbb188d44f1d2ac3db40e4842214179a55bc949345fa6f6520bd2a6006', '[\"*\"]', '2025-06-25 21:28:24', NULL, '2025-06-25 21:26:00', '2025-06-25 21:28:24'),
(329, 'App\\Models\\User', 1, 'api-token', '36a266011107630ed6e501499118f3777adc3725d1d76fa75cefb710640bc201', '[\"*\"]', '2025-06-25 21:50:19', NULL, '2025-06-25 21:49:38', '2025-06-25 21:50:19'),
(330, 'App\\Models\\User', 1, 'api-token', '68669150966c7c3e529ad8b4b4c041d886750426657e914093c97313c7c65a16', '[\"*\"]', '2025-06-26 02:52:09', NULL, '2025-06-26 02:49:36', '2025-06-26 02:52:09'),
(331, 'App\\Models\\User', 1, 'api-token', 'ef3aee754a548347d08a30a3b4348a537f638080c50bd51f2e1296fc0862b540', '[\"*\"]', '2025-06-26 02:59:06', NULL, '2025-06-26 02:53:34', '2025-06-26 02:59:06'),
(332, 'App\\Models\\User', 2, 'api-token', 'ec6c08a499e3b53542c8d8835d135285436d4ad030756e7c58e6abbf8f7ae621', '[\"*\"]', '2025-06-26 02:57:13', NULL, '2025-06-26 02:55:05', '2025-06-26 02:57:13'),
(333, 'App\\Models\\User', 1, 'api-token', 'd7b9b03edf392a2fcff5e79f842b2c43c21969fe1d3c6476535e17d24af1ccaf', '[\"*\"]', '2025-06-26 03:06:22', NULL, '2025-06-26 03:06:10', '2025-06-26 03:06:22'),
(334, 'App\\Models\\User', 1, 'api-token', '106b1f1dfaa146d32b4cd48996079916ff72440b96129f16f6024e9076dfc9fd', '[\"*\"]', NULL, NULL, '2025-06-26 03:09:38', '2025-06-26 03:09:38'),
(335, 'App\\Models\\User', 1, 'api-token', 'a5f5d7c5b6c20507dbc5257abf527034af37c02882defba2155d36c928f6ff5c', '[\"*\"]', '2025-06-26 03:10:45', NULL, '2025-06-26 03:10:19', '2025-06-26 03:10:45'),
(336, 'App\\Models\\User', 1, 'api-token', '720dcd1464502c000e9cc6fb60f12c2ef9516ecf99de4612d1e974462ff61908', '[\"*\"]', '2025-06-26 03:12:39', NULL, '2025-06-26 03:12:26', '2025-06-26 03:12:39'),
(337, 'App\\Models\\User', 1, 'api-token', 'e876fa8b91cbb6a38c80c7a9effe0b5449e640e3183a3fa8b4488e0dbe8136a9', '[\"*\"]', '2025-06-26 03:15:39', NULL, '2025-06-26 03:15:27', '2025-06-26 03:15:39'),
(338, 'App\\Models\\User', 1, 'api-token', 'd888aec3213cb1f33b1aa311ffd6165f679a972eaeb72252941dc8ce7292844e', '[\"*\"]', '2025-06-26 03:17:28', NULL, '2025-06-26 03:17:15', '2025-06-26 03:17:28'),
(339, 'App\\Models\\User', 1, 'api-token', '5447ed6a7e7ddae7c1069378ade376a8756cbf47f4d3f5e6475249236fe97005', '[\"*\"]', '2025-06-26 03:20:38', NULL, '2025-06-26 03:20:32', '2025-06-26 03:20:38'),
(340, 'App\\Models\\User', 1, 'api-token', '5c06b60f042c6632aeb557da71040ca33c2d87bca852c1df92b8e5f50d7938fc', '[\"*\"]', '2025-06-26 03:22:24', NULL, '2025-06-26 03:22:12', '2025-06-26 03:22:24'),
(341, 'App\\Models\\User', 1, 'api-token', '56d60dea836ddbcac5ee0e6e3abbc9ea0f9c2cd684c0cd06fb0a034d7e4dbb46', '[\"*\"]', '2025-06-26 03:24:37', NULL, '2025-06-26 03:24:26', '2025-06-26 03:24:37'),
(342, 'App\\Models\\User', 1, 'api-token', '98e08bc95cbe670e88c561943ce6b9a98ce673da423f68cf1e114008c8f2a144', '[\"*\"]', '2025-06-26 03:27:47', NULL, '2025-06-26 03:27:12', '2025-06-26 03:27:47'),
(343, 'App\\Models\\User', 1, 'api-token', '8e81b6a191afa28fe5723e645e83fbb9458b62af64519ac798b84f16415ffd07', '[\"*\"]', '2025-06-26 03:32:49', NULL, '2025-06-26 03:32:14', '2025-06-26 03:32:49'),
(344, 'App\\Models\\User', 1, 'api-token', '27519a739c49a0616446416f0f3f167541a0f8be8aac0835b589e4fe693bf444', '[\"*\"]', '2025-06-26 03:35:36', NULL, '2025-06-26 03:35:15', '2025-06-26 03:35:36'),
(345, 'App\\Models\\User', 1, 'api-token', 'dce55008203301f68464c8321bd6a94602ec2e6746e242649919d8180c926b79', '[\"*\"]', '2025-06-26 05:55:40', NULL, '2025-06-26 05:55:34', '2025-06-26 05:55:40'),
(346, 'App\\Models\\User', 1, 'api-token', '5dbf66a4d84a4afbeaa859235360b8c460bbd6ccb06bcbece712a7cb546e52a4', '[\"*\"]', '2025-06-26 06:01:41', NULL, '2025-06-26 06:01:35', '2025-06-26 06:01:41'),
(347, 'App\\Models\\User', 1, 'api-token', '6dafdd64a98d63ff8bb492cd6e6a7fad2d20c98d77b9cf1a35ffc5b77a99d35e', '[\"*\"]', '2025-06-26 06:32:19', NULL, '2025-06-26 06:30:46', '2025-06-26 06:32:19'),
(348, 'App\\Models\\User', 1, 'api-token', 'd8b3a0d324bf31ab613ec01eb9a44b0c73f95238938f1246f26fbf193c7a38fc', '[\"*\"]', '2025-06-26 06:46:14', NULL, '2025-06-26 06:46:07', '2025-06-26 06:46:14'),
(349, 'App\\Models\\User', 1, 'api-token', '5cf2b93cec96a41026c937e11c683e6cb132d58feb566f96b7883228c3da8e46', '[\"*\"]', '2025-06-26 06:48:22', NULL, '2025-06-26 06:48:17', '2025-06-26 06:48:22'),
(350, 'App\\Models\\User', 1, 'api-token', '457c2e4c17a45809c09cfade9fe0a7bfb2ec3f757455d3960cf67b9d44a47ac4', '[\"*\"]', '2025-06-26 06:51:16', NULL, '2025-06-26 06:51:11', '2025-06-26 06:51:16'),
(351, 'App\\Models\\User', 1, 'api-token', 'b9639c42f41218e8b560c943bae782229de8a7b5e59eb06cd94d15a6aa936468', '[\"*\"]', '2025-06-26 07:02:16', NULL, '2025-06-26 07:01:45', '2025-06-26 07:02:16'),
(352, 'App\\Models\\User', 1, 'api-token', '2188985afa087842233f8287a91e466232d54ca282d3641a3beb5cb05a122859', '[\"*\"]', '2025-06-26 07:08:09', NULL, '2025-06-26 07:08:05', '2025-06-26 07:08:09'),
(353, 'App\\Models\\User', 1, 'api-token', '60f73eb7867ee360aa7524080839af0006152b30ba4a7962f95f51c239231d72', '[\"*\"]', '2025-06-26 07:12:30', NULL, '2025-06-26 07:12:26', '2025-06-26 07:12:30'),
(354, 'App\\Models\\User', 1, 'api-token', 'bdc30879a82da14f9a64919ec22db8fcf899c926c8adb9f7fe3a2557721aa023', '[\"*\"]', '2025-06-26 07:13:20', NULL, '2025-06-26 07:13:16', '2025-06-26 07:13:20'),
(355, 'App\\Models\\User', 1, 'api-token', '55bd512ebea745c060b88e90af9608a1f6d3fd43157859f9604865d5e0f7ad87', '[\"*\"]', '2025-06-26 07:15:48', NULL, '2025-06-26 07:15:44', '2025-06-26 07:15:48'),
(356, 'App\\Models\\User', 1, 'api-token', '7def1a9ad2a6688cca27c7db95ce806ecb55994c19f307cff9c3aa9fe8bbd887', '[\"*\"]', '2025-06-26 07:17:57', NULL, '2025-06-26 07:17:53', '2025-06-26 07:17:57'),
(357, 'App\\Models\\User', 1, 'api-token', 'e4d16b6d34db6ff03ecf5eea9a99f97de6281768b222052ab4453759a3f8cc3b', '[\"*\"]', '2025-06-26 07:20:23', NULL, '2025-06-26 07:19:40', '2025-06-26 07:20:23'),
(358, 'App\\Models\\User', 1, 'api-token', '1a900f067376cd244c0833871067255881affabe2f0415b5f0fd5921a5f01ebc', '[\"*\"]', '2025-06-26 07:28:09', NULL, '2025-06-26 07:27:37', '2025-06-26 07:28:09'),
(359, 'App\\Models\\User', 1, 'api-token', '1ab6481ee11a31be5e3dab61bd55eae81d2cb09df85c4f348b4fb98c7a9fe284', '[\"*\"]', '2025-06-26 07:31:52', NULL, '2025-06-26 07:30:39', '2025-06-26 07:31:52'),
(360, 'App\\Models\\User', 1, 'api-token', '3ff4bc5066ee8eed5ed3723b2d1d5c8c56a5f45b0c72719be59afdb7f4a7c811', '[\"*\"]', '2025-06-26 17:54:00', NULL, '2025-06-26 17:53:53', '2025-06-26 17:54:00'),
(361, 'App\\Models\\User', 1, 'api-token', '6f8e8c6097af2670e344bbdf3e0aba20e86821ff29d39714b2797aab4f95ea0a', '[\"*\"]', '2025-06-26 17:58:20', NULL, '2025-06-26 17:58:18', '2025-06-26 17:58:20'),
(362, 'App\\Models\\User', 1, 'api-token', '91b8a36267ab8e67a35f14568657fa02eb1930b023bcdc7e6648c1a71afd44e2', '[\"*\"]', '2025-06-26 17:59:44', NULL, '2025-06-26 17:59:42', '2025-06-26 17:59:44'),
(363, 'App\\Models\\User', 1, 'api-token', '73e2708262820cc4028680c64ec4e8d4ebbaad88daf63f8968daabccdea85624', '[\"*\"]', '2025-06-26 18:06:12', NULL, '2025-06-26 18:06:10', '2025-06-26 18:06:12'),
(364, 'App\\Models\\User', 1, 'api-token', 'd6307a9662bd061632428b6c27b4bc336be9861ab21d18924f3ee56b2eabcce8', '[\"*\"]', '2025-06-29 20:16:05', NULL, '2025-06-26 18:08:49', '2025-06-29 20:16:05'),
(365, 'App\\Models\\User', 1, 'api-token', '81baab40364dad21b04ba740daca68a0992c68486573c9f7cb73167c4c315eb2', '[\"*\"]', '2025-06-26 18:10:36', NULL, '2025-06-26 18:10:34', '2025-06-26 18:10:36'),
(366, 'App\\Models\\User', 1, 'api-token', 'bd4f47ff28af13522235aed6d5ef998bd598f8eae9277f8ad1cadb089d9de709', '[\"*\"]', '2025-06-26 18:13:33', NULL, '2025-06-26 18:13:31', '2025-06-26 18:13:33'),
(367, 'App\\Models\\User', 1, 'api-token', '010b67f63677336746f58c570a9b879d7178d4eb3366e893d37821d52fb233b4', '[\"*\"]', '2025-06-26 18:16:39', NULL, '2025-06-26 18:16:37', '2025-06-26 18:16:39'),
(368, 'App\\Models\\User', 1, 'api-token', 'a01c17386b773a823b02a5d5237b0afc02e73f26d5893c7ab02bf52e5b6521c3', '[\"*\"]', '2025-06-26 18:17:36', NULL, '2025-06-26 18:17:35', '2025-06-26 18:17:36'),
(369, 'App\\Models\\User', 1, 'api-token', '972e96aafd4266842268b1724c721853f4db6fc8bb360b839a532b798973282d', '[\"*\"]', '2025-06-26 18:18:16', NULL, '2025-06-26 18:18:15', '2025-06-26 18:18:16'),
(370, 'App\\Models\\User', 1, 'api-token', 'f61485a5874fa946e38bd41018f79bd3ec61fc394387736f35acad3875494708', '[\"*\"]', '2025-06-26 18:20:15', NULL, '2025-06-26 18:20:13', '2025-06-26 18:20:15'),
(371, 'App\\Models\\User', 1, 'api-token', 'f9b9bbc4ca95f948eaaa688115523815d769995b725da8fa0212b4f34f91759a', '[\"*\"]', '2025-06-26 18:21:27', NULL, '2025-06-26 18:21:26', '2025-06-26 18:21:27'),
(372, 'App\\Models\\User', 1, 'api-token', '2cd21e8dfc9e058377ba782bda38d24f5cd76703366da2c896986e976e40f6f9', '[\"*\"]', '2025-06-26 18:23:36', NULL, '2025-06-26 18:23:34', '2025-06-26 18:23:36'),
(373, 'App\\Models\\User', 1, 'api-token', '3f2731795c3bebbac276a79ee4ab6ddd3cc14beb425082e9485dc26894cb2bd6', '[\"*\"]', '2025-06-26 18:24:55', NULL, '2025-06-26 18:24:54', '2025-06-26 18:24:55'),
(374, 'App\\Models\\User', 1, 'api-token', 'a85c14668e712d3d6da73646349c4f081b7dffe1ccfbbe241fc32b444f09f7c2', '[\"*\"]', '2025-06-26 18:29:33', NULL, '2025-06-26 18:28:44', '2025-06-26 18:29:33'),
(375, 'App\\Models\\User', 1, 'api-token', '6f58db6ba97ae7c3624fdaff566c3b6452cdf253e6bed9434a8a1f7c40b0643b', '[\"*\"]', '2025-06-26 19:15:54', NULL, '2025-06-26 19:15:02', '2025-06-26 19:15:54'),
(376, 'App\\Models\\User', 1, 'api-token', 'aba6c685650b42f07064b56e5440e13b0505a3eebd4aa929a21dcf8ef891f213', '[\"*\"]', '2025-06-26 19:20:24', NULL, '2025-06-26 19:19:19', '2025-06-26 19:20:24'),
(377, 'App\\Models\\User', 2, 'api-token', 'e46c527ca9ba5bd83069b46932b82a34b85756dbc6b732c172fc50dc5f153f13', '[\"*\"]', NULL, NULL, '2025-06-26 19:22:08', '2025-06-26 19:22:08'),
(378, 'App\\Models\\User', 2, 'api-token', 'b6e4aff005107273968d4a3772a6603ef8fedc50aced88149793f6ba964a7007', '[\"*\"]', '2025-06-26 19:23:59', NULL, '2025-06-26 19:23:43', '2025-06-26 19:23:59'),
(379, 'App\\Models\\User', 1, 'api-token', '2e0cef1c9527033147373327ca74b11385da6146220bf433d629d7650a762a2b', '[\"*\"]', '2025-06-26 19:25:55', NULL, '2025-06-26 19:24:19', '2025-06-26 19:25:55'),
(380, 'App\\Models\\User', 1, 'api-token', '7baeda9848e02abfd3ce86ba6868833d7af124c422facf5a9794e26e8a9f9be9', '[\"*\"]', '2025-06-26 19:29:42', NULL, '2025-06-26 19:28:57', '2025-06-26 19:29:42'),
(381, 'App\\Models\\User', 1, 'api-token', '85ea92daa2621c14a7ec6495b32eb4788b5e123d2d6e1694247297f17d79647e', '[\"*\"]', '2025-06-26 19:42:08', NULL, '2025-06-26 19:41:17', '2025-06-26 19:42:08'),
(382, 'App\\Models\\User', 1, 'api-token', '9ec2201b6cfdecfca0386032a7f8a8147f2d0bd45e1eabde9361de4fb16dc296', '[\"*\"]', '2025-06-26 19:47:18', NULL, '2025-06-26 19:47:14', '2025-06-26 19:47:18'),
(383, 'App\\Models\\User', 1, 'api-token', '790b4bbe17181c46112e20a97fa03f741a81a2a77b0ca43d54ad786d9bce1159', '[\"*\"]', '2025-06-26 19:49:22', NULL, '2025-06-26 19:49:17', '2025-06-26 19:49:22'),
(384, 'App\\Models\\User', 1, 'api-token', '0839c177086abb120781fa58bbe07f56217162395d58bfdf51c0b156052ce422', '[\"*\"]', '2025-06-26 19:52:42', NULL, '2025-06-26 19:50:42', '2025-06-26 19:52:42'),
(385, 'App\\Models\\User', 1, 'api-token', '20017121f81d147b35978da23469817b7ebf58b0225ae2a432dcd8f01beb096d', '[\"*\"]', '2025-06-26 19:55:19', NULL, '2025-06-26 19:55:05', '2025-06-26 19:55:19'),
(386, 'App\\Models\\User', 1, 'api-token', '084d03b25db07c81e1569dae053ae521cc9f0e19be1137e4d0d21bf35000d771', '[\"*\"]', '2025-06-26 19:59:56', NULL, '2025-06-26 19:59:52', '2025-06-26 19:59:56'),
(387, 'App\\Models\\User', 1, 'api-token', 'b489081480a92315e1a3bd48394b257ebb07c466205927d2a6f021a9a50da052', '[\"*\"]', '2025-06-26 20:01:33', NULL, '2025-06-26 20:01:08', '2025-06-26 20:01:33'),
(388, 'App\\Models\\User', 1, 'api-token', '67d5703ad7b8b3e39d502fdb6f05a14ae97567171028e4fe383a013552ec4ef7', '[\"*\"]', '2025-06-26 20:07:11', NULL, '2025-06-26 20:06:54', '2025-06-26 20:07:11'),
(389, 'App\\Models\\User', 1, 'api-token', 'bc0dff1b78cd108970109f35c791896e2b989cb715269d5a51118807f31445e4', '[\"*\"]', '2025-06-26 20:11:20', NULL, '2025-06-26 20:11:16', '2025-06-26 20:11:20'),
(390, 'App\\Models\\User', 1, 'api-token', '15519c14aff04045d25604eeaa250c7d5273a601f7d2dcb50d476b9a6a93a212', '[\"*\"]', '2025-06-26 20:14:18', NULL, '2025-06-26 20:14:14', '2025-06-26 20:14:18'),
(391, 'App\\Models\\User', 1, 'api-token', 'b6035a95f11ec1a57b4b46d9ba7018c3c49e17cda61a1b7952b41c2e9f7406e1', '[\"*\"]', '2025-06-26 20:52:02', NULL, '2025-06-26 20:15:36', '2025-06-26 20:52:02'),
(392, 'App\\Models\\User', 1, 'api-token', '3e9cbd878e11af82293785b88c9ec8ee9b35e9016b11d41a67540a912a83c151', '[\"*\"]', '2025-06-26 20:59:15', NULL, '2025-06-26 20:59:11', '2025-06-26 20:59:15'),
(393, 'App\\Models\\User', 1, 'api-token', '4d20bac71d9c654f486cc82007072f56587d34a48813e78ab93a24b1a633360b', '[\"*\"]', '2025-06-26 21:05:13', NULL, '2025-06-26 21:04:07', '2025-06-26 21:05:13'),
(394, 'App\\Models\\User', 1, 'api-token', '65ce9426d9c465dc4e9afb8cf83a3db9ee70b06c5ed86d553e49631ea4f6e683', '[\"*\"]', '2025-06-26 21:15:02', NULL, '2025-06-26 21:07:16', '2025-06-26 21:15:02'),
(395, 'App\\Models\\User', 1, 'api-token', '56b69c6dfc87a71ef68a53adb3d971e1cf0261bbfdeff28c0adbc38a2ed6884d', '[\"*\"]', '2025-06-26 21:19:35', NULL, '2025-06-26 21:19:33', '2025-06-26 21:19:35'),
(396, 'App\\Models\\User', 1, 'api-token', '89d65d370d80e4dd668b15d0f780a1ec568d1e9efb70baf6c64e59854d47f51d', '[\"*\"]', '2025-06-26 21:21:12', NULL, '2025-06-26 21:21:11', '2025-06-26 21:21:12'),
(397, 'App\\Models\\User', 1, 'api-token', '52abf950afbbcfecef979bebe6b3baa04cd400d9eb46393c368302cd094da17a', '[\"*\"]', '2025-06-26 21:23:07', NULL, '2025-06-26 21:23:04', '2025-06-26 21:23:07'),
(398, 'App\\Models\\User', 1, 'api-token', '300bcd941e9306836bcdff83b5be022e33011fdeb131b04a6273834be77277fa', '[\"*\"]', '2025-06-26 21:27:01', NULL, '2025-06-26 21:27:00', '2025-06-26 21:27:01'),
(399, 'App\\Models\\User', 1, 'api-token', '7d50fd2ae1aef812f0a33b4c6fbccd9bd971e1d46d73265f14f5ded4e1df5e63', '[\"*\"]', '2025-06-26 21:32:03', NULL, '2025-06-26 21:32:02', '2025-06-26 21:32:03'),
(400, 'App\\Models\\User', 1, 'api-token', '5ddd96c0b0c4e31834d91369fd9f14d4d30496f59636b9d357a87b4f7675ee66', '[\"*\"]', '2025-06-26 21:34:23', NULL, '2025-06-26 21:34:22', '2025-06-26 21:34:23'),
(401, 'App\\Models\\User', 1, 'api-token', '330cbf56afa44f6507343e0e182ed26c24b7be10a025ba1a0872e071f978d0d7', '[\"*\"]', '2025-06-26 21:38:58', NULL, '2025-06-26 21:38:56', '2025-06-26 21:38:58'),
(402, 'App\\Models\\User', 1, 'api-token', '065cfc5ff0af11bd6d0237a72016c61d680733e804938cd9be7e6f007523e0e2', '[\"*\"]', '2025-06-26 21:40:55', NULL, '2025-06-26 21:40:51', '2025-06-26 21:40:55'),
(403, 'App\\Models\\User', 1, 'api-token', '0af280994ee3bd458447b5edbd140681717a61e35d1696b523676e99962e587c', '[\"*\"]', '2025-06-26 21:44:34', NULL, '2025-06-26 21:44:17', '2025-06-26 21:44:34'),
(404, 'App\\Models\\User', 1, 'api-token', 'e189fc277dfc9b2bedd7f69f1dd7f126498ac889c1aa170ca4cb5487f5e3ba20', '[\"*\"]', '2025-06-26 21:47:43', NULL, '2025-06-26 21:47:42', '2025-06-26 21:47:43'),
(405, 'App\\Models\\User', 1, 'api-token', '742123891a25ac6d9df52e1d63098dd6a720dc54d05336354ad6a05e589887a0', '[\"*\"]', '2025-06-26 21:50:39', NULL, '2025-06-26 21:50:16', '2025-06-26 21:50:39'),
(406, 'App\\Models\\User', 1, 'api-token', '511ec2bab7c850eb3b34f7737c7a404009a7e3557c43a41b21fd5bbf15b9c0b4', '[\"*\"]', '2025-06-27 02:55:24', NULL, '2025-06-27 02:54:50', '2025-06-27 02:55:24'),
(407, 'App\\Models\\User', 2, 'api-token', '6dd36a55f234903397976907d13a331e9c0dd8f88cca8317bdb782cab074382d', '[\"*\"]', '2025-06-27 03:02:31', NULL, '2025-06-27 03:02:26', '2025-06-27 03:02:31'),
(408, 'App\\Models\\User', 1, 'api-token', '88b866eb5b3b004e94c5765513327f8bfa89616a065f696f2492e4370ca3bade', '[\"*\"]', '2025-06-27 03:03:37', NULL, '2025-06-27 03:02:52', '2025-06-27 03:03:37'),
(409, 'App\\Models\\User', 1, 'api-token', '33cf4b97beca0e9a839de24f5d1608454018dbe58502d3b71f979bcb66d3e8a9', '[\"*\"]', '2025-06-27 03:09:27', NULL, '2025-06-27 03:09:12', '2025-06-27 03:09:27'),
(410, 'App\\Models\\User', 2, 'api-token', '83f6f2565bdc3966ff5fd2d8371675206c9a1ce0e55b12e311eb49763149c4eb', '[\"*\"]', '2025-06-27 03:12:26', NULL, '2025-06-27 03:09:46', '2025-06-27 03:12:26'),
(411, 'App\\Models\\User', 2, 'api-token', 'f01ad0ab82370baafb1d499ea0602470f812795db3b9662d4495eac0b39b86f5', '[\"*\"]', '2025-06-27 03:15:57', NULL, '2025-06-27 03:12:50', '2025-06-27 03:15:57'),
(412, 'App\\Models\\User', 2, 'api-token', '083de9cd7f900b342848448718c5ab5c3fc18ad8d94e1c9cef39838e554ef63b', '[\"*\"]', '2025-06-27 03:21:46', NULL, '2025-06-27 03:16:29', '2025-06-27 03:21:46'),
(413, 'App\\Models\\User', 2, 'api-token', '74778191e1b9e5eebb50f7408eea3754d7e0c3a5c51d9b1ac8c2139f11cf1199', '[\"*\"]', '2025-06-27 03:22:47', NULL, '2025-06-27 03:22:43', '2025-06-27 03:22:47'),
(414, 'App\\Models\\User', 2, 'api-token', '70dd939975c31ac6d1224e7ae084ddf93c964550e5a6d29edfa61b66facb9004', '[\"*\"]', '2025-06-27 03:25:08', NULL, '2025-06-27 03:25:03', '2025-06-27 03:25:08'),
(415, 'App\\Models\\User', 1, 'api-token', '255eda9946df18205ed6a5aa4cb63f1a27bf8f0efbe5c7422af177e42ec0c23c', '[\"*\"]', '2025-06-27 05:22:48', NULL, '2025-06-27 05:22:43', '2025-06-27 05:22:48'),
(416, 'App\\Models\\User', 1, 'api-token', '4e631e85e6eb35e304c8b8d7fbfa60347b06811d9b4dabf9ec610a4a0dba46cf', '[\"*\"]', '2025-06-27 05:24:37', NULL, '2025-06-27 05:24:07', '2025-06-27 05:24:37'),
(417, 'App\\Models\\User', 1, 'api-token', '94c57c0d9a0730a9acb0500b5bd85077282c0308dc9e0485fad4bf7114998df0', '[\"*\"]', '2025-06-27 05:32:17', NULL, '2025-06-27 05:31:55', '2025-06-27 05:32:17'),
(418, 'App\\Models\\User', 1, 'api-token', 'd9f5b8c7fee1eadf5b6f710e6500811aa1a7894b876857cc1ded46208263abf2', '[\"*\"]', '2025-06-27 05:39:01', NULL, '2025-06-27 05:38:02', '2025-06-27 05:39:01'),
(419, 'App\\Models\\User', 2, 'api-token', '4e4759b2186d9f003f8c14e625dce0567496cc1168888a791b35bea6d69a4513', '[\"*\"]', '2025-06-27 05:39:57', NULL, '2025-06-27 05:39:52', '2025-06-27 05:39:57'),
(420, 'App\\Models\\User', 2, 'api-token', '7e3dca411c40fc26035f39173abdaafeafa8788ef962f0d7dd83462682c752b3', '[\"*\"]', '2025-06-27 05:40:41', NULL, '2025-06-27 05:40:26', '2025-06-27 05:40:41'),
(421, 'App\\Models\\User', 1, 'api-token', '8b1784a288e5f33120d4fc6a8364e2c85b37c43e5ec799ed050a40a8db695d72', '[\"*\"]', '2025-06-27 05:49:24', NULL, '2025-06-27 05:41:08', '2025-06-27 05:49:24'),
(422, 'App\\Models\\User', 2, 'api-token', '2b267d9191df121cf8d2b84b351971b4dbf1456e19d5915bd31e26f375e5934b', '[\"*\"]', '2025-06-27 05:54:00', NULL, '2025-06-27 05:53:51', '2025-06-27 05:54:00'),
(423, 'App\\Models\\User', 2, 'api-token', '2ef4f432d3d196c687e233b2ab42a0bab9a8eb542ac8c302fa2821671a685d15', '[\"*\"]', '2025-06-27 05:58:13', NULL, '2025-06-27 05:58:09', '2025-06-27 05:58:13'),
(424, 'App\\Models\\User', 2, 'api-token', '6712834253717e0ab289e57a56d59880fbc55d97af6cdbabd2ca3879cde82fed', '[\"*\"]', '2025-06-27 06:08:10', NULL, '2025-06-27 06:07:46', '2025-06-27 06:08:10'),
(425, 'App\\Models\\User', 1, 'api-token', 'ee6f3eeb0b691af99cd8bc9a0ff47405553ad15be8cae97ab95116bba4bf8b6a', '[\"*\"]', '2025-06-27 06:10:02', NULL, '2025-06-27 06:09:00', '2025-06-27 06:10:02'),
(426, 'App\\Models\\User', 1, 'api-token', '9ea962f34fbe9562976a9f23db492ebf31f07cac5b5f6f66084a2fd8c2706874', '[\"*\"]', '2025-06-27 06:28:25', NULL, '2025-06-27 06:27:53', '2025-06-27 06:28:25'),
(427, 'App\\Models\\User', 2, 'api-token', '4ff6bcae29aa3d2f7860f2ddbc4a66ff4a935be47aff7a54a2b2c32bfe06c73e', '[\"*\"]', '2025-06-27 06:29:32', NULL, '2025-06-27 06:29:30', '2025-06-27 06:29:32'),
(428, 'App\\Models\\User', 2, 'api-token', '53bc84d37ad091fd22693eac5e90890582993cb883f08f7921f877b09b35cfcd', '[\"*\"]', '2025-06-27 06:29:52', NULL, '2025-06-27 06:29:49', '2025-06-27 06:29:52'),
(429, 'App\\Models\\User', 2, 'api-token', '8f87a687162333b99b91b81dfc539b1789d1b5cfe42b58eccb19d7933377779a', '[\"*\"]', '2025-06-27 06:30:51', NULL, '2025-06-27 06:30:42', '2025-06-27 06:30:51'),
(430, 'App\\Models\\User', 2, 'api-token', '92a8ed9e3c96c6137db86cd6071ae29ebfe375f554c95baa27801fb671a3dcdb', '[\"*\"]', '2025-06-27 06:37:36', NULL, '2025-06-27 06:37:19', '2025-06-27 06:37:36'),
(431, 'App\\Models\\User', 1, 'api-token', '453f134c2feedd0a1b59baafb3cce495f235e6cbfa4c24b9767b4710bdefda62', '[\"*\"]', '2025-06-27 07:11:40', NULL, '2025-06-27 06:43:24', '2025-06-27 07:11:40'),
(432, 'App\\Models\\User', 2, 'api-token', 'a9ac84ee327dc3d24fcdb090f859f22194ab41cd9d98a8ec1667c34a240446ae', '[\"*\"]', '2025-06-27 07:12:17', NULL, '2025-06-27 07:12:13', '2025-06-27 07:12:17'),
(433, 'App\\Models\\User', 2, 'api-token', '44e6d4ed9e18e213dbdfa4bebd7d718fcf16fc4e1abf628dc656e2003e8631a4', '[\"*\"]', '2025-06-27 07:13:07', NULL, '2025-06-27 07:13:03', '2025-06-27 07:13:07'),
(434, 'App\\Models\\User', 2, 'api-token', '3e770930b64c488059e2eed16918a2bb1f9a5b5943bca837dc9e7a6d7854b7a7', '[\"*\"]', '2025-06-27 07:15:25', NULL, '2025-06-27 07:15:15', '2025-06-27 07:15:25'),
(435, 'App\\Models\\User', 1, 'api-token', '807149ad73709d2c857843b45b11df9f2786df8e2cf826939ea326ef9c3770d4', '[\"*\"]', '2025-06-27 07:15:53', NULL, '2025-06-27 07:15:47', '2025-06-27 07:15:53'),
(436, 'App\\Models\\User', 1, 'api-token', 'badb764dde523c3b0d8f674c0aaf7dad4a463dddcbcfd55fa6b2f5aa96f4635d', '[\"*\"]', '2025-06-27 19:15:56', NULL, '2025-06-27 19:15:42', '2025-06-27 19:15:56'),
(437, 'App\\Models\\User', 2, 'api-token', '754b5b4ce696a9d79ffa631865f32ea06ac98466f28361c524a75925e9f68dcb', '[\"*\"]', '2025-06-27 19:19:34', NULL, '2025-06-27 19:19:14', '2025-06-27 19:19:34'),
(438, 'App\\Models\\User', 2, 'api-token', '710dc2c9db013bc74ea234d2e994f0aa4b350dab4b5ba22e1ed2689b454a8021', '[\"*\"]', '2025-06-27 19:22:45', NULL, '2025-06-27 19:22:18', '2025-06-27 19:22:45'),
(439, 'App\\Models\\User', 1, 'api-token', 'f071c0c7d90cfc8c5736ae693e97433467e369f82473723e74995ef0276a30e8', '[\"*\"]', '2025-06-27 19:24:19', NULL, '2025-06-27 19:23:39', '2025-06-27 19:24:19'),
(440, 'App\\Models\\User', 2, 'api-token', '8f40c2314529187309a9686afe2cc58727515981a5723be75286c7e6a0485041', '[\"*\"]', '2025-06-27 19:25:05', NULL, '2025-06-27 19:24:45', '2025-06-27 19:25:05'),
(441, 'App\\Models\\User', 2, 'api-token', '02f964bcd0e3da5849c0ecd71dcdccefc24d53eab7b44f3eae83288055ce6163', '[\"*\"]', '2025-06-27 19:30:44', NULL, '2025-06-27 19:30:42', '2025-06-27 19:30:44'),
(442, 'App\\Models\\User', 1, 'api-token', '2070f0b46f39ebeedb160a3cb716d163b334eeef5e62a3e3af94cad30178a716', '[\"*\"]', '2025-06-27 19:34:29', NULL, '2025-06-27 19:34:27', '2025-06-27 19:34:29'),
(443, 'App\\Models\\User', 1, 'api-token', '7cd2601098e5e5bb86fd412d2743a1d00f0a47bcb2a0bc93c9e777b3c444a5d8', '[\"*\"]', '2025-06-27 19:37:27', NULL, '2025-06-27 19:37:22', '2025-06-27 19:37:27'),
(444, 'App\\Models\\User', 1, 'api-token', '03f169939089cc7df502eef5d8973a6a5937bf43bd919f47e89d8cd4ce02323d', '[\"*\"]', '2025-06-27 19:38:11', NULL, '2025-06-27 19:38:07', '2025-06-27 19:38:11'),
(445, 'App\\Models\\User', 1, 'api-token', '73e6d8bebe6b367762318e445ad129769489848a027452aad4c0dc9beb76cc02', '[\"*\"]', '2025-06-27 19:39:49', NULL, '2025-06-27 19:39:44', '2025-06-27 19:39:49'),
(446, 'App\\Models\\User', 1, 'api-token', '70bfe24965d255e2c2a0602ca1c828835e59ac6b19f80e6c1fbe7ed4ffb762e3', '[\"*\"]', '2025-06-27 19:42:29', NULL, '2025-06-27 19:42:24', '2025-06-27 19:42:29'),
(447, 'App\\Models\\User', 1, 'api-token', '8fddfbdfc4b5f6c6f25b01f9f87442bf691a00f3f1bd1e8ced4f148537578c8d', '[\"*\"]', '2025-06-27 19:46:35', NULL, '2025-06-27 19:46:31', '2025-06-27 19:46:35'),
(448, 'App\\Models\\User', 1, 'api-token', '8cfa20dd7f3831fba1a7c19a5f64e9eb47bd6c62706116905c23203efc871d46', '[\"*\"]', '2025-06-27 19:49:20', NULL, '2025-06-27 19:49:15', '2025-06-27 19:49:20'),
(449, 'App\\Models\\User', 1, 'api-token', '87fb586af8cdaf0503fda93faeb033e70f753be66e1a4bab46226b1c4ee090bd', '[\"*\"]', '2025-06-27 19:53:37', NULL, '2025-06-27 19:53:31', '2025-06-27 19:53:37'),
(450, 'App\\Models\\User', 1, 'api-token', '57a7efb307b20b3fcf5086a3d5074286133c59fd5c1384d33af43a5929f3dc1a', '[\"*\"]', '2025-06-27 19:58:08', NULL, '2025-06-27 19:58:03', '2025-06-27 19:58:08'),
(451, 'App\\Models\\User', 1, 'api-token', '59ede28a80c8655a4ee49afb381d377eb38c9895d1e1f2378a6abc22a75a1676', '[\"*\"]', '2025-06-27 19:59:56', NULL, '2025-06-27 19:59:49', '2025-06-27 19:59:56'),
(452, 'App\\Models\\User', 1, 'api-token', '3fcaf1d89b5ac974470fe0effead6877bcab3babd324f3451b74c60ef4fd7323', '[\"*\"]', '2025-06-27 20:02:19', NULL, '2025-06-27 20:02:14', '2025-06-27 20:02:19'),
(453, 'App\\Models\\User', 1, 'api-token', 'c0483a28e9e85a518e9d49bec6da34d87560b4cfa270b7afd7b5089c5796e7c8', '[\"*\"]', '2025-06-27 20:08:53', NULL, '2025-06-27 20:08:49', '2025-06-27 20:08:53'),
(454, 'App\\Models\\User', 1, 'api-token', '5ba6677f9801280c8a192216218cc56a47acea2d6809643403ff29ec46cfc571', '[\"*\"]', '2025-06-27 20:12:07', NULL, '2025-06-27 20:12:03', '2025-06-27 20:12:07'),
(455, 'App\\Models\\User', 2, 'api-token', 'f90c6b492f59ff4177f36b3f540fee28095849c594b64a89d1f53b709095f6db', '[\"*\"]', '2025-06-27 20:13:41', NULL, '2025-06-27 20:13:37', '2025-06-27 20:13:41'),
(456, 'App\\Models\\User', 2, 'api-token', '42286e86d8b005c8c1bb5c4c41c9208440be0480cebf2a6f80b89da608d78587', '[\"*\"]', '2025-06-27 20:17:41', NULL, '2025-06-27 20:17:37', '2025-06-27 20:17:41'),
(457, 'App\\Models\\User', 1, 'api-token', '31b4ebb1fe7a9d1656ea571b6a4495bb2afbda77cfbbd652639403acbf829528', '[\"*\"]', '2025-06-27 20:20:43', NULL, '2025-06-27 20:20:40', '2025-06-27 20:20:43'),
(458, 'App\\Models\\User', 1, 'api-token', 'c07f46d517978bf330f749649aac5b1d966c973e8d51c5ba48f80b59cc9cf045', '[\"*\"]', '2025-06-27 20:22:03', NULL, '2025-06-27 20:21:38', '2025-06-27 20:22:03'),
(459, 'App\\Models\\User', 1, 'api-token', '022c512c313c5063f94a93a5aaff3af05deb4e1c4ee7463545a56d0f8ac816fe', '[\"*\"]', '2025-06-27 20:57:22', NULL, '2025-06-27 20:24:06', '2025-06-27 20:57:22'),
(460, 'App\\Models\\User', 2, 'api-token', '4bc9eb66c7f14645ed59ffd0fbd4a61caaeab7d4e9c1629931d6e38a7329e10a', '[\"*\"]', '2025-06-27 21:00:07', NULL, '2025-06-27 20:57:55', '2025-06-27 21:00:07'),
(461, 'App\\Models\\User', 2, 'api-token', 'd8b643460974ccc4616e6c47442cb2f5e290e40b6659be56e3e5527a6db751ec', '[\"*\"]', '2025-06-27 21:26:28', NULL, '2025-06-27 21:26:22', '2025-06-27 21:26:28'),
(462, 'App\\Models\\User', 2, 'api-token', 'ff8d3a3721f68dceb6c66d23db495b16dee9347c63841d160ceee772aa5c2553', '[\"*\"]', '2025-06-27 21:27:08', NULL, '2025-06-27 21:26:57', '2025-06-27 21:27:08'),
(463, 'App\\Models\\User', 1, 'api-token', '57484d881befa06527c41753f2ef413c977e394ec829be37008f07a4626c53b1', '[\"*\"]', '2025-06-27 21:29:30', NULL, '2025-06-27 21:28:49', '2025-06-27 21:29:30'),
(464, 'App\\Models\\User', 1, 'api-token', '6996e783dae639ed91164def251fde3bb7b83eb04cbbad098198d71564992152', '[\"*\"]', '2025-06-27 21:35:06', NULL, '2025-06-27 21:35:03', '2025-06-27 21:35:06'),
(465, 'App\\Models\\User', 1, 'api-token', '36804fe946573b77138dab36ef042c971794c0d3b52d2887992ea0311e1e22d5', '[\"*\"]', '2025-06-27 21:38:45', NULL, '2025-06-27 21:38:39', '2025-06-27 21:38:45'),
(466, 'App\\Models\\User', 1, 'api-token', 'ef4a3be9f64f0b8af0af5ac5bb90b3fdf786795b1dfaf97890e32e07015fe0bf', '[\"*\"]', '2025-06-27 21:42:26', NULL, '2025-06-27 21:42:01', '2025-06-27 21:42:26'),
(467, 'App\\Models\\User', 1, 'api-token', 'd3a95f0ae5dc57aaedb9fc9f4bc649ee7533b679e8763074234e098b223ce5be', '[\"*\"]', '2025-06-28 05:56:29', NULL, '2025-06-28 05:55:27', '2025-06-28 05:56:29'),
(468, 'App\\Models\\User', 1, 'api-token', '5c22e68b177e6f234e74d7b9abeaf7c7687237a327f4d68d9d7aa3c761c768a1', '[\"*\"]', '2025-06-28 05:59:15', NULL, '2025-06-28 05:59:07', '2025-06-28 05:59:15'),
(469, 'App\\Models\\User', 1, 'api-token', '894c4def5bdb2f478820f66b451c7b2c7933d5b3ad9ac68579e55681b3e9216a', '[\"*\"]', '2025-06-28 06:04:51', NULL, '2025-06-28 06:02:05', '2025-06-28 06:04:51'),
(470, 'App\\Models\\User', 1, 'api-token', '5786a3252523fee04dd74d3559f4efce8a05bf6e70dd8e5595c99ac99636c693', '[\"*\"]', '2025-06-28 06:15:53', NULL, '2025-06-28 06:15:17', '2025-06-28 06:15:53'),
(471, 'App\\Models\\User', 1, 'api-token', '1245c736e336d6d4a6aab02f381b0d55d5d1843e43335b3a12d24f7468f2b174', '[\"*\"]', '2025-06-28 06:19:45', NULL, '2025-06-28 06:17:16', '2025-06-28 06:19:45'),
(472, 'App\\Models\\User', 1, 'api-token', '6604140be31aa0f52a74f8f15e73b88c9a8474793e27a9f4211dc4aeff05e23e', '[\"*\"]', '2025-06-28 06:25:19', NULL, '2025-06-28 06:25:03', '2025-06-28 06:25:19'),
(473, 'App\\Models\\User', 1, 'api-token', '27cc809e02cb32b557f2178ac9ca3f3b87cb4647af3c0656e6f8eb7082444d60', '[\"*\"]', '2025-06-28 06:33:55', NULL, '2025-06-28 06:33:48', '2025-06-28 06:33:55'),
(474, 'App\\Models\\User', 1, 'api-token', '8a7f984f6ae7daeaa0a0b4e9627812e22c2fbbdbbf5dfb89f65dc11db91aa1ff', '[\"*\"]', '2025-06-28 06:36:08', NULL, '2025-06-28 06:36:01', '2025-06-28 06:36:08'),
(475, 'App\\Models\\User', 1, 'api-token', '05d33634b6c3ec8829975dda3b65a97bb522a5d173862bc509925630d9b2d492', '[\"*\"]', '2025-06-28 06:41:57', NULL, '2025-06-28 06:41:50', '2025-06-28 06:41:57'),
(476, 'App\\Models\\User', 1, 'api-token', 'e10563d47a808990bb4d8ab727e33b6857078667fc6e8fd07ee8fa045f092298', '[\"*\"]', '2025-06-28 06:44:19', NULL, '2025-06-28 06:44:17', '2025-06-28 06:44:19'),
(477, 'App\\Models\\User', 1, 'api-token', '4a95a64a4bd4a757662ec133cded0cd03f8284a5524e710f4ee342b6335e1745', '[\"*\"]', '2025-06-28 06:50:09', NULL, '2025-06-28 06:50:07', '2025-06-28 06:50:09'),
(478, 'App\\Models\\User', 1, 'api-token', 'cdeaaaa36fbb3a26ce6cabc78673a2b0f4eb716ffb0f8359b487f5a2aa2008a7', '[\"*\"]', '2025-06-28 06:57:44', NULL, '2025-06-28 06:57:41', '2025-06-28 06:57:44'),
(479, 'App\\Models\\User', 2, 'api-token', '4d969a2368a30ddacfca7d902e01d22c45f6366b6d84b4804c415cbef2a9c1a6', '[\"*\"]', '2025-06-28 06:59:29', NULL, '2025-06-28 06:58:55', '2025-06-28 06:59:29'),
(480, 'App\\Models\\User', 1, 'api-token', 'c5610835261179d9c553cd7999ba392ca3559a50491e367a6eb5735152f4189e', '[\"*\"]', '2025-06-28 06:59:51', NULL, '2025-06-28 06:59:50', '2025-06-28 06:59:51'),
(481, 'App\\Models\\User', 1, 'api-token', '1a68bfbd00676e05b76671258b1c6b4d587c9bbcf6f4007921cdb6db2103c80d', '[\"*\"]', '2025-06-28 07:03:31', NULL, '2025-06-28 07:03:29', '2025-06-28 07:03:31'),
(482, 'App\\Models\\User', 2, 'api-token', '40a7f1f8b1dd6c89ac926230d3d464ecf26832014fe5aa6aa28e7e62fb8e889f', '[\"*\"]', '2025-06-28 21:29:22', NULL, '2025-06-28 19:57:16', '2025-06-28 21:29:22'),
(483, 'App\\Models\\User', 1, 'api-token', 'c38abc917bf840456592fec96e6ed5b91324c7c798227a45ccc256afceb04492', '[\"*\"]', '2025-06-28 21:29:56', NULL, '2025-06-28 21:29:51', '2025-06-28 21:29:56'),
(484, 'App\\Models\\User', 2, 'api-token', '453d568d9d535ed6dcd4e60801d166d9dce8d6dc9074298621f5a01af0cdeaf2', '[\"*\"]', '2025-06-28 21:31:46', NULL, '2025-06-28 21:31:40', '2025-06-28 21:31:46'),
(485, 'App\\Models\\User', 1, 'api-token', '89eb040d31b072a4d05070fdbf6751cd30c087e0a2ba4666a2b46d5e387cf76b', '[\"*\"]', '2025-06-28 21:37:34', NULL, '2025-06-28 21:35:52', '2025-06-28 21:37:34'),
(486, 'App\\Models\\User', 1, 'api-token', '005773ae7143cd99f1673c17c0320768494d34a6cfd0307538eb6845e3e063ac', '[\"*\"]', '2025-06-28 21:39:53', NULL, '2025-06-28 21:39:49', '2025-06-28 21:39:53'),
(487, 'App\\Models\\User', 1, 'api-token', '4e09eea41665f0f08f88a8acbdde0c4498dd2301554f62c0538eded0edecf89d', '[\"*\"]', '2025-06-28 21:45:01', NULL, '2025-06-28 21:44:26', '2025-06-28 21:45:01'),
(488, 'App\\Models\\User', 2, 'api-token', 'ab6b44c09416d89d0a0e6a905ebcda773cf7702fd9165727a5c54657d5244c0f', '[\"*\"]', '2025-06-29 06:27:27', NULL, '2025-06-29 06:27:22', '2025-06-29 06:27:27'),
(489, 'App\\Models\\User', 2, 'api-token', '7098babcb221cc9ef4395090c3c06723e7309022ed98df5977e9d0e9240dc433', '[\"*\"]', '2025-06-29 06:30:45', NULL, '2025-06-29 06:30:41', '2025-06-29 06:30:45'),
(490, 'App\\Models\\User', 2, 'api-token', 'f7003c6416d602b83f6408d0f971a2bb20673e4a2faac9c78e9d3137169cf897', '[\"*\"]', '2025-06-29 06:36:01', NULL, '2025-06-29 06:35:56', '2025-06-29 06:36:01'),
(491, 'App\\Models\\User', 2, 'api-token', '1fefddbc0d1a5fb8df40d96982f7777038ca0ea0171674012a0a2f607447f86a', '[\"*\"]', '2025-06-29 06:37:39', NULL, '2025-06-29 06:37:35', '2025-06-29 06:37:39'),
(492, 'App\\Models\\User', 2, 'api-token', '81333b6ac1355b3e43711c8223a26711212a22cc5290683c05c34c52e9d22895', '[\"*\"]', '2025-06-29 06:38:41', NULL, '2025-06-29 06:38:36', '2025-06-29 06:38:41'),
(493, 'App\\Models\\User', 2, 'api-token', '7aaa225427afabbd6e34f16157b436423064955532cb580d4052c8e9737d3fdc', '[\"*\"]', '2025-06-29 06:41:37', NULL, '2025-06-29 06:39:25', '2025-06-29 06:41:37'),
(494, 'App\\Models\\User', 1, 'api-token', '74d9bb81ce78625477a745e2938e992bf54f8b2b2e10493ca1992ecd89a30025', '[\"*\"]', '2025-06-29 06:44:55', NULL, '2025-06-29 06:44:50', '2025-06-29 06:44:55'),
(495, 'App\\Models\\User', 1, 'api-token', 'b980b6cef384cc868b4e1f1940fbb815885545e6df5b15e25b1fdaa7ae91ce28', '[\"*\"]', '2025-06-29 06:45:46', NULL, '2025-06-29 06:45:40', '2025-06-29 06:45:46'),
(496, 'App\\Models\\User', 1, 'api-token', 'e9335670215645f325294f9051a8703e4fed4c73fb7202577b0825ba49e9d035', '[\"*\"]', '2025-06-29 07:11:44', NULL, '2025-06-29 07:11:42', '2025-06-29 07:11:44'),
(497, 'App\\Models\\User', 1, 'api-token', '1e3dc6a6033544f3a261ca692e5502384eef47707fc9e87a0376af9043063761', '[\"*\"]', '2025-06-29 07:20:00', NULL, '2025-06-29 07:19:47', '2025-06-29 07:20:00'),
(498, 'App\\Models\\User', 2, 'api-token', '8262ca3418c8d4064096dd35e3fc5e5f55d34cea6b91e97de5231df7138acdf0', '[\"*\"]', '2025-06-29 07:20:51', NULL, '2025-06-29 07:20:32', '2025-06-29 07:20:51'),
(499, 'App\\Models\\User', 1, 'api-token', 'fa034347e874a1d491d871b81307456de59f1fa436fdd90bca62608f21471676', '[\"*\"]', '2025-06-29 07:28:54', NULL, '2025-06-29 07:23:04', '2025-06-29 07:28:54'),
(500, 'App\\Models\\User', 1, 'api-token', '20e5b51b52116aaa378f16fff136f6e72016fcfd622b2c83745780f5a4302e32', '[\"*\"]', '2025-06-29 07:30:42', NULL, '2025-06-29 07:29:56', '2025-06-29 07:30:42'),
(501, 'App\\Models\\User', 1, 'api-token', '5c60331252dfde060d6358c9b7f136e5c1bae089cef5c2c7a40a98282787f2bf', '[\"*\"]', '2025-06-29 07:31:51', NULL, '2025-06-29 07:31:38', '2025-06-29 07:31:51'),
(502, 'App\\Models\\User', 2, 'api-token', '37d27fa789a4f9f6a66659291f0bcb4732330ed0a71cd87e8e36990c1e12ddf2', '[\"*\"]', '2025-06-29 07:33:12', NULL, '2025-06-29 07:33:10', '2025-06-29 07:33:12'),
(503, 'App\\Models\\User', 1, 'api-token', 'fdc50d2fd038a5c58a85b978bef0e199f516729b5036c7f4b17854f26077b715', '[\"*\"]', '2025-06-29 17:53:06', NULL, '2025-06-29 17:50:48', '2025-06-29 17:53:06'),
(504, 'App\\Models\\User', 1, 'api-token', 'c7667174f6f1a8805fa446c53f47e4abc0cee6cad085fb5182f42c5a9395a313', '[\"*\"]', '2025-06-29 18:59:57', NULL, '2025-06-29 18:59:42', '2025-06-29 18:59:57'),
(505, 'App\\Models\\User', 1, 'api-token', '63dadbfab49ff52fb23096fdd4c200bc4e936b6e054bd0b4c634fae54e69cb32', '[\"*\"]', '2025-06-29 19:55:43', NULL, '2025-06-29 19:55:38', '2025-06-29 19:55:43'),
(506, 'App\\Models\\User', 2, 'api-token', '818cda389bc8f612323aad3de91fa43b8b2e8a5eace2253e93467eb3c1ecaf1e', '[\"*\"]', '2025-06-29 19:57:51', NULL, '2025-06-29 19:57:12', '2025-06-29 19:57:51'),
(507, 'App\\Models\\User', 1, 'api-token', '34c3492a3f7915244d22ea8fe8b1804b8a35b2ec1553a34830cdd0e8d20937fd', '[\"*\"]', '2025-06-29 20:01:15', NULL, '2025-06-29 19:58:50', '2025-06-29 20:01:15'),
(508, 'App\\Models\\User', 1, 'api-token', '4fd0c29f150137854992fb64702b77eb18d3da9ddac11789efb52dfb1f5b2401', '[\"*\"]', '2025-06-29 20:12:05', NULL, '2025-06-29 20:11:44', '2025-06-29 20:12:05');
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(509, 'App\\Models\\User', 1, 'api-token', '11e68759bb7ecf7d2c96c51cddce9705881a76ce5b33ce91987fc94c929b7e7b', '[\"*\"]', '2025-06-29 20:15:36', NULL, '2025-06-29 20:15:22', '2025-06-29 20:15:36'),
(510, 'App\\Models\\User', 1, 'api-token', '8889ac61c3cc7684e0532bb3fd50d12749d1f201d8667552a2d720a9fcc96328', '[\"*\"]', '2025-06-29 20:22:09', NULL, '2025-06-29 20:21:55', '2025-06-29 20:22:09'),
(511, 'App\\Models\\User', 1, 'api-token', '922b11ae3b49214a3668f1019a03ad2d557a691001419d7478696dad695955ef', '[\"*\"]', '2025-06-29 20:31:16', NULL, '2025-06-29 20:26:25', '2025-06-29 20:31:16'),
(512, 'App\\Models\\User', 2, 'api-token', 'd56359d8e9540af8e81a684024a3d208a1f89a7abd1540cf4239fa85cdc49ab2', '[\"*\"]', '2025-06-29 20:37:18', NULL, '2025-06-29 20:32:42', '2025-06-29 20:37:18'),
(513, 'App\\Models\\User', 1, 'api-token', '5b58862c8aa41cb944fff4832c43a1ed7c072f815c6e5cf1fe55eb7595d9a851', '[\"*\"]', NULL, NULL, '2025-06-29 20:35:28', '2025-06-29 20:35:28'),
(514, 'App\\Models\\User', 2, 'api-token', '1aba4db25d20819f196c14af3b988673f2d37ece436dba96d745c9fcc3460354', '[\"*\"]', '2025-06-29 20:36:33', NULL, '2025-06-29 20:35:44', '2025-06-29 20:36:33'),
(515, 'App\\Models\\User', 2, 'api-token', 'f2d7767f8f525c3180f0cbf716a64b7b6d4ff3dcee9d1d081eabe2f070113db9', '[\"*\"]', '2025-06-29 20:42:34', NULL, '2025-06-29 20:42:20', '2025-06-29 20:42:34'),
(516, 'App\\Models\\User', 1, 'api-token', '2c7b7a0f46e919059089c0937d888266534828c54c2cb3e3e57df4c9f5412e56', '[\"*\"]', '2025-06-29 20:48:35', NULL, '2025-06-29 20:47:03', '2025-06-29 20:48:35'),
(517, 'App\\Models\\User', 2, 'api-token', 'd15a0bddc703177e8e446aa13886d92a8cc5ea74fe617ba930f02c2f66fec955', '[\"*\"]', '2025-06-29 20:50:11', NULL, '2025-06-29 20:49:20', '2025-06-29 20:50:11'),
(518, 'App\\Models\\User', 1, 'api-token', '5106a4321b9cd2409981cbaf112f20a900529aba681af70d20e67c709daa408c', '[\"*\"]', '2025-06-30 02:53:13', NULL, '2025-06-30 02:47:40', '2025-06-30 02:53:13'),
(519, 'App\\Models\\User', 1, 'api-token', '0c4bf1d1250c71551095579c4235ac27f2ce31c837bfe4c0f4c8d2a10c3c18b8', '[\"*\"]', '2025-06-30 03:20:16', NULL, '2025-06-30 03:13:39', '2025-06-30 03:20:16');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('JxZ8L9zck7HXN9rklD7MfFRAh5i2IS8qYwNoFB3V', 2, '192.168.1.6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiU0VpeXVEYVU2ZERjYVRmckFhWnhhWkR3ZG1FcEdkUDFSVkxrUjhRNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly8xOTIuMTY4LjEuNjo4MDAwL2FwcHJvdmVyL3N0b2stYmFyYW5nIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9', 1751173112),
('lb7ydaH0mw0sGVkXYV4Y097AKXwsZmZ9WwnSce1p', 2, '192.168.1.6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZ1NOUHByb1lHYzBLSUJyTjhSN29xRjNseERZSmN5cUU4NTJWUVFoeCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xOTIuMTY4LjEuNjo4MDAwL2xvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9', 1751191944),
('Lsm5hQGLUPZe1zacJF6Fa0CnHsx9QGiu6XHQgFFv', 2, '192.168.1.3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoid2YySWl2a0tMMnhoUGk0N0pWb2txdElsSTF0d2Z1WjQwT2p6VTc5SiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly8xOTIuMTY4LjEuMzo4MDAwL2FwcHJvdmVyL3N0b2stYmFyYW5nIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9', 1751259715),
('Pu7elUDsNrZFU4HuuQANNXn26Z9v4UWfOb2x8l8T', 2, '192.168.1.3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoibWViVHFjV1RoMmRNaE9hRTdzQ3RwWFJCMEY2N3JpekxnQlgzUUpxUCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly8xOTIuMTY4LjEuMzo4MDAwL2FwcHJvdmVyL211dGFzaS10ZW1wbGF0ZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjI7fQ==', 1751277385),
('QT3hGRnOL2IGOm31Wh2fEWeN17HIPCFNZBa4fPlS', 2, '192.168.1.3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNGVxT1NuOExnUzBsYUFPNWlxQ0RuWnNlZzB3YWJ1TzdYYVpsdTZZRSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly8xOTIuMTY4LjEuMzo4MDAwL2FwcHJvdmVyL211dGFzaS10ZW1wbGF0ZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjI7fQ==', 1751285400),
('wkA6fTqqs1ptVeONKx06ObqyEtOMr30GN3sEzzSL', 2, '192.168.1.3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoicTdpcHYxdHpZdVYyQWFKdDZkaVUyY3dTVExicjZXcXFabkhGV2FoRSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NzE6Imh0dHA6Ly8xOTIuMTY4LjEuMzo4MDAwL2FwcHJvdmVyL3N0b2stYmFyYW5nP2NhdGVnb3J5PSZxPSZzdWJfY2F0ZWdvcnk9Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9', 1751206806),
('XdUmITbxhcdXeIXaZWf6jSOyGLoZPxdaWvw49Wno', 2, '192.168.1.6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoicU92bWdCT3BGOExrck94ZVh5ZWRBNUdvR0dqSFFKSWpEcGlLYWZjNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xOTIuMTY4LjEuNjo4MDAwL2xvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9', 1751191666);

-- --------------------------------------------------------

--
-- Table structure for table `stock_requests`
--

CREATE TABLE `stock_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `item_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('increase','decrease','delete') DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stock_requests`
--

INSERT INTO `stock_requests` (`id`, `item_id`, `user_id`, `type`, `quantity`, `unit`, `status`, `description`, `created_at`, `updated_at`) VALUES
(1, 22, 1, 'increase', 100, 'Box', 'approved', NULL, '2025-06-25 20:32:03', '2025-06-26 02:55:18'),
(3, 22, 1, 'decrease', 15, 'Box', 'approved', NULL, '2025-06-26 19:20:23', '2025-06-26 19:23:54'),
(4, 22, 1, 'decrease', 5, 'Box', 'approved', NULL, '2025-06-26 19:25:01', '2025-06-28 06:59:28'),
(6, 22, 1, 'increase', 15, 'Box', 'approved', 'Mencoba', '2025-06-27 05:38:59', '2025-06-27 05:40:38'),
(10, 22, 1, 'increase', 10, 'Box', 'approved', 'Percobaan', '2025-06-28 06:19:09', '2025-06-29 20:37:04'),
(12, 25, 2, 'increase', 10, 'Box', 'approved', 'Barang diterima dari supplier A', '2025-06-28 21:27:06', '2025-06-28 21:27:06'),
(13, 26, 2, 'increase', 50, 'Pcs', 'approved', 'Persediaan tambahan', '2025-06-28 21:27:06', '2025-06-28 21:27:06'),
(16, 28, 1, 'increase', 50, 'Box', 'approved', 'Mencoba dashboard approver web', '2025-06-29 17:53:05', '2025-06-29 20:32:52'),
(18, 29, 1, 'increase', 150, 'Pcs', 'pending', 'Mencoba lagi', '2025-06-29 20:48:00', '2025-06-29 20:48:00');

-- --------------------------------------------------------

--
-- Table structure for table `sub_categories`
--

CREATE TABLE `sub_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sub_categories`
--

INSERT INTO `sub_categories` (`id`, `name`, `category_id`, `created_at`, `updated_at`) VALUES
(1, 'Herbisida', 9, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(2, 'Insektisida', 9, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(3, 'Fungisida', 9, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(4, 'Lain-lain', 9, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(5, 'Herbisida', 10, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(6, 'Insektisida', 10, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(7, 'Fungisida', 10, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(8, 'Lain-lain', 10, '2025-06-25 06:26:19', '2025-06-25 06:26:19'),
(9, 'Herbisida', 12, '2025-06-27 04:11:56', '2025-06-27 04:11:56'),
(10, 'Insektisida', 12, '2025-06-27 04:12:35', '2025-06-27 04:12:35'),
(11, 'Fungisida', 12, '2025-06-27 04:13:01', '2025-06-27 04:13:01'),
(12, 'Lain-lain', 12, '2025-06-27 04:13:34', '2025-06-27 04:13:34');

-- --------------------------------------------------------

--
-- Table structure for table `sub_category_requests`
--

CREATE TABLE `sub_category_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `requested_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sub_category_requests`
--

INSERT INTO `sub_category_requests` (`id`, `category_id`, `name`, `status`, `requested_by`, `created_at`, `updated_at`) VALUES
(1, 11, 'Herbisida', 'approved', 1, '2025-06-27 07:11:30', '2025-06-27 07:15:25');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Submitter','Approver') NOT NULL DEFAULT 'Submitter',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Submitter 1', 'submitter@example.com', NULL, '$2y$12$HgbOEJIE39CDjEsReqGcUu.JIKOeZEglnO1lYYnv9MHTnTQf23cvm', 'Submitter', NULL, '2025-06-14 04:09:35', '2025-06-14 04:09:35'),
(2, 'Approver 1', 'approver@example.com', NULL, '$2y$12$yTF1dXzAbqttg8Zv9RPTA..cfLPiQuJKLey7qVPNOmK8ot//9sMPC', 'Approver', NULL, '2025-06-14 04:09:48', '2025-06-14 04:09:48');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_name_unique` (`name`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `items_sku_unique` (`sku`),
  ADD KEY `items_category_id_foreign` (`category_id`),
  ADD KEY `items_user_id_foreign` (`user_id`),
  ADD KEY `items_sub_category_id_foreign` (`sub_category_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `stock_requests`
--
ALTER TABLE `stock_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stock_requests_item_id_foreign` (`item_id`),
  ADD KEY `stock_requests_user_id_foreign` (`user_id`);

--
-- Indexes for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_categories_category_id_foreign` (`category_id`);

--
-- Indexes for table `sub_category_requests`
--
ALTER TABLE `sub_category_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_category_requests_category_id_foreign` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=520;

--
-- AUTO_INCREMENT for table `stock_requests`
--
ALTER TABLE `stock_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `sub_categories`
--
ALTER TABLE `sub_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `sub_category_requests`
--
ALTER TABLE `sub_category_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `items_sub_category_id_foreign` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stock_requests`
--
ALTER TABLE `stock_requests`
  ADD CONSTRAINT `stock_requests_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD CONSTRAINT `sub_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sub_category_requests`
--
ALTER TABLE `sub_category_requests`
  ADD CONSTRAINT `sub_category_requests_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
