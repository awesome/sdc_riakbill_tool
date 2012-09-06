#!/usr/bin/env ruby
## coding: utf-8
#

require 'bundler/setup'
require 'thor'
require 'uri'
require 'json'
require 'yaml'
require 'riak'

module Riak
  # disable waning messages
  self.disable_list_keys_warnings = true
end


class Riakbill < Thor
  ## load riak client config.
  @@config = JSON.parse(DATA.read, :symbolize_names => true)

  desc "list", "list all buckets"
  def list
    client = connect_to_riak(@@config[:riak])
    all_buckets =  client.list_buckets
    all_buckets.map {|i| puts i.name}
  end	

  desc "reports", "list available reports and print index"
  def reports
    backet_name = "billing_reports"
    client = connect_to_riak(@@config[:riak])
    all_reports = client.list_keys(backet_name)
    all_reports.each_with_index do |reports, index|
      puts "#{index}: #{URI.unescape(URI.unescape(reports))}"
      begin
        data = client.get_object(backet_name, reports).data
        puts ["  in_progress? => ", data["in_progress"], ",  has_report? => ", data.has_key?("report")].join
      rescue Riak::HTTPFailedRequest => e
        # puts e.message
        puts "  Report Not Found."
      end
    end
  end	

  desc "show", "show report"
  method_option :number, :type => :numeric , :required => true, :aliases => "-n"
  def show
    backet_name = "billing_reports"
    client = connect_to_riak(@@config[:riak])

    all_reports = client.list_keys(backet_name)
    begin
      # puts JSON.pretty_generate(client.get_object(backet_name, all_reports[options[:number]]).data)
      puts client.get_object(backet_name, all_reports[options[:number]]).data.to_yaml
    rescue Riak::HTTPFailedRequest => e
      # puts e.message
      puts "  Report Not Found."
    end
  end	

  desc "uuid_info", "show information by uuid. configs and timestamps"
  method_option :uuid, :type => :string , :required => true, :aliases => "-u"
  method_option :silent, :type => :boolean , :aliases => "-s"
  def uuid_info
    backet_name = ["billing_", options[:uuid], "_timestamps"].join
    client = connect_to_riak(@@config[:riak])

    %w(_configs _timestamps).each do |suffix|
      backet_name = ["billing_", options[:uuid], suffix].join
      begin
        keys = client.list_keys(backet_name)
        keys.map do |key|
          puts [backet_name, ": " , key].join unless options[:silent]
          # puts JSON.pretty_generate(client.get_object(backet_name, options[:key]).data)
          puts client.get_object(backet_name, options[:key]).data.to_yaml
        end
      rescue Riak::HTTPFailedRequest => e
        # puts e.message
        puts "  Bucket Not Found."
      end
    end
  end	


  private
  def connect_to_riak(con_options = {})
    Riak::Client.new(con_options)
  end
end

Riakbill.start

__END__
{
  "riak": {
    "host": "set_ip_address",
    "http_port": 8098
  }
}

