if RUBY_PLATFORM =~ /linux/; os = "Linux"
elsif RUBY_PLATFORM =~ /32/; os = "Windows"
elsif RUBY_PLATFORM =~ /darwin11/; os = "Mac OS X 10.7 Lion"
elsif RUBY_PLATFORM =~ /darwin12/; os = "OS X 10.8 Mountain Lion"
elsif RUBY_PLATFORM =~ /darwin13/; os = "OS X 10.9 Mavericks"
elsif RUBY_PLATFORM =~ /darwin14/; os = "OS X 10.10 Yosemite"
end


puts "Please, enter your email address to login to bluescape: "
email = gets.chomp                            # Get user email and assign it to variable
puts "Please, enter your password: "
password = gets.chomp                         # Get user password and assign to variable

print "##################################################\n"
print "### User \t\t\t\t: #{ENV['USER']} \n"
print "### Email \t\t\t\t: #{email} \n"
print "================================================== \n"
print "### Date \t\t\t\t: #{Time.now.to_s[0..18]} \n"
print "### Operating System \t: #{os} \n"
print "### Ruby version \t\t: #{RUBY_VERSION} \n"

require 'selenium-webdriver'
require 'test/unit'
actions = Selenium::WebDriver::ActionBuilder

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

# 2.Create new workspace

browser.find_element(:xpath => "//*[@id='session-list']/div[1]/div[2]/a").click
puts "Creating new workspace"

browser.switch_to.active_element

ws_name_field = browser.find_element(:xpath => "//*[@id='editable_session_name']")
ws_name = "Workspace " + Time.now.to_s[0..18]
ws_name_field.send_keys ws_name
puts "Workspace name is: #{ws_name}"

ws_description = browser.find_element(:xpath => '//*[@id="editable_session_description"]')
ws_description.send_keys "New test workspace. Created @ " + Time.now.to_s[0..18]

ws_create_button = browser.find_element(:xpath => '//*[@id="new_editable_session"]/div[3]/input')
ws_create_button.click
puts "Workspace successfully created!"


# 3.Open your workspace
browser.find_element(:class, "tooltip-app").click
puts "Opening workspace: "


sleep(5)                        # There is a bug on chrome-driver which sometime cannot click element, I used 5 second delay to avoid it
browser.find_element(:xpath, "/html/body/div[9]/div/a[2]").click    # Close tour



puts "Workspace opened!"
puts "New page title is: #{browser.title}"

# TC 01.03 Create new Note card

new_notecard = browser.find_element(:xpath, "//*[@id='note-creator-button']/i")
new_notecard.click
puts "Creating new notecard"
browser.find_element(:xpath, '//*[@id="note-creator"]/section/form/div[1]/textarea').send_key "New Note Card"

browser.find_element(:xpath, "//*[@id='note-creator']/section/form/div[2]/div[3]/button").displayed?

sleep(5)                        # Same problem as above with "Close tour" button
browser.find_element(:xpath, "//*[@id='note-creator']/section/form/div[2]/div[3]/button").click

new_notecard.click
puts "New notecard created!"

# Verify Note card exist
is_notecard = browser.find_element(:class, "text-container").displayed?
puts "Is notecard displayed: #{is_notecard}"





# This code will send email via Microsoft Outlook to the address provided above.
# Please, comment out this section, if you don't have MS Outlook installed on your machine

=begin
require 'win32ole'
outlook = WIN32OLE.new('Outlook.Application')
message = outlook.CreateItem(0)
message.Subject = "New workspace created"
message.Body = "New workspace: #{ws_name} created"
message.To = email
#message.Recipients.Add 'utest4u@gmail.com'                           # Additional recipient
message.Send

=end


# Closing browser
puts "Closing browser, Test case pass!"
browser.quit