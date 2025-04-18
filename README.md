# MySQL Bicycle Retail Supply Chain Analysis

## Overview
This project analyzes a bicycle retail supply chain using a MySQL database, focusing on product, customer, and order data to improve operational efficiency. Advanced SQL techniques (JOINs, subqueries, window functions) were used to identify top revenue-generating stores, optimize shipping times through simulated store allocation, and analyze repeat customers and high-demand product categories by state to guide inventory and marketing strategies.

## Features
- **Revenue Analysis**: Identifies top revenue-generating stores using JOINs and aggregations for strategic planning.
- **Shipping Optimization**: Simulates store allocation to optimize shipping times based on order fulfillment metrics.
- **Customer Insights**: Analyzes repeat customers and high-demand product categories by state using subqueries and window functions.
- **SQL Techniques**: Leverages advanced SQL (e.g., JOINs, subqueries, ROW_NUMBER) for efficient querying.

## Setup
1. **Prerequisites**:
   - MySQL Server (8.0 or later recommended)
   - MySQL Workbench or any SQL client (e.g., DBeaver, phpMyAdmin)
2. **Clone the Repository**:
3. **Set Up the Database**:
- Open MySQL Workbench (or your SQL client) and connect to your MySQL server.
- Create a new database:
  ```sql
  CREATE DATABASE bicycle_retail;
  USE bicycle_retail;
  ```
- The dataset is anonymized and not included (to protect privacy). The schema includes tables like `products`, `customers`, `orders`, and `stores`. A schema diagram is provided in `screenshots/schema_diagram.png`.
4. **Run the SQL Script**:
- Open `Bicycle_Retail_Analysis.sql` in MySQL Workbench.
- Execute the script to run queries and view results (assumes tables are pre-populated with dummy data).

## Usage
1. **Run the Queries**:
- Open `Bicycle_Retail_Analysis.sql` in your SQL client.
- Execute queries sequentially to analyze the supply chain:
  - **Revenue by Store**: Identifies top revenue-generating stores.
  - **Shipping Optimization**: Simulates store allocation to reduce shipping times.
  - **Customer and Demand Analysis**: Finds repeat customers and high-demand product categories by state.
2. **View Results**:
- Results are displayed in your SQL client (e.g., MySQL Workbench’s result grid).
- Screenshots of key outputs (e.g., top stores, repeat customers) are in the `screenshots/` folder.
3. **Apply Insights**:
- Use findings to inform inventory allocation, marketing strategies, and shipping optimization in a retail supply chain context.

## File Structure
- `Bicycle_Retail_Analysis.sql`: SQL script containing all queries for analysis.
- `screenshots/`: Folder containing result screenshots (e.g., `top_stores.png`, `repeat_customers.png`) and schema diagram (`schema_diagram.png`).
- `README.md`: This file.

## Limitations
- **Sanitized Data**: The dataset is not included (anonymized for privacy). Users must populate the database with their own data matching the schema.
- **MySQL Dependency**: Queries are written for MySQL; syntax may vary in other SQL databases (e.g., PostgreSQL, SQLite).
- **Static Analysis**: Queries are pre-written for the bicycle retail dataset; users must modify them for different datasets.

