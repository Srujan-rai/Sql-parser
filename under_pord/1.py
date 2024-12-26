from graphviz import Digraph

def visualize_schema(tables):
    """
    Visualize the schema diagram.
    
    :param tables: A dictionary where keys are table names and values are lists of columns or foreign keys.
                   Example: {'users': ['id', 'name', 'email', 'role_id (FK)'], 
                             'roles': ['id', 'role_name']}
    """
    dot = Digraph(comment='Schema Diagram')

    # Add tables as nodes
    for table, columns in tables.items():
        label = f"{table}\n" + "\n".join(columns)
        dot.node(table, label=label, shape='box')

    # Add relationships (foreign keys) as edges
    for table, columns in tables.items():
        for column in columns:
            if '(FK)' in column:  # Detect foreign key columns
                fk_column = column.split()[0]
                target_table = fk_column.split('_')[0]  # Assuming FK names are like `role_id`
                dot.edge(table, target_table, label=fk_column)

    # Render and visualize
    dot.render('schema_diagram', format='png', cleanup=True)
    print("Schema diagram saved as 'schema_diagram.png'.")

# Example schema
schema = {
    'users': ['id', 'name', 'email', 'role_id (FK)'],
    'roles': ['id', 'role_name'],
    'orders': ['id', 'user_id (FK)', 'total_amount'],
}

visualize_schema(schema)
