### Aviation Delay Analytics

Live Dashboard: Coming soon

An end-to-end analytics project analysing flight operations data to identify delay patterns, cancellation trends, and operational bottlenecks.

This project simulates how airlines and airport operations teams can use data to monitor on-time performance, understand disruption drivers, and improve operational efficiency.

### Project Goals

- Analyse departure and arrival delay trends
- Identify the airports and airlines with the worst on-time performance
- Understand the operational causes of delays
- Measure cancellation rates and disruption hotspots
- Build a dashboard for monitoring flight performance metrics

### Tech Stack

- Python
- SQL
- PostgreSQL
- Pandas
- Matplotlib
- Streamlit

### Project Structure

- `data/` → raw, processed, and exported datasets
- `sql/` → schema design, transformation logic, and analysis queries
- `scripts/` → data ingestion, cleaning, loading, and analytics pipeline
- `dashboard/` → Streamlit dashboard application
- `assets/` → images and dashboard previews

### Data Source

This project uses airline on-time performance data from the U.S. Bureau of Transportation Statistics (BTS), which includes scheduled and actual departure and arrival times, cancellations, diversions, taxi times, and delay causes.

Link - https://www.transtats.bts.gov/DL_SelectFields.aspx?QO_fu146_anzr=b0-gvzr&gnoyr_VQ=FGJ&utm_source=chatgpt.com

### Why a US Aviation Dataset?

Ireland does not publicly release flight-level operational datasets containing departure delays, arrival delays, or delay causes. Most Irish aviation statistics are aggregated at the airport or passenger level.

To enable meaningful operational analysis, this project uses the Airline On-Time Performance dataset published by the U.S. Department of Transportation's Bureau of Transportation Statistics.

This dataset provides detailed flight-level records including delay durations, cancellation status, and delay causes, making it possible to analyse airline performance, airport congestion, and operational bottlenecks.

### Key Questions Answered

- Which airports experience the highest delays?
- Which airlines have the worst on-time performance?
- What are the most common causes of delays?
- How do delays vary across time, routes, and carriers?
- Where are cancellations most concentrated?

### Key Metrics

- On-time performance rate
- Average departure delay
- Average arrival delay
- Cancellation rate
- Delay cause contribution
- Airport and airline ranking by delay severity

### Pipeline Overview

- Ingest raw flight operations data
- Clean and transform records using Python
- Store structured data in PostgreSQL
- Create analytics tables and KPIs with SQL
- Power an interactive dashboard for business insights

### Dashboard Features

- KPI summary cards
- Delay trends over time
- Airport performance analysis
- Airline performance comparison
- Cancellation breakdown
- Delay cause analysis
- Route-level bottleneck insights

### Why This Project Matters

Flight delays affect customer satisfaction, operational cost, resource planning, and network reliability. This project shows how raw operational data can be transformed into actionable analytics for performance monitoring and decision-making.

### Future Improvements

- Add weather data enrichment
- Introduce route clustering and hub analysis
- Build a delay prediction model
- Add airport-level operational benchmarking

### Author

Vedant Limaye
