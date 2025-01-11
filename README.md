
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
   ```
2. Install the required libraries:
   ```bash
   pip install sqlparse pandas selenium argparse
   ```

## Usage

### Command-Line Arguments

| Argument           | Description                                                                                     |
|--------------------|-------------------------------------------------------------------------------------------------|
| `-s, --source`     | Path(s) to the source SQL file(s). Accepts multiple files. **(Required)**                       |
| `-d, --destination`| Destination directory for output files. Defaults to the current directory.                      |
| `-type, --type`    | Specify the database type (`mysql`, `postgresql`, `oracle`). **(Required)**                     |
| `-graph, --graphs` | Enable query diagram generation. Requires a compatible browser and driver.                      |

### Example Usage
1. Basic usage for query analysis:
   ```bash
   python main.py --source queries.sql --type mysql
   ```

2. Analyze multiple files and save the output to a specific directory:
   ```bash
   python main.py --source query1.sql query2.sql --destination ./output --type postgresql
   ```

3. Generate query diagrams along with analysis:
   ```bash
   python main.py --source queries.sql --type mysql --graphs
   ```

---

## Output
- **Formatted SQL**: A new file with the formatted query.
- **Analysis Summary**: An Excel file with query metrics.
- **Query Diagrams**: Visual representation of queries (optional, when `--graphs` is used).

---

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork this repository.
2. Create a new branch (`feature/your-feature`).
3. Commit your changes.
4. Push to your branch and open a pull request.

---

## License
This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgments
Special thanks to the contributors and open-source libraries used in this project:
- `sqlparse`
- `pandas`
- `selenium`
- `argparse`
```

Copy this content directly into your `README.md` file. Replace `<repository-url>` with your actual repository URL.
