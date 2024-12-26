from graphviz import Digraph

def visualize_query_schema(main_query, subqueries):
    """
    Visualize schema diagram for a query with subqueries and nested queries.
    
    :param main_query: A dictionary representing the main query structure. 
                       Example: {'name': 'MainQuery', 'tables': ['users', 'orders']}
    :param subqueries: A list of subqueries, where each subquery is represented as a dictionary.
                       Example: [{'name': 'SubQuery1', 'tables': ['roles'], 'parent': 'MainQuery'}]
    """
    dot = Digraph(comment='Query Schema Diagram')

    # Add main query as a node
    main_label = f"{main_query['name']}\nTables: " + ", ".join(main_query['tables'])
    dot.node(main_query['name'], label=main_label, shape='ellipse')

    # Add subqueries and nested queries as nodes
    for subquery in subqueries:
        sub_label = f"{subquery['name']}\nTables: " + ", ".join(subquery['tables'])
        dot.node(subquery['name'], label=sub_label, shape='ellipse')

        # Connect subquery to its parent
        dot.edge(subquery['parent'], subquery['name'], label='Subquery')

    # Render and visualize
    dot.render('query_schema_diagram', format='png', cleanup=True)
    print("Query schema diagram saved as 'query_schema_diagram.png'.")

# Example structure with nested queries
main_query = {'name': 'MainQuery', 'tables': ['users', 'orders']}
subqueries = [
    {'name': 'SubQuery1', 'tables': ['roles'], 'parent': 'MainQuery'},
    {'name': 'NestedQuery1', 'tables': ['permissions'], 'parent': 'SubQuery1'}
]

visualize_query_schema(main_query, subqueries)
