import os
import sqlparse
import pandas as pd
import re
import argparse

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
    cte_count = len(re.findall(cte_pattern, formatted_sql, re.IGNORECASE))
    return cte_count


def count_subqueries(formatted_sql):
    subquery_pattern=r'\(\s*SELECT\s+.*?\s+FROM\s+[^\(\);]+\s*(WHERE\s+.*?|GROUP\s+BY\s+.*?|ORDER\s+BY\s+.*?|LIMIT\s+\d+|FETCH\s+FIRST\s+\d+\s+ROWS\s+ONLY)?\s*\)'
    subquery_count=len(re.findall(subquery_pattern,formatted_sql,re.IGNORECASE))
    return subquery_count

def count_pivots(formatted_sql):
    pivot_pattern=r"PIVOT\s*\(\s*(SUM|COUNT|AVG|MIN|MAX)\s*\(\s*\w+\s*\)\s*FOR\s+\w+\s+IN\s*\(\s*[\w',\s]+\s*\)\s*\)|CASE\s+WHEN\s+[\w\s=']+\s+THEN\s+\w+\s+ELSE\s+\w+\s+END"
    pivot_count=len(re.findall(pivot_pattern,formatted_sql,re.IGNORECASE))
    return pivot_count

def count_unpivots(formatted_sql):
    unpivot_pattern=r"UNPIVOT\s*\(\s*\w+\s+FOR\s+\w+\s+IN\s*\([\w',\s]+\)\s*\)|SELECT\s+\w+,\s*'?\w+'?\s+AS\s+\w+,\s*\w+\s+AS\s+\w+\s+FROM\s+\w+(\s+UNION\s+ALL\s+SELECT\s+\w+,\s*'?\w+'?\s+AS\s+\w+,\s*\w+\s+AS\s+\w+\s+FROM\s+\w+)*"
    unpivot_count=len(re.findall(unpivot_pattern,formatted_sql,re.IGNORECASE))
    return unpivot_count

def generate_excel_summary(results, excel_file):
    df = pd.DataFrame(results)
    df.to_excel(excel_file, index=False)
    print(f"Excel summary saved to {excel_file}")

def parse_arguments():
    parser = argparse.ArgumentParser(description="Analyze SQL files for JOINs, CTEs, and lines of code.")
    parser.add_argument('-s', '--source', nargs='+', required=True,
                        help="Path(s) to the source SQL file(s). Accepts multiple files.")
    parser.add_argument('-d', '--destination', default='.',
                        help="Destination directory for outputs.")
    return parser.parse_args()

def main():
    args = parse_arguments()
    
    input_files = args.source
    destination_path = args.destination

    if not os.path.exists(destination_path):
        os.makedirs(destination_path)

    results = []  

    for input_file in input_files:
        if not os.path.isfile(input_file):
            print(f"Warning: File '{input_file}' does not exist. Skipping.")
            continue

        base_filename = os.path.splitext(os.path.basename(input_file))[0]
        output_sql_file = os.path.join(destination_path, f"{base_filename}_formatted.sql")
        excel_summary_file = os.path.join(destination_path, "sql_summary.xlsx")

        print(f"Formatting '{input_file}'...")
        formatted_sql = format_sql_file(input_file, output_sql_file)
        print(f"Formatted SQL saved to '{output_sql_file}'")

        print(f"Analyzing '{input_file}' for JOINs, CTEs, and lines of code...")
        join_counts, total_lines = count_joins_and_lines(formatted_sql)
        cte_count = count_ctes(formatted_sql)
        subquery_count=count_subqueries(formatted_sql)
        pivot_count=count_pivots(formatted_sql)
        unpivot_count=count_unpivots(formatted_sql)
        
        result = {
            "File Name": os.path.basename(input_file),
            "INNER JOIN": join_counts.get("INNER JOIN", 0),
            "LEFT JOIN": join_counts.get("LEFT JOIN", 0),
            "RIGHT JOIN": join_counts.get("RIGHT JOIN", 0),
            "FULL JOIN": join_counts.get("FULL JOIN", 0),
            "CROSS JOIN": join_counts.get("CROSS JOIN", 0),
            "OUTER JOIN": join_counts.get("OUTER JOIN", 0),
            "SELF JOIN": join_counts.get("SELF JOIN", 0),
            "SUBQUERY COUNT":subquery_count,
            "CTEs": cte_count,
            "PIVOT COUNT":pivot_count,
            "UNPIVOT COUNT":unpivot_count,
            "Total Lines": total_lines
            
            
        }
        results.append(result)
        print(f"Analysis complete for '{input_file}'!")

    generate_excel_summary(results, excel_summary_file)
    print("Task complete! All files analyzed.")

if __name__ == "__main__":
    main()