import os
import sqlparse
import pandas as pd
import re
import argparse

def format_sql_file(input_file, output_file):
    """Format the SQL file and save it."""
    with open(input_file, 'r') as f:
        raw_sql = f.read()
    formatted_sql = sqlparse.format(raw_sql, reindent=True, keyword_case='upper')
    
    with open(output_file, 'w') as f:
        f.write(formatted_sql)
    return formatted_sql

def count_joins_and_lines(formatted_sql):
    """Count different types of JOINs and lines of code."""
    join_types = {
        "INNER JOIN": 0,
        "LEFT JOIN": 0,
        "RIGHT JOIN": 0,
        "FULL JOIN": 0,
        "CROSS JOIN": 0,
        "OUTER JOIN": 0,
        "SELF JOIN": 0
    }
    
    # Count JOIN occurrences
    for join in join_types.keys():
        join_types[join] = len(re.findall(rf'\b{join}\b', formatted_sql, re.IGNORECASE))
    
    # Count total lines of code
    lines = [line for line in formatted_sql.splitlines() if line.strip()]
    total_lines = len(lines)
    
    return join_types, total_lines

def generate_excel_summary(file_name, join_counts, total_lines, excel_file):
    """Generate an Excel summary file."""
    data = {
        "File Name": [file_name],
        "INNER JOIN": [join_counts.get("INNER JOIN", 0)],
        "LEFT JOIN": [join_counts.get("LEFT JOIN", 0)],
        "RIGHT JOIN": [join_counts.get("RIGHT JOIN", 0)],
        "FULL JOIN": [join_counts.get("FULL JOIN", 0)],
        "CROSS JOIN": [join_counts.get("CROSS JOIN", 0)],
        "OUTER JOIN": [join_counts.get("OUTER JOIN", 0)],
        "SELF JOIN": [join_counts.get("SELF JOIN", 0)],
        "Total Lines": [total_lines]
    }
    
    df = pd.DataFrame(data)
    df.to_excel(excel_file, index=False)
    print(f"Excel summary saved to {excel_file}")

def parse_arguments():
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description="Analyze SQL files for JOINs and lines of code.")
    parser.add_argument('-s', '--source', required=True, help="Path to the source SQL file.")
    parser.add_argument('-d', '--destination', default='.', help="Destination directory for outputs.")
    return parser.parse_args()

def main():
    args = parse_arguments()
    
    input_file = args.source
    destination_path = args.destination
    
    # Validate source file
    if not os.path.isfile(input_file):
        print(f"Error: Source file '{input_file}' does not exist.")
        return
    
    # Prepare output file paths
    base_filename = os.path.splitext(os.path.basename(input_file))[0]
    output_sql_file = os.path.join(destination_path, f"{base_filename}_formatted.sql")
    excel_file = os.path.join(destination_path, f"{base_filename}_summary.xlsx")
    
    # Step 1: Format the SQL file
    print("Formatting SQL file...")
    formatted_sql = format_sql_file(input_file, output_sql_file)
    print(f"Formatted SQL saved to {output_sql_file}")
    
    # Step 2: Count JOINs and lines of code
    print("Analyzing SQL file for JOINs and lines of code...")
    join_counts, total_lines = count_joins_and_lines(formatted_sql)
    print("Analysis complete!")
    print(f"Join Counts: {join_counts}")
    print(f"Total Lines of Code: {total_lines}")
    
    # Step 3: Generate Excel summary
    generate_excel_summary(os.path.basename(input_file), join_counts, total_lines, excel_file)
    print(f"Excel summary saved to {excel_file}")
    print("Task complete!")

if __name__ == "__main__":
    main()