-- Fully Robust Fix Script (Updated V4)
-- Safe to run multiple times. Handles partial updates.

DROP PROCEDURE IF EXISTS `repair_acore_characters_schema`;

DELIMITER //

CREATE PROCEDURE `repair_acore_characters_schema`()
BEGIN
    -- 1. Fix Mail Server Template Items
    CREATE TABLE IF NOT EXISTS `mail_server_template_items` (
        `id` INT UNSIGNED AUTO_INCREMENT,
        `templateID` INT UNSIGNED NOT NULL,
        `faction` ENUM('Alliance', 'Horde') NOT NULL,
        `item` INT UNSIGNED NOT NULL,
        `itemCount` INT UNSIGNED NOT NULL,
        PRIMARY KEY (`id`),
        CONSTRAINT `fk_mail_template`
            FOREIGN KEY (`templateID`) REFERENCES `mail_server_template`(`id`)
            ON DELETE CASCADE
    ) ENGINE=InnoDB COLLATE='utf8mb4_unicode_ci';

    -- Migrate Data ONLY if source columns exist
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'itemA') THEN
        DELETE FROM `mail_server_template_items`;
        INSERT INTO `mail_server_template_items` (`templateID`, `faction`, `item`, `itemCount`)
        SELECT `id`, 'Alliance', `itemA`, `itemCountA` FROM `mail_server_template` WHERE `itemA` > 0;
        INSERT INTO `mail_server_template_items` (`templateID`, `faction`, `item`, `itemCount`)
        SELECT `id`, 'Horde', `itemH`, `itemCountH` FROM `mail_server_template` WHERE `itemH` > 0;
    END IF;

    -- 2. Fix Mail Server Template Conditions
    CREATE TABLE IF NOT EXISTS `mail_server_template_conditions` (
        `id` INT UNSIGNED AUTO_INCREMENT,
        `templateID` INT UNSIGNED NOT NULL,
        `conditionType` ENUM('Level', 'PlayTime', 'Quest', 'Achievement', 'Reputation', 'Faction', 'Race', 'Class') NOT NULL,
        `conditionValue` INT UNSIGNED NOT NULL,
        `conditionState` INT UNSIGNED NOT NULL DEFAULT 0,
        PRIMARY KEY (`id`),
        CONSTRAINT `fk_mail_template_conditions`
            FOREIGN KEY (`templateID`) REFERENCES `mail_server_template`(`id`)
            ON DELETE CASCADE
    ) ENGINE=InnoDB COLLATE='utf8mb4_unicode_ci';

    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'reqLevel') THEN
        DELETE FROM `mail_server_template_conditions` WHERE `conditionType` IN ('Level', 'PlayTime');
        INSERT INTO `mail_server_template_conditions` (`templateID`, `conditionType`, `conditionValue`)
        SELECT `id`, 'Level', `reqLevel` FROM `mail_server_template` WHERE `reqLevel` > 0;
        INSERT INTO `mail_server_template_conditions` (`templateID`, `conditionType`, `conditionValue`)
        SELECT `id`, 'PlayTime', `reqPlayTime` FROM `mail_server_template` WHERE `reqPlayTime` > 0;
    END IF;

    -- 3. Cleanup Old Mail Columns
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'itemA') THEN
        ALTER TABLE `mail_server_template` DROP COLUMN `itemA`;
    END IF;
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'itemCountA') THEN
        ALTER TABLE `mail_server_template` DROP COLUMN `itemCountA`;
    END IF;
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'itemH') THEN
        ALTER TABLE `mail_server_template` DROP COLUMN `itemH`;
    END IF;
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'itemCountH') THEN
        ALTER TABLE `mail_server_template` DROP COLUMN `itemCountH`;
    END IF;
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'reqLevel') THEN
        ALTER TABLE `mail_server_template` DROP COLUMN `reqLevel`;
    END IF;
    IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mail_server_template' AND COLUMN_NAME = 'reqPlayTime') THEN
        ALTER TABLE `mail_server_template` DROP COLUMN `reqPlayTime`;
    END IF;

    -- 4. Fix Petitions (Petition ID)
    IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'petition' AND COLUMN_NAME = 'petition_id') THEN
        ALTER TABLE `petition` ADD COLUMN `petition_id` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `petitionguid`;
        UPDATE `petition` SET `petition_id` = CASE WHEN `petitionguid` <= 2147483647 THEN `petitionguid` ELSE `petitionguid` - 2147483648 END WHERE `petition_id` = 0;
        ALTER TABLE `petition` ADD INDEX `idx_petition_id` (`petition_id`);
    END IF;

    IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'petition_sign' AND COLUMN_NAME = 'petition_id') THEN
        ALTER TABLE `petition_sign` ADD COLUMN `petition_id` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `petitionguid`;
        UPDATE `petition_sign` AS `ps` JOIN `petition` AS `p` ON `p`.`petitionguid` = `ps`.`petitionguid` SET `ps`.`petition_id` = `p`.`petition_id` WHERE `ps`.`petition_id` = 0;
        ALTER TABLE `petition_sign` ADD INDEX `idx_petition_id_player` (`petition_id`, `playerguid`);
    END IF;

    -- 5. Fix Character Achievement Offline Updates
    CREATE TABLE IF NOT EXISTS `character_achievement_offline_updates` (
        `guid` INT UNSIGNED NOT NULL COMMENT 'Character\'s GUID',
        `update_type` TINYINT UNSIGNED NOT NULL COMMENT 'Supported types: 1 - COMPLETE_ACHIEVEMENT; 2 - UPDATE_CRITERIA',
        `arg1` INT UNSIGNED NOT NULL COMMENT 'For type 1: achievement ID; for type 2: ACHIEVEMENT_CRITERIA_TYPE',
        `arg2` INT UNSIGNED DEFAULT NULL COMMENT 'For type 2: miscValue1 for updating achievement criteria',
        `arg3` INT UNSIGNED DEFAULT NULL COMMENT 'For type 2: miscValue2 for updating achievement criteria',
        INDEX `idx_guid` (`guid`)
    )
    COMMENT = 'Stores updates to character achievements when the character was offline'
    CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    ENGINE = InnoDB;

    -- 6. Fix World State
    DROP TABLE IF EXISTS `world_state`;
    CREATE TABLE IF NOT EXISTS `world_state` (
       `Id` INT UNSIGNED NOT NULL COMMENT 'Internal save ID',
       `Data` longtext,
       PRIMARY KEY(`Id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WorldState save system';

    DELETE FROM `world_state` WHERE `Id` = 20;
    INSERT INTO `world_state` (`Id`, `Data`) VALUES(20, '3 15 10000 10000 10000 10000 10000 10000 10000 10000 10000 10000 3 80 80 80');

    -- 7. Fix Characters NPCBot Miscvalues
    IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'characters_npcbot' AND COLUMN_NAME = 'miscvalues') THEN
        ALTER TABLE `characters_npcbot` ADD `miscvalues` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `spells_disabled`;
    END IF;

    -- 8. Fix Recovery Item DeleteDate
    IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'recovery_item' AND COLUMN_NAME = 'DeleteDate') THEN
        ALTER TABLE `recovery_item` ADD COLUMN `DeleteDate` INT UNSIGNED NULL DEFAULT NULL AFTER `Count`;
    END IF;

END //

DELIMITER ;

-- Run the procedure
CALL `repair_acore_characters_schema`();

-- Cleanup procedure
DROP PROCEDURE `repair_acore_characters_schema`;

-- Constants update (Safe to run always)
UPDATE `item_instance` AS `ii` JOIN `petition` AS `p` ON `p`.`petitionguid` = `ii`.`guid` SET `ii`.`enchantments` = CONCAT(`p`.`petition_id`, SUBSTRING(`ii`.`enchantments`, LOCATE(' ', `ii`.`enchantments`))) WHERE `ii`.`enchantments` IS NOT NULL AND `ii`.`enchantments` <> '';
