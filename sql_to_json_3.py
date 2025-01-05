import sqlparse
import re
import json


def extract_insert_into(sql_query):
    match = re.search(r"INSERT INTO\s+([\w\.]+)", sql_query, re.IGNORECASE)
    return match.group(1) if match else None


def extract_columns(select_clause):
    columns = []
    column_pattern = re.compile(
        r"(\w+\.\w+|\w+\s+AS\s+\w+|\w+\.\w+\s+AS\s+\w+|\w+|\*)", re.IGNORECASE
    )
    matches = column_pattern.findall(select_clause)
    for match in matches:
        column_info = {}
        if " AS " in match.upper():
            original, alias = match.upper().split(" AS ")
            column_info["original"] = original.strip()
            column_info["alias"] = alias.strip()
        else:
            column_info["original"] = match.strip()
            column_info["alias"] = None
        columns.append(column_info)
    return columns


def extract_tables_and_joins(from_clause):
    tables = []
    joins = []

    table_pattern = re.compile(r"(FROM|JOIN)\s+([\w\.]+)\s*(?:AS\s+(\w+))?", re.IGNORECASE)
    for match in table_pattern.findall(from_clause):
        tables.append({
            "type": match[0].upper(),
            "table": match[1].strip(),
            "alias": match[2].strip() if match[2] else None
        })

    join_pattern = re.compile(r"(LEFT|RIGHT|INNER|FULL|CROSS)?\s*JOIN\s+([\w\.]+)\s+ON\s+(.+)", re.IGNORECASE)
    for match in join_pattern.findall(from_clause):
        joins.append({
            "type": match[0].upper() if match[0] else "JOIN",
            "table": match[1].strip(),
            "condition": match[2].strip()
        })

    return tables, joins


def extract_where_clause(sql_query):
    match = re.search(r"WHERE\s+(.+)", sql_query, re.IGNORECASE)
    return match.group(1).strip() if match else None


def parse_subqueries(sql_query):
    subqueries = []
    subquery_pattern = re.compile(r"\((SELECT.+?FROM.+?)\)", re.IGNORECASE | re.DOTALL)
    matches = subquery_pattern.findall(sql_query)

    for match in matches:
        subquery_content = match.strip("()")
        subqueries.append(parse_sql_query(subquery_content))  # Recursively parse subquery

    return subqueries


def parse_sql_query(sql_query):
    result = {}

    formatted_query = sqlparse.format(sql_query, reindent=True, keyword_case="upper")

    insert_into = extract_insert_into(formatted_query)
    if insert_into:
        result["insert_into"] = insert_into

    select_match = re.search(r"SELECT\s+DISTINCT\s+(.+?)\s+FROM", formatted_query, re.IGNORECASE | re.DOTALL)
    if not select_match:
        select_match = re.search(r"SELECT\s+(.+?)\s+FROM", formatted_query, re.IGNORECASE | re.DOTALL)
    if select_match:
        result["result_set"] = extract_columns(select_match.group(1))

    from_match = re.search(r"FROM\s+(.+)", formatted_query, re.IGNORECASE | re.DOTALL)
    if from_match:
        from_clause = from_match.group(1).split("WHERE")[0].strip()
        tables, joins = extract_tables_and_joins(from_clause)
        if tables:
            result["tables"] = tables
        if joins:
            result["joins"] = joins

    where_clause = extract_where_clause(formatted_query)
    if where_clause:
        result["where"] = where_clause

    subqueries = parse_subqueries(formatted_query)
    if subqueries:
        result["subqueries"] = subqueries

    return result


def sql_file_to_json(input_file, output_file):
    with open(input_file, "r") as file:
        sql_query = file.read()

    parsed_result = parse_sql_query(sql_query)

    with open(output_file, "w") as json_file:
        json.dump(parsed_result, json_file, indent=4)

    print(f"SQL parsed and saved to {output_file}")


if __name__ == "__main__":
    input_file = "test.sql" 
    output_file = "output.json"  
    sql_file_to_json(input_file, output_file)
