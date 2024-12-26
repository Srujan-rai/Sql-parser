import sqlparse
from graphviz import Digraph

def parse_sql_file(file_path):
    """
    Parse the SQL file and extract queries.
    
    :param file_path: Path to the .sql file
    :return: List of parsed SQL queries
    """
    with open(file_path, 'r') as file:
        content = file.read()
    queries = sqlparse.split(content)
    return queries

def analyze_query(query):
    """
    Analyze the SQL query to extract components (tables, columns, joins, filters, etc.).
    
    :param query: SQL query as a string
    :return: Dictionary containing query components
    """
    tokens = sqlparse.parse(query)[0].tokens
    query_structure = {"tables": [], "columns": [], "joins": [], "filters": [], "aggregates": [], "group_by": []}

    for token in tokens:
        token_str = str(token).strip()
        if not token_str:
            continue

        if token_str.upper().startswith("FROM"):
            parts = token_str.split(" ")
            if len(parts) > 1:
                query_structure["tables"].append(parts[1])
        elif token_str.upper().startswith("JOIN"):
            join_parts = token_str.split("ON")
            if len(join_parts) > 1:
                table = join_parts[0].split("JOIN")[1].strip() if "JOIN" in join_parts[0] else ""
                condition = join_parts[1].strip()
                if table:
                    query_structure["joins"].append({"table": table, "condition": condition})
        elif token_str.upper().startswith("WHERE"):
            query_structure["filters"].append(token_str[5:].strip())
        elif token_str.upper().startswith("GROUP BY"):
            query_structure["group_by"].extend([col.strip() for col in token_str[8:].split(",")])
        elif token_str.upper().startswith("SELECT"):
            columns = token_str[6:].split(",")
            query_structure["columns"].extend([col.strip() for col in columns])

    return query_structure

def generate_combined_diagram(queries_structures):
    """
    Generate a single combined diagram for all queries.
    
    :param queries_structures: List of query structures, where each structure is a dictionary
                               representing query components.
    """
    dot = Digraph(comment="Combined SQL Query Overview")

    for i, query_structure in enumerate(queries_structures, start=1):
        subgraph = Digraph(name=f"cluster_query_{i}")
        subgraph.attr(label=f"Query {i}")
        subgraph.attr(style="dotted")

        # Add tables as nodes
        for table in query_structure["tables"]:
            subgraph.node(table, label=table, shape="box")

        # Add joins as edges
        for join in query_structure["joins"]:
            label = f"JOIN ({join['condition']})"
            subgraph.edge(query_structure["tables"][0], join["table"], label=label)

        # Add selected columns as a node
        if query_structure["columns"]:
            columns_label = "Selected Columns:\n" + "\n".join(query_structure["columns"])
            subgraph.node(f"Columns_{i}", label=columns_label, shape="note")

        # Add filters as a node
        if query_structure["filters"]:
            filters_label = "Filters:\n" + "\n".join(query_structure["filters"])
            subgraph.node(f"Filters_{i}", label=filters_label, shape="note", color="red")

        # Add aggregations and group by as nodes
        if query_structure["aggregates"]:
            aggregates_label = "Aggregates:\n" + "\n".join(query_structure["aggregates"])
            subgraph.node(f"Aggregates_{i}", label=aggregates_label, shape="note", color="blue")

        if query_structure["group_by"]:
            group_by_label = "Group By:\n" + "\n".join(query_structure["group_by"])
            subgraph.node(f"GroupBy_{i}", label=group_by_label, shape="note", color="green")

        # Connect components for clarity within the subgraph
        subgraph.edge(f"Columns_{i}", f"Filters_{i}", label="Filtered By")
        if query_structure["aggregates"]:
            subgraph.edge(f"Filters_{i}", f"Aggregates_{i}", label="Aggregate After Filtering")
        if query_structure["group_by"]:
            subgraph.edge(f"Aggregates_{i}", f"GroupBy_{i}", label="Grouped By")

        dot.subgraph(subgraph)

    # Render the combined diagram
    dot.render("combined_query_diagram", format="png", cleanup=True)
    print("Combined query diagram saved as 'combined_query_diagram.png'.")

def process_sql_file(file_path):
    queries = parse_sql_file(file_path)
    queries_structures = [analyze_query(query) for query in queries]
    generate_combined_diagram(queries_structures)

# Example Usage
sql_file_path = "files/test2_formatted.sql"  # Path to your .sql file
process_sql_file(sql_file_path)
