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
  `saas_plan_id` int(11) unsigned NOT NULL,
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
  `zipcode` varchar(20),
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_email` (`email`),
  KEY `saas_plan`(`saas_plan_id`),
  CONSTRAINT `account_plan_ibfk_1` FOREIGN KEY (`saas_plan_id`) REFERENCES `saas_plan` (`id`) ON DELETE RESTRICT
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
CREATE TABLE `blacklist` (
  `email` varchar(191) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
CREATE TABLE `campaign__1` (
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
CREATE TABLE `campaign_tracker__1` (
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
  `scheduled` timestamp NULL DEFAULT NULL,
  `status_change` timestamp NULL DEFAULT NULL,
  `delivered` int(11) unsigned NOT NULL DEFAULT '0',
  `blacklisted` int(11) unsigned NOT NULL DEFAULT '0',
  `opened` int(11) unsigned NOT NULL DEFAULT '0',
  `clicks` int(11) unsigned NOT NULL DEFAULT '0',
  `unsubscribed` int(11) unsigned NOT NULL DEFAULT '0',
  `bounced` int(1) unsigned NOT NULL DEFAULT '0',
  `complained` int(1) unsigned NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `open_tracking_disabled` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `click_tracking_disabled` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`),
  KEY `name` (`name`(191)),
  KEY `status` (`status`),
  KEY `schedule_index` (`scheduled`),
  KEY `type_index` (`type`),
  KEY `parent_index` (`parent`),
  KEY `check_index` (`last_check`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
INSERT INTO `campaigns` (`id`, `cid`, `type`, `parent`, `name`, `description`, `list`, `segment`, `template`, `source_url`, `editor_name`, `editor_data`, `last_check`, `check_status`, `from`, `address`, `reply_to`, `subject`, `html`, `html_prepared`, `text`, `status`, `scheduled`, `status_change`, `delivered`, `blacklisted`, `opened`, `clicks`, `unsubscribed`, `bounced`, `complained`, `created`, `open_tracking_disabled`, `click_tracking_disabled`, `saas_account_id`) VALUES (1,'BkwHWgCWb',1,NULL,'Merge Tags','',1,0,0,'','codeeditor',NULL,NULL,NULL,'My Awesome Company','admin@example.com','','Test message','<style>dt { margin-top: 10px; }</style>\r\n<dl>\r\n    <dt>LINK_UNSUBSCRIBE</dt>\r\n    <dd id=\"LINK_UNSUBSCRIBE\">[LINK_UNSUBSCRIBE]</dd>\r\n    <dt>LINK_PREFERENCES</dt>\r\n    <dd id=\"LINK_PREFERENCES\">[LINK_PREFERENCES]</dd>\r\n    <dt>LINK_BROWSER</dt>\r\n    <dd id=\"LINK_BROWSER\">[LINK_BROWSER]</dd>\r\n    <dt>EMAIL</dt>\r\n    <dd id=\"EMAIL\">[EMAIL]</dd>\r\n    <dt>FIRST_NAME</dt>\r\n    <dd id=\"FIRST_NAME\">[FIRST_NAME]</dd>\r\n    <dt>LAST_NAME</dt>\r\n    <dd id=\"LAST_NAME\">[LAST_NAME]</dd>\r\n    <dt>FULL_NAME</dt>\r\n    <dd id=\"FULL_NAME\">[FULL_NAME]</dd>\r\n    <dt>SUBSCRIPTION_ID</dt>\r\n    <dd id=\"SUBSCRIPTION_ID\">[SUBSCRIPTION_ID]</dd>\r\n    <dt>LIST_ID</dt>\r\n    <dd id=\"LIST_ID\">[LIST_ID]</dd>\r\n    <dt>CAMPAIGN_ID</dt>\r\n    <dd id=\"CAMPAIGN_ID\">[CAMPAIGN_ID]</dd>\r\n    <dt>MERGE_TEXT</dt>\r\n    <dd id=\"MERGE_TEXT\">[MERGE_TEXT]</dd>\r\n    <dt>MERGE_NUMBER</dt>\r\n    <dd id=\"MERGE_NUMBER\">[MERGE_NUMBER]</dd>\r\n    <dt>MERGE_WEBSITE</dt>\r\n    <dd id=\"MERGE_WEBSITE\">[MERGE_WEBSITE]</dd>\r\n    <dt>MERGE_GPG_PUBLIC_KEY</dt>\r\n    <dd id=\"MERGE_GPG_PUBLIC_KEY\">[MERGE_GPG_PUBLIC_KEY/GPG Fallback Text]</dd>\r\n    <dt>MERGE_MULTILINE_TEXT</dt>\r\n    <dd id=\"MERGE_MULTILINE_TEXT\">[MERGE_MULTILINE_TEXT]</dd>\r\n    <dt>MERGE_JSON</dt>\r\n    <dd id=\"MERGE_JSON\">[MERGE_JSON]</dd>\r\n    <dt>MERGE_DATE_MMDDYYYY</dt>\r\n    <dd id=\"MERGE_DATE_MMDDYY\">[MERGE_DATE_MMDDYYYY]</dd>\r\n    <dt>MERGE_DATE_DDMMYYYY</dt>\r\n    <dd id=\"MERGE_DATE_DDMMYY\">[MERGE_DATE_DDMMYYYY]</dd>\r\n    <dt>MERGE_BIRTHDAY_MMDD</dt>\r\n    <dd id=\"MERGE_BIRTHDAY_MMDD\">[MERGE_BIRTHDAY_MMDD]</dd>\r\n    <dt>MERGE_BIRTHDAY_DDMM</dt>\r\n    <dd id=\"MERGE_BIRTHDAY_DDMM\">[MERGE_BIRTHDAY_DDMM]</dd>\r\n    <dt>MERGE_DROP_DOWNS</dt>\r\n    <dd id=\"MERGE_DROP_DOWNS\">[MERGE_DROP_DOWNS]</dd>\r\n    <dt>MERGE_CHECKBOXES</dt>\r\n    <dd id=\"MERGE_CHECKBOXES\">[MERGE_CHECKBOXES]</dd>\r\n</dl>','<!doctype html><html><head>\n<meta charset=\"utf-8\"></head><body><dl>\n    <dt style=\"margin-top: 10px;\">LINK_UNSUBSCRIBE</dt>\n    <dd id=\"LINK_UNSUBSCRIBE\">[LINK_UNSUBSCRIBE]</dd>\n    <dt style=\"margin-top: 10px;\">LINK_PREFERENCES</dt>\n    <dd id=\"LINK_PREFERENCES\">[LINK_PREFERENCES]</dd>\n    <dt style=\"margin-top: 10px;\">LINK_BROWSER</dt>\n    <dd id=\"LINK_BROWSER\">[LINK_BROWSER]</dd>\n    <dt style=\"margin-top: 10px;\">EMAIL</dt>\n    <dd id=\"EMAIL\">[EMAIL]</dd>\n    <dt style=\"margin-top: 10px;\">FIRST_NAME</dt>\n    <dd id=\"FIRST_NAME\">[FIRST_NAME]</dd>\n    <dt style=\"margin-top: 10px;\">LAST_NAME</dt>\n    <dd id=\"LAST_NAME\">[LAST_NAME]</dd>\n    <dt style=\"margin-top: 10px;\">FULL_NAME</dt>\n    <dd id=\"FULL_NAME\">[FULL_NAME]</dd>\n    <dt style=\"margin-top: 10px;\">SUBSCRIPTION_ID</dt>\n    <dd id=\"SUBSCRIPTION_ID\">[SUBSCRIPTION_ID]</dd>\n    <dt style=\"margin-top: 10px;\">LIST_ID</dt>\n    <dd id=\"LIST_ID\">[LIST_ID]</dd>\n    <dt style=\"margin-top: 10px;\">CAMPAIGN_ID</dt>\n    <dd id=\"CAMPAIGN_ID\">[CAMPAIGN_ID]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_TEXT</dt>\n    <dd id=\"MERGE_TEXT\">[MERGE_TEXT]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_NUMBER</dt>\n    <dd id=\"MERGE_NUMBER\">[MERGE_NUMBER]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_WEBSITE</dt>\n    <dd id=\"MERGE_WEBSITE\">[MERGE_WEBSITE]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_GPG_PUBLIC_KEY</dt>\n    <dd id=\"MERGE_GPG_PUBLIC_KEY\">[MERGE_GPG_PUBLIC_KEY/GPG Fallback Text]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_MULTILINE_TEXT</dt>\n    <dd id=\"MERGE_MULTILINE_TEXT\">[MERGE_MULTILINE_TEXT]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_JSON</dt>\n    <dd id=\"MERGE_JSON\">[MERGE_JSON]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_DATE_MMDDYYYY</dt>\n    <dd id=\"MERGE_DATE_MMDDYY\">[MERGE_DATE_MMDDYYYY]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_DATE_DDMMYYYY</dt>\n    <dd id=\"MERGE_DATE_DDMMYY\">[MERGE_DATE_DDMMYYYY]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_BIRTHDAY_MMDD</dt>\n    <dd id=\"MERGE_BIRTHDAY_MMDD\">[MERGE_BIRTHDAY_MMDD]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_BIRTHDAY_DDMM</dt>\n    <dd id=\"MERGE_BIRTHDAY_DDMM\">[MERGE_BIRTHDAY_DDMM]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_DROP_DOWNS</dt>\n    <dd id=\"MERGE_DROP_DOWNS\">[MERGE_DROP_DOWNS]</dd>\n    <dt style=\"margin-top: 10px;\">MERGE_CHECKBOXES</dt>\n    <dd id=\"MERGE_CHECKBOXES\">[MERGE_CHECKBOXES]</dd>\n</dl></body></html>','',1,NOW(),NULL,0,0,0,0,0,0,0,NOW(),0,0,@demo_account);
CREATE TABLE `confirmations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) CHARACTER SET ascii NOT NULL,
  `list` int(11) unsigned NOT NULL,
  `action` varchar(100) NOT NULL,
  `ip` varchar(100) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (1,1,'Text','MERGE_TEXT',NULL,'text',NULL,NULL,'custom_text_field_byiiqjrw',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (2,1,'Number','MERGE_NUMBER',NULL,'number',NULL,NULL,'custom_number_field_r1dd91awb',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (3,1,'Website','MERGE_WEBSITE',NULL,'website',NULL,NULL,'custom_website_field_rkq991cw',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (4,1,'GPG Public Key','MERGE_GPG_PUBLIC_KEY',NULL,'gpg',NULL,NULL,'custom_gpg_public_key_ryvj51cz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (5,1,'Multiline Text','MERGE_MULTILINE_TEXT',NULL,'longtext',NULL,NULL,'custom_multiline_text_bjbfojawb',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (6,1,'JSON','MERGE_JSON',NULL,'json',NULL,NULL,'custom_json_skqjkcb',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (7,1,'Date (MM/DD/YYYY)','MERGE_DATE_MMDDYYYY',NULL,'date-us',NULL,NULL,'custom_date_mmddyy_rjkeojrzz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (8,1,'Date (DD/MM/YYYY)','MERGE_DATE_DDMMYYYY',NULL,'date-eur',NULL,NULL,'custom_date_ddmmyy_ryedsk0wz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (9,1,'Birthday (MM/DD)','MERGE_BIRTHDAY_MMDD',NULL,'birthday-us',NULL,NULL,'custom_birthday_mmdd_h18coj0zz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (10,1,'Birthday (DD/MM)','MERGE_BIRTHDAY_DDMM',NULL,'birthday-eur',NULL,NULL,'custom_birthday_ddmm_r1g3s1czz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (11,1,'Drop Downs','MERGE_DROP_DOWNS',NULL,'dropdown',NULL,NULL,NULL,1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (12,1,'Drop Down Opt 1','MERGE_DROP_DOWN_OPT_1',NULL,'option',11,NULL,'custom_dd_option_1_b1wwn1rzw',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (13,1,'Drop Down Opt 2','MERGE_DROP_DOWN_OPT_2',NULL,'option',11,NULL,'custom_drop_down_opt_2_hkzd2jcww',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (14,1,'Drop Down Opt 3','MERGE_DROP_DOWN_OPT_3',NULL,'option',11,NULL,'custom_drop_down_opt_3_rjghnyrz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (15,1,'Checkboxes','MERGE_CHECKBOXES',NULL,'checkbox',NULL,NULL,NULL,1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (16,1,'Checkbox Option 1','MERGE_CHECKBOX_OPTION_1',NULL,'option',15,NULL,'custom_checkbox_option_1_by_l0jcwz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (17,1,'Checkbox Option 2','MERGE_CHECKBOX_OPTION_2',NULL,'option',15,NULL,'custom_checkbox_option_2_sjdprj0zz',1,NOW(), @demo_account);
INSERT INTO `custom_fields` (`id`, `list`, `name`, `key`, `default_value`, `type`, `group`, `group_template`, `column`, `visible`, `created`, `saas_account_id`) VALUES (18,1,'Checkbox Option 3','MERGE_CHECKBOX_OPTION_3',NULL,'option',15,NULL,'custom_checkbox_option_3_bk2drjabz',1,NOW(), @demo_account);
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
  `public_subscribe` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `unsubscription_mode` int(11) unsigned NOT NULL DEFAULT '0',
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`),
  KEY `name` (`name`(191))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
INSERT INTO `lists` (`id`, `cid`, `default_form`, `name`, `description`, `subscribers`, `created`, `public_subscribe`, `unsubscription_mode`, `saas_account_id`) VALUES (1,'Hkj1vCoJb',0,'#1 (one-step, no form)','',1,NOW(),1,0,@demo_account);
INSERT INTO `lists` (`id`, `cid`, `default_form`, `name`, `description`, `subscribers`, `created`, `public_subscribe`, `unsubscription_mode`, `saas_account_id`) VALUES (2,'SktV4HDZ-',NULL,'#2 (one-step, with form)','',0,NOW(),1,1,@demo_account);
INSERT INTO `lists` (`id`, `cid`, `default_form`, `name`, `description`, `subscribers`, `created`, `public_subscribe`, `unsubscription_mode`, `saas_account_id`) VALUES (3,'BkdvNBw-W',NULL,'#3 (two-step, no form)','',0,NOW(),1,2,@demo_account);
INSERT INTO `lists` (`id`, `cid`, `default_form`, `name`, `description`, `subscribers`, `created`, `public_subscribe`, `unsubscription_mode`, `saas_account_id`) VALUES (4,'rJMKVrDZ-',NULL,'#4 (two-step, with form)','',0,NOW(),1,3,@demo_account);
INSERT INTO `lists` (`id`, `cid`, `default_form`, `name`, `description`, `subscribers`, `created`, `public_subscribe`, `unsubscription_mode`, `saas_account_id`) VALUES (5,'SJgoNSw-W',NULL,'#5 (manual unsubscribe)','',0,NOW(),1,4,@demo_account);
INSERT INTO `lists` (`id`, `cid`, `default_form`, `name`, `description`, `subscribers`, `created`, `public_subscribe`, `unsubscription_mode`, `saas_account_id`) VALUES (6,'HyveEPvWW',NULL,'#6 (non-public)','',0,NOW(),0,0,@demo_account);
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
CREATE TABLE `report_templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `mime_type` varchar(255) NOT NULL DEFAULT 'text/html',
  `description` text,
  `user_fields` longtext,
  `js` longtext,
  `hbs` longtext,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `reports` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `description` text,
  `report_template` int(11) unsigned NOT NULL,
  `params` longtext,
  `state` int(11) unsigned NOT NULL DEFAULT '0',
  `last_run` datetime DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saas_account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `report_template` (`report_template`),
  CONSTRAINT `report_template_ibfk_1` FOREIGN KEY (`report_template`) REFERENCES `report_templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4;
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (1,'smtp_hostname','localhost',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (2,'smtp_port','5587',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (3,'smtp_encryption','NONE',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (4,'smtp_user','testuser',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (5,'smtp_pass','testpass',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (6,'service_url','http://localhost:3000/',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (7,'admin_email','keep.admin@mailtrain.org',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (8,'smtp_max_connections','5',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (9,'smtp_max_messages','100',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (10,'smtp_log','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (11,'default_sender','My Awesome Company',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (12,'default_postaddress','1234 Main Street',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (13,'default_from','My Awesome Company',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (14,'default_address','keep.admin@mailtrain.org',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (15,'default_subject','Test message',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (16,'default_homepage','https://mailtrain.org',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (17,'db_schema_version','29',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (46,'ua_code','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (47,'shoutout','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (54,'mail_transport','smtp',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (60,'ses_key','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (61,'ses_secret','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (62,'ses_region','us-east-1',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (65,'smtp_throttling','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (66,'pgp_passphrase','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (67,'pgp_private_key','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (68,'dkim_api_key','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (69,'dkim_domain','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (70,'dkim_selector','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (71,'dkim_private_key','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (73,'smtp_self_signed','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (74,'smtp_disable_auth','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (75,'verp_use','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (76,'disable_wysiwyg','',@demo_account);
INSERT INTO `settings` (`id`, `key`, `value`, `saas_account_id`) VALUES (77,'disable_confirmations','',@demo_account);
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
CREATE TABLE `subscription__1` (
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
  `custom_text_field_byiiqjrw` varchar(255) DEFAULT NULL,
  `custom_number_field_r1dd91awb` int(11) DEFAULT NULL,
  `custom_website_field_rkq991cw` varchar(255) DEFAULT NULL,
  `custom_gpg_public_key_ryvj51cz` text,
  `custom_multiline_text_bjbfojawb` text,
  `custom_json_skqjkcb` text,
  `custom_date_mmddyy_rjkeojrzz` timestamp NULL DEFAULT NULL,
  `custom_date_ddmmyy_ryedsk0wz` timestamp NULL DEFAULT NULL,
  `custom_birthday_mmdd_h18coj0zz` timestamp NULL DEFAULT NULL,
  `custom_birthday_ddmm_r1g3s1czz` timestamp NULL DEFAULT NULL,
  `custom_dd_option_1_b1wwn1rzw` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `custom_drop_down_opt_2_hkzd2jcww` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `custom_drop_down_opt_3_rjghnyrz` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `custom_checkbox_option_1_by_l0jcwz` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `custom_checkbox_option_2_sjdprj0zz` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `custom_checkbox_option_3_bk2drjabz` tinyint(4) unsigned NOT NULL DEFAULT '0',
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
INSERT INTO `subscription__1` (`id`, `cid`, `email`, `opt_in_ip`, `opt_in_country`, `tz`, `imported`, `status`, `is_test`, `status_change`, `latest_open`, `latest_click`, `created`, `first_name`, `last_name`, `custom_text_field_byiiqjrw`, `custom_number_field_r1dd91awb`, `custom_website_field_rkq991cw`, `custom_gpg_public_key_ryvj51cz`, `custom_multiline_text_bjbfojawb`, `custom_json_skqjkcb`, `custom_date_mmddyy_rjkeojrzz`, `custom_date_ddmmyy_ryedsk0wz`, `custom_birthday_mmdd_h18coj0zz`, `custom_birthday_ddmm_r1g3s1czz`, `custom_dd_option_1_b1wwn1rzw`, `custom_drop_down_opt_2_hkzd2jcww`, `custom_drop_down_opt_3_rjghnyrz`, `custom_checkbox_option_1_by_l0jcwz`, `custom_checkbox_option_2_sjdprj0zz`, `custom_checkbox_option_3_bk2drjabz`, `saas_account_id`) VALUES (1,'SJDW9J0Wb','keep.john.doe@mailtrain.org',NULL,NULL,'europe/zurich',NULL,1,1,NOW(),NOW(),NULL,NOW(),'John','Doe','Lorem Ipsum',42,'https://mailtrain.org','','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.','',NOW(),NOW(),NOW(),NOW(),1,0,0,0,1,0,@demo_account);
CREATE TABLE `subscription__2` (
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
CREATE TABLE `subscription__3` (
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
CREATE TABLE `subscription__4` (
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
CREATE TABLE `subscription__5` (
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
CREATE TABLE `subscription__6` (
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
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/abidjan',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/accra',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/addis_ababa',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/algiers',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/asmara',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/asmera',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/bamako',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/bangui',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/banjul',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/bissau',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/blantyre',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/brazzaville',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/bujumbura',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/cairo',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/casablanca',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/ceuta',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/conakry',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/dakar',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/dar_es_salaam',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/djibouti',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/douala',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/el_aaiun',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/freetown',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/gaborone',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/harare',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/johannesburg',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/juba',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/kampala',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/khartoum',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/kigali',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/kinshasa',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/lagos',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/libreville',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/lome',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/luanda',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/lubumbashi',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/lusaka',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/malabo',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/maputo',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/maseru',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/mbabane',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/mogadishu',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/monrovia',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/nairobi',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/ndjamena',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/niamey',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/nouakchott',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/ouagadougou',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/porto-novo',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/sao_tome',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/timbuktu',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/tripoli',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/tunis',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('africa/windhoek',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/adak',-540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/anchorage',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/anguilla',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/antigua',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/araguaina',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/buenos_aires',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/catamarca',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/comodrivadavia',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/cordoba',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/jujuy',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/la_rioja',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/mendoza',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/rio_gallegos',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/salta',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/san_juan',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/san_luis',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/tucuman',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/argentina/ushuaia',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/aruba',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/asuncion',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/atikokan',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/atka',-540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/bahia',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/bahia_banderas',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/barbados',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/belem',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/belize',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/blanc-sablon',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/boa_vista',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/bogota',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/boise',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/buenos_aires',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/cambridge_bay',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/campo_grande',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/cancun',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/caracas',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/catamarca',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/cayenne',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/cayman',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/chicago',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/chihuahua',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/coral_harbour',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/cordoba',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/costa_rica',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/creston',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/cuiaba',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/curacao',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/danmarkshavn',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/dawson',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/dawson_creek',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/denver',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/detroit',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/dominica',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/edmonton',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/eirunepe',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/el_salvador',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/ensenada',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/fortaleza',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/fort_nelson',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/fort_wayne',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/glace_bay',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/godthab',-120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/goose_bay',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/grand_turk',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/grenada',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/guadeloupe',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/guatemala',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/guayaquil',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/guyana',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/halifax',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/havana',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/hermosillo',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/indianapolis',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/knox',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/marengo',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/petersburg',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/tell_city',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/vevay',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/vincennes',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indiana/winamac',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/indianapolis',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/inuvik',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/iqaluit',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/jamaica',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/jujuy',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/juneau',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/kentucky/louisville',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/kentucky/monticello',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/knox_in',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/kralendijk',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/la_paz',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/lima',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/los_angeles',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/louisville',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/lower_princes',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/maceio',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/managua',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/manaus',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/marigot',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/martinique',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/matamoros',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/mazatlan',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/mendoza',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/menominee',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/merida',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/metlakatla',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/mexico_city',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/miquelon',-120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/moncton',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/monterrey',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/montevideo',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/montreal',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/montserrat',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/nassau',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/new_york',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/nipigon',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/nome',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/noronha',-120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/north_dakota/beulah',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/north_dakota/center',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/north_dakota/new_salem',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/ojinaga',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/panama',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/pangnirtung',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/paramaribo',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/phoenix',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/port-au-prince',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/porto_acre',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/porto_velho',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/port_of_spain',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/puerto_rico',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/punta_arenas',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/rainy_river',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/rankin_inlet',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/recife',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/regina',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/resolute',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/rio_branco',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/rosario',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/santarem',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/santa_isabel',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/santiago',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/santo_domingo',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/sao_paulo',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/scoresbysund',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/shiprock',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/sitka',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/st_barthelemy',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/st_johns',-150,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/st_kitts',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/st_lucia',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/st_thomas',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/st_vincent',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/swift_current',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/tegucigalpa',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/thule',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/thunder_bay',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/tijuana',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/toronto',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/tortola',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/vancouver',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/virgin',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/whitehorse',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/winnipeg',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/yakutat',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('america/yellowknife',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/casey',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/davis',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/dumontdurville',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/macquarie',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/mawson',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/mcmurdo',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/palmer',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/rothera',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/south_pole',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/syowa',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/troll',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('antarctica/vostok',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('arctic/longyearbyen',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/aden',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/almaty',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/amman',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/anadyr',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/aqtau',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/aqtobe',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/ashgabat',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/ashkhabad',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/atyrau',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/baghdad',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/bahrain',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/baku',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/bangkok',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/barnaul',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/beirut',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/bishkek',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/brunei',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/calcutta',330,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/chita',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/choibalsan',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/chongqing',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/chungking',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/colombo',330,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/dacca',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/damascus',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/dhaka',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/dili',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/dubai',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/dushanbe',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/famagusta',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/gaza',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/harbin',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/hebron',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/hong_kong',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/hovd',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/ho_chi_minh',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/irkutsk',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/istanbul',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/jakarta',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/jayapura',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/jerusalem',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kabul',270,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kamchatka',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/karachi',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kashgar',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kathmandu',345,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/katmandu',345,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/khandyga',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kolkata',330,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/krasnoyarsk',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kuala_lumpur',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kuching',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/kuwait',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/macao',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/macau',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/magadan',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/makassar',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/manila',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/muscat',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/nicosia',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/novokuznetsk',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/novosibirsk',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/omsk',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/oral',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/phnom_penh',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/pontianak',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/pyongyang',510,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/qatar',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/qyzylorda',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/rangoon',390,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/riyadh',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/saigon',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/sakhalin',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/samarkand',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/seoul',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/shanghai',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/singapore',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/srednekolymsk',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/taipei',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/tashkent',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/tbilisi',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/tehran',270,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/tel_aviv',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/thimbu',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/thimphu',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/tokyo',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/tomsk',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/ujung_pandang',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/ulaanbaatar',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/ulan_bator',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/urumqi',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/ust-nera',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/vientiane',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/vladivostok',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/yakutsk',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/yangon',390,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/yekaterinburg',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('asia/yerevan',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/azores',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/bermuda',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/canary',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/cape_verde',-60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/faeroe',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/faroe',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/jan_mayen',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/madeira',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/reykjavik',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/south_georgia',-120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/stanley',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('atlantic/st_helena',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/act',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/adelaide',570,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/brisbane',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/broken_hill',570,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/canberra',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/currie',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/darwin',570,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/eucla',525,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/hobart',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/lhi',630,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/lindeman',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/lord_howe',630,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/melbourne',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/north',570,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/nsw',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/perth',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/queensland',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/south',570,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/sydney',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/tasmania',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/victoria',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/west',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('australia/yancowinna',570,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('brazil/acre',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('brazil/denoronha',-120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('brazil/east',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('brazil/west',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/atlantic',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/central',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/east-saskatchewan',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/eastern',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/mountain',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/newfoundland',-150,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/pacific',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/saskatchewan',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('canada/yukon',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('cet',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('chile/continental',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('chile/easterisland',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('cst6cdt',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('cuba',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('eet',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('egypt',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('eire',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('est',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('est5edt',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+0',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+1',-60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+10',-600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+11',-660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+12',-720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+2',-120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+3',-180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+4',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+5',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+6',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+7',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+8',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt+9',-540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-0',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-1',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-10',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-11',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-12',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-13',780,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-14',840,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-2',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-3',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-4',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-5',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-6',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-7',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-8',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt-9',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/gmt0',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/greenwich',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/uct',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/universal',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/utc',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('etc/zulu',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/amsterdam',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/andorra',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/astrakhan',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/athens',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/belfast',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/belgrade',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/berlin',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/bratislava',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/brussels',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/bucharest',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/budapest',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/busingen',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/chisinau',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/copenhagen',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/dublin',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/gibraltar',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/guernsey',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/helsinki',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/isle_of_man',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/istanbul',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/jersey',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/kaliningrad',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/kiev',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/kirov',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/lisbon',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/ljubljana',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/london',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/luxembourg',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/madrid',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/malta',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/mariehamn',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/minsk',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/monaco',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/moscow',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/nicosia',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/oslo',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/paris',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/podgorica',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/prague',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/riga',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/rome',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/samara',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/san_marino',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/sarajevo',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/saratov',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/simferopol',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/skopje',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/sofia',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/stockholm',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/tallinn',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/tirane',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/tiraspol',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/ulyanovsk',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/uzhgorod',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/vaduz',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/vatican',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/vienna',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/vilnius',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/volgograd',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/warsaw',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/zagreb',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/zaporozhye',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('europe/zurich',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('gb',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('gb-eire',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('gmt',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('gmt+0',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('gmt-0',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('gmt0',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('greenwich',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('hongkong',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('hst',-600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('iceland',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/antananarivo',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/chagos',360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/christmas',420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/cocos',390,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/comoro',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/kerguelen',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/mahe',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/maldives',300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/mauritius',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/mayotte',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('indian/reunion',240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('iran',270,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('israel',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('jamaica',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('japan',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('kwajalein',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('libya',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('met',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('mexico/bajanorte',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('mexico/bajasur',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('mexico/general',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('mst',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('mst7mdt',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('navajo',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('nz',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('nz-chat',765,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/apia',780,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/auckland',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/bougainville',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/chatham',765,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/chuuk',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/easter',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/efate',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/enderbury',780,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/fakaofo',780,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/fiji',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/funafuti',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/galapagos',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/gambier',-540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/guadalcanal',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/guam',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/honolulu',-600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/johnston',-600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/kiritimati',840,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/kosrae',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/kwajalein',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/majuro',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/marquesas',-570,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/midway',-660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/nauru',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/niue',-660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/norfolk',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/noumea',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/pago_pago',-660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/palau',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/pitcairn',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/pohnpei',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/ponape',660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/port_moresby',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/rarotonga',-600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/saipan',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/samoa',-660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/tahiti',-600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/tarawa',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/tongatapu',780,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/truk',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/wake',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/wallis',720,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pacific/yap',600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('poland',120,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('portugal',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('prc',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('pst8pdt',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('roc',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('rok',540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('singapore',480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('turkey',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('uct',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('universal',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/alaska',-480,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/aleutian',-540,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/arizona',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/central',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/east-indiana',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/eastern',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/hawaii',-600,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/indiana-starke',-300,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/michigan',-240,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/mountain',-360,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/pacific',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/pacific-new',-420,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('us/samoa',-660,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('utc',0,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('w-su',180,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('wet',60,@demo_account);
INSERT INTO `tzoffset` (`tz`, `offset`, `saas_account_id`) VALUES ('zulu',0,@demo_account);
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
INSERT INTO `users` (`id`, `username`, `password`, `email`, `access_token`, `reset_token`, `reset_expire`, `created`, `saas_account_id`) VALUES (1,'admin','$2a$10$mzKU71G62evnGB2PvQA4k..Wf9jASk.c7a8zRMHh6qQVjYJ2r/g/K','keep.admin@mailtrain.org','7833d148e22c85474c314f43ae4591a7c9adec26',NULL,NULL,NOW(),@demo_account);

ALTER TABLE `attachments` ADD KEY `attachments_sass_account_id` (`saas_account_id`);
ALTER TABLE `campaign` ADD KEY `campaign_sass_account_id` (`saas_account_id`);
ALTER TABLE `campaign__1` ADD KEY `campaign__1_sass_account_id` (`saas_account_id`);
ALTER TABLE `campaign_tracker` ADD KEY `campaign_tracker_sass_account_id` (`saas_account_id`);
ALTER TABLE `campaign_tracker__1` ADD KEY `campaign__1_tracker_sass_account_id` (`saas_account_id`);
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
ALTER TABLE `subscription__1` ADD KEY `subscription__1_sass_account_id` (`saas_account_id`);
ALTER TABLE `subscription__2` ADD KEY `subscription__2_sass_account_id` (`saas_account_id`);
ALTER TABLE `subscription__3` ADD KEY `subscription__3_sass_account_id` (`saas_account_id`);
ALTER TABLE `subscription__4` ADD KEY `subscription__4_sass_account_id` (`saas_account_id`);
ALTER TABLE `subscription__5` ADD KEY `subscription__5_sass_account_id` (`saas_account_id`);
ALTER TABLE `subscription__6` ADD KEY `subscription__6_sass_account_id` (`saas_account_id`);
ALTER TABLE `templates` ADD KEY `templates_sass_account_id` (`saas_account_id`);
ALTER TABLE `trigger` ADD KEY `trigger_sass_account_id` (`saas_account_id`);
ALTER TABLE `tzoffset` ADD KEY `tzoffset_sass_account_id` (`saas_account_id`);
ALTER TABLE `users` ADD KEY `users_sass_account_id` (`saas_account_id`);

ALTER TABLE `attachments` ADD CONSTRAINT `attachments_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `campaign` ADD CONSTRAINT `campaign_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `campaign__1` ADD CONSTRAINT `campaign__1_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `campaign_tracker` ADD CONSTRAINT `campaign_tracker_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `campaign_tracker__1` ADD CONSTRAINT `campaign_tracker__1_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
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
ALTER TABLE `subscription__1` ADD CONSTRAINT `subscription__1_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `subscription__2` ADD CONSTRAINT `subscription__2_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `subscription__3` ADD CONSTRAINT `subscription__3_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `subscription__4` ADD CONSTRAINT `subscription__4_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `subscription__5` ADD CONSTRAINT `subscription__5_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `subscription__6` ADD CONSTRAINT `subscription__6_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `templates` ADD CONSTRAINT `templates_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `trigger` ADD CONSTRAINT `trigger_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `tzoffset` ADD CONSTRAINT `tzoffset_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;
ALTER TABLE `users` ADD CONSTRAINT `users_account_ibfk_1` FOREIGN KEY (`saas_account_id`) REFERENCES `saas_account`(`id`) ON DELETE RESTRICT;


SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
