-- Fix for missing 'autobroadcast_locale' table
DROP TABLE IF EXISTS `autobroadcast_locale`;
CREATE TABLE `autobroadcast_locale` (
  `realmid` INT NOT NULL,
  `id` INT NOT NULL,
  `locale` VARCHAR(4) NOT NULL,
  `text` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
  PRIMARY KEY (`realmid`, `id`, `locale`)
)
CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
ENGINE = InnoDB;
