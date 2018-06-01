SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;

SET @free_tier = 1;
SET @small_tier = 2;
SET @medium_tier = 3;
SET @modest_tier = 4;

SET @demo_account = 1;
SET @demo_account_email = 'demo@campanhasemkt.com.br';
SET @demo_salt = MD5('2308377020');
SET @demo_account_pwd = SHA1(CONCAT(@demo_salt, 'demo@123'));

CREATE TABLE `saas_plan`(
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text,
  `email_limit` int unsigned NOT NULL DEFAULT 100,
  `month_sends_limit` int unsigned NOT NULL DEFAULT 5,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `saas_plan` VALUES
(@free_tier, 'Free', 'Free tier to start your campaigns.', 100, 5),
(@small_tier, 'Small', 'Small tier for your campaigns.', 500, 10),
(@medium_tier, 'Medium', 'Medium tier for your campaigns.', 1000, 10),
(@modest_tier, 'Modest', 'Some kind of large tier for your campaigns.', 5000, 20);

CREATE TABLE `saas_account`(
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sass_plan_id` int(11) unsigned NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `salt` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `company` varchar(255),
  `cnpj` varchar(20),
  `name` varchar(255),
  `phone1` varchar(30),
  `phone2` varchar(30),
  `address1` varchar(255),
  `address2` varchar(255),
  `city` varchar(100),
  `state` varchar(100),
  `country` varchar(100),
  `zipcode` varchar(20)
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_email` (`email`),
  KEY `sass_plan`(`sass_plan_id`),
  CONSTRAINT `account_plan_ibfk_1` FOREIGN KEY (`sass_plan_id`) REFERENCES `saas_plan` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `saas_account`(`id`, `saas_plan_id`, `email`, `password`, `salt`) VALUES
(@demo_account, @free_tier, @demo_account_email, @demo_account_pwd, @demo_salt);

CREATE TABLE `attachments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `campaign` int(11) unsigned NOT NULL,
  `filename` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `content_type` varchar(100) CHARACTER SET ascii NOT NULL DEFAULT '',
  `content` longblob,
  `size` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `campaign` (`campaign`),
  CONSTRAINT `attachments_ibfk_1` FOREIGN KEY (`campaign`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `campaign` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list` int(11) unsigned NOT NULL,
  `segment` int(11) unsigned NOT NULL,
  `subscription` int(11) unsigned NOT NULL,
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `response` varchar(255) DEFAULT NULL,
  `response_id` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `updated` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `list` (`list`,`segment`,`subscription`),
  KEY `created` (`created`),
  KEY `response_id` (`response_id`),
  KEY `status_index` (`status`),
  KEY `subscription_index` (`subscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `campaign_tracker` (
  `list` int(11) unsigned NOT NULL,
  `subscriber` int(11) unsigned NOT NULL,
  `link` int(11) NOT NULL,
  `ip` varchar(100) CHARACTER SET ascii DEFAULT NULL,
  `device_type` varchar(50) DEFAULT NULL,
  `country` varchar(2) CHARACTER SET ascii DEFAULT NULL,
  `count` int(11) unsigned NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`list`,`subscriber`,`link`),
  KEY `created_index` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `campaigns` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) CHARACTER SET ascii NOT NULL,
  `type` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `parent` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `list` int(11) unsigned NOT NULL,
  `segment` int(11) unsigned DEFAULT NULL,
  `template` int(11) unsigned NOT NULL,
  `source_url` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `editor_name` varchar(50) DEFAULT '',
  `editor_data` longtext,
  `last_check` timestamp NULL DEFAULT NULL,
  `check_status` varchar(255) DEFAULT NULL,
  `from` varchar(255) DEFAULT '',
  `address` varchar(255) DEFAULT '',
  `reply_to` varchar(255) DEFAULT '',
  `subject` varchar(255) DEFAULT '',
  `html` longtext,
  `html_prepared` longtext,
  `text` longtext,
  `status` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `tracking_disabled` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `scheduled` timestamp NULL DEFAULT NULL,
  `status_change` timestamp NULL DEFAULT NULL,
  `delivered` int(11) unsigned NOT NULL DEFAULT '0',
  `opened` int(11) unsigned NOT NULL DEFAULT '0',
  `clicks` int(11) unsigned NOT NULL DEFAULT '0',
  `unsubscribed` int(11) unsigned NOT NULL DEFAULT '0',
  `bounced` int(1) unsigned NOT NULL DEFAULT '0',
  `complained` int(1) unsigned NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`),
  KEY `name` (`name`(191)),
  KEY `status` (`status`),
  KEY `schedule_index` (`scheduled`),
  KEY `type_index` (`type`),
  KEY `parent_index` (`parent`),
  KEY `check_index` (`last_check`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `confirmations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) CHARACTER SET ascii NOT NULL,
  `list` int(11) unsigned NOT NULL,
  `email` varchar(255) NOT NULL,
  `opt_in_ip` varchar(100) DEFAULT NULL,
  `data` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`),
  KEY `list` (`list`),
  CONSTRAINT `confirmations_ibfk_1` FOREIGN KEY (`list`) REFERENCES `lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `custom_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list` int(11) unsigned NOT NULL,
  `name` varchar(255) DEFAULT '',
  `key` varchar(100) CHARACTER SET ascii NOT NULL,
  `default_value` varchar(255) DEFAULT NULL,
  `type` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `group` int(11) unsigned DEFAULT NULL,
  `group_template` text,
  `column` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `visible` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `list` (`list`,`column`),
  KEY `list_2` (`list`),
  CONSTRAINT `custom_fields_ibfk_1` FOREIGN KEY (`list`) REFERENCES `lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `custom_forms` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list` int(11) unsigned NOT NULL,
  `name` varchar(255) DEFAULT '',
  `description` text,
  `fields_shown_on_subscribe` varchar(255) DEFAULT '',
  `fields_shown_on_manage` varchar(255) DEFAULT '',
  `layout` longtext,
  `form_input_style` longtext,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `list` (`list`),
  CONSTRAINT `custom_forms_ibfk_1` FOREIGN KEY (`list`) REFERENCES `lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `custom_forms_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form` int(11) unsigned NOT NULL,
  `data_key` varchar(255) DEFAULT '',
  `data_value` longtext,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `form` (`form`),
  CONSTRAINT `custom_forms_data_ibfk_1` FOREIGN KEY (`form`) REFERENCES `custom_forms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `import_failed` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `import` int(11) unsigned NOT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `reason` varchar(255) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `import` (`import`),
  CONSTRAINT `import_failed_ibfk_1` FOREIGN KEY (`import`) REFERENCES `importer` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `importer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list` int(11) unsigned NOT NULL,
  `type` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `path` varchar(255) NOT NULL DEFAULT '',
  `size` int(11) unsigned NOT NULL DEFAULT '0',
  `delimiter` varchar(1) CHARACTER SET ascii NOT NULL DEFAULT ',',
  `emailcheck` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `error` varchar(255) DEFAULT NULL,
  `processed` int(11) unsigned NOT NULL DEFAULT '0',
  `new` int(11) unsigned NOT NULL DEFAULT '0',
  `failed` int(11) unsigned NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mapping` text NOT NULL,
  `finished` timestamp NULL DEFAULT NULL,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `list` (`list`),
  CONSTRAINT `importer_ibfk_1` FOREIGN KEY (`list`) REFERENCES `lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `links` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `campaign` int(11) unsigned NOT NULL,
  `url` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `clicks` int(11) unsigned NOT NULL DEFAULT '0',
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`),
  UNIQUE KEY `campaign_2` (`campaign`,`url`),
  KEY `campaign` (`campaign`),
  CONSTRAINT `links_ibfk_1` FOREIGN KEY (`campaign`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `lists` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) CHARACTER SET ascii NOT NULL,
  `default_form` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `subscribers` int(11) unsigned DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`),
  KEY `name` (`name`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `queued` (
  `campaign` int(11) unsigned NOT NULL,
  `list` int(11) unsigned NOT NULL,
  `subscriber` int(11) unsigned NOT NULL,
  `source` varchar(255) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`campaign`,`list`,`subscriber`),
  KEY `created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `rss` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent` int(11) unsigned NOT NULL,
  `guid` varchar(255) NOT NULL DEFAULT '',
  `pubdate` timestamp NULL DEFAULT NULL,
  `campaign` int(11) unsigned DEFAULT NULL,
  `found` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parent_2` (`parent`,`guid`),
  KEY `parent` (`parent`),
  CONSTRAINT `rss_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `segment_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `segment` int(11) unsigned NOT NULL,
  `column` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `value` varchar(255) NOT NULL DEFAULT '',
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `segment` (`segment`),
  CONSTRAINT `segment_rules_ibfk_1` FOREIGN KEY (`segment`) REFERENCES `segments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `segments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `type` tinyint(4) unsigned NOT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `list` (`list`),
  KEY `name` (`name`(191)),
  CONSTRAINT `segments_ibfk_1` FOREIGN KEY (`list`) REFERENCES `lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `settings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `value` text NOT NULL,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (1,'smtp_hostname','smtp-pulse.com', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (2,'smtp_port','465', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (3,'smtp_encryption','TLS', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (4,'smtp_user','', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (5,'smtp_pass','', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (6,'service_url','http://localhost:3000/', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (7,'admin_email','admin@example.com', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (8,'smtp_max_connections','5', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (9,'smtp_max_messages','100', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (10,'smtp_log','', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (11,'default_sender','My Awesome Company', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (12,'default_postaddress','1234 Main Street', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (13,'default_from','My Awesome Company', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (14,'default_address','admin@example.com', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (15,'default_subject','Test message', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (16,'default_homepage','http://localhost:3000/', @demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (17,'db_schema_version','29', @demo_account);
CREATE TABLE `subscription` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) CHARACTER SET ascii NOT NULL,
  `email` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `opt_in_ip` varchar(100) DEFAULT NULL,
  `opt_in_country` varchar(2) DEFAULT NULL,
  `tz` varchar(100) CHARACTER SET ascii DEFAULT NULL,
  `imported` int(11) unsigned DEFAULT NULL,
  `status` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `is_test` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `status_change` timestamp NULL DEFAULT NULL,
  `latest_open` timestamp NULL DEFAULT NULL,
  `latest_click` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `cid` (`cid`),
  KEY `status` (`status`),
  KEY `first_name` (`first_name`(191)),
  KEY `last_name` (`last_name`(191)),
  KEY `subscriber_tz` (`tz`),
  KEY `is_test` (`is_test`),
  KEY `latest_open` (`latest_open`),
  KEY `latest_click` (`latest_click`),
  KEY `created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `editor_name` varchar(50) DEFAULT '',
  `editor_data` longtext,
  `html` longtext,
  `text` longtext,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `trigger` (
  `list` int(11) unsigned NOT NULL,
  `subscription` int(11) unsigned NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`list`,`subscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `triggers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `list` int(11) unsigned NOT NULL,
  `source_campaign` int(11) unsigned DEFAULT NULL,
  `rule` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT 'column',
  `column` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `seconds` int(11) NOT NULL DEFAULT '0',
  `dest_campaign` int(11) unsigned DEFAULT NULL,
  `count` int(11) unsigned NOT NULL DEFAULT '0',
  `last_check` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`(191)),
  KEY `source_campaign` (`source_campaign`),
  KEY `dest_campaign` (`dest_campaign`),
  KEY `list` (`list`),
  KEY `column` (`column`),
  KEY `active` (`enabled`),
  KEY `last_check` (`last_check`),
  CONSTRAINT `triggers_ibfk_1` FOREIGN KEY (`list`) REFERENCES `lists` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `tzoffset` (
  `tz` varchar(100) NOT NULL DEFAULT '',
  `offset` int(11) NOT NULL DEFAULT '0',
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`tz`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `access_token` varchar(40) DEFAULT NULL,
  `reset_token` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `reset_expire` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `username` (`username`(191)),
  KEY `reset` (`reset_token`),
  KEY `check_reset` (`username`(191),`reset_token`,`reset_expire`),
  KEY `token_index` (`access_token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
INSERT INTO `users` (`id`, `username`, `password`, `email`, `access_token`, `reset_token`, `reset_expire`, `created`, `saas_account_id`) VALUES (1,'admin','$2a$10$mzKU71G62evnGB2PvQA4k..Wf9jASk.c7a8zRMHh6qQVjYJ2r/g/K','admin@example.com',NULL,NULL,NULL,NOW(),@demo_account);


ALTER TABLE `attachments` ADD KEY `attachments_sass_account_id` (`saas_account_id`);
ALTER TABLE `campaign` ADD KEY `campaign_sass_account_id` (`saas_account_id`);
ALTER TABLE `campaign_tracker` ADD KEY `campaign_tracker_sass_account_id` (`saas_account_id`);
ALTER TABLE `campaigns` ADD KEY `campaigns_sass_account_id` (`saas_account_id`);
ALTER TABLE `confirmations` ADD KEY `confirmations_sass_account_id` (`saas_account_id`);
ALTER TABLE `custom_fields` ADD KEY `custom_fields_sass_account_id` (`saas_account_id`);
ALTER TABLE `custom_forms` ADD KEY `custom_forms_sass_account_id` (`saas_account_id`);
ALTER TABLE `custom_forms_data` ADD KEY `custom_forms_data_sass_account_id` (`saas_account_id`);
ALTER TABLE `import_failed` ADD KEY `import_failed_sass_account_id` (`saas_account_id`);
ALTER TABLE `importer` ADD KEY `importer_sass_account_id` (`saas_account_id`);
ALTER TABLE `links` ADD KEY `links_sass_account_id` (`saas_account_id`);
ALTER TABLE `lists` ADD KEY `lists_sass_account_id` (`saas_account_id`);
ALTER TABLE `queued` ADD KEY `queued_sass_account_id` (`saas_account_id`);
ALTER TABLE `rss` ADD KEY `rss_sass_account_id` (`saas_account_id`);
ALTER TABLE `segment_rules` ADD KEY `segment_rules_sass_account_id` (`saas_account_id`);
ALTER TABLE `segments` ADD KEY `segments_sass_account_id` (`saas_account_id`);
ALTER TABLE `settings` ADD KEY `settings_sass_account_id` (`saas_account_id`);
ALTER TABLE `subscription` ADD KEY `subscription_sass_account_id` (`saas_account_id`);
ALTER TABLE `templates` ADD KEY `templates_sass_account_id` (`saas_account_id`);
ALTER TABLE `trigger` ADD KEY `trigger_sass_account_id` (`saas_account_id`);
ALTER TABLE `tzoffset` ADD KEY `tzoffset_sass_account_id` (`saas_account_id`);
ALTER TABLE `users` ADD KEY `users_sass_account_id` (`saas_account_id`);

ALTER TABLE `attachments` ADD CONSTRAINT `attachments_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `campaign` ADD CONSTRAINT `campaign_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `campaign_tracker` ADD CONSTRAINT `campaign_tracker_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `campaigns` ADD CONSTRAINT `campaigns_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `confirmations` ADD CONSTRAINT `confirmations_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `custom_fields` ADD CONSTRAINT `custom_fields_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `custom_forms` ADD CONSTRAINT `custom_forms_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `custom_forms_data` ADD CONSTRAINT `custom_forms_data_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `import_failed` ADD CONSTRAINT `import_failed_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `importer` ADD CONSTRAINT `importer_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `links` ADD CONSTRAINT `links_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `lists` ADD CONSTRAINT `lists_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `queued` ADD CONSTRAINT `queued_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `rss` ADD CONSTRAINT `rss_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `segment_rules` ADD CONSTRAINT `segment_rules_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `segments` ADD CONSTRAINT `segments_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `settings` ADD CONSTRAINT `settings_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `subscription` ADD CONSTRAINT `subscription_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `templates` ADD CONSTRAINT `templates_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `trigger` ADD CONSTRAINT `trigger_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `tzoffset` ADD CONSTRAINT `tzoffset_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `users` ADD CONSTRAINT `users_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;

SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
