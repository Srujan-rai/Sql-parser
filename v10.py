import os
import sqlparse
import pandas as pd
import re
import argparse

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

def remove_comments(sql_text):
    sql_text_no_comments = re.sub(r'(--.*?$|/\*.*?\*/)', '', sql_text, flags=re.DOTALL | re.MULTILINE)
    return sql_text_no_comments

def format_sql_file(input_file, output_file):
    with open(input_file, 'r') as f:
        raw_sql = f.read()
    
    sql_without_comments = remove_comments(raw_sql)
    formatted_sql = sqlparse.format(sql_without_comments, reindent=True, keyword_case='upper')
    
    with open(output_file, 'w') as f:
        f.write(formatted_sql)
    return formatted_sql

def count_joins_and_lines(formatted_sql):
    join_types = {
        "INNER JOIN": 0,
        "LEFT JOIN": 0,
        "RIGHT JOIN": 0,
        "FULL JOIN": 0,
        "CROSS JOIN": 0,
        "OUTER JOIN": 0,
        "SELF JOIN": 0
    }
    
    for join in join_types.keys():
        join_types[join] = len(re.findall(rf'\b{join}\b', formatted_sql, re.IGNORECASE))
    
    lines = [line for line in formatted_sql.splitlines() if line.strip()]
    total_lines = len(lines)
    
    return join_types, total_lines

def count_ctes(formatted_sql):
    cte_pattern = r'\bWITH\b\s+\w+\s+AS\s*\('
    return len(re.findall(cte_pattern, formatted_sql, re.IGNORECASE))

def count_subqueries(formatted_sql):
    subquery_pattern = r'\(\s*SELECT\s+.*?\s+FROM\s+[^\(\);]+\s*(WHERE\s+.*?|GROUP\s+BY\s+.*?|ORDER\s+BY\s+.*?|LIMIT\s+\d+|FETCH\s+FIRST\s+\d+\s+ROWS\s+ONLY)?\s*\)'
    return len(re.findall(subquery_pattern, formatted_sql, re.IGNORECASE))

def count_pivots(formatted_sql):
    pivot_pattern = r"PIVOT\s*\(\s*(SUM|COUNT|AVG|MIN|MAX)\s*\(\s*\w+\s*\)\s*FOR\s+\w+\s+IN\s*\(\s*[\w',\s]+\s*\)\s*\)"
    return len(re.findall(pivot_pattern, formatted_sql, re.IGNORECASE))

def count_unpivots(formatted_sql):
    unpivot_pattern = r"UNPIVOT\s*\(\s*\w+\s+FOR\s+\w+\s+IN\s*\([\w',\s]+\)\s*\)"
    return len(re.findall(unpivot_pattern, formatted_sql, re.IGNORECASE))

def count_specific_keywords(formatted_sql, keywords):
    keyword_counts = {}
    for keyword in keywords:
        keyword_counts[keyword] = len(re.findall(rf'\b{keyword}\b', formatted_sql, re.IGNORECASE))
    total_count = sum(keyword_counts.values())
    return total_count, keyword_counts

def filter_unsupported_keywords(keyword_details):
    """Filter keywords that have a count greater than 0."""
    return {keyword: count for keyword, count in keyword_details.items() if count > 0}

def calculate_complexity_score(metrics):
    subquery_score = (
        (metrics['SUBQUERY COUNT'] / MAX_VALUES['subqueries']) * 0.6 +
        (metrics.get('max_subquery_depth', 0) / MAX_VALUES['subquery_depth']) * 0.4
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

    total_score = subquery_score + join_score 
    return round(total_score, 2)

def generate_excel_summary(results, excel_file):
    df = pd.DataFrame(results)
    df.to_excel(excel_file, index=False)
    print(f"Excel summary saved to {excel_file}")

def parse_arguments():
    parser = argparse.ArgumentParser(description="Analyze SQL files and visualize queries.")
    parser.add_argument('-s', '--source', nargs='+', required=True,
                        help="Path(s) to the source SQL file(s). Accepts multiple files.")
    parser.add_argument('-d', '--destination', default='.',
                        help="Destination directory for outputs.")
    parser.add_argument('-type', '--type', help="Specify the type used (e.g., mysql, postgres, oracle)", required=True)
    return parser.parse_args()

def main():
    args = parse_arguments()
    input_files = args.source
    destination_path = args.destination
    db_type = args.type.lower()

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
    "macaddr8", "jsonb", "INTERVAL"
]
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
        subquery_count = count_subqueries(formatted_sql)
        pivot_count = count_pivots(formatted_sql)
        unpivot_count = count_unpivots(formatted_sql)

        metrics = {
            "INNER JOIN": join_counts.get("INNER JOIN", 0),
            "LEFT JOIN": join_counts.get("LEFT JOIN", 0),
            "RIGHT JOIN": join_counts.get("RIGHT JOIN", 0),
            "FULL JOIN": join_counts.get("FULL JOIN", 0),
            "CROSS JOIN": join_counts.get("CROSS JOIN", 0),
            "PIVOTS": pivot_count,
            "UNPIVOT COUNT": unpivot_count,
            "SUBQUERY COUNT": subquery_count,
            "CTEs": cte_count,
            "Total Lines": total_lines
        }
        complexity_score = calculate_complexity_score(metrics)

        keyword_details = {}
        if db_type == 'mysql':
            _, keyword_details = count_specific_keywords(formatted_sql, mysql_keywords)
        elif db_type == 'oracle':
            _, keyword_details = count_specific_keywords(formatted_sql, oracle_keywords)
        elif db_type == 'postgres':
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
    print("Task complete! All files analyzed.")

    

if __name__ == "__main__":
    main()
