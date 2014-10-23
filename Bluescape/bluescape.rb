if RUBY_PLATFORM =~ /linux/; os = "Linux"
elsif RUBY_PLATFORM =~ /32/; os = "Windows"
elsif RUBY_PLATFORM =~ /darwin11/; os = "Mac OS X 10.7 Lion"
elsif RUBY_PLATFORM =~ /darwin12/; os = "OS X 10.8 Mountain Lion"
elsif RUBY_PLATFORM =~ /darwin13/; os = "OS X 10.9 Mavericks"
elsif RUBY_PLATFORM =~ /darwin14/; os = "OS X 10.10 Yosemite"
end

puts "Please, enter your email address to login to bluescape: "
email = gets.chomp
puts "PLease, enter your password: "
password = gets.chomp

print "##################################################\n"
print "### User \t\t\t\t: #{ENV['USER']} \n"
print "### Email \t\t\t\t: #{email} \n"
print "================================================== \n"
print "### Date \t\t\t\t: #{Time.now.to_s[0..18]} \n"
print "### Operating System \t: #{os} \n"
print "### Ruby version \t\t: #{RUBY_VERSION} \n"

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
browser.manage.window.resize_to(1600, 900)
#browser.manage.window.maximize

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
wait.until {browser.find_element(:class, ).displayed?}
close_tour = browser.find_element(:css, "body > div.walkthrough-overlay > div > a.close-tour-btn.dismiss.ui-icon-delete-o-circle").click
#wait.until {browser.find_element(:xpath, "/html/body/div[9]/div/a[2]").displayed?} # Problem here! in `assert_ok': unknown error: Element is not clickable at point (960, 551
#browser.find_element(:partial_link_text, "Close the tour").click


# TC 03
# Create new Note card
new_notecard = browser.find_element(:xpath => "//*[@id='note-creator-button']/i")
new_notecard.click
text_field = browser.find_element(:xpath => '//*[@id="note-creator"]/section/form/div[1]/textarea')
note_text = text_field.send_keys "New Note Card"
wait.until {browser.find_element(:xpath => "//*[@id='note-creator']/section/form/div[2]/div[3]/button").displayed?}
create_note = browser.find_element(:xpath => "//*[@id='note-creator']/section/form/div[2]/div[3]/button").click
new_notecard.click

# Verify Note card exist


# Email via Microsoft Outlook

require 'win32ole'
outlook = WIN32OLE.new('Outlook.Application')

message = outlook.CreateItem(0)
message.Subject = "Test case #{ws_name}"
message.Body = "Test case #{ws_name} pass"
message.To = email
#message.Recipients.Add 'utest4u@gmail.com'                           # Additional recipient
#message.Attachments.Add ('C:\Users\rnadir\Pictures\img\tiger.jpg')    # Full path AS IT. No underscore !
#message.Attachments.Add ('C:\QA\Ruby\My Scripts\EFI QA Jobs_1.png')
message.Send

browser.quit


