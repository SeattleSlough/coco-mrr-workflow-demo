coco-mrr-workflow-demo
A small dbt project used to test whether Snowflake Cortex Code's live account access produces a measurable advantage over a schema-blind AI assistant, across three scenarios: building a model from scratch, evolving it with a new requirement, and reasoning about the impact of a schema change.

Full write-up with methodology, results, and findings: TBD (link once published)
What's here
A SaaS billing dataset (customers, subscriptions, plan_changes, invoices, cancellations, refunds) and a dbt project computing monthly recurring revenue (MRR) from it. Each experiment below was run twice, once by a schema-blind AI (a general-purpose LLM given only static files, no account access) and once by CoCo (with live access to the actual Snowflake account), from the same starting point, in separate branches.
Branches
Branch
Contents
main
Schema setup + the Pillar 1 CoCo baseline, merged
act1-manual
Pillar 1 (Build), schema-blind arm
act1-coco
Pillar 1 (Build), CoCo arm
act2-manual
Pillar 2 (Evolve), schema-blind arm
act2-coco
Pillar 2 (Evolve), CoCo arm


Pillar 3 (Understand) was a live query/reasoning session against the act1-coco schema rather than a build, so it isn't a separate branch. See the write-up for that transcript.

To see exactly what changed between a schema-blind build and a CoCo build for a given pillar:

git diff act1-manual act1-coco
git diff act2-manual act2-coco
Setup
Requires:

A Snowflake account with a warehouse and a database you can create objects in
dbt-core with the Snowflake adapter (pip install dbt-core dbt-snowflake)
A ~/.dbt/profiles.yml pointing at your account (see sql/schema.sql for the database/schema this project expects)
For the CoCo branches: Cortex Code, configured with a valid Snowflake connection
Running it
Create the schema and seed data (run once, in Snowsight or via your preferred SQL client):

sql/schema.sql

Clone and check out whichever branch you want to inspect or run:

git clone https://github.com/SeattleSlough/coco-mrr-workflow-demo
cd coco-mrr-workflow-demo
git checkout <branch-name>

Confirm your connection and build the models:

dbt debug
dbt run

Verify the result:

SELECT * FROM ANALYTICS.MONTHLY_RECURRING_REVENUE ORDER BY month;
Notes
The two build pillars (1 and 2) are timing comparisons; Pillar 3 is a capability comparison (can the model verify its answer against live data, not just reason about it). See the write-up for why that distinction matters and why the two are tested differently.
One real spec ambiguity surfaced during Pillar 1 (whether a subscription's cancellation month counts toward that month's MRR). Both arms made different, individually defensible calls on it. The write-up covers the fix and the broader lesson about underspecified requirements.