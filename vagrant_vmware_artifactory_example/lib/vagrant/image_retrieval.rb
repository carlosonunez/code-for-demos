#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

def retrieve_latest_box_file_from_artifactory(args)
  url = args[:url]
  box_file = args[:box_kind]
  list_of_box_files_from_artifactory =
    retrieve_list_of_box_files_as_csv :url => url, :search_terms => box_file
  find_latest_box_file_in_list :list_of_box_files_csv => list_of_box_files_from_artifactory,
    :url => url
end

private
require 'net/http'
require 'uri'
require 'time'

def get_url_body_with_redirects_or_die(args)
  uri =  URI.parse(args[:url])
  current_depth = 0
  max_depth = 10
  while current_depth < max_depth do
    begin
      response = Net::HTTP.get_response(uri)
    rescue SocketError
      raise "Your Artifactory URL seems to be invalid: #{uri}"
    end
    raise "Your Artifactory URL is invalid: #{url}" if response.code == '404'
    if response.code == '301' or response.code == '302'
      next_uri = URI.parse response.header['location']
      response = Net::HTTP.get_response next_uri
    end
    if response.code == '200'
      body = response.body
      break
    end
    current_depth += 1
  end
  if current_depth == max_depth
    raise "Too many redirects returned from your box_file artifactory at #{url}."
  end
  body
end

def retrieve_list_of_box_files_as_csv(args)
  url = args[:url]
  search_terms = args[:search_terms]
  find_long_spaces_regex = /[ ]{2,}/
  box_files_available_from_artifactory_html = get_url_body_with_redirects_or_die url: url
  matching_box_files_as_csv = box_files_available_from_artifactory_html.gsub!(find_long_spaces_regex,',')
    .split("\n")
    .select do |line|
    line.include? "<a href=\"#{search_terms}"
  end
  matching_box_files_as_csv
end

def find_latest_box_file_in_list(args)
  list_of_box_files_csv = args[:list_of_box_files_csv]
  box_file_artifactory_url = args[:url]
  box_files = list_of_box_files_csv.map do |box_file_data_csv|
    box_file_data = box_file_data_csv.split(',')
    box_file_name = box_file_data[0].gsub /^.*>(.*)\.box<.*$/,'\1'
    box_file_upload_date = Time.parse box_file_data[1]
    {
      :box_name => box_file_name,
      :box_uri => "#{box_file_artifactory_url}/#{box_file_name}.box",
      :box_upload_date => box_file_upload_date
    }
  end
  box_files_sorted_by_upload_date = box_files.sort do |left, right|
    left[:box_upload_date] <=> right[:box_upload_date]
  end
  latest_box_file_found = box_files_sorted_by_upload_date.last
  latest_box_file_found
end
