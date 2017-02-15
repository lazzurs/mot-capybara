#!/usr/bin/env ruby

require 'optparse'
require 'capybara'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
#Capybara.javascript_driver = :selenium
#Capybara.default_driver = :firefox

session = Capybara::Session.new(:poltergeist)

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: carers_health_check.rb [options]"
  opts.on('-r', '--registration NUMBER', '') { |v| options[:reg_number] = v }
  opts.on('-m', '--make NAME', '') { |v| options[:make_name] = v }
end.parse!

reg_number = options[:reg_number]
make_name = options[:make_name]

session.visit 'https://www.check-mot.service.gov.uk/'

if session.has_content?("Check the MOT history of a vehicle")
  session.fill_in('registration', :with => reg_number)
  session.fill_in('manufacturer', :with => make_name)
  session.click_button('Search')
else
  puts 'The MOT History service is broken'
  exit(-1)
end

puts session.find(:xpath, './/div[3]/div/ul/li[2]/span[2]', :match => :first).text

#session.save_screenshot('screenshot.png', :full => true)
