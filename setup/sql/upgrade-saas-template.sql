# This file is a handlebars template
# To modify several similar tables at once use (replace [] with {}):
#   [[#each tables.tablename]] ALTER TABLE `[[this]]` ... [[/each]]
# NB! as this is a handlebars file, then remember to escape any template sequences

# Header section
# Define incrementing schema version number
SET @schema_version = '99';

SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `saas_plan`(
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text,
  `email_limit` int unsigned NOT NULL DEFAULT 100,
  `month_sends_limit` int unsigned NOT NULL DEFAULT 5,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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


# UPDATE OTHER TABLES TO REFERENCE ACCOUNT ID
ALTER TABLE `attachments` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `campaign` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `campaign_tracker` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `campaigns` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `confirmations` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `custom_fields` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `custom_forms` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `custom_forms_data` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `import_failed` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `importer` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `links` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `lists` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `queued` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `rss` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `segment_rules` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `segments` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `settings` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `subscription` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `templates` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `trigger` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `tzoffset` ADD COLUMN `sass_account_id` int(11) unsgined;
ALTER TABLE `users` ADD COLUMN `sass_account_id` int(11) unsgined;

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


# Footer section. Updates schema version in settings
LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` (`key`, `value`) VALUES('db_schema_version', @schema_version) ON DUPLICATE KEY UPDATE `value`=@schema_version;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;


SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
