require "mytime/version"
require "mytime/setup"
require "mytime/timesheet"
require 'ruby-freshbooks'
require 'optparse'
require 'yaml'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

module Mytime
    extend self

    USER_FILE = File.expand_path('~/.mytime')

    # Parses command line arguments and does what needs to be done.
    #
    # @returns nothing
    def execute(*args)
      @options = parse_options(*args)
      command = args.shift || 'list'

      case command.to_sym
      when :init
        puts "We have all the time in the world."
        init
      when :status
        status
      when :commit
        puts "Submitting Timesheet..."
        commit(args.first)
      else
        puts @options
      end
    end

    def save(contents)
      File.open(USER_FILE, 'w') do |file|
        file.write contents.to_yaml
      end
    end

    def get_account_details
      return unless YAML.load_file(USER_FILE)
      YAML.load_file(USER_FILE).each do |key, texts|
        return key
      end
    end
end
