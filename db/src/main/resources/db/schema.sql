-- MySQL Script generated by MySQL Workbench
-- Mon Jun 23 20:03:54 2014
-- Model: New Model    Version: 1.0
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema services
-- -----------------------------------------------------
-- Database that contains of the services to be monitored.
CREATE SCHEMA IF NOT EXISTS `services` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
USE `services` ;

-- -----------------------------------------------------
-- Table `t_service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_service` ;

CREATE TABLE IF NOT EXISTS `t_service` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Database identifier of the specific service.ß',
  `name` VARCHAR(64) BINARY NOT NULL COMMENT 'Name of the service in a system',
  `owner` VARCHAR(256) BINARY NULL COMMENT 'E-mail of the owner associated with the service.',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Contains the name of the services to be monitored.';

CREATE UNIQUE INDEX `name_UNIQUE` ON `t_service` (`name` ASC);


-- -----------------------------------------------------
-- Table `t_schedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_schedule` ;

CREATE TABLE IF NOT EXISTS `t_schedule` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) BINARY NULL,
  `cron` VARCHAR(128) BINARY NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Stores named schedules that are implemented as Quartz cron strings.';


-- -----------------------------------------------------
-- Table `t_ping_config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_ping_config` ;

CREATE TABLE IF NOT EXISTS `t_ping_config` (
  `id` INT NOT NULL,
  `host` VARCHAR(128) BINARY NOT NULL,
  `timeout` INT NOT NULL DEFAULT 5000,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t_ssh_config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_ssh_config` ;

CREATE TABLE IF NOT EXISTS `t_ssh_config` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `host` VARCHAR(128) BINARY NOT NULL,
  `port` INT(11) NOT NULL DEFAULT 22,
  `user` VARCHAR(64) BINARY NOT NULL,
  `password` VARCHAR(64) BINARY NOT NULL,
  `command` VARCHAR(512) BINARY NOT NULL,
  `expected_output` VARCHAR(256) BINARY NOT NULL,
  `timeout` INT NOT NULL DEFAULT 5000,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t_port_config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_port_config` ;

CREATE TABLE IF NOT EXISTS `t_port_config` (
  `id` INT NOT NULL,
  `host` VARCHAR(128) BINARY NOT NULL,
  `port` INT(11) NOT NULL,
  `timeout` INT NOT NULL DEFAULT 5000,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t_url_config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_url_config` ;

CREATE TABLE IF NOT EXISTS `t_url_config` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `url` VARCHAR(512) BINARY NOT NULL,
  `code` INT NOT NULL,
  `payload` TINYTEXT BINARY NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t_service_check`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_service_check` ;

CREATE TABLE IF NOT EXISTS `t_service_check` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) BINARY NULL,
  `schedule_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_t_service_test_t_schedule`
    FOREIGN KEY (`schedule_id`)
    REFERENCES `t_schedule` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Groups one or more service tests that are to be run against a service.';

CREATE INDEX `fk_t_service_test_t_schedule1_idx` ON `t_service_check` (`schedule_id` ASC);


-- -----------------------------------------------------
-- Table `t_service_to_check`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_service_to_check` ;

CREATE TABLE IF NOT EXISTS `t_service_to_check` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `service_id` INT UNSIGNED NOT NULL,
  `service_check_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_t_services_to_tests_t_services`
    FOREIGN KEY (`service_id`)
    REFERENCES `t_service` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_services_to_tests_t_service_test`
    FOREIGN KEY (`service_check_id`)
    REFERENCES `t_service_check` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Relates a Service Check to a service.';

CREATE INDEX `fk_t_services_to_tests_t_services_idx` ON `t_service_to_check` (`service_id` ASC);

CREATE INDEX `fk_t_services_to_tests_t_service_test1_idx` ON `t_service_to_check` (`service_check_id` ASC);


-- -----------------------------------------------------
-- Table `t_service_test_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_service_test_type` ;

CREATE TABLE IF NOT EXISTS `t_service_test_type` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) BINARY NULL,
  `table_name` VARCHAR(64) BINARY NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t_service_test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_service_test` ;

CREATE TABLE IF NOT EXISTS `t_service_test` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) BINARY NULL,
  `service_test_type_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_t_service_tests_t_service_test_type`
    FOREIGN KEY (`service_test_type_id`)
    REFERENCES `t_service_test_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_t_service_tests_t_service_test_types1_idx` ON `t_service_test` (`service_test_type_id` ASC);


-- -----------------------------------------------------
-- Table `t_service_check_to_test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_service_check_to_test` ;

CREATE TABLE IF NOT EXISTS `t_service_check_to_test` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `service_check_id` INT UNSIGNED NOT NULL,
  `service_test_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_t_service_check_to_tests_t_service_check`
    FOREIGN KEY (`service_check_id`)
    REFERENCES `t_service_check` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_service_check_to_tests_t_service_tests`
    FOREIGN KEY (`service_test_id`)
    REFERENCES `t_service_test` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_t_service_check_to_tests_t_service_check1_idx` ON `t_service_check_to_test` (`service_check_id` ASC);

CREATE INDEX `fk_t_service_check_to_tests_t_service_tests1_idx` ON `t_service_check_to_test` (`service_test_id` ASC);

USE `services` ;

-- -----------------------------------------------------
-- Placeholder table for view `v_services`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_services` (`serviceId` INT, `serviceName` INT, `serviceCheckId` INT, `serviceCheckName` INT, `serviceTestId` INT, `serviceTestName` INT, `serviceTypeName` INT, `serviceTypeTableName` INT, `configId` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_service_tests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_service_tests` (`id` INT, `name` INT, `type` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_service_checks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_service_checks` (`serviceCheckName` INT, `serviceTestId` INT, `serviceTestName` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_service_check_configs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_service_check_configs` (`serviceId` INT, `serviceName` INT, `serviceCheckId` INT, `serviceCheckName` INT, `serviceTestId` INT, `serviceTestName` INT, `serviceTypeName` INT, `serviceTypeTableName` INT, `configId` INT, `pingHost` INT, `pingTimeout` INT, `portHost` INT, `portPort` INT, `sshHost` INT, `sshPort` INT);

-- -----------------------------------------------------
-- View `v_services`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_services` ;
DROP TABLE IF EXISTS `v_services`;
USE `services`;
CREATE  OR REPLACE VIEW `v_services` AS
SELECT
 s.id AS serviceId
,s.name AS serviceName
,sc.id AS serviceCheckId
,sc.name AS serviceCheckName
,st.id AS serviceTestId
,st.name AS serviceTestName
,stt.name AS serviceTypeName
,stt.table_name AS serviceTypeTableName
,st.id AS configId
FROM t_service s
INNER JOIN t_service_to_check stc ON s.id = stc.service_id
INNER JOIN t_service_check sc ON sc.id = stc.service_check_id
INNER JOIN t_service_check_to_test sctt ON sc.id = sctt.service_check_id
INNER JOIN t_service_test st ON st.id = sctt.service_test_id
INNER JOIN t_service_test_type stt ON stt.id = st.service_test_type_id
;

-- -----------------------------------------------------
-- View `v_service_tests`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_service_tests` ;
DROP TABLE IF EXISTS `v_service_tests`;
USE `services`;
CREATE  OR REPLACE VIEW `v_service_tests` AS
SELECT
  st.id AS id
 ,st.name AS name
 ,tt.name AS type
FROM t_service_test st, t_service_test_type tt
WHERE st.service_test_type_id = tt.id;

-- -----------------------------------------------------
-- View `v_service_checks`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_service_checks` ;
DROP TABLE IF EXISTS `v_service_checks`;
USE `services`;
CREATE  OR REPLACE VIEW `v_service_checks` AS
SELECT
 sc.name AS serviceCheckName
,st.id AS serviceTestId
,st.name AS serviceTestName
FROM t_service_check sc
INNER JOIN t_service_check_to_test sctt ON sc.id = sctt.service_check_id
INNER JOIN t_service_test st ON st.id = sctt.service_test_id
;

-- -----------------------------------------------------
-- View `v_service_check_configs`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_service_check_configs` ;
DROP TABLE IF EXISTS `v_service_check_configs`;
USE `services`;
CREATE  OR REPLACE VIEW `v_service_check_configs` AS
SELECT
 s.id AS serviceId
,s.name AS serviceName
,sc.id AS serviceCheckId
,sc.name AS serviceCheckName
,st.id AS serviceTestId
,st.name AS serviceTestName
,stt.name AS serviceTypeName
,stt.table_name AS serviceTypeTableName
,st.id AS configId
,ping.host AS pingHost
,ping.timeout AS pingTimeout
,port.host AS portHost
,port.port AS portPort
,ssh.host AS sshHost
,ssh.port AS sshPort
FROM t_service s
INNER JOIN t_service_to_check stc ON s.id = stc.service_id
INNER JOIN t_service_check sc ON sc.id = stc.service_check_id
INNER JOIN t_service_check_to_test sctt ON sc.id = sctt.service_check_id
INNER JOIN t_service_test st ON st.id = sctt.service_test_id
INNER JOIN t_service_test_type stt ON stt.id = st.service_test_type_id
LEFT JOIN t_ping_config ping ON st.id = ping.id
LEFT JOIN t_port_config port ON st.id = port.id 
LEFT JOIN t_ssh_config ssh ON st.id = ssh.id
ORDER BY sc.id;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
