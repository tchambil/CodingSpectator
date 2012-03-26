--This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.

* USAGE_TIME_START =1305435601000 --May 15, 2011

* USAGE_TIME_STOP =1332619371000 -- February 3, 2011

* TIME_WINDOW_IN_MINTUES =10

\p Renaming columns of "PUBLIC"."ALL_DATA"

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "username" RENAME TO "USERNAME";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "timestamp" RENAME TO "TIMESTAMP";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "id" RENAME TO "REFACTORING_ID";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "workspace ID" RENAME TO "WORKSPACE_ID";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "codingspectator version" RENAME
TO "CODINGSPECTATOR_VERSION";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "refactoring kind" RENAME TO
"REFACTORING_KIND";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "recorder" RENAME TO "RECORDER";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "human-readable timestamp" RENAME
TO "HUMAN_READABLE_TIMESTAMP";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "captured-by-codingspectator"
RENAME TO "CAPTURED_BY_CODINGSPECTATOR";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN
"code-snippet-with-selection-markers" RENAME TO
"CODE_SNIPPET_WITH_SELECTION_MARKERS";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "codingtracker description" RENAME
TO "CODINGTRACKER_DESCRIPTION";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "comment" RENAME TO "COMMENT";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "description" RENAME TO
"DESCRIPTION";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "status" RENAME TO "STATUS";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "invoked-by-quickassist" RENAME TO
"INVOKED_BY_QUICKASSIST";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN
"invoked-through-structured-selection" RENAME TO
"INVOKED_THROUGH_STRUCTURED_SELECTION";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "navigation duration" RENAME TO
"NAVIGATION_DURATION";

ALTER TABLE "PUBLIC"."ALL_DATA" ALTER COLUMN "navigation-history" RENAME TO
"NAVIGATION_HISTORY";

\p Deleting out-of-scope data from "PUBLIC"."ALL_DATA"

DELETE FROM "PUBLIC"."ALL_DATA" "AD"

WHERE NOT ("AD"."USERNAME" LIKE 'cs-___' AND *{USAGE_TIME_START} <
"AD"."TIMESTAMP" AND "AD"."TIMESTAMP" < *{USAGE_TIME_STOP} AND
IS_REFACTORING_ID_IN_ICSE2012_PAPER("AD"."REFACTORING_ID"));

\p Creating an index on "PUBLIC"."ALL_DATA"

DROP INDEX "ALL_DATA_INDEX" IF EXISTS;

CREATE INDEX "ALL_DATA_INDEX" ON "PUBLIC"."ALL_DATA" (

  "USERNAME",

  "WORKSPACE_ID",

  "CODINGSPECTATOR_VERSION",

  "TIMESTAMP",

  "RECORDER",

  "REFACTORING_KIND"

);

* USERNAME_MAX_LENGTH =100

* WORKSPACE_ID_MAX_LENGTH =100

* CODINGSPECTATOR_VERSION_MAX_LENGTH =100

* REFACTORING_ID_MAX_LENGTH =100

* HUMAN_READABLE_TIMESTAMP_MAX_LENGTH =100

* RECORDER_MAX_LENGTH =100

* TIMESTAMP_MAX_LENGTH =50

* CAPTURED_BY_CODINGSPECTATOR_MAX_LENGTH =50

* REFACTORING_KIND_MAX_LENGTH =50

* CODE_SNIPPET_WITH_SELECTION_MARKERS_MAX_LENGTH =1000000

* CODINGTRACKER_DESCRIPTION_MAX_LENGTH =1000

* COMMENT_MAX_LENGTH =10000

* DESCRIPTION_MAX_LENGTH =10000

* STATUS_MAX_LENGTH =100000

* INVOKED_BY_QUICKASSIST_MAX_LENGTH =50

* INVOKED_THROUGH_STRUCTURED_SELECTION_MAX_LENGTH =50

* NAVIGATION_DURATION_MAX_LENGTH =1000

* NAVIGATION_HISTORY_MAX_LENGTH =10000

\p Importing matched-performed-refactorings.csv

DROP TABLE "PUBLIC"."MATCHED_PERFORMED_REFACTORINGS" IF EXISTS;

CREATE TABLE "PUBLIC"."MATCHED_PERFORMED_REFACTORINGS" (

  "CODINGSPECTATOR_HUMAN_READABLE_TIMESTAMP"
VARCHAR(*{HUMAN_READABLE_TIMESTAMP_MAX_LENGTH}),

  "CODINGSPECTATOR_TIMESTAMP" BIGINT,

  "CODINGSPECTATOR_VERSION" VARCHAR(*{CODINGSPECTATOR_VERSION_MAX_LENGTH}),

  "CODINGTRACKER_HUMAN_READABLE_TIMESTAMP"
VARCHAR(*{HUMAN_READABLE_TIMESTAMP_MAX_LENGTH}),

  "CODINGTRACKER_TIMESTAMP" BIGINT,

  "MISSING" VARCHAR(*{RECORDER_MAX_LENGTH}),

  "REFACTORING_ID" VARCHAR(*{REFACTORING_ID_MAX_LENGTH}),

  "USERNAME" VARCHAR(*{USERNAME_MAX_LENGTH}),

  "WORKSPACE_ID" VARCHAR(*{WORKSPACE_ID_MAX_LENGTH})

);

* *DSV_COL_SPLITTER =,

* *DSV_ROW_SPLITTER =\n

* *DSV_TARGET_TABLE ="PUBLIC"."MATCHED_PERFORMED_REFACTORINGS"

\m matched-performed-refactorings.csv

DELETE FROM "PUBLIC"."MATCHED_PERFORMED_REFACTORINGS" "MPR"

WHERE NOT ("MPR"."USERNAME" LIKE 'cs-___' AND *{USAGE_TIME_START} <
"MPR"."CODINGTRACKER_TIMESTAMP" AND "MPR"."CODINGTRACKER_TIMESTAMP" <
*{USAGE_TIME_STOP} AND
IS_REFACTORING_ID_IN_ICSE2012_PAPER("MPR"."REFACTORING_ID"));

\p Creating an index on "PUBLIC"."MATCHED_PERFORMED_REFACTORINGS"

DROP INDEX "MATCHED_PERFORMED_REFACTORINGS_INDEX" IF EXISTS;

CREATE INDEX "MATCHED_PERFORMED_REFACTORINGS_INDEX" ON
"PUBLIC"."MATCHED_PERFORMED_REFACTORINGS" (

  "USERNAME",

  "WORKSPACE_ID",

  "CODINGSPECTATOR_VERSION",

  "CODINGTRACKER_TIMESTAMP"

);

\p Exporting refactoring events under study

DROP TABLE "PUBLIC"."REFACTORINGS_UNDER_STUDY" IF EXISTS;

CREATE TABLE "PUBLIC"."REFACTORINGS_UNDER_STUDY" (

  "USERNAME" VARCHAR(*{USERNAME_MAX_LENGTH}),

  "WORKSPACE_ID" VARCHAR(*{WORKSPACE_ID_MAX_LENGTH}),

  "CODINGSPECTATOR_VERSION" VARCHAR(*{CODINGSPECTATOR_VERSION_MAX_LENGTH}),

  "CODINGTRACKER_TIMESTAMP" BIGINT,

  "CODINGSPECTATOR_TIMESTAMP" BIGINT,

  "REFACTORING_ID" VARCHAR(*{REFACTORING_ID_MAX_LENGTH})

);

INSERT INTO "PUBLIC"."REFACTORINGS_UNDER_STUDY" (

  "USERNAME",

  "WORKSPACE_ID",

  "CODINGSPECTATOR_VERSION",

  "CODINGTRACKER_TIMESTAMP",

  "CODINGSPECTATOR_TIMESTAMP",

  "REFACTORING_ID"

)

SELECT

"AD"."USERNAME" AS "USERNAME",

"AD"."WORKSPACE_ID" AS "WORKSPACE_ID",

"AD"."CODINGSPECTATOR_VERSION" AS "CODINGSPECTATOR_VERSION",

"AD"."TIMESTAMP" AS "CODINGTRACKER_TIMESTAMP",

(SELECT "MPR"."CODINGSPECTATOR_TIMESTAMP" FROM
"PUBLIC"."MATCHED_PERFORMED_REFACTORINGS" "MPR" WHERE "MPR"."USERNAME" =
"USERNAME" AND "MPR"."WORKSPACE_ID" = "AD"."WORKSPACE_ID" AND
"MPR"."CODINGSPECTATOR_VERSION" = "AD"."CODINGSPECTATOR_VERSION" AND
"MPR"."CODINGTRACKER_TIMESTAMP" = "AD"."TIMESTAMP") AS
"CODINGSPECTATOR_TIMESTAMP",

"AD"."REFACTORING_ID" AS "REFACTORING_ID"

FROM "PUBLIC"."ALL_DATA" "AD"

WHERE IS_CODINGTRACKER_PERFORMED("AD"."RECORDER", "AD"."REFACTORING_KIND")

ORDER BY "USERNAME", "WORKSPACE_ID", "CODINGSPECTATOR_VERSION",
"CODINGTRACKER_TIMESTAMP", "REFACTORING_ID";

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =refactorings-under-study.csv

\x SELECT * FROM "PUBLIC"."REFACTORINGS_UNDER_STUDY"

\p Creating an index on "PUBLIC"."REFACTORINGS_UNDER_STUDY"

DROP INDEX "REFACTORINGS_UNDER_STUDY_INDEX" IF EXISTS;

CREATE INDEX "REFACTORINGS_UNDER_STUDY_INDEX" ON "PUBLIC"."REFACTORINGS_UNDER_STUDY" (

  "WORKSPACE_ID",

  "CODINGTRACKER_TIMESTAMP"

);

\p Gathering the contexts of refactorings under study

DROP TABLE "PUBLIC"."REFACTORINGS_UNDER_STUDY_CONTEXT" IF EXISTS;

CREATE TABLE "PUBLIC"."REFACTORINGS_UNDER_STUDY_CONTEXT" (

  "REFACTORING_ID_FIELD" VARCHAR(*{REFACTORING_ID_MAX_LENGTH}),

  "RECORDER_FIELD" VARCHAR(*{RECORDER_MAX_LENGTH}),

  "HUMAN_READABLE_TIMESTAMP_FIELD"
VARCHAR(*{HUMAN_READABLE_TIMESTAMP_MAX_LENGTH}),

  "TIMESTAMP_FIELD" VARCHAR(*{TIMESTAMP_MAX_LENGTH}),

  "USERNAME_FIELD" VARCHAR(*{USERNAME_MAX_LENGTH}),

  "WORKSPACE_ID_FIELD" VARCHAR(*{WORKSPACE_ID_MAX_LENGTH}),

  "CAPTURED_BY_CODINGSPECTATOR_FIELD"
VARCHAR(*{CAPTURED_BY_CODINGSPECTATOR_MAX_LENGTH}),

  "REFACTORING_KIND_FIELD" VARCHAR(*{REFACTORING_KIND_MAX_LENGTH}),

  "CODE_SNIPPET_WITH_SELECTION_MARKERS_FIELD"
VARCHAR(*{CODE_SNIPPET_WITH_SELECTION_MARKERS_MAX_LENGTH}),

  "CODINGSPECTATOR_VERSION_FIELD"
VARCHAR(*{CODINGSPECTATOR_VERSION_MAX_LENGTH}),

  "CODINGTRACKER_DESCRIPTION_FIELD"
VARCHAR(*{CODINGTRACKER_DESCRIPTION_MAX_LENGTH}),

  "COMMENT_FIELD" VARCHAR(*{COMMENT_MAX_LENGTH}),

  "DESCRIPTION_FIELD" VARCHAR(*{DESCRIPTION_MAX_LENGTH}),

  "STATUS_FIELD" VARCHAR(*{STATUS_MAX_LENGTH}),

  "INVOKED_BY_QUICKASSIST_FIELD" VARCHAR(*{INVOKED_BY_QUICKASSIST_MAX_LENGTH}),

  "INVOKED_THROUGH_STRUCTURED_SELECTION_FIELD"
VARCHAR(*{INVOKED_THROUGH_STRUCTURED_SELECTION_MAX_LENGTH}),

  "NAVIGATION_DURATION_FIELD" VARCHAR(*{NAVIGATION_DURATION_MAX_LENGTH}),

  "NAVIGATION_HISTORY_FIELD" VARCHAR(*{NAVIGATION_HISTORY_MAX_LENGTH})

);

INSERT INTO "PUBLIC"."REFACTORINGS_UNDER_STUDY_CONTEXT" (

  "REFACTORING_ID_FIELD",

  "RECORDER_FIELD",

  "HUMAN_READABLE_TIMESTAMP_FIELD",

  "TIMESTAMP_FIELD",

  "USERNAME_FIELD",

  "WORKSPACE_ID_FIELD",

  "CAPTURED_BY_CODINGSPECTATOR_FIELD",

  "REFACTORING_KIND_FIELD",

  "CODE_SNIPPET_WITH_SELECTION_MARKERS_FIELD",

  "CODINGSPECTATOR_VERSION_FIELD",

  "CODINGTRACKER_DESCRIPTION_FIELD",

  "COMMENT_FIELD",

  "DESCRIPTION_FIELD",

  "STATUS_FIELD",

  "INVOKED_BY_QUICKASSIST_FIELD",

  "INVOKED_THROUGH_STRUCTURED_SELECTION_FIELD",

  "NAVIGATION_DURATION_FIELD",

  "NAVIGATION_HISTORY_FIELD"

)

SELECT

'REFACTORING_ID:' || "REFACTORING_ID",

'RECORDER:' || "RECORDER",

'HUMAN_READABLE_TIMESTAMP:' || "HUMAN_READABLE_TIMESTAMP",

'TIMESTAMP:' || "TIMESTAMP",

'USERNAME:' || "USERNAME",

'WORKSPACE_ID:' || "WORKSPACE_ID",

'CAPTURED_BY_CODINGSPECTATOR:' || "CAPTURED_BY_CODINGSPECTATOR",

'REFACTORING_KIND:' || "REFACTORING_KIND",

'CODE_SNIPPET_WITH_SELECTION_MARKERS:' ||
"CODE_SNIPPET_WITH_SELECTION_MARKERS",

'CODINGSPECTATOR_VERSION:' || "CODINGSPECTATOR_VERSION",

'CODINGTRACKER_DESCRIPTION:' || "CODINGTRACKER_DESCRIPTION",

'COMMENT:' || "COMMENT",

'DESCRIPTION:' || "DESCRIPTION",

'STATUS:' || "STATUS",

'INVOKED_BY_QUICKASSIST:' || "INVOKED_BY_QUICKASSIST",

'INVOKED_THROUGH_STRUCTURED_SELECTION:' ||
"INVOKED_THROUGH_STRUCTURED_SELECTION",

'NAVIGATION_DURATION:' || "NAVIGATION_DURATION",

'NAVIGATION_HISTORY:' || "NAVIGATION_HISTORY"

FROM "PUBLIC"."ALL_DATA" "AD"

WHERE

EXISTS (

SELECT "RUS"."CODINGTRACKER_TIMESTAMP"

FROM "PUBLIC"."REFACTORINGS_UNDER_STUDY" "RUS"

WHERE "RUS"."WORKSPACE_ID" = "AD"."WORKSPACE_ID" AND 

ABS("RUS"."CODINGTRACKER_TIMESTAMP" - "AD"."TIMESTAMP") <=
*{TIME_WINDOW_IN_MINTUES} * 60 * 1000

)

ORDER BY "AD"."USERNAME", "AD"."WORKSPACE_ID", "AD"."TIMESTAMP";

* *DSV_COL_DELIM =\n

* *DSV_ROW_DELIM =\n\n_____________________________________________________\n\n

* *DSV_TARGET_FILE =refactorings-under-study-context.csv

\x SELECT * FROM "PUBLIC"."REFACTORINGS_UNDER_STUDY_CONTEXT"

