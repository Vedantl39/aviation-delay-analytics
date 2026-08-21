"""
BTS TranStats does not offer a simple public API — the Airline On-Time
Performance data is exported through an interactive, session-based form
at transtats.bts.gov, which can't be scripted with a plain HTTP request.

This file documents the manual steps used to produce
data/raw/flights_raw_sample.csv, rather than pretending an automated
download exists.

Steps:
  1. Go to https://www.transtats.bts.gov/DL_SelectFields.aspx?QO_fu146_anzr=b0-gvzr&gnoyr_VQ=FGJ
  2. Select the year/month range (this project uses January 2025)
  3. Select fields: YEAR, MONTH, FL_DATE, TAIL_NUM, OP_CARRIER_FL_NUM,
     ORIGIN + ORIGIN_* fields, DEST + DEST_* fields, DEP_TIME, DEP_DELAY,
     ARR_TIME, ARR_DELAY, CANCELLED, DIVERTED, DISTANCE, and the
     diversion fields
  4. Download as CSV, save to data/raw/flights_raw_sample.csv

Note: this export does NOT include an airline carrier identifier field
(OP_UNIQUE_CARRIER / OP_CARRIER) — only OP_CARRIER_FL_NUM (flight
number). To enable genuine airline-level comparison in a future version
of this project, re-run the export with OP_UNIQUE_CARRIER included as
a selected field.
"""

if __name__ == "__main__":
    print(__doc__)
