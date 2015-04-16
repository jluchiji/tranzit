# =========================================================================== #
#                                                                             #
# TRANZIT - Database Initialization Script                                    #
# Copyright © Contributors. See docs/charter.md for team roster.              #
#                                                                             #
# =========================================================================== #
CREATE TABLE user (
  id          VARCHAR(20) NOT NULL,
  firstName  VARCHAR(50)  NOT NULL,
  lastName   VARCHAR(50)  NOT NULL,
  email       VARCHAR(50) NOT NULL  UNIQUE,
  hash        TEXT        NOT NULL,
  auth        TEXT        NOT NULL,
  PRIMARY KEY (id),
  INDEX users_email (email)
);

CREATE TABLE recipient (
  id         VARCHAR(20)  NOT NULL,
  name       VARCHAR(100) NOT NULL,
  email      VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  INDEX recipients_name (firstName, lastName)
);

CREATE TABLE package (
  id          VARCHAR(20)  NOT NULL,
  tracking    VARCHAR(100) NOT NULL,
  received    DATETIME     NOT NULL,
  recipient   VARCHAR(20)  NOT NULL,
  released    DATETIME     DEFAULT NULL,
  user        VARCHAR(20)  NOT NULL,
  PRIMARY KEY (id),
  INDEX packages_tracking (tracking)
);

CREATE TABLE location (
  id          VARCHAR(20) NOT NULL,
  address     TEXT        NOT NULL,
  name        TEXT        NOT NULL,
  PRIMARY KEY (id),
  INDEX locations_name (name)
);
