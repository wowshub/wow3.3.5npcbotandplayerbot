-- Mark manually applied updates as 'RELEASED' in the 'updates' table to prevent auto-updater crashes.

-- AUTH DATABASE UPDATES
USE acore_auth;
INSERT IGNORE INTO `updates` (`name`, `hash`, `state`, `timestamp`, `speed`) VALUES
('2025_07_24_00.sql', '', 'RELEASED', NOW(), 0), -- Flags column
('2024_12_15_00.sql', '', 'RELEASED', NOW(), 0), -- motd_localized
('2025_01_26_00.sql', '', 'RELEASED', NOW(), 0); -- autobroadcast_locale


-- CHARACTERS DATABASE UPDATES
USE acore_characters;
INSERT IGNORE INTO `updates` (`name`, `hash`, `state`, `timestamp`, `speed`) VALUES
('2025_09_03_00.sql', '', 'RELEASED', NOW(), 0), -- petition_id
('2024_09_03_00.sql', '', 'RELEASED', NOW(), 0), -- offline updates
('2025_01_31_00.sql', '', 'RELEASED', NOW(), 0), -- world_state
('2024_09_22_00.sql', '', 'RELEASED', NOW(), 0), -- recovery_item
('2025_03_09_00.sql', '', 'RELEASED', NOW(), 0), -- mail_server_template items/conditions
('2024_11_21_00_characters_npcbot.sql', '', 'RELEASED', NOW(), 0); -- miscvalues column (custom)


-- WORLD DATABASE UPDATES
USE acore_world;
INSERT IGNORE INTO `updates` (`name`, `hash`, `state`, `timestamp`, `speed`) VALUES
('2024_08_13_02.sql', '', 'RELEASED', NOW(), 0), -- module_string
('2025_05_27_01.sql', '', 'RELEASED', NOW(), 0), -- player_totem_model
('2025_01_26_00.sql', '', 'RELEASED', NOW(), 0); -- creature_sparring
