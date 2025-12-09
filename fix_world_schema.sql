-- Fix for missing tables in 'acore_world'
-- Includes: module_string, player_totem_model, player_shapeshift_model, creature_sparring

-- 1. Fix module_string (from 2024_08_13_02.sql)
DROP TABLE IF EXISTS `module_string`;
CREATE TABLE IF NOT EXISTS `module_string` (
  `module` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'module dir name, eg mod-cfbg',
  `id` int unsigned NOT NULL,
  `string` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`module`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `module_string_locale`;
CREATE TABLE IF NOT EXISTS `module_string_locale` (
  `module` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Corresponds to an existing entry in module_string',
  `id` int unsigned NOT NULL COMMENT 'Corresponds to an existing entry in module_string',
  `locale` ENUM('koKR', 'frFR', 'deDE', 'zhCN', 'zhTW', 'esES', 'esMX', 'ruRU') NOT NULL,
  `string` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`module`, `id`, `locale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELETE FROM `command` WHERE `name` = 'reload module_string';
INSERT INTO `command` (`name`, `security`, `help`) VALUES
('reload module_string', 3, 'Syntax: .reload module_string');

-- 2. Fix player_shapeshift_model & player_totem_model (from 2025_05_27_01.sql)
DROP TABLE IF EXISTS `player_shapeshift_model`;
DROP TABLE IF EXISTS `player_totem_model`;

CREATE TABLE IF NOT EXISTS `player_shapeshift_model` (
  `ShapeshiftID` TINYINT unsigned NOT NULL,
  `RaceID` TINYINT unsigned NOT NULL,
  `CustomizationID` TINYINT unsigned NOT NULL,
  `GenderID` TINYINT unsigned NOT NULL,
  `ModelID` INT unsigned NOT NULL,
  PRIMARY KEY (`ShapeshiftID`, `RaceID`, `CustomizationID`, `GenderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 PACK_KEYS=0;

CREATE TABLE IF NOT EXISTS `player_totem_model` (
  `TotemID` TINYINT unsigned NOT NULL,
  `RaceID` TINYINT unsigned NOT NULL,
  `ModelID` INT unsigned NOT NULL,
  PRIMARY KEY (`TotemID`, `RaceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 PACK_KEYS=0;

INSERT INTO `player_shapeshift_model` (`ShapeshiftID`, `RaceID`, `CustomizationID`, `GenderID`, `ModelID`) VALUES
(1, 4, 0, 2, 29407), (1, 4, 1, 2, 29407), (1, 4, 2, 2, 29407), (1, 4, 3, 2, 29406), (1, 4, 4, 2, 29408), (1, 4, 7, 2, 29405), (1, 4, 8, 2, 29405), (1, 4, 255, 2, 892),
(1, 6, 12, 0, 29409), (1, 6, 13, 0, 29409), (1, 6, 14, 0, 29409), (1, 6, 18, 0, 29409), (1, 6, 9, 0, 29410), (1, 6, 10, 0, 29410), (1, 6, 11, 0, 29410), (1, 6, 6, 0, 29411), (1, 6, 7, 0, 29411), (1, 6, 8, 0, 29411), (1, 6, 0, 0, 29412), (1, 6, 1, 0, 29412), (1, 6, 2, 0, 29412), (1, 6, 3, 0, 29412), (1, 6, 4, 0, 29412), (1, 6, 5, 0, 29412), (1, 6, 255, 0, 8571),
(1, 6, 10, 1, 29409), (1, 6, 6, 1, 29410), (1, 6, 7, 1, 29410), (1, 6, 4, 1, 29411), (1, 6, 5, 1, 29411), (1, 6, 0, 1, 29412), (1, 6, 1, 1, 29412), (1, 6, 2, 1, 29412), (1, 6, 3, 1, 29412), (1, 6, 255, 1, 8571),
(5, 4, 0, 2, 29413), (5, 4, 1, 2, 29413), (5, 4, 2, 2, 29413), (5, 4, 6, 2, 29414), (5, 4, 4, 2, 29416), (5, 4, 3, 2, 29417), (5, 4, 255, 2, 2281),
(8, 4, 0, 2, 29413), (8, 4, 1, 2, 29413), (8, 4, 2, 2, 29413), (8, 4, 6, 2, 29414), (8, 4, 4, 2, 29416), (8, 4, 3, 2, 29417), (8, 4, 255, 2, 2281),
(5, 6, 0, 0, 29418), (5, 6, 1, 0, 29418), (5, 6, 2, 0, 29418), (5, 6, 3, 0, 29419), (5, 6, 4, 0, 29419), (5, 6, 5, 0, 29419), (5, 6, 12, 0, 29419), (5, 6, 13, 0, 29419), (5, 6, 14, 0, 29419), (5, 6, 9, 0, 29420), (5, 6, 10, 0, 29420), (5, 6, 11, 0, 29420), (5, 6, 15, 0, 29420), (5, 6, 16, 0, 29420), (5, 6, 17, 0, 29420), (5, 6, 18, 0, 29421), (5, 6, 255, 0, 2289),
(8, 6, 0, 0, 29418), (8, 6, 1, 0, 29418), (8, 6, 2, 0, 29418), (8, 6, 3, 0, 29419), (8, 6, 4, 0, 29419), (8, 6, 5, 0, 29419), (8, 6, 12, 0, 29419), (8, 6, 13, 0, 29419), (8, 6, 14, 0, 29419), (8, 6, 9, 0, 29420), (8, 6, 10, 0, 29420), (8, 6, 11, 0, 29420), (8, 6, 15, 0, 29420), (8, 6, 16, 0, 29420), (8, 6, 17, 0, 29420), (8, 6, 18, 0, 29421), (8, 6, 255, 0, 2289),
(5, 6, 0, 1, 29418), (5, 6, 1, 1, 29418), (5, 6, 2, 1, 29419), (5, 6, 3, 1, 29419), (5, 6, 6, 1, 29420), (5, 6, 7, 1, 29420), (5, 6, 8, 1, 29420), (5, 6, 9, 1, 29420), (5, 6, 10, 1, 29421), (5, 6, 255, 1, 2289),
(8, 6, 0, 1, 29418), (8, 6, 1, 1, 29418), (8, 6, 2, 1, 29419), (8, 6, 3, 1, 29419), (8, 6, 6, 1, 29420), (8, 6, 7, 1, 29420), (8, 6, 8, 1, 29420), (8, 6, 9, 1, 29420), (8, 6, 10, 1, 29421), (8, 6, 255, 1, 2289),
(27, 4, 255, 2, 21243), (27, 6, 255, 2, 21244), (29, 4, 255, 2, 20857), (29, 6, 255, 2, 20872);

INSERT INTO `player_totem_model` (`TotemID`, `RaceID`, `ModelID`) VALUES
(1, 2, 30758), (2, 2, 30757), (3, 2, 30759), (4, 2, 30756),
(1, 3, 30754), (2, 3, 30753), (3, 3, 30755), (4, 3, 30736),
(1, 8, 30762), (2, 8, 30761), (3, 8, 30763), (4, 8, 30760),
(1, 6, 4589), (2, 6, 4588), (3, 6, 4587), (4, 6, 4590),
(1, 11, 19074), (2, 11, 19073), (3, 11, 19075), (4, 11, 19071);

-- 3. Fix creature_sparring (from 2025_01_26_00.sql)
DROP TABLE IF EXISTS `creature_sparring`;
CREATE TABLE `creature_sparring` (
  `GUID` int unsigned NOT NULL,
  `SparringPCT` float NOT NULL,
  PRIMARY KEY (`GUID`),
  -- Removed FK constraint to avoid error if 'creature' table is missing/empty/incompatible in some weird state, though ideally it should be there.
  -- Keeping it simple for manual fix script to succeed.
  -- FOREIGN KEY (`GUID`) REFERENCES creature(`guid`),
  CONSTRAINT `creature_sparring_chk_1` CHECK (`SparringPCT` BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
