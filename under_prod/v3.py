from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import os

# Load SQL query from a file
def load_sql_query(file_path):
    with open(file_path, 'r') as file:
        return file.read()

# JavaScript to set content in CodeMirror editor
def set_codemirror_content(driver, query):
    script = """
    var editor = document.querySelector('.CodeMirror').CodeMirror;
    editor.setValue(arguments[0]);
    """
    driver.execute_script(script, query)

# Function to handle login process
def handle_login(driver, email, password):
    try:
        # Wait for the email input to appear and enter the email
        email_input = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "email"))
        )
        email_input.clear()
        email_input.send_keys(email)
        print("Email entered successfully.")

        # Wait for the password input to appear and enter the password
        password_input = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "password"))
        )
        password_input.clear()
        password_input.send_keys(password)
        print("Password entered successfully.")

        # Locate and click the login button
        login_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="login"]]'))
        )
        login_button.click()
        print("Login button clicked successfully.")
        time.sleep(2)  # Allow time for login to process
    except Exception as e:
        print(f"Error during login process: {e}")

# Function to process a single query
def process_query(driver, sql_query, actions):
    try:
        # Set content in CodeMirror editor
        set_codemirror_content(driver, sql_query)
        print("SQL query pasted into the CodeMirror editor.")
        time.sleep(2)

        # Locate and click the "Visualize" button
        visualize_button = driver.find_element(By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="visualize"]]')
        actions.move_to_element(visualize_button).click().perform()
        print("Clicked the 'Visualize' button.")
        time.sleep(3)  # Wait for the visualization and pop-up

        # Locate the diagram and perform a right-click
        diagram_area = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'div.Canvas__k2Y31 .scale'))
        )
        actions.context_click(diagram_area).perform()  # Right-click on the diagram
        print("Right-clicked on the diagram.")
        time.sleep(1)  # Wait for the context menu to appear

        # Move the mouse slightly to the right and down to reach the context menu
        actions.move_by_offset(50, 10).perform()  # Adjust the offset as needed
        time.sleep(0.5)

        # Move the mouse down to the "Download as PNG" option
        for _ in range(6):  # Move down 6 times to reach the 7th option
            actions.move_by_offset(0, 30).perform()  # Adjust the vertical offset for menu item height
            time.sleep(0.2)  

        # Click on the "Download as PNG" option
        actions.click().perform()
        print("Diagram downloaded.")
        time.sleep(5)  
    except Exception as e:
        print(f"Error processing query: {e}")


def automate_sqlflow_for_multiple_files(sql_files, download_dir):
    
    chrome_options = webdriver.ChromeOptions()
    prefs = {
        "download.default_directory": download_dir,
        "download.prompt_for_download": False,
        "safebrowsing.enabled": True,
    }
    chrome_options.add_experimental_option("prefs", prefs)
    driver = webdriver.Chrome(options=chrome_options)
    driver.maximize_window()
    
    actions = ActionChains(driver)

    try:
        # Open SQLFlow website
        driver.get("https://sqlflow.gudusoft.com/#/")
        print("Opened SQLFlow website.")
        time.sleep(5)

        # Locate and click the "Visualize" button to trigger the login
        visualize_button = driver.find_element(By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="visualize"]]')
        actions.move_to_element(visualize_button).click().perform()
        print("Clicked the 'Visualize' button to trigger login popup.")
        time.sleep(3)

        # Handle login popup
        email = "srujan.ci21@sahyadri.edu.in"
        password = "srujan@2003"  # Replace with the actual password
        handle_login(driver, email, password)
        time.sleep(10)  # Wait for login process to complete

        # Process each SQL file
        for sql_file in sql_files:
            print(f"Processing file: {sql_file}")
            sql_query = load_sql_query(sql_file)
            process_query(driver, sql_query, actions)

    finally:
        # Close the browser
        driver.quit()
        print("Session ended.")

# Directory containing the SQL files
sql_files_dir = "files"  # Path to your directory containing SQL files
sql_files = [os.path.join(sql_files_dir, file) for file in os.listdir(sql_files_dir) if file.endswith('.sql')]

# Directory to save the downloaded PNGs
download_directory = os.path.join(os.getcwd(), "downloads")
os.makedirs(download_directory, exist_ok=True)

# Automate for all SQL files
automate_sqlflow_for_multiple_files(sql_files, download_directory)
