# Aviation Delay Analytics

An end-to-end analytics project analysing US domestic flight operations data to identify delay patterns, cancellation trends, and operational bottlenecks — built to mirror how an airline or airport operations team would monitor on-time performance.

**Status:** functional end-to-end pipeline (clean → SQLite → SQL marts → dashboard). Run locally with the steps below.

## Scope note (read this before the numbers)

This dataset covers **4,998 flights over a single month** (January 2025), pulled from the BTS On-Time Performance database — a demo-scale extract, not a full-year dataset. Treat the findings below as a demonstration of the method (dimensional modelling → SQL marts → dashboard), not as a robust year-round delay pattern.

Also: the BTS export used here does **not** include an airline carrier identifier (no `OP_UNIQUE_CARRIER` field) — only a flight-number field. Flight number is not a reliable proxy for airline identity, so this project deliberately does **not** claim airline-level comparisons ("which airline is worst") — that would require re-pulling the data with the carrier field included. Airport- and route-level analysis, which the data does support well, is the focus instead.

## Project Goals

- Analyse departure and arrival delay trends
- Identify the airports and routes with the worst on-time performance
- Understand cancellation and diversion patterns
- Explore how flight distance relates to delay
- Provide an interactive dashboard for exploring the above

## Tech Stack

Python, SQL (SQLite), Pandas, Streamlit, Plotly

## Data Source

U.S. Bureau of Transportation Statistics (BTS), Airline On-Time Performance data.
https://www.transtats.bts.gov/DL_SelectFields.aspx?QO_fu146_anzr=b0-gvzr&gnoyr_VQ=FGJ

### Why a US dataset?

Ireland doesn't publicly release flight-level operational data (departure/arrival delays, delay causes) — Irish aviation stats are aggregated at airport/passenger level. BTS publishes detailed flight-level records, which is what this kind of analysis needs.

## Project Structure

```
aviation-delay-analytics/
├── data/
│   ├── raw/                  # raw BTS extract
│   └── processed/            # cleaned CSV + SQLite db (built by the pipeline)
├── sql/
│   ├── schema.sql            # fact/dimension table definitions
│   ├── marts.sql             # dimension loads + summary tables
│   └── analysis_queries.sql  # 15 business questions as SQL
├── scripts/
│   ├── clean_flights_data.py     # raw -> cleaned CSV
│   └── load_to_postgres.py       # cleaned CSV -> SQLite, runs schema + marts
├── dashboard/
│   └── app.py                # Streamlit dashboard
└── assets/                   # dashboard preview image
```

(The loader script is named `load_to_postgres.py` for historical reasons — it currently targets SQLite for a zero-setup local demo. The SQL in `schema.sql`/`marts.sql` is written portably enough to point at a real Postgres instance instead, if needed — swap the connection string in that script.)

## Data Quality Note

The raw BTS export includes a large trailing block of fully blank rows (214,202 total rows, but only 4,998 carry real data) — a known quirk of TranStats CSV downloads. The cleaning script drops these explicitly rather than silently, and reports the real row count on each run.

## Running this project

```bash
pip install -r requirements.txt

# 1. Clean the raw data
python scripts/clean_flights_data.py

# 2. Build the SQLite db, load data, run schema + marts
python scripts/load_to_postgres.py

# 3. (optional) explore the SQL layer directly
sqlite3 data/processed/aviation.db < sql/analysis_queries.sql

# 4. Launch the dashboard
streamlit run dashboard/app.py
```

## Dashboard

Four views: airport performance (worst/busiest origin & destination airports, with a minimum-flights filter), route analysis (worst-delayed and most-cancelled routes), distance-band delay comparison, and a raw data explorer.

## Key Findings (from this month's data)

- Overall on-time rate (arrivals within 15 min): ~85%
- Cancellation rate: ~0.5% for the month
- Departure delays and arrival delays are concentrated in a small number of airports/routes rather than spread evenly — consistent with hub congestion effects
- Medium-haul flights (500–1500mi) show somewhat higher average delay than short- or long-haul in this sample

## Future Improvements

- Re-pull BTS data with the carrier identifier field included, to enable genuine airline-level comparison
- Extend to a full year of data to test whether findings hold beyond a single month
- Add weather data enrichment
- Build a delay prediction model

## Author

Vedant Limaye
