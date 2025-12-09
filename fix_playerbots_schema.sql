-- Fix for missing 'playerbots_account_type' in 'acore_playerbots' (Version 5 - Final?)
-- Inferred Schema:
-- playerbots_account_type: account_id (INT), account_type (TINYINT), assignment_date (BIGINT)
-- playerbots_account_links: id (INT), account_id (INT), bot_account_id (INT)

USE acore_playerbots;

DROP TABLE IF EXISTS `playerbots_account_type`;
CREATE TABLE IF NOT EXISTS `playerbots_account_type` (
  `account_id` INT UNSIGNED NOT NULL COMMENT 'Account ID from auth.account',
  `account_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Player, 1=Mod, etc.',
  `assignment_date` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Timestamp of assignment',
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `playerbots_account_links`;
CREATE TABLE IF NOT EXISTS `playerbots_account_links` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `account_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Master Account ID',
  `bot_account_id` INT UNSIGNED NOT NULL DEFAULT 0,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Active link',
  UNIQUE KEY `idx_link` (`account_id`, `bot_account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
