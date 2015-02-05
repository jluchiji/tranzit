# =========================================================================== #
#                                                                             #
# TRANZIT - Database Initialization Script                                    #
# Copyright © Contributors. See docs/charter.md for team roster.              #
#                                                                             #
# =========================================================================== #
CREATE TABLE users (
  id          VARCHAR(20) NOT NULL,
  firstName  VARCHAR(50) NOT NULL,
  lastName   VARCHAR(50) NOT NULL,
  email       VARCHAR(50) NOT NULL  UNIQUE,
  hash        TEXT        NOT NULL,
  auth        TEXT        NOT NULL,
  PRIMARY KEY (id),
  INDEX users_email (email)
);

CREATE TABLE recipients (
  id          VARCHAR(20) NOT NULL,
  firstName  VARCHAR(50) NOT NULL,
  lastName   VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  INDEX recipients_name (firstName, lastName)
);

CREATE TABLE packages (
  id          VARCHAR(20) NOT NULL,
  tracking    VARCHAR(100) NOT NULL,
  received    DATETIME    NOT NULL,
  recipient   VARCHAR(20) NOT NULL,
  released    DATETIME    DEFAULT NULL,
  user        VARCHAR(20) NOT NULL,
  PRIMARY KEY (id),
  INDEX packages_tracking (tracking)
);
