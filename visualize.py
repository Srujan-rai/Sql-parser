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

# Locate and interact with the close button area
def handle_close_area(driver):
    try:
        # Wait for the close button to appear
        close_button = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'button.ant-modal-close'))
        )
        
        # Click the close button
        close_button.click()
        print("Close button clicked successfully.")
        time.sleep(1)  # Allow some time for the modal to close
    except Exception as e:
        print(f"Error locating or interacting with the close button: {e}")


        
# Main function
def automate_sqlflow(file_path, download_dir):
    # Set up Chrome WebDriver with download preferences
    chrome_options = webdriver.ChromeOptions()
    prefs = {
        "download.default_directory": download_dir,
        "download.prompt_for_download": False,
        "safebrowsing.enabled": True,
    }
    chrome_options.add_experimental_option("prefs", prefs)
    driver = webdriver.Chrome(options=chrome_options)
    driver.maximize_window()

    # Open SQLFlow website
    driver.get("https://sqlflow.gudusoft.com/#/")
    print("Opened SQLFlow website.")
    time.sleep(5)
    # Load the SQL query
    sql_query = load_sql_query(file_path)

    # Set content in CodeMirror editor
    set_codemirror_content(driver, sql_query)
    print("SQL Query Pasted into CodeMirror Editor")

    # Locate and click the "Visualize" button
    visualize_button = driver.find_element(By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="visualize"]]')
    actions = ActionChains(driver)
    actions.move_to_element(visualize_button).click().perform()
    print("Clicked the 'Visualize' button.")
    time.sleep(3)  # Wait for the visualization and pop-up

    # Handle the close area
    handle_close_area(driver)

    # Locate the diagram and perform a right-click
    diagram_area = driver.find_element(By.CSS_SELECTOR, 'div.Canvas__k2Y31 .scale')
    actions.context_click(diagram_area).perform()  # Right-click on the diagram
    print("Right-clicked on the diagram.")
    time.sleep(1)  # Wait for the context menu to appear

    # Move the mouse slightly to the right and down to reach the context menu
    actions.move_by_offset(50, 10).perform()  # Adjust the offset as needed
    time.sleep(0.5)

    # Move the mouse down to the "Download as PNG" option
    for _ in range(6):  # Move down 6 times to reach the 7th option
        actions.move_by_offset(0, 30).perform()  # Adjust the vertical offset for menu item height
        time.sleep(0.2)  # Allow some time for hover effect

    # Click on the "Download as PNG" option
    actions.click().perform()
    print("Selected 'Download as PNG'.")

    # Wait for the download to complete
    time.sleep(5)  # Adjust timing as needed for the file to download
    print(f"Diagram downloaded to: {download_dir}")

    # Close the browser
    driver.quit()

# File containing the SQL query
sql_file = "files/test.sql"  # Path to your SQL file
download_directory = os.path.join(os.getcwd(), "downloads")
os.makedirs(download_directory, exist_ok=True)

automate_sqlflow(sql_file, download_directory)
