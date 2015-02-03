# =========================================================================== #
#                                                                             #
# TRANZIT - Database Initialization Script                                    #
# Copyright © Contributors. See docs/charter.md for team roster.              #
#                                                                             #
# =========================================================================== #
CREATE TABLE IF NOT EXISTS users (
  `id`          VARCHAR(20) NOT NULL,
  `first_name`  VARCHAR(50) NOT NULL,
  `last_name`   VARCHAR(50) NOT NULL,
  `uname`       VARCHAR(50) NOT NULL  UNIQUE,
  `hash`        TEXT        NOT NULL,
  `auth`        TEXT        NOT NULL,
  PRIMARY KEY (id),
  INDEX users_uname (uname)
);

CREATE TABLE IF NOT EXISTS recipients (
  `id`          VARCHAR(20) NOT NULL,
  `first_name`  VARCHAR(50) NOT NULL,
  `last_name`   VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  INDEX recipients_name (first_name, last_name)
);

CREATE TABLE IF NOT EXISTS packages (
  `id`          VARCHAR(20) NOT NULL,
  `tracking`    VARCHAR(100) NOT NULL,
  `received`    DATETIME    NOT NULL,
  `recipient`   VARCHAR(20) NOT NULL,
  `released`    DATETIME    DEFAULT NULL,
  `user`        VARCHAR(20) NOT NULL,
  PRIMARY KEY (id),
  INDEX packages_tracking (tracking)
);
