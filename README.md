# SQL Query Summary and Visualization Tool

This tool provides a comprehensive solution for analyzing, summarizing, and visualizing SQL queries. It calculates query complexity, formats SQL code, generates summaries, and creates query diagrams using Selenium.

---

## Features

1. **SQL Formatting**
   - Formats SQL queries for better readability.
   - Removes inline and block comments from SQL code.

2. **Query Analysis**
   - Counts occurrences of specific keywords (e.g., `SELECT`, `JOIN`, etc.).
   - Identifies query components like JOIN types, CTEs, subqueries, and nesting levels.
   - Generates a complexity score for SQL queries.

3. **Visualization**
   - Automates query diagram generation using Selenium and a web-based visualization tool.
   - Downloads the query diagrams directly to your system.

4. **Excel Summary Generation**
   - Creates an Excel file summarizing query analysis metrics for all input files.

---

## Installation

### Prerequisites
- **Python 3.10 or later**  
- Compatible browser driver (e.g., ChromeDriver for Google Chrome).  

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/Srujan-rai/Sql-parser
   cd Sql-parser
