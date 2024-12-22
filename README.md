# Advanced SQL Query Project  

This project showcases a series of SQL queries written to analyze and extract meaningful insights from a dataset, particularly in the context of a music business scenario. The queries range from basic to advanced levels, employing techniques like CTEs, window functions, and recursive queries.

## Features  

### Beginner-Level Queries:
1. **Senior-most Employee:** Identifies the senior-most employee based on hire date.  
2. **Countries with Most Invoices:** Lists countries by invoice count in descending order.  
3. **Top Invoice Values:** Retrieves the top three invoice totals.  
4. **City with Highest Revenue:** Determines the city with the maximum total revenue.  
5. **Best Customer:** Finds the customer who spent the most.

### Moderate-Level Queries:
1. **Rock Music Listeners:** Fetches all customers who listen to Rock music, ordered by email.  
2. **Top Rock Artists:** Identifies the top 10 artists based on the number of Rock tracks.  
3. **Longest Tracks:** Lists all tracks with durations longer than the average song length.

### Advanced-Level Queries:
1. **Customer Spending on Artists:** Calculates the total amount spent by each customer on the best-selling artist.  
2. **Popular Genres by Country:** Determines the most popular music genre for each country.  
3. **Top Customers by Country:** Identifies the top-spending customer in each country.

## Techniques Used
- **JOINS:** For combining data across multiple tables.
- **Common Table Expressions (CTEs):** Simplifying complex query logic.
- **Window Functions:** For ranking and aggregating data within partitions.
- **Recursive Queries:** For hierarchical and iterative data analysis.
- **Aggregations:** Using SUM, COUNT, and AVG for data summarization.
- **Subqueries:** To filter and refine data further.

## Dataset Overview
The dataset includes tables such as `employee`, `invoice`, `customer`, `track`, `album`, `artist`, `genre`, and `invoice_line`. It simulates a music database that tracks customer purchases, artist contributions, and genre popularity.

## How to Use
1. Clone the repository:  
   ```bash
   git clone https://github.com/username/sql-music-insights.git
2. Import the dataset into your SQL environment.
3. Execute the queries in the provided order or based on the specific insights you're looking for.

## Sample Query
```sql
-- Identify the city with the highest revenue
SELECT SUM(total) AS revenue, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY revenue DESC
LIMIT 1;
```

## Feedback  
I'd love to hear your thoughts and suggestions for improvement. Feel free to reach out or open an issue in this repository.  


**Author:** Atul Dharnia  
**Connect with me:** [LinkedIn Profile](https://www.linkedin.com/in/atul-dharnia-b2b210222/)  


