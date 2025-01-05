import sqlparse
import json
import re

def extract_query_structure(statement):
    """Recursively parse SQL queries and represent them as JSON."""
    result = {}

    formatted_query = sqlparse.format(statement, reindent=True, keyword_case='upper')

    parsed = sqlparse.parse(formatted_query)[0]

    result["statement"] = str(parsed).strip()
    result["type"] = parsed.get_type()
    result["clauses"] = {}
    for token in parsed.tokens:
        if token.ttype is None:  
            clause = token.value.strip().split()[0].upper()
            if clause in ["SELECT", "FROM", "WHERE", "GROUP BY", "ORDER BY", "LIMIT", "HAVING"]:
                result["clauses"][clause] = str(token).strip()

    subqueries = []
    subquery_pattern = re.compile(r"\((\s*SELECT.*?\))", re.IGNORECASE | re.DOTALL)
    for match in subquery_pattern.findall(statement):
        subquery = match.strip("()")
        subqueries.append(extract_query_structure(subquery))

    if subqueries:
        result["subqueries"] = subqueries

    return result


def sql_file_to_json(sql_file):
    with open(sql_file, "r") as f:
        sql_content = f.read()

    parsed_statements = sqlparse.split(sql_content)

    statements_json = [extract_query_structure(statement) for statement in parsed_statements]

    return json.dumps(statements_json, indent=4)


sql_file_path = "files/test5.sql"  
json_output = sql_file_to_json(sql_file_path)

with open("output.json", "w") as json_file:
    json_file.write(json_output)

print("Conversion complete! JSON saved to 'output.json'.")
