# Import libraries I need for data wrangling + plotting
import pandas as pd
import matplotlib
matplotlib.use("Agg")   # make sure plots save to files instead of trying to open a window
import matplotlib.pyplot as plt
import seaborn as sns
import os

# quick check: confirm where this script is running from
print("Current working directory:", os.getcwd())

# set a consistent look for all charts (white grid + muted colors)
sns.set_theme(style="whitegrid", palette="muted")

# Read in all the CSVs I’ll be using
# -----------------------------
ticket_sales = pd.read_csv("datasets/ticket_sales.table.csv")
games = pd.read_csv("datasets/games.table.csv")
staff_history = pd.read_csv("datasets/staff_history.table.csv")
roster = pd.read_csv("datasets/roster.table.csv")
injuries = pd.read_csv("datasets/injuries.table.csv")
jersey_sales = pd.read_csv("datasets/jersey_sales.table.csv")
coaches = pd.read_csv("datasets/coaches.table.csv")

# Ticket Sales Revenue by Game Date
# -----------------------------
# convert purchase_date to datetime so I can group by actual dates
ticket_sales['purchase_date'] = pd.to_datetime(ticket_sales['purchase_date'])

# group ticket revenue by date
sales_by_date = (
    ticket_sales.groupby('purchase_date')['total_price']
    .sum()
    .reset_index()
    .sort_values('purchase_date')
)

# plot ticket revenue over time
plt.figure(figsize=(12,6))
sns.barplot(data=sales_by_date, x='purchase_date', y='total_price', color='steelblue')
plt.title("Ticket Sales Revenue by Game Date", fontsize=16)
plt.xlabel("Game Date")
plt.ylabel("Revenue ($)")
plt.xticks(rotation=45)  # rotate dates so they don’t overlap
plt.tight_layout()
plt.savefig("visualizations/ticket_sales_by_game_date.png", dpi=300)

# Giveaway vs Non-Giveaway Ticket Revenue
# -----------------------------
# compare revenue between promo nights vs normal nights
revenue_by_promo = (
    ticket_sales.groupby('is_giveaway_night')['total_price']
    .sum()
    .reset_index()
)

# map 0/1 into readable labels
revenue_by_promo['Promo_Type'] = revenue_by_promo['is_giveaway_night'].map({
    1: "Giveaway Night",
    0: "Non-Giveaway Night"
})

# plot comparison
plt.figure(figsize=(8,6))
sns.barplot(data=revenue_by_promo, x='Promo_Type', y='total_price', palette="Set2")
plt.title("Impact of Giveaway Nights on Ticket Revenue", fontsize=16)
plt.xlabel("")
plt.ylabel("Total Revenue ($)")

# annotate each bar with the actual revenue number
for index, row in revenue_by_promo.iterrows():
    plt.text(index, row['total_price'] + 200, f"${row['total_price']:,.0f}", 
             ha='center', fontsize=12, weight='bold')

plt.tight_layout()
plt.savefig("visualizations/giveaway_vs_non.png", dpi=300)


# Jersey Revenue by Type
# -----------------------------
# figure out which jersey styles (home/away/city/classic) bring in the most money
revenue_by_type = (
    jersey_sales.groupby("jersey_type")["price"]
    .sum()
    .reset_index()
    .sort_values("price", ascending=False)
)

plt.figure(figsize=(8,6))
sns.barplot(data=revenue_by_type, x="price", y="jersey_type", palette="crest")
plt.title("Jersey Revenue by Type", fontsize=16)
plt.xlabel("Total Revenue ($)")
plt.ylabel("Jersey Type")
plt.tight_layout()
plt.savefig("visualizations/jersey_revenue_by_type.png", dpi=300)


# Top 5 Jersey Sellers by Revenue
# -----------------------------
# aggregate jersey revenue per player and merge with roster for names
top_sellers = (
    jersey_sales.groupby("player_id")["price"]
    .sum()
    .reset_index()
    .merge(roster[["player_id", "first_name", "last_name"]], on="player_id")
)

# add full name column
top_sellers["player_name"] = top_sellers["first_name"] + " " + top_sellers["last_name"]

# sort and keep top 5
top_sellers = top_sellers.sort_values("price", ascending=False).head(5)

# plot top 5 jersey sellers
plt.figure(figsize=(10,6))
sns.barplot(data=top_sellers, x="price", y="player_name", palette="Blues_r")
plt.title("Top 5 Jersey Sellers by Revenue", fontsize=16)
plt.xlabel("Total Revenue ($)")
plt.ylabel("Player")
plt.tight_layout()
plt.savefig("visualizations/top5_jersey_sellers.png", dpi=300)


# Ticket Sales by Section
# -----------------------------
# break down ticket revenue by arena section (floor, lower bowl, upper bowl, etc.)
section_sales = ticket_sales.groupby('section')['total_price'].sum().reset_index()

plt.figure(figsize=(12,6))
sns.barplot(data=section_sales, x='section', y='total_price', palette="viridis")
plt.title("Ticket Sales Revenue by Section", fontsize=16)
plt.xlabel("Arena Section")
plt.ylabel("Revenue ($)")
plt.xticks(rotation=90)  # rotate section labels so they fit
plt.tight_layout()
plt.savefig("visualizations/ticket_sales_by_section.png", dpi=300)


# Total Jersey Sales per Player
# -----------------------------
# count jerseys sold + total revenue per player
sales_per_player = (
    jersey_sales.groupby("player_id")
    .agg(jerseys_sold=("sale_id", "count"), total_revenue=("price", "sum"))
    .reset_index()
    .merge(roster[["player_id", "first_name", "last_name"]], on="player_id")
)

# add full name column
sales_per_player["player_name"] = sales_per_player["first_name"] + " " + sales_per_player["last_name"]

# sort by revenue so biggest sellers are at the top
sales_per_player = sales_per_player.sort_values("total_revenue", ascending=False)

# plot jersey sales per player
plt.figure(figsize=(10,6))
sns.barplot(data=sales_per_player, x="total_revenue", y="player_name", palette="viridis")
plt.title("Total Jersey Sales per Player", fontsize=16)
plt.xlabel("Total Revenue ($)")
plt.ylabel("Player")
plt.tight_layout()
plt.savefig("visualizations/jersey_sales_per_player.png", dpi=300)
