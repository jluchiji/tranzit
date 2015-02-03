# =========================================================================== #
#                                                                             #
# TRANZIT - Database Initialization Script                                    #
# Copyright © Contributors. See docs/charter.md for team roster.              #
#                                                                             #
# =========================================================================== #

CREATE TABLE IF NOT EXISTS packages (
  `id`          TEXT      NOT NULL,
  `tracking`    TEXT      NOT NULL,
  `received`    DATETIME  NOT NULL,
  `recipient`   TEXT      NOT NULL,
  `released`    DATETIME  DEFAULT NULL,
  `user`        TEXT      NOT NULL,
  PRIMARY KEY (id),
  INDEX packages_tracking (tracking),
  FOREIGN KEY (recipient) REFERENCES recipients(id) ON DELETE CASCADE,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS recipients (
  `id`          TEXT      NOT NULL      PRIMARY KEY,
  `first_name`  TEXT      NOT NULL,
  `last_name`   TEXT      NOT NULL,
  INDEX recipients_name (first_name, last_name)
);

CREATE TABLE IF NOT EXISTS users (
  `id`          TEXT      NOT NULL      PRIMARY KEY,
  `first_name`  TEXT      NOT NULL,
  `last_name`   TEXT      NOT NULL,
  `uname`       TEXT    NOT NULL  UNIQUE,
  `hash`        TEXT    NOT NULL,
  `auth`        TEXT    NOT NULL,
  INDEX users_uname (uname)
);
