"""
Aviation Delay Analytics — Dashboard

Run with:
    streamlit run dashboard/app.py
"""
import sqlite3
from pathlib import Path

import pandas as pd
import plotly.express as px
import streamlit as st

DB_PATH = Path(__file__).resolve().parent.parent / "data" / "processed" / "aviation.db"

st.set_page_config(page_title="Aviation Delay Analytics", page_icon="airplane", layout="wide")


@st.cache_data
def load_tables():
    conn = sqlite3.connect(DB_PATH)
    fact = pd.read_sql_query("SELECT * FROM fact_flights", conn)
    origin = pd.read_sql_query("SELECT * FROM mart_origin_airport_performance", conn)
    dest = pd.read_sql_query("SELECT * FROM mart_destination_airport_performance", conn)
    route = pd.read_sql_query("SELECT * FROM mart_route_performance", conn)
    conn.close()
    return fact, origin, dest, route


fact, origin, dest, route = load_tables()

st.title("Aviation Delay Analytics")
st.caption(
    "US domestic flight operations — BTS On-Time Performance data, January 2025. "
    "SQL-modelled (SQLite) with a Python analytics layer on top."
)

st.info(
    "**Scope note:** this dataset covers **4,998 flights over a single month** "
    "(January 2025) — a demo-scale pull from BTS, not a full-year dataset. "
    "Treat findings as illustrative of the method, not as a robust year-round "
    "delay pattern. Also: the flight-number field in this BTS export is **not** "
    "an airline identifier, so airline-level comparisons aren't shown here — "
    "see the README for why."
)

total_flights = len(fact)
cancelled = fact["cancelled"].sum()
on_time_rate = 1 - fact["is_delayed_15"].mean()
avg_arr_delay = fact.loc[fact["cancelled"] == 0, "arrival_delay"].mean()

c1, c2, c3, c4 = st.columns(4)
c1.metric("Total flights", f"{total_flights:,}")
c2.metric("Cancellation rate", f"{cancelled/total_flights*100:.2f}%")
c3.metric("On-time rate (< 15 min)", f"{on_time_rate*100:.1f}%")
c4.metric("Avg arrival delay", f"{avg_arr_delay:.1f} min")

st.divider()

tab1, tab2, tab3, tab4 = st.tabs(["Airport performance", "Routes", "Distance bands", "Explore raw data"])

with tab1:
    left, right = st.columns(2)
    min_flights = st.slider("Minimum flights to include an airport", 1, 20, 5)

    with left:
        worst_origin = (
            origin[origin["total_flights"] >= min_flights]
            .sort_values("avg_departure_delay", ascending=False)
            .head(10)
        )
        fig = px.bar(
            worst_origin, x="origin_airport", y="avg_departure_delay",
            title="Worst origin airports — avg departure delay (min)",
            color="avg_departure_delay", color_continuous_scale="Reds",
        )
        st.plotly_chart(fig, use_container_width=True)

    with right:
        worst_dest = (
            dest[dest["total_flights"] >= min_flights]
            .sort_values("avg_arrival_delay", ascending=False)
            .head(10)
        )
        fig2 = px.bar(
            worst_dest, x="destination_airport", y="avg_arrival_delay",
            title="Worst destination airports — avg arrival delay (min)",
            color="avg_arrival_delay", color_continuous_scale="Reds",
        )
        st.plotly_chart(fig2, use_container_width=True)

    busiest = origin.sort_values("total_flights", ascending=False).head(15)
    fig3 = px.bar(busiest, x="origin_airport", y="total_flights", title="Busiest origin airports (by flight count)")
    st.plotly_chart(fig3, use_container_width=True)

with tab2:
    min_route_flights = st.slider("Minimum flights to include a route", 1, 10, 3, key="route_slider")
    route_f = route[route["total_flights"] >= min_route_flights].copy()
    route_f["route"] = route_f["origin_airport"] + " -> " + route_f["destination_airport"]

    left, right = st.columns(2)
    with left:
        worst_routes = route_f.sort_values("avg_arrival_delay", ascending=False).head(15)
        fig4 = px.bar(worst_routes, x="route", y="avg_arrival_delay", title="Worst routes — avg arrival delay (min)")
        fig4.update_xaxes(tickangle=45)
        st.plotly_chart(fig4, use_container_width=True)

    with right:
        cancelled_routes = route_f.sort_values("cancellation_rate", ascending=False).head(15)
        fig5 = px.bar(
            cancelled_routes, x="route", y="cancellation_rate",
            title="Most-cancelled routes", color_discrete_sequence=["#c44e52"],
        )
        fig5.update_xaxes(tickangle=45)
        fig5.update_yaxes(tickformat=".0%")
        st.plotly_chart(fig5, use_container_width=True)

with tab3:
    dist_df = fact.copy()
    dist_df["distance_band"] = pd.cut(
        dist_df["distance"], bins=[0, 500, 1500, dist_df["distance"].max()],
        labels=["Short-haul (<500mi)", "Medium-haul (500-1500mi)", "Long-haul (>1500mi)"],
    )
    band_summary = (
        dist_df.groupby("distance_band", observed=True)
        .agg(
            total_flights=("flight_number", "count"),
            avg_departure_delay=("departure_delay", "mean"),
            avg_arrival_delay=("arrival_delay", "mean"),
            cancellation_rate=("cancelled", "mean"),
        )
        .reset_index()
    )
    fig6 = px.bar(
        band_summary, x="distance_band", y=["avg_departure_delay", "avg_arrival_delay"],
        barmode="group", title="Average delay by flight distance band",
    )
    st.plotly_chart(fig6, use_container_width=True)
    st.dataframe(band_summary.style.format({"cancellation_rate": "{:.2%}"}))

with tab4:
    st.markdown("Raw flight-level records (first 500 rows) — the same table the SQL marts are built on.")
    st.dataframe(fact.head(500))
