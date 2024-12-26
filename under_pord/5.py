import sqlparse
from graphviz import Digraph


def parse_and_segment_sql(sql_query):
    """
    Parse and segment a SQL query into its components (CTEs, main query, etc.).
    
    :param sql_query: The full SQL query as a string.
    :return: A dictionary containing CTEs, main query, and relationships.
    """
    parsed_query = sqlparse.format(sql_query, reindent=True, keyword_case='upper')
    statements = sqlparse.parse(parsed_query)

    ctes = {}
    main_query = None

    for statement in statements:
        statement_str = str(statement).strip()
        if statement_str.upper().startswith("WITH"):
            # Extract CTEs
            cte_blocks = statement_str.split("WITH")[1].split("),")
            for cte_block in cte_blocks:
                if "AS" in cte_block:
                    cte_name = cte_block.split("AS")[0].strip().split()[-1]
                    cte_query = cte_block.split("AS", 1)[1].strip()
                    ctes[cte_name] = cte_query
        elif "SELECT" in statement_str.upper() or "INSERT" in statement_str.upper():
            # Assign the first valid query as the main query
            if main_query is None:
                main_query = statement_str

    return {
        "ctes": ctes,
        "main_query": main_query
    }


def truncate_label(label, max_length=150):
    """
    Truncate a label for better visualization.
    
    :param label: The label text.
    :param max_length: Maximum length of the label.
    :return: Truncated label with ellipsis if needed.
    """
    return label if len(label) <= max_length else label[:max_length] + "..."


def visualize_combined_sql(parsed_queries, output_file="combined_sql_diagram"):
    """
    Generate a combined diagram for all SQL queries in a file, including all inputs.
    
    :param parsed_queries: List of parsed SQL query segments.
    :param output_file: Output file name without extension.
    """
    dot = Digraph(comment="Combined SQL Query Diagram", format="png")
    dot.attr(rankdir="TB", size="20,15", dpi="300")  # Vertical layout with high DPI

    for query_index, parsed_sql in enumerate(parsed_queries, start=1):
        # Subgraph for each query
        query_graph = Digraph(name=f"cluster_query_{query_index}")
        query_graph.attr(label=f"Query {query_index}")
        query_graph.attr(style="dotted")

        # Add CTEs as nodes
        for cte_name, cte_query in parsed_sql["ctes"].items():
            truncated_cte = truncate_label(cte_query)
            label = f"{cte_name}\n{truncated_cte}"  # Truncated CTE content for readability
            query_graph.node(cte_name, label=label, shape="box", style="filled", fillcolor="lightblue")

        # Add main query
        if parsed_sql["main_query"]:
            truncated_main_query = truncate_label(parsed_sql["main_query"])
            main_query_label = "Main Query:\n" + truncated_main_query
            query_graph.node("MainQuery", label=main_query_label, shape="ellipse", style="filled", fillcolor="yellow")

            # Connect CTEs to the main query
            for cte_name in parsed_sql["ctes"]:
                if cte_name in parsed_sql["main_query"]:
                    query_graph.edge(cte_name, "MainQuery", label=f"Feeds into {cte_name}")

        # Add query to the combined graph
        dot.subgraph(query_graph)

    # Render and save the combined diagram
    dot.render(output_file, cleanup=True)
    print(f"Combined SQL query diagram saved as '{output_file}.png' and '{output_file}.svg'.")


def process_large_sql_file(file_path):
    """
    Process a large SQL file containing multiple queries and visualize them.
    
    :param file_path: Path to the SQL file.
    """
    with open(file_path, 'r') as file:
        sql_content = file.read()

    # Split the SQL file into individual queries
    queries = sqlparse.split(sql_content)
    parsed_queries = [parse_and_segment_sql(query) for query in queries]

    # Visualize all queries in a combined diagram
    visualize_combined_sql(parsed_queries)


# Example Usage
sql_file_path = "files/test5.sql"  # Path to your SQL file
process_large_sql_file(sql_file_path)
