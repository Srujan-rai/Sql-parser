
# SQL Query Summary and Visualization Tool  

SQL queries often grow complex as they scale, making them challenging to read, optimize, and debug. Developers and analysts frequently encounter issues such as:  
- Poorly formatted or undocumented queries that hinder collaboration.  
- Difficulty understanding query structures and components, such as joins, subqueries, or Common Table Expressions (CTEs).  
- Lack of visualization tools to optimize query flow and identify bottlenecks.  
- Absence of automated systems to generate meaningful summaries and assess complexity across multiple queries.  

---

## **Problem Statement**  

This tool addresses the following key challenges:  
1. **Improved Readability**: Automates SQL formatting to enhance maintainability.  
2. **Comprehensive Insights**: Extracts critical metrics like joins, subqueries, and nesting levels to evaluate query complexity.  
3. **Enhanced Visualization**: Generates diagrams for clear representation of query flow.  
4. **Automated Reporting**: Creates Excel-based summaries, saving time and aiding documentation.  

---

## **Objectives**  

1. **Streamline Documentation**: Automatically format and summarize SQL queries for better clarity.  
2. **Facilitate Optimization**: Provide insights into query components to identify bottlenecks and optimize performance.  
3. **Enable Visualization**: Create diagrams representing query logic and flow for improved understanding.  
4. **Batch Processing**: Analyze multiple queries simultaneously and save outputs efficiently.  

---

## **Key Features**  

### 1. **SQL Query Formatting**  
- Automatically reformats queries for enhanced readability.  
- Removes inline and block comments to focus on core logic.  
- Ensures adherence to consistent coding standards.  

### 2. **Query Analysis**  
- Detects key SQL components, including:  
  - **Join Types**: INNER, LEFT, RIGHT, FULL.  
  - **CTEs** and their usage.  
  - **Subqueries** with nesting levels.  
- Calculates a **complexity score** based on the structure and components.  

### 3. **Visualization**  
- Automatically generates query diagrams using Selenium.  
- Integrates with web-based tools (e.g., dbdiagram.io).  
- Saves diagrams in image or PDF formats for easy sharing.  

### 4. **Excel-Based Summaries**  
- Compiles query metrics, including join counts, nesting levels, and complexity scores, into structured Excel files.  
- Enables bulk analysis and comprehensive reporting.  

---

## **Technical Overview**  

### **Core Components**  

1. **SQL Parsing and Formatting**  
   - Utilizes the `sqlparse` library for parsing and reformatting SQL queries.  
   - Strips comments and enforces consistent formatting.  

2. **Component Analysis**  
   - Detects SQL keywords, joins, subqueries, and other elements using string parsing and regular expressions.  

3. **Complexity Scoring**  
   - Assigns scores based on factors such as table joins, query length, and subquery levels.  

4. **Visualization Automation**  
   - Uses Selenium to interact with web-based visualization tools.  
   - Supports headless browser execution for seamless automation in CI/CD pipelines.  

5. **Excel File Generation**  
   - Leverages `pandas` to organize query metrics into structured data.  
   - Exports detailed reports in Excel format.  

---

## **Installation**  

### **Prerequisites**  
- **Python 3.10 or later**  
- Compatible browser driver (e.g., ChromeDriver for Google Chrome).  

### **Installation Steps**  
1. Clone the repository:  
   ```bash  
   git clone https://github.com/Srujan-rai/Sql-parser  
   cd Sql-parser  
   ```  
2. Install the required libraries:  
   ```bash  
   pip install sqlparse pandas selenium argparse  
   ```  

---

## **Usage**  

### **Command-Line Arguments**  

| Argument             | Description                                                                                     |  
|----------------------|-------------------------------------------------------------------------------------------------|  
| `-s, --source`       | Path(s) to the source SQL file(s). Accepts multiple files. **(Required)**                       |  
| `-d, --destination`  | Destination directory for output files. Defaults to the current directory.                      |  
| `-type, --type`      | Specify the database type (`mysql`, `postgresql`, `oracle`). **(Required)**                     |  
| `-graph, --graphs`   | Enable query diagram generation. Requires a compatible browser and driver.                      |  

### **Example Commands**  

1. **Basic Query Analysis**:  
   ```bash  
   python main.py --source queries.sql --type mysql  
   ```  

2. **Multiple File Analysis**:  
   ```bash  
   python main.py --source query1.sql query2.sql --destination ./output --type postgresql  
   ```  

3. **Query Diagram Generation**:  
   ```bash  
   python main.py --source queries.sql --type mysql --graphs  
   ```  

---

## **Outputs**  

1. **Formatted SQL Queries**: Enhanced readability and structure.  
2. **Analysis Summary**:  
   - Excel files detailing metrics such as join counts, nesting levels, and complexity scores.  
3. **Visual Diagrams**: Professionally styled representations of query flow in image or PDF formats.  

---

## **Roadmap**  

1. **Live Database Integration**: Analyze queries directly from active databases.  
2. **Advanced Metrics**: Incorporate execution cost and database-specific optimization metrics.  
3. **Interactive Visualizations**: Introduce dynamic query diagrams for easier exploration.  
4. **Optimization Recommendations**: Provide actionable suggestions to improve query performance.  

---

## **Contributing**  

1. Fork this repository.  
2. Create a feature branch (`feature/your-feature`).  
3. Commit your changes and open a pull request.  

---

## **License**  

This project is licensed under the [MIT License](LICENSE).  

---

## **Acknowledgments**  

Special thanks to the creators and maintainers of:  
- `sqlparse`  
- `pandas`  
- `selenium`  
- `argparse`  

