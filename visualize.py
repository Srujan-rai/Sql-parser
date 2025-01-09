from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import os

def load_sql_query(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def set_codemirror_content(driver, query):
    script = """
    var editor = document.querySelector('.CodeMirror').CodeMirror;
    editor.setValue(arguments[0]);
    """
    driver.execute_script(script, query)

def handle_login(driver, email, password):
    try:
        email_input = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "email"))
        )
        email_input.clear()
        email_input.send_keys(email)
        print("Email entered successfully.")

        password_input = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "password"))
        )
        password_input.clear()
        password_input.send_keys(password)
        print("Password entered successfully.")

        login_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="login"]]'))
        )
        login_button.click()
        print("Login button clicked successfully.")
        time.sleep(2)
    except Exception as e:
        print(f"Error during login process: {e}")

def process_query(driver, sql_query, actions):
    try:
        set_codemirror_content(driver, sql_query)
        print("SQL query pasted into the CodeMirror editor.")
        time.sleep(4)

        visualize_button = driver.find_element(By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="visualize"]]')
        actions.move_to_element(visualize_button).click().perform()
        print("Clicked the 'Visualize' button.")
        time.sleep(15)  

        diagram_area = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'div.Canvas__k2Y31 .scale'))
        )
        actions.context_click(diagram_area).perform()  
        print("Right-clicked on the diagram.")
        time.sleep(1)  

        actions.move_by_offset(50, 10).perform()  
        time.sleep(0.5)

       
        for _ in range(6):  
            actions.move_by_offset(0, 30).perform()  
            time.sleep(0.2)  

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
        driver.get("https://sqlflow.gudusoft.com/#/")
        print("Opened SQLFlow website.")
        time.sleep(12)

        visualize_button = driver.find_element(By.XPATH, '//button[contains(@class, "ant-btn-primary") and .//span[text()="visualize"]]')
        actions.move_to_element(visualize_button).click().perform()
        print("Clicked the 'Visualize' button to trigger login popup.")
        time.sleep(3)

        email = "srujan.ci21@sahyadri.edu.in"
        password = "srujan@2003"  
        handle_login(driver, email, password)
        time.sleep(20) #componsating for slow internet connection
        
        for sql_file in sql_files:
            print(f"Processing file: {sql_file}")
            sql_query = load_sql_query(sql_file)
            process_query(driver, sql_query, actions)

    finally:
        driver.quit()
        print("Session ended.")

sql_files_dir = "files"  
sql_files = [os.path.join(sql_files_dir, file) for file in os.listdir(sql_files_dir) if file.endswith('.sql')]

download_directory = os.path.join(os.getcwd(), "downloads")
os.makedirs(download_directory, exist_ok=True)

automate_sqlflow_for_multiple_files(sql_files, download_directory)
    