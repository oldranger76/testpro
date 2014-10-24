require 'selenium-webdriver'

# TC 01.01 "Sign in":
# Open browser
# Navigate to bluescape.com sign in page
# Input valid email and password
# Click "Sign in" button

browser = Selenium::WebDriver.for :chrome
browser.manage.timeouts.implicit_wait = 10
url = "https://portal.bluescape.com/users/sign_in"

browser.navigate.to url
#browser.manage.window.resize_to(1600, 900)
browser.manage.window.maximize
email = "rufat.nadir@gmail.com"
password = "nr3181299"

email_field = browser.find_element(:xpath => '//*[@id="user_email"]')
user_email = email
email_field.send_keys user_email

password_field = browser.find_element(:xpath => '//*[@id="user_password"]')
user_pass = password
password_field.send_keys user_pass

signin_button = browser.find_element(:xpath => '//*[@id="new_user"]/div[2]/input').click

# TC 01.02 "Create workspace and open it"
# Click on your organization

organization = browser.find_element(:xpath => "/html/body/div[2]/div/div/div[1]/ul/li/a").click

# Create new workspace
new_workspace = browser.find_element(:xpath => "//*[@id='session-list']/div[1]/div[2]/a").click
browser.switch_to.active_element
ws_name = browser.find_element(:xpath => "//*[@id='editable_session_name']")
ws_name.send_keys "Workspace " + Time.now.to_s[0..18]
ws_description = browser.find_element(:xpath => '//*[@id="editable_session_description"]')
ws_description.send_keys "New test workspace"
create_button = browser.find_element(:xpath => '//*[@id="new_editable_session"]/div[3]/input')
create_button.click

# Open your workspace
open_ws = browser.find_element(:class, "tooltip-app").click
wait = Selenium::WebDriver::Wait.new(:timeout => 15) #seconds
is_displayed = browser.find_element(:xpath, "/html/body/div[9]/div/a[2]").displayed?
puts is_displayed
location = browser.find_element(:xpath, "/html/body/div[9]/div/a[2]").location.to_s
puts location
close_tour = browser.find_element(:xpath, "/html/body/div[9]/div/a[2]").click
#wait.until {browser.find_element(:xpath, "/html/body/div[9]/div/a[2]").displayed?} # Problem here! in `assert_ok': unknown error: Element is not clickable at point (960, 551
#browser.find_element(:partial_link_text, "Close the tour").click
