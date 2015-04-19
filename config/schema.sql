# =========================================================================== #
#                                                                             #
# TRANZIT - Database Initialization Script                                    #
# Copyright © Contributors. See docs/charter.md for team roster.              #
#                                                                             #
# =========================================================================== #
CREATE TABLE users (
  id          VARCHAR(20) NOT NULL,
  name        VARCHAR(50)  NOT NULL,
  email       VARCHAR(50) NOT NULL  UNIQUE,
  hash        TEXT        NOT NULL,
  auth        TEXT        NOT NULL,
  PRIMARY KEY (id),
  INDEX users_email (email)
);

CREATE TABLE recipients (
  id         VARCHAR(20)  NOT NULL,
  name       VARCHAR(100) NOT NULL,
  email      VARCHAR(100) NOT NULL,
  zip        VARCHAR(20)  NOT NULL,
  address    VARCHAR(200) NOT NULL,
  PRIMARY KEY (id),
  INDEX recipients_name (name)
);

CREATE TABLE packages (
  id          VARCHAR(20)  NOT NULL,
  user        VARCHAR(20)  NOT NULL,
  recipient   VARCHAR(20)  NOT NULL,
  tracking    VARCHAR(100) NOT NULL,
  received    INTEGER      NOT NULL,
  released    INTEGER      DEFAULT NULL,
  status      INTEGER      DEFAULT 0,
  PRIMARY KEY (id),
  INDEX packages_tracking (tracking)
);
