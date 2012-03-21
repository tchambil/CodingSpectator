--This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.

--This script reports the number of time refactorings with specific properties (number of affected files and lines and configuration time) have been used.

/*

TODO: I don't know where the JavaRefactoringChangeSizeConfiguration.csv comes
from. I guess the Ruby script generates it.

DROP TABLE "PUBLIC"."REFACTORING_CHANGE_SIZE_CONFIGURATION_TIME" IF EXISTS;

CREATE TABLE "PUBLIC"."REFACTORING_CHANGE_SIZE_CONFIGURATION_TIME" (
  "REFACTORING_ID" VARCHAR(100),
  "CONFIGURATION_TIMESTAMP" BIGINT,
  "SIZE_TIMESTAMP" BIGINT,
  "AFFECTED_FILES_COUNT" INT,
  "AFFECTED_LINES_COUNT" INT,
  "CONFIGURATION_TIME_IN_MILLI_SEC" BIGINT
);

* *DSV_COL_SPLITTER = ,
* *DSV_TARGET_TABLE = "PUBLIC"."REFACTORING_CHANGE_SIZE_CONFIGURATION_TIME"

\m JavaRefactoringChangeSizeConfiguration.csv

DROP TABLE "PUBLIC"."CHANGE_SIZE_CONFIGURATION_TIME_MULTIPLICITIES" IF EXISTS;

CREATE TABLE "PUBLIC"."CHANGE_SIZE_CONFIGURATION_TIME_MULTIPLICITIES" (
  "AFFECTED_FILES_COUNT" INT,
  "AFFECTED_LINES_COUNT" INT,
  "CONFIGURATION_TIME_IN_SEC" BIGINT,
  "MULTIPLICITY" INT
);

INSERT INTO "PUBLIC"."CHANGE_SIZE_CONFIGURATION_TIME_MULTIPLICITIES" (
  "AFFECTED_FILES_COUNT",
  "AFFECTED_LINES_COUNT",
  "CONFIGURATION_TIME_IN_SEC",
  "MULTIPLICITY"
)
SELECT
"T"."AFFECTED_FILES_COUNT" AS "AFFECTED_FILES_COUNT",
"T"."AFFECTED_LINES_COUNT" AS "AFFECTED_LINES_COUNT",
"T"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000 AS "CONFIGURATION_TIME_IN_SEC",
COUNT(*) AS "MULTIPLICITY"
FROM "PUBLIC"."REFACTORING_CHANGE_SIZE_CONFIGURATION_TIME" "T"
GROUP BY "AFFECTED_FILES_COUNT", "AFFECTED_LINES_COUNT", "CONFIGURATION_TIME_IN_SEC";

* *DSV_COL_DELIM = ,
* *DSV_ROW_DELIM = \n
* *DSV_TARGET_FILE=JavaRefactoringChangeSizeConfigurationMultiplicities.csv

\x "PUBLIC"."CHANGE_SIZE_CONFIGURATION_TIME_MULTIPLICITIES"

*/

\p Reporting the size of Java refactorings

DROP TABLE "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" IF EXISTS;

CREATE TABLE "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" (

  "USERNAME" VARCHAR(100),

  "WORKSPACE_ID" VARCHAR(100),

  "TIMESTAMP" BIGINT,

  "REFACTORING_ID" VARCHAR(100),

  "AFFECTED_FILES_COUNT" INT,

  "AFFECTED_LINES_COUNT" INT

);

INSERT INTO "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" (

  "USERNAME",

  "WORKSPACE_ID",

  "TIMESTAMP",

  "REFACTORING_ID",

  "AFFECTED_FILES_COUNT",

  "AFFECTED_LINES_COUNT"

)

SELECT

"T"."USERNAME" AS "USERNAME",

"T"."WORKSPACE_ID" AS "WORKSPACE_ID",

"T"."TIMESTAMP" AS "TIMESTAMP",

JAVA_REFACTORING_ID("T"."REFACTORING_ID") AS "REFACTORING_ID",

"T"."AFFECTED_FILES_COUNT" AS "AFFECTED_FILES_COUNT",

"T"."AFFECTED_LINES_COUNT" AS "AFFECTED_LINES_COUNT"

FROM "PUBLIC"."REFACTORING_CHANGE_SIZE" "T"

WHERE IS_JAVA_REFACTORING("REFACTORING_ID") AND "T"."USERNAME" LIKE 'cs-___'

AND EXISTS (SELECT * FROM "PUBLIC"."ALL_DATA" "T2"

WHERE IS_CODINGTRACKER_PERFORMED("T2"."recorder", "T2"."refactoring kind") AND
"T2"."username" = "T"."USERNAME" AND "T2"."workspace ID" = "WORKSPACE_ID" AND
"T2"."timestamp" = "TIMESTAMP" AND JAVA_REFACTORING_ID("T2"."id") =
JAVA_REFACTORING_ID("REFACTORING_ID"));

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =JavaRefactoringChangeSize.csv

\x SELECT * FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE"

\p Reporting the configuration times of Java refactorings

DROP TABLE "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" IF EXISTS;

CREATE TABLE "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" (

  "USERNAME" VARCHAR(100),

  "WORKSPACE_ID" VARCHAR(100),

  "TIMESTAMP" BIGINT,

  "REFACTORING_ID" VARCHAR(100),

  "CONFIGURATION_TIME_IN_MILLI_SEC" INT

);

INSERT INTO "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" (

  "USERNAME",

  "WORKSPACE_ID",

  "TIMESTAMP",

  "REFACTORING_ID",

  "CONFIGURATION_TIME_IN_MILLI_SEC"

)

SELECT

"T"."username" AS "USERNAME",

"T"."workspace ID" AS "WORKSPACE_ID",

"T"."timestamp" AS "TIMESTAMP",

JAVA_REFACTORING_ID("T"."id") AS "REFACTORING_ID",

CAST("T"."navigation duration" AS INT) AS "CONFIGURATION_TIME_IN_MILLI_SEC"

FROM "PUBLIC"."ALL_DATA" "T"

WHERE IS_JAVA_REFACTORING("T"."id") AND
IS_REFACTORING_ID_SUPPORTED_BY_CS("T"."id") AND
(IS_CODINGSPECTATOR_PERFORMED("T"."recorder", "T"."refactoring kind") OR
IS_CODINGSPECTATOR_CANCELED("T"."recorder", "T"."refactoring kind")) AND
"T"."navigation duration" <> '' AND "T"."username" LIKE 'cs-___';

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =PerformedOrCanceledRefactoringConfigurationTime.csv

\x SELECT * FROM "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME"

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =PerJavaRefactoringIDChangeSize.csv

DROP TABLE "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE" (

  "REFACTORING_ID" VARCHAR(100),

  "NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE" INT,

  "AFFECTED_FILES_COUNT" NUMERIC(5, 2),

  "AFFECTED_LINES_COUNT" NUMERIC(5, 2),

  "SUM_AFFECTED_FILES" INT,

  "SUM_AFFECTED_LINES" INT

);

INSERT INTO "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE" (

  "REFACTORING_ID",

  "NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE",

  "AFFECTED_FILES_COUNT",

  "AFFECTED_LINES_COUNT",

  "SUM_AFFECTED_FILES",

  "SUM_AFFECTED_LINES"

)

SELECT

JAVA_REFACTORING_ID("T"."REFACTORING_ID") AS "REFACTORING_ID",

COUNT(*) AS  "NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE",

CONVERT(AVG(CONVERT("T"."AFFECTED_FILES_COUNT", SQL_FLOAT)), NUMERIC(5, 2)) AS
"AVG_AFFECTED_FILES",

CONVERT(AVG(CONVERT("T"."AFFECTED_LINES_COUNT", SQL_FLOAT)), NUMERIC(5, 2)) AS
"AVG_AFFECTED_LINES",

SUM("T"."AFFECTED_FILES_COUNT") AS "SUM_AFFECTED_FILES",

SUM("T"."AFFECTED_LINES_COUNT") AS "SUM_AFFECTED_LINES"

FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" "T"

GROUP BY JAVA_REFACTORING_ID("T"."REFACTORING_ID")

ORDER BY JAVA_REFACTORING_ID("T"."REFACTORING_ID");

\x SELECT * FROM "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE"

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =PerJavaRefactoringIDChangeSizeProportions.csv

DROP TABLE "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE_PROPORTIONS" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE_PROPORTIONS" (

  "REFACTORING_ID" VARCHAR(100),

  "NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE" INT,

  "CODINGTRACKER_PERFORMED_COUNT" INT,

  "CODINGSPECTATOR_PERFORMED_COUNT" INT

);

INSERT INTO "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE_PROPORTIONS" (

  "REFACTORING_ID",

  "NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE",

  "CODINGTRACKER_PERFORMED_COUNT",

  "CODINGSPECTATOR_PERFORMED_COUNT"

)

SELECT

JAVA_REFACTORING_ID("T"."REFACTORING_ID") AS "REFACTORING_ID",

"T"."NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE" AS
"NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE",

(SELECT "T2"."CODINGTRACKER_PERFORMED_COUNT"

 FROM "PUBLIC"."PER_REFACTORING_ID" "T2"

 WHERE JAVA_REFACTORING_ID("T2"."REFACTORING_ID") =
JAVA_REFACTORING_ID("T"."REFACTORING_ID")) AS "CODINGTRACKER_PERFORMED_COUNT",

(SELECT "T2"."CODINGSPECTATOR_PERFORMED_COUNT"

 FROM "PUBLIC"."PER_REFACTORING_ID" "T2"

 WHERE JAVA_REFACTORING_ID("T2"."REFACTORING_ID") =
JAVA_REFACTORING_ID("T"."REFACTORING_ID")) AS "CODINGSPECTATOR_PERFORMED_COUNT"

FROM "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE" "T"

WHERE IS_REFACTORING_ID_IN_ICSE2012_PAPER("T"."REFACTORING_ID");

\x SELECT * FROM "PUBLIC"."PER_JAVA_REFACTORING_ID_CHANGE_SIZE_PROPORTIONS";

DROP TABLE "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" IF EXISTS;

CREATE TABLE "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" (

  "VARIABLE_NAME" VARCHAR(1000),

  "VALUE_INT" INT,

  "VALUE_NUMERIC" NUMERIC(5, 2)

);

INSERT INTO "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" (

  "VARIABLE_NAME",

  "VALUE_INT",

  "VALUE_NUMERIC"

)

VALUES (

  'NUMBER_OF_CODINGTRACKER_PERFORMED_REFACTORINGS',

  (SELECT SUM("T"."CODINGTRACKER_PERFORMED_COUNT") FROM
"PER_JAVA_REFACTORING_ID_CHANGE_SIZE_PROPORTIONS" "T"),

  NULL

);

INSERT INTO "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" (

  "VARIABLE_NAME",

  "VALUE_INT",

  "VALUE_NUMERIC"

)

VALUES (

  'NUMBER_OF_CODINGSPECTATOR_PERFORMED_REFACTORINGS',

  (SELECT SUM("T"."CODINGSPECTATOR_PERFORMED_COUNT") FROM
"PER_JAVA_REFACTORING_ID_CHANGE_SIZE_PROPORTIONS" "T"),

  NULL

);

INSERT INTO "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" (

  "VARIABLE_NAME",

  "VALUE_INT",

  "VALUE_NUMERIC"

)

VALUES (

  'NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE',

  (SELECT SUM("T"."NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE") FROM
"PER_JAVA_REFACTORING_ID_CHANGE_SIZE_PROPORTIONS" "T"),

  NULL

);

INSERT INTO "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" (

  "VARIABLE_NAME",

  "VALUE_INT",

  "VALUE_NUMERIC"

)

VALUES (

  'PERCENTAGE_OF_PERFORMED_CODINGSPECTATOR_REFACTORINGS_WITH_CHANGE_SIZE',

  NULL,

  100.00 * CONVERT((SELECT "T"."VALUE_INT"

  FROM "REFACTORING_CHANGE_SIZE_SUMMARY" "T"

  WHERE "T"."VARIABLE_NAME" = 'NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE'),

  SQL_FLOAT)

  /

  CONVERT((SELECT "T"."VALUE_INT"

  FROM "REFACTORING_CHANGE_SIZE_SUMMARY" "T"

  WHERE "T"."VARIABLE_NAME" =
'NUMBER_OF_CODINGSPECTATOR_PERFORMED_REFACTORINGS'),

  SQL_FLOAT)

);

INSERT INTO "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" (

  "VARIABLE_NAME",

  "VALUE_INT",

  "VALUE_NUMERIC"

)

VALUES (

  'PERCENTAGE_OF_PERFORMED_CODINGTRACKER_REFACTORINGS_WITH_CHANGE_SIZE',

  NULL,

  100.00 * CONVERT((SELECT "T"."VALUE_INT"

  FROM "REFACTORING_CHANGE_SIZE_SUMMARY" "T"

  WHERE "T"."VARIABLE_NAME" = 'NUMBER_OF_REFACTORINGS_WITH_CHANGE_SIZE'),

  SQL_FLOAT)

  /

  CONVERT((SELECT "T"."VALUE_INT"

  FROM "REFACTORING_CHANGE_SIZE_SUMMARY" "T"

  WHERE "T"."VARIABLE_NAME" =
'NUMBER_OF_CODINGTRACKER_PERFORMED_REFACTORINGS'),

  SQL_FLOAT)

);

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =PerChangeSizeMultiplicity.csv

DROP TABLE "PUBLIC"."PER_CHANGE_SIZE_MULTIPLICITY" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_CHANGE_SIZE_MULTIPLICITY" (

  "AFFECTED_FILES_COUNT" INT,

  "AFFECTED_LINES_COUNT" INT,

  "MULTIPLICITY" INT

);

INSERT INTO "PUBLIC"."PER_CHANGE_SIZE_MULTIPLICITY" (

  "AFFECTED_FILES_COUNT",

  "AFFECTED_LINES_COUNT",

  "MULTIPLICITY"

)

SELECT

"T"."AFFECTED_FILES_COUNT" AS "AFFECTED_FILES_COUNT",

"T"."AFFECTED_LINES_COUNT" AS "AFFECTED_LINES_COUNT",

COUNT(*) AS "MULTIPLICITY"

FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" "T"

GROUP BY "T"."AFFECTED_FILES_COUNT", "T"."AFFECTED_LINES_COUNT"

ORDER BY "T"."AFFECTED_FILES_COUNT", "T"."AFFECTED_LINES_COUNT";

\x SELECT * FROM "PUBLIC"."PER_CHANGE_SIZE_MULTIPLICITY"

\p Computing statistics about the number of affected files

DROP TABLE "PUBLIC"."PER_AFFECTED_FILES_COUNTS" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_AFFECTED_FILES_COUNTS" (

  "AFFECTED_FILES_COUNT" INT,

  "COUNT" INT

);

INSERT INTO "PUBLIC"."PER_AFFECTED_FILES_COUNTS" (

  "AFFECTED_FILES_COUNT",

  "COUNT"

)

SELECT

"T"."AFFECTED_FILES_COUNT" AS "AFFECTED_FILES_COUNT",

COUNT(*) AS "COUNT"

FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" "T"

GROUP BY "T"."AFFECTED_FILES_COUNT"

ORDER BY "T"."AFFECTED_FILES_COUNT";

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =PerAffectedFilesCumulativeCounts.csv

DROP TABLE "PUBLIC"."PER_AFFECTED_FILES_CUMULATIVE_COUNTS" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_AFFECTED_FILES_CUMULATIVE_COUNTS" (

  "AFFECTED_FILES_COUNT" INT,

  "COUNT" INT,

  "CUMULATIVE_COUNT" INT,

  "CUMULATIVE_PERCENTAGE" NUMERIC(5, 2)

);

INSERT INTO "PUBLIC"."PER_AFFECTED_FILES_CUMULATIVE_COUNTS" (

  "AFFECTED_FILES_COUNT",

  "COUNT",

  "CUMULATIVE_COUNT",

  "CUMULATIVE_PERCENTAGE"

)

SELECT

"T"."AFFECTED_FILES_COUNT" AS "AFFECTED_FILES_COUNT",

"T"."COUNT" AS "COUNT",

(SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" "T2" WHERE
"T2"."AFFECTED_FILES_COUNT" <= "T"."AFFECTED_FILES_COUNT") AS
"CUMULATIVE_COUNT",

100 * CONVERT((SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE"
"T3" WHERE "T3"."AFFECTED_FILES_COUNT" <= "T"."AFFECTED_FILES_COUNT"),
SQL_FLOAT) / (SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE") AS
"CUMULATIVE_PERCENTAGE"

FROM "PUBLIC"."PER_AFFECTED_FILES_COUNTS" "T";

\x SELECT * FROM "PUBLIC"."PER_AFFECTED_FILES_CUMULATIVE_COUNTS"

\p Computing statistics about the number of affected lines

DROP TABLE "PUBLIC"."PER_AFFECTED_LINES_COUNTS" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_AFFECTED_LINES_COUNTS" (

  "AFFECTED_LINES_COUNT" INT,

  "COUNT" INT

);

INSERT INTO "PUBLIC"."PER_AFFECTED_LINES_COUNTS" (

  "AFFECTED_LINES_COUNT",

  "COUNT"

)

SELECT

"T"."AFFECTED_LINES_COUNT" AS "AFFECTED_LINES_COUNT",

COUNT(*) AS "COUNT"

FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" "T"

GROUP BY "T"."AFFECTED_LINES_COUNT"

ORDER BY "T"."AFFECTED_LINES_COUNT";

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =PerAffectedLinesCumulativeCounts.csv

DROP TABLE "PUBLIC"."PER_AFFECTED_LINES_CUMULATIVE_COUNTS" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_AFFECTED_LINES_CUMULATIVE_COUNTS" (

  "AFFECTED_LINES_COUNT" INT,

  "COUNT" INT,

  "CUMULATIVE_COUNT" INT,

  "CUMULATIVE_PERCENTAGE" NUMERIC(5, 2)

);

INSERT INTO "PUBLIC"."PER_AFFECTED_LINES_CUMULATIVE_COUNTS" (

  "AFFECTED_LINES_COUNT",

  "COUNT",

  "CUMULATIVE_COUNT",

  "CUMULATIVE_PERCENTAGE"

)

SELECT

"T"."AFFECTED_LINES_COUNT" AS "AFFECTED_LINES_COUNT",

"T"."COUNT" AS "COUNT",

(SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" "T2" WHERE
"T2"."AFFECTED_LINES_COUNT" <= "T"."AFFECTED_LINES_COUNT") AS
"CUMULATIVE_COUNT",

100 * CONVERT((SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE"
"T3" WHERE "T3"."AFFECTED_LINES_COUNT" <= "T"."AFFECTED_LINES_COUNT"),
SQL_FLOAT) / (SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE") AS
"CUMULATIVE_PERCENTAGE"

FROM "PUBLIC"."PER_AFFECTED_LINES_COUNTS" "T";

\x SELECT * FROM "PUBLIC"."PER_AFFECTED_LINES_CUMULATIVE_COUNTS"

\p Computing cumulative counts of refactorings per configuration time

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =PerConfigurationTimeCumulativeCounts.csv

DROP TABLE "PUBLIC"."PER_CONFIGURATION_TIME_CUMULATIVE_COUNTS" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_CONFIGURATION_TIME_CUMULATIVE_COUNTS" (

  "CONFIGURATION_TIME_IN_SEC" INT,

  "COUNT" INT,

  "CUMULATIVE_COUNT" INT,

  "CUMULATIVE_PERCENTAGE" NUMERIC(5, 2)

);

INSERT INTO "PUBLIC"."PER_CONFIGURATION_TIME_CUMULATIVE_COUNTS" (

  "CONFIGURATION_TIME_IN_SEC",

  "COUNT",

  "CUMULATIVE_COUNT",

  "CUMULATIVE_PERCENTAGE"

)

SELECT

DISTINCT("T"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000) AS
"CONFIGURATION_TIME_IN_SEC",

(SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" "T1" WHERE
IS_REFACTORING_ID_IN_ICSE2012_PAPER("T1"."REFACTORING_ID") AND
"T1"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000 =
"T"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000) AS "COUNT",

(SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" "T2" WHERE
IS_REFACTORING_ID_IN_ICSE2012_PAPER("T2"."REFACTORING_ID") AND
"T2"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000 <=
"T"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000) AS "CUMULATIVE_COUNT",

100.0 * CONVERT((SELECT COUNT(*) FROM
"PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" "T3" WHERE
IS_REFACTORING_ID_IN_ICSE2012_PAPER("T3"."REFACTORING_ID") AND
"T3"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000 <=
"T"."CONFIGURATION_TIME_IN_MILLI_SEC" / 1000), SQL_FLOAT) / (SELECT COUNT(*)
FROM "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" "T4" WHERE
IS_REFACTORING_ID_IN_ICSE2012_PAPER("T4"."REFACTORING_ID")) AS
"CUMULATIVE_PERCENTAGE"

FROM "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" "T"

WHERE IS_REFACTORING_ID_IN_ICSE2012_PAPER("T"."REFACTORING_ID");

\x SELECT * FROM "PUBLIC"."PER_CONFIGURATION_TIME_CUMULATIVE_COUNTS"

INSERT INTO "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY" (

  "VARIABLE_NAME",

  "VALUE_INT",

  "VALUE_NUMERIC"

)

VALUES (

  'NUMBER_OF_REFACTORINGS_WITH_CONFIGURATION_TIME_INFORMATION',

  (SELECT COUNT(*) FROM "PUBLIC"."JAVA_REFACTORING_CONFIGURATION_TIME" "T"),

  NULL

);

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =RefactoringChangeSizeSummary.csv

\x SELECT * FROM "PUBLIC"."REFACTORING_CHANGE_SIZE_SUMMARY";

