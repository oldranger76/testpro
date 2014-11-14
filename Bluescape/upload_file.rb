puts "Please, enter your email address to login to bluescape: "
email = gets.chomp                            # Get user email and assign it to variable
puts "Please, enter your password: "
password = gets.chomp                         # Get user password and assign to variable

print "##################################################\n"
print "### User \t\t\t\t: #{ENV['USER']} \n"
print "### Email \t\t\t\t: #{email} \n"
print "================================================== \n"
print "### Date \t\t\t\t: #{Time.now.to_s[0..18]} \n"
print "### Ruby version \t\t: #{RUBY_VERSION} \n"

require 'selenium-webdriver'
require 'test/unit'


# TC 01.01 "Sign in":
# Open browser
# Navigate to bluescape.com sign in page
# Input valid email and password
# Click "Sign in" button

browser = Selenium::WebDriver.for :chrome
browser.manage.timeouts.implicit_wait = 10
url = "https://portal.bluescape.com/users/sign_in"


browser.navigate.to url                       # Open Sign-in page
puts "Navigating to #{url}"
browser.manage.window.maximize                # Maximize browser window
puts "Maximize window. Window resolution: #{browser.manage.window.size.to_a}"
puts "New page title is: #{browser.title}"

email_field = browser.find_element(:xpath => '//*[@id="user_email"]')
email_field.send_keys email
puts "Entering email address: #{email}"

password_field = browser.find_element(:xpath => '//*[@id="user_password"]')
password_field.send_keys password
puts "Entering password"

browser.find_element(:xpath => '//*[@id="new_user"]/div[2]/input').click
puts "Signing in"
sleep(1)
puts "New page title is: #{browser.title}"

# TC 01.02 "Create workspace and open it"
# 1.Click on your organization name
browser.find_element(:class, "organization-listing").click

# Open workspace
browser.find_element(:class, "tooltip-app").click
puts "Opening workspace: "

sleep(5)                        # There is a bug on chrome-driver which sometime cannot click element, I used 5 second delay to avoid it
browser.find_element(:xpath, "/html/body/div[9]/div/a[2]").click    # Close tour

puts "Workspace opened!"

browser.find_element(:class, "upload").click

f = IO.popen("hangout.exe")
puts f.readlines