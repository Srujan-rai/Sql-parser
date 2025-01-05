import sqlparse
import json
from sqlparse.sql import IdentifierList, Identifier, Where
from sqlparse.tokens import Keyword, DML

def parse_sql_to_json(sql):
    parsed = sqlparse.parse(sql)
    query = parsed[0]
    query_dict = {
        "select": [],
        "from": [],
        "where": [],
        "group_by": [],
        "order_by": []
    }
    
    tokens = query.tokens
    last_keyword = None
    
    for token in tokens:
        if token.ttype == DML and token.value.upper() == "SELECT":
            last_keyword = "select"
        elif token.ttype == Keyword and token.value.upper() in {"FROM", "WHERE", "GROUP BY", "ORDER BY"}:
            last_keyword = token.value.lower().replace(" ", "_")
        
        if isinstance(token, IdentifierList) or isinstance(token, Identifier):
            if last_keyword == "select":
                columns = [str(i) for i in token.get_identifiers()]
                for col in columns:
                    parts = col.split(".")
                    if len(parts) == 2:
                        query_dict["select"].append({"table": parts[0].strip(), "column": parts[1].strip()})
                    elif len(parts) > 2:
                        query_dict["select"].append({"database": parts[0].strip(), "schema": parts[1].strip(), "table": parts[2].strip(), "column": parts[3].strip()})
                    else:
                        query_dict["select"].append({"table": None, "column": col.strip()})
            elif last_keyword == "from":
                tables = [str(i) for i in token.get_identifiers()]
                for table in tables:
                    query_dict["from"].append({"table": table.strip(), "alias": None})
        
        elif isinstance(token, Where):
            conditions = str(token).replace("WHERE", "").strip()
            query_dict["where"].append(conditions)
    
    return query_dict

def sql_to_json_file(input_file, output_file):
    with open(input_file, "r") as file:
        sql = file.read()
    
    parsed_json = parse_sql_to_json(sql)
    
    with open(output_file, "w") as file:
        json.dump(parsed_json, file, indent=4)
    print(f"JSON output saved to {output_file}")

# Input and Output file paths
input_sql_file = "files/test.sql"
output_json_file = "query.json"

# Convert SQL to JSON
sql_to_json_file(input_sql_file, output_json_file)
