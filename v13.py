#SQL SUMMARY AND VISUALIZATION CODE
import os
import sqlparse
import pandas as pd
import re
import argparse
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import os


MAX_VALUES = {
    "subqueries": 10,
    "subquery_depth": 5,
    "joins": 10,
    "conditions": 15,
    "aggregations": 10,
    "ctes": 5,
    "case_statements": 10,
}
WEIGHTS = {
    "subquery_complexity": 25,
    "join_complexity": 20,
    "condition_complexity": 20,
    "aggregation_complexity": 15,
    "cte_complexity": 10,
    "case_complexity": 10,
}

def load_sql_query(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def set_codemirror_content(driver, query):
    script = """
    var editor = document.querySelector('.CodeMirror').CodeMirror;
    editor.setValue(arguments[0]);
    """
    driver.execute_script(script, query)

def handle_login(driver, email, password):
    try:
        email_input = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "email"))
        )
        email_input.clear()
        email_input.send_keys(email)
        print("Email entered successfully.")

        password_input = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "password"))
        )
        password_input.clear()
        password_input.send_keys(password)
        print("Password entered successfully.")

        login_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="login"]]'))
        )
        login_button.click()
        print("Login button clicked successfully.")
        time.sleep(2)
    except Exception as e:
        print(f"Error during login process: {e}")

def process_query(driver, sql_query, actions):
    try:
        set_codemirror_content(driver, sql_query)
        print("SQL query pasted into the CodeMirror editor.")
        time.sleep(4)

        visualize_button = driver.find_element(By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="visualize"]]')
        actions.move_to_element(visualize_button).click().perform()
        print("Clicked the 'Visualize' button.")
        time.sleep(15)  

        diagram_area = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'div.Canvas__k2Y31 .scale'))
        )
        actions.context_click(diagram_area).perform()  
        print("Right-clicked on the diagram.")
        time.sleep(1)  

        actions.move_by_offset(50, 10).perform()  
        time.sleep(0.5)

       
        for _ in range(6):  
            actions.move_by_offset(0, 30).perform()  
            time.sleep(0.2)  

        actions.click().perform()
        print("Diagram downloaded.")
        time.sleep(5)  
    except Exception as e:
        print(f"Error processing query: {e}")



def remove_comments(sql_text):
    """Removes SQL comments."""
    return re.sub(r'(--.*?$|/\*.*?\*/)', '', sql_text, flags=re.DOTALL | re.MULTILINE)

def format_sql_file(input_file, output_file):
    """Formats SQL file and removes comments."""
    with open(input_file, 'r') as f:
        raw_sql = f.read()
    
    sql_without_comments = remove_comments(raw_sql)
    formatted_sql = sqlparse.format(sql_without_comments, reindent=True, keyword_case='upper')
    
    with open(output_file, 'w') as f:
        f.write(formatted_sql)
    return formatted_sql

def count_specific_keywords(formatted_sql, keywords):
    """Counts occurrences of specific keywords in the SQL."""
    keyword_counts = {keyword: len(re.findall(rf'\b{keyword}\b', formatted_sql, re.IGNORECASE)) for keyword in keywords}
    return sum(keyword_counts.values()), keyword_counts

def count_joins_and_lines(formatted_sql):
    """Counts different JOIN types and total lines in the SQL."""
    patterns = {
        "INNER JOIN": r'\bINNER JOIN\b',
        "LEFT JOIN": r'\bLEFT JOIN\b',
        "RIGHT JOIN": r'\bRIGHT JOIN\b',
        "FULL JOIN": r'\bFULL JOIN\b',
        "CROSS JOIN": r'\bCROSS JOIN\b',
        "LEFT OUTER JOIN": r'\bLEFT\s+OUTER\s+JOIN\b',
        "RIGHT OUTER JOIN": r'\bRIGHT\s+OUTER\s+JOIN\b',
        "LEFT INNER JOIN": r'\bLEFT\s+INNER\s+JOIN\b',
        "RIGHT INNER JOIN": r'\bRIGHT\s+INNER\s+JOIN\b',
    }
    
    join_counts = {key: len(re.findall(pattern, formatted_sql, re.IGNORECASE)) for key, pattern in patterns.items()}
    
    join_counts["OUTER JOIN"] = join_counts.get("LEFT OUTER JOIN", 0) + join_counts.get("RIGHT OUTER JOIN", 0)
    join_counts["INNER JOIN"] = join_counts.get("LEFT INNER JOIN", 0) + join_counts.get("RIGHT INNER JOIN", 0)

    join_types = {k: join_counts[k] for k in ["INNER JOIN", "LEFT JOIN", "RIGHT JOIN", "FULL JOIN", "CROSS JOIN", "OUTER JOIN"]}
    
    total_lines = sum(1 for line in formatted_sql.splitlines() if line.strip())
    return join_types, total_lines


def filter_unsupported_keywords(keyword_details):
    """Filter keywords that have a count greater than 0."""
    return {keyword: count for keyword, count in keyword_details.items() if count > 0}


def count_ctes(formatted_sql):
    """Counts the number of CTEs in the SQL."""
    return len(re.findall(r'\bWITH\b\s+\w+\s+AS\s*\(', formatted_sql, re.IGNORECASE))

def count_subqueries_and_depth(sql_text):
    """
    Counts subqueries and determines the maximum nesting depth of subqueries.
    """
    subquery_pattern = r"""
        \(                             
        \s*SELECT\s+                   # SELECT keyword
        .*?                            # Non-greedy match for the query
        \s+FROM\s+                     # FROM keyword
        [^\(\);]+                      # Match table names or aliases
        (?:                            # Non-capturing group for optional clauses
            \s+(?:WHERE|GROUP\s+BY|HAVING|ORDER\s+BY)\s+.*? # WHERE, GROUP BY, etc.
        )*                             
        \s*\)                          
    """
    formatted_pattern = re.compile(subquery_pattern, re.IGNORECASE | re.VERBOSE | re.DOTALL)

    def find_subqueries(sql, depth=0):
        matches = formatted_pattern.findall(sql)
        if not matches:
            return 0, depth

        subquery_count = len(matches)
        for match in matches:
            sql = sql.replace(match, "", 1)
        nested_count, max_depth = find_subqueries(sql, depth + 1)
        return subquery_count + nested_count, max(depth, max_depth)

    return find_subqueries(sql_text)

def calculate_complexity_score(metrics):
    subquery_score = (
        (metrics['SUBQUERY COUNT'] / MAX_VALUES['subqueries']) * 0.6 +
        (metrics['max_subquery_depth'] / MAX_VALUES['subquery_depth']) * 0.4
    ) * WEIGHTS['subquery_complexity']
    subquery_score = min(subquery_score, WEIGHTS['subquery_complexity'])

    join_count = sum([
        metrics['INNER JOIN'],
        metrics['LEFT JOIN'] * 1.2,
        metrics['RIGHT JOIN'] * 1.2,
        metrics['FULL JOIN'] * 1.5,
        metrics['CROSS JOIN'] * 1.5
    ])
    join_score = (join_count / MAX_VALUES['joins']) * WEIGHTS['join_complexity']
    join_score = min(join_score, WEIGHTS['join_complexity'])

    return round(subquery_score + join_score, 2)

def generate_excel_summary(results, excel_file):
    """Generates an Excel summary of the results."""
    df = pd.DataFrame(results)
    df.to_excel(excel_file, index=False)
    print(f"Excel summary saved to {excel_file}")

def parse_arguments():
    """Parses command-line arguments."""
    parser = argparse.ArgumentParser(description="Analyze SQL files and visualize queries.")
    parser.add_argument('-s', '--source', nargs='+', required=True,
                        help="Path(s) to the source SQL file(s). Accepts multiple files.")
    parser.add_argument('-d', '--destination', default='.',
                        help="Destination directory for outputs.")
    parser.add_argument('-type', '--type', help="Specify the type used (e.g., mysql, postgresql, oracle)", required=True)
    
    parser.add_argument('-graph', '--graphs', action='store_true', help='Generate graphs')
    
    return parser.parse_args()

def main():
    args = parse_arguments()
    input_files = args.source
    destination_path = args.destination
    db_type = args.type.lower()
    diagram = args.graphs
    
    
    if not os.path.exists(destination_path):
        os.makedirs(destination_path)
    mysql_keywords =  [
    "AUTO_INCREMENT", "ENUM", "SET", "TINYINT", "MEDIUMINT", "SMALLINT", "BIGINT", 
    "YEAR", "TEXT", "TINYTEXT", "MEDIUMTEXT", "LONGTEXT", "BLOB", "MEDIUM_BLOB", 
    "LONG_BLOB", "TINY_BLOB", "VARBINARY", "UNSIGNED", "ZEROFILL", "IF", "NOW", 
    "DUAL", "LOCK TABLES", "UNLOCK TABLES", "INSERT IGNORE", "REPLACE INTO", 
    "SQL_CALC_FOUND_ROWS", "SHOW", "DESCRIBE", "DATABASE", "SCHEMA", "INDEX", 
    "KEY", "PRIMARY", "TRUNCATE", "ENGINE", "CHECKSUM", "OPTIMIZE TABLE", 
    "FLUSH", "ANALYZE TABLE", "RESET QUERY CACHE", "SAVEPOINT", "ROLLBACK TO SAVEPOINT", 
    "RELEASE SAVEPOINT", "MASTER", "SLAVE", "PARTITION", "SPATIAL", "FULLTEXT", 
    "CHARSET", "COLLATE", "CONNECTION", "DELAYED", "HANDLER", "LOAD DATA", 
    "DUMPFILE", "FORCE", "STRAIGHT_JOIN", "AUTOEXTEND_SIZE", "MIN_ROWS", 
    "MAX_ROWS", "AVG_ROW_LENGTH", "PAGE_CHECKSUM", "TABLESPACE", "ROW_FORMAT"
]

    oracle_keywords = [
    "CONNECT BY", "START WITH", "LEVEL", "ROWNUM", "SYSDATE", "SYSTIMESTAMP", 
    "DUAL", "DECODE", "NVL", "TO_DATE", "TO_CHAR", "TO_NUMBER", "TO_TIMESTAMP", 
    "MERGE", "PERCENT_RANK", "RATIO_TO_REPORT", "XMLTABLE", "ROWID", 
    "EXPLAIN PLAN", "MODEL", "MINUS", "INTERSECT", "PRIOR", "REGEXP_LIKE", 
    "REGEXP_INSTR", "REGEXP_SUBSTR", "PL/SQL Procedures", "Packages", "Sequences", 
    "Autonomous Transactions", "Flashback Queries", "VARCHAR2", "NVARCHAR2", 
    "NCHAR", "NCOLB", "BINARY_DOUBLE", "BINARY_FLOAT", "LONG", "BFILE", 
    "TIMESTAMP WITH LOCAL TIME ZONE", "INTERVAL YEAR TO MONTH", "INTERVAL DAY TO SECOND", 
    "RAW", "LONG RAW", "FETCH NEXT>", "NVL2", "QUALIFY", "ROLLUP", "LISTAGG", 
    "WM_CONCAT", "CUBE_TABLE", "ADD_MONTHS", "MONTHS_BETWEEN", "NEW_TIME", 
    "SYS_AT_TIME_ZONE", "TO_TIMESTAMP_TZ", "TZ_OFFSET"
]
    postgres_keywords=[
    "smallserial", "serial", "bigserial", "money", "bytea", "bit", 
    "inet", "path", "pg_lsn", "point", "polygon", "tsquery", "tsvector", 
    "txid_snapshot", "xml", "box", "circle", "line", "lseg", "macaddr", 
    "macaddr8", "jsonb", "INTERVAL","jsonb_build_object"
]
    results = []

    results = []

    for input_file in input_files:
        if not os.path.isfile(input_file):
            print(f"Warning: File '{input_file}' does not exist. Skipping.")
            continue

        base_filename = os.path.splitext(os.path.basename(input_file))[0]
        output_sql_file = os.path.join(destination_path, f"{base_filename}_formatted.sql")

        print(f"Formatting '{input_file}'...")
        formatted_sql = format_sql_file(input_file, output_sql_file)
        print(f"Formatted SQL saved to '{output_sql_file}'")

        print(f"Analyzing '{input_file}' for JOINs, CTEs, and lines of code...")
        join_counts, total_lines = count_joins_and_lines(formatted_sql)
        cte_count = count_ctes(formatted_sql)
        subquery_count, max_subquery_depth = count_subqueries_and_depth(formatted_sql)

        metrics = {
            "INNER JOIN": join_counts.get("INNER JOIN", 0),
            "LEFT JOIN": join_counts.get("LEFT JOIN", 0),
            "RIGHT JOIN": join_counts.get("RIGHT JOIN", 0),
            "FULL JOIN": join_counts.get("FULL JOIN", 0),
            "CROSS JOIN": join_counts.get("CROSS JOIN", 0),
            "OUTER JOIN": join_counts.get("OUTER JOIN", 0),
            "SUBQUERY COUNT": subquery_count,
            "max_subquery_depth": max_subquery_depth,
            "CTEs": cte_count,
            "Total Lines": total_lines
        }
        complexity_score = calculate_complexity_score(metrics)
        keyword_details = {}
        if db_type == 'mysql':
            _, keyword_details = count_specific_keywords(formatted_sql, mysql_keywords)
        elif db_type == 'oracle':
            _, keyword_details = count_specific_keywords(formatted_sql, oracle_keywords)
        elif db_type == 'postgresql':
            _, keyword_details = count_specific_keywords(formatted_sql, postgres_keywords)

        filtered_keywords = filter_unsupported_keywords(keyword_details)
        total_unsupported_keywords = sum(filtered_keywords.values())
        result = {
            **metrics,
            "File Name": os.path.basename(input_file),
            "Complexity Score": complexity_score,
            "unsupported Keywords": filtered_keywords,
            "Total unsupported Keywords": total_unsupported_keywords
        }
        results.append(result)

        print(f"Analysis complete for '{input_file}' with Complexity Score: {complexity_score}")
    
    generate_excel_summary(results, os.path.join(destination_path, "sql_summary.xlsx"))
    
    download_directory = os.path.join(os.getcwd(), "downloads")
    os.makedirs(download_directory, exist_ok=True)
    
    if diagram:
        chrome_options = webdriver.ChromeOptions()
        
        prefs = {
            "download.default_directory": download_directory,
            "download.prompt_for_download": False,
            "safebrowsing.enabled": True,
        }
        chrome_options.add_experimental_option("prefs", prefs)
        driver = webdriver.Chrome(options=chrome_options)
        driver.maximize_window()
        
        actions = ActionChains(driver)

        try:
            driver.get("https://sqlflow.gudusoft.com/#/")
            print("Opened SQLFlow website.")
            time.sleep(12)

            visualize_button = driver.find_element(By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="visualize"]]')
            actions.move_to_element(visualize_button).click().perform()
            print("Clicked the 'Visualize' button to trigger login popup.")
            time.sleep(3)

            email = "srujan.ci21@sahyadri.edu.in"
            password = "srujan@2003"  
            handle_login(driver, email, password)
            time.sleep(20) #componsating for slow internet connection
            
            for input_file in input_files:
                print(f"Processing file: {input_file}")
                sql_query = load_sql_query(input_file)
                process_query(driver, sql_query, actions)

        finally:
            driver.quit()
            print("Session ended.")
                 

    print("Task complete! All files analyzed.")

if __name__ == "__main__":
    main()

