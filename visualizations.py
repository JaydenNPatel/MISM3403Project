# Import libraries
import pandas as pd
import matplotlib
matplotlib.use("Agg")   # Use non-GUI backend (saves plots as files)
import matplotlib.pyplot as plt
import seaborn as sns
import os

print("Current working directory:", os.getcwd())

# Set style for consistency across slides
sns.set_theme(style="whitegrid", palette="muted")

# Read in all csvs
ticket_sales = pd.read_csv("datasets/ticket_sales.table.csv")
games = pd.read_csv("datasets/games.table.csv")
staff_history = pd.read_csv("datasets/staff_history.table.csv")
roster = pd.read_csv("datasets/roster.table.csv")
injuries = pd.read_csv("datasets/injuries.table.csv")
jersey_sales = pd.read_csv("datasets/jersey_sales.table.csv")
coaches = pd.read_csv("datasets/coaches.table.csv")

# Ticket Sales Revenue by Game Date
ticket_sales['purchase_date'] = pd.to_datetime(ticket_sales['purchase_date'])
sales_by_date = (
    ticket_sales.groupby('purchase_date')['total_price']
    .sum()
    .reset_index()
    .sort_values('purchase_date')
)

plt.figure(figsize=(12,6))
sns.barplot(data=sales_by_date, x='purchase_date', y='total_price', color='steelblue')
plt.title("Ticket Sales Revenue by Game Date", fontsize=16)
plt.xlabel("Game Date")
plt.ylabel("Revenue ($)")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("visualizations/ticket_sales_by_game_date.png", dpi=300)

# Giveaway vs Non-Giveaway Ticket Revenue
revenue_by_promo = (
    ticket_sales.groupby('is_giveaway_night')['total_price']
    .sum()
    .reset_index()
)

# Map labels for clarity
revenue_by_promo['Promo_Type'] = revenue_by_promo['is_giveaway_night'].map({
    1: "Giveaway Night",
    0: "Non-Giveaway Night"
})

plt.figure(figsize=(8,6))
sns.barplot(data=revenue_by_promo, x='Promo_Type', y='total_price', palette="Set2")
plt.title("Impact of Giveaway Nights on Ticket Revenue", fontsize=16)
plt.xlabel("")
plt.ylabel("Total Revenue ($)")

# Annotate bars with values
for index, row in revenue_by_promo.iterrows():
    plt.text(index, row['total_price'] + 200, f"${row['total_price']:,.0f}", 
             ha='center', fontsize=12, weight='bold')

plt.tight_layout()
plt.savefig("visualizations/giveaway_vs_non.png", dpi=300)

# Visualization: Jersey Revenue by Type

# Aggregate revenue by jersey type
revenue_by_type = (
    jersey_sales.groupby("jersey_type")["price"]
    .sum()
    .reset_index()
    .sort_values("price", ascending=False)
)

# Plot
plt.figure(figsize=(8,6))
sns.barplot(data=revenue_by_type, x="price", y="jersey_type", palette="crest")
plt.title("Jersey Revenue by Type", fontsize=16)
plt.xlabel("Total Revenue ($)")
plt.ylabel("Jersey Type")
plt.tight_layout()
plt.savefig("visualizations/jersey_revenue_by_type.png", dpi=300)


# Visualization: Top 5 Jersey Sellers by Revenue (No Labels)

# Aggregate revenue per player
top_sellers = (
    jersey_sales.groupby("player_id")["price"]
    .sum()
    .reset_index()
    .merge(roster[["player_id", "first_name", "last_name"]], on="player_id")
)

top_sellers["player_name"] = top_sellers["first_name"] + " " + top_sellers["last_name"]
top_sellers = top_sellers.sort_values("price", ascending=False).head(5)

# Plot
plt.figure(figsize=(10,6))
sns.barplot(data=top_sellers, x="price", y="player_name", palette="Blues_r")
plt.title("Top 5 Jersey Sellers by Revenue", fontsize=16)
plt.xlabel("Total Revenue ($)")
plt.ylabel("Player")
plt.tight_layout()
plt.savefig("visualizations/top5_jersey_sellers.png", dpi=300)



# Ticket Sales by Section
section_sales = ticket_sales.groupby('section')['total_price'].sum().reset_index()

plt.figure(figsize=(12,6))
sns.barplot(data=section_sales, x='section', y='total_price', palette="viridis")
plt.title("Ticket Sales Revenue by Section", fontsize=16)
plt.xlabel("Arena Section")
plt.ylabel("Revenue ($)")
plt.xticks(rotation=90)
plt.tight_layout()
plt.savefig("visualizations/ticket_sales_by_section.png", dpi=300)

# Visualization: Total Jersey Sales per Player

# Aggregate jersey sales count and revenue per player
sales_per_player = (
    jersey_sales.groupby("player_id")
    .agg(jerseys_sold=("sale_id", "count"), total_revenue=("price", "sum"))
    .reset_index()
    .merge(roster[["player_id", "first_name", "last_name"]], on="player_id")
)

# Add full name
sales_per_player["player_name"] = sales_per_player["first_name"] + " " + sales_per_player["last_name"]

# Sort by total revenue
sales_per_player = sales_per_player.sort_values("total_revenue", ascending=False)

# Plot
plt.figure(figsize=(10,6))
sns.barplot(data=sales_per_player, x="total_revenue", y="player_name", palette="viridis")
plt.title("Total Jersey Sales per Player", fontsize=16)
plt.xlabel("Total Revenue ($)")
plt.ylabel("Player")
plt.tight_layout()
plt.savefig("visualizations/jersey_sales_per_player.png", dpi=300)


# -----------------------------
# Visualization: Most Profitable Day (Tickets + Jerseys)
# -----------------------------
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
ticket_sales = pd.read_csv("datasets/ticket_sales.table.csv")
jersey_sales = pd.read_csv("datasets/jersey_sales.table.csv")

# Convert dates
ticket_sales['purchase_date'] = pd.to_datetime(ticket_sales['purchase_date'])
jersey_sales['transaction_date'] = pd.to_datetime(jersey_sales['transaction_date'])

# Combine into one dataframe
ticket_rev = ticket_sales[['purchase_date','total_price']].rename(columns={'purchase_date':'date','total_price':'ticket_revenue'})
jersey_rev = jersey_sales[['transaction_date','price']].rename(columns={'transaction_date':'date','price':'jersey_revenue'})

combined = pd.concat([
    ticket_rev.assign(jersey_revenue=0),
    jersey_rev.assign(ticket_revenue=0)
])

# Aggregate by date
daily_revenue = combined.groupby('date').sum().reset_index()
daily_revenue['total_revenue'] = daily_revenue['ticket_revenue'] + daily_revenue['jersey_revenue']

# Identify most profitable day
max_day = daily_revenue.loc[daily_revenue['total_revenue'].idxmax()]

# Plot
plt.figure(figsize=(12,6))
sns.barplot(data=daily_revenue, x='date', y='total_revenue', color='steelblue')

# Highlight most profitable day in red
plt.bar(max_day['date'], max_day['total_revenue'], color='crimson')

plt.title("Most Profitable Day (Tickets + Jerseys)", fontsize=16)
plt.xlabel("Date")
plt.ylabel("Total Revenue ($)")
plt.xticks(rotation=45)

# Annotate the highlighted bar
plt.text(max_day['date'], max_day['total_revenue'] + 100,
         f"Most Profitable: {max_day['date'].date()} (${max_day['total_revenue']:,.2f})",
         ha='center', fontsize=12, weight='bold', color='crimson')

plt.tight_layout()
plt.savefig("visualizations/most_profitable_day.png", dpi=300)