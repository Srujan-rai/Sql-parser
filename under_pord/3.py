from graphviz import Digraph

def visualize_query_overview(query_details):
    """
    Visualize a MySQL-style query overview diagram.
    
    :param query_details: A dictionary representing the query components.
                          Example:
                          {
                              "tables": ["users", "roles", "orders"],
                              "columns": ["users.name", "roles.role_name", "orders.total_amount"],
                              "joins": [
                                  {"type": "INNER JOIN", "table1": "users", "table2": "roles", "condition": "users.role_id = roles.id"},
                                  {"type": "LEFT JOIN", "table1": "users", "table2": "orders", "condition": "users.id = orders.user_id"}
                              ],
                              "filters": ["users.name LIKE 'A%'", "orders.total_amount > 100"],
                              "group_by": ["users.role_id"],
                              "aggregates": ["SUM(orders.total_amount) AS total_spent"]
                          }
    """
    dot = Digraph(comment="Query Overview")

    # Add tables as nodes
    for table in query_details["tables"]:
        dot.node(table, label=table, shape="box")

    # Add joins as edges
    for join in query_details["joins"]:
        label = f"{join['type']} ({join['condition']})"
        dot.edge(join["table1"], join["table2"], label=label)

    # Add selected columns as a node
    if "columns" in query_details:
        columns_label = "Selected Columns:\n" + "\n".join(query_details["columns"])
        dot.node("Columns", label=columns_label, shape="note")

    # Add filters as a node
    if "filters" in query_details:
        filters_label = "Filters:\n" + "\n".join(query_details["filters"])
        dot.node("Filters", label=filters_label, shape="note", color="red")

    # Add aggregations and group by as nodes
    if "aggregates" in query_details:
        aggregates_label = "Aggregates:\n" + "\n".join(query_details["aggregates"])
        dot.node("Aggregates", label=aggregates_label, shape="note", color="blue")

    if "group_by" in query_details:
        group_by_label = "Group By:\n" + "\n".join(query_details["group_by"])
        dot.node("GroupBy", label=group_by_label, shape="note", color="green")

    # Link components for clarity
    dot.edge("Columns", "Filters", label="Filtered By")
    if "aggregates" in query_details:
        dot.edge("Filters", "Aggregates", label="Aggregate After Filtering")
    if "group_by" in query_details:
        dot.edge("Aggregates", "GroupBy", label="Grouped By")

    # Render and visualize
    dot.render("query_overview_diagram", format="png", cleanup=True)
    print("Query overview diagram saved as 'query_overview_diagram.png'.")

# Example Usage
query_details = {
    "tables": ["users", "roles", "orders"],
    "columns": ["users.name", "roles.role_name", "SUM(orders.total_amount) AS total_spent"],
    "joins": [
        {"type": "INNER JOIN", "table1": "users", "table2": "roles", "condition": "users.role_id = roles.id"},
        {"type": "LEFT JOIN", "table1": "users", "table2": "orders", "condition": "users.id = orders.user_id"}
    ],
    "filters": ["users.name LIKE 'A%'", "orders.total_amount > 100"],
    "group_by": ["users.role_id"],
    "aggregates": ["SUM(orders.total_amount) AS total_spent"]
}

visualize_query_overview(query_details)
