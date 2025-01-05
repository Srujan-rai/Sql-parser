import sqlparse
import re
import json


def extract_insert_into(sql_query):
    """Extract the table name from INSERT INTO clause."""
    match = re.search(r"INSERT INTO\s+([\w\.]+)", sql_query, re.IGNORECASE)
    return match.group(1) if match else None


def extract_columns(select_clause):
    """Extract columns from SELECT clause."""
    columns = []
    column_pattern = re.compile(r"(\w+\.\w+|\w+|\w+\s+AS\s+\w+|\w+\.\w+\s+AS\s+\w+|\*)", re.IGNORECASE)
    matches = column_pattern.findall(select_clause)
    for match in matches:
        columns.append(match.strip())
    return columns


def extract_tables_and_joins(from_clause):
    """Extract tables and join relationships from FROM and JOIN clauses."""
    tables = []
    joins = []

    # Extract tables
    table_pattern = re.compile(r"(FROM|JOIN)\s+([\w\.]+)\s*(?:AS\s+(\w+))?", re.IGNORECASE)
    for match in table_pattern.findall(from_clause):
        tables.append({
            "type": match[0].upper(),
            "table": match[1].strip(),
            "alias": match[2].strip() if match[2] else None
        })

    # Extract joins
    join_pattern = re.compile(r"(LEFT|RIGHT|INNER|FULL|CROSS)?\s*JOIN\s+([\w\.]+)\s+ON\s+(.+)", re.IGNORECASE)
    for match in join_pattern.findall(from_clause):
        joins.append({
            "type": match[0].upper() if match[0] else "JOIN",
            "table": match[1].strip(),
            "condition": match[2].strip()
        })

    return tables, joins


def extract_where_clause(sql_query):
    """Extract WHERE clause."""
    match = re.search(r"WHERE\s+(.+)", sql_query, re.IGNORECASE)
    return match.group(1).strip() if match else None


def parse_subqueries(sql_query):
    """Extract and parse subqueries."""
    subqueries = []
    subquery_pattern = re.compile(r"\((SELECT.+?FROM.+?)\)", re.IGNORECASE | re.DOTALL)
    matches = subquery_pattern.findall(sql_query)

    for match in matches:
        subquery = match.strip("()")
        subqueries.append(parse_sql_query(subquery))  # Recursively parse subqueries

    return subqueries


def parse_sql_query(sql_query):
    """Main function to parse SQL query and convert it to JSON."""
    result = {
        "type": "UNKNOWN",
        "insert_into": None,
        "columns": [],
        "tables": [],
        "joins": [],
        "where": None,
        "subqueries": []
    }

    # Normalize and format query
    formatted_query = sqlparse.format(sql_query, reindent=True, keyword_case="upper")

    # Parse INSERT INTO
    result["insert_into"] = extract_insert_into(formatted_query)

    # Parse SELECT clause
    select_match = re.search(r"SELECT\s+DISTINCT\s+(.+?)\s+FROM", formatted_query, re.IGNORECASE | re.DOTALL)
    if not select_match:
        select_match = re.search(r"SELECT\s+(.+?)\s+FROM", formatted_query, re.IGNORECASE | re.DOTALL)
    if select_match:
        result["columns"] = extract_columns(select_match.group(1))

    # Parse FROM clause
    from_match = re.search(r"FROM\s+(.+)", formatted_query, re.IGNORECASE | re.DOTALL)
    if from_match:
        from_clause = from_match.group(1).split("WHERE")[0].strip()
        tables, joins = extract_tables_and_joins(from_clause)
        result["tables"] = tables
        result["joins"] = joins

    # Parse WHERE clause
    result["where"] = extract_where_clause(formatted_query)

    # Parse subqueries
    result["subqueries"] = parse_subqueries(formatted_query)

    return result


def sql_file_to_json(input_file, output_file):
    """Read an SQL file and convert it to a JSON file."""
    with open(input_file, "r") as file:
        sql_query = file.read()

    parsed_result = parse_sql_query(sql_query)

    # Save JSON output to a file
    with open(output_file, "w") as json_file:
        json.dump(parsed_result, json_file, indent=4)

    print(f"Parsed SQL saved to {output_file}")


# Example usage
if __name__ == "__main__":
    input_file = "test.sql"  # Replace with your SQL file path
    output_file = "output.json"  # Replace with desired output JSON file path
    sql_file_to_json(input_file, output_file)
