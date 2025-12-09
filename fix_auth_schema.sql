-- Fix for missing 'Flags' column in 'account' table
ALTER TABLE `account`
    ADD COLUMN `Flags` INT UNSIGNED NOT NULL DEFAULT '0' AFTER `expansion`;

-- Fix for missing 'motd_localized' table
CREATE TABLE IF NOT EXISTS `motd_localized` (
  `realmid` INT,
  `locale` VARCHAR(4) NOT NULL COLLATE 'utf8mb4_unicode_ci',
  `text` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
  PRIMARY KEY (`realmid`, `locale`)
)
CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
ENGINE = InnoDB
;
