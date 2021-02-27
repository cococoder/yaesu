# frozen_string_literal: true
require 'bundler/inline'

require 'ost'
require 'sdbm'
require 'uuid'
require 'ostruct'
require 'msgpack'
require 'fileutils'

require_relative "yaesu/version"

module Yaesu
	class Error < StandardError; end

	def self.listen on:
		
		FileUtils.mkdir_p(".data/#{name}") unless Dir.exists? ".data"
		
		puts "listening on #{on}...."

		loop do
			Ost[on].items.each do |data|		
				SDBM.open "./.data/#{name}" do |db|
					o = MessagePack.unpack(data)
					message =OpenStruct.new(o)
					next if db.has_key? message.uid
					begin
						yield message if block_given?
						db[message.uid] = message.payload
					rescue Interrupt => e
						puts "listening on #{on}....finished!"
					rescue => exception
						p exception
					end
					
				end
			end
			sleep 0.200
		end
	end
end


