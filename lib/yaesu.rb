# frozen_string_literal: true
require 'bundler/inline'

require 'ost'
require 'sdbm'
require 'uuid'
require 'thor'
require 'ostruct'
require 'msgpack'
require 'fileutils'


require_relative "yaesu/version"

module Yaesu

	def self.configuration
		@configuration ||= OpenStruct.new(
		  {
			channel: "yaesu.local",
			name: "base",
			data_dir: "./.data"
		  }
		)
	end

	def self.configure
		yield(configuration)
	end

	class Error < StandardError; end
	def self.transmit on:, event:, data:
		Ost[on] << {uid: UUID.new.generate,event:event, data: data}.to_msgpack
	end
	
	def self.listen!
		self.listen name:Yaesu.configuration.name, on: Yaesu.configuration.channel
	end

	def self.listen name:, on:
		
		FileUtils.mkdir_p("#{Yaesu.configuration.data_dir}/#{name}") unless Dir.exists? ".data"
		
		puts "#{name} is listening on #{on} -> Ok!"

		begin
			loop do
				Ost[on].items.each do |data|		
					SDBM.open "#{Yaesu.configuration.data_dir}/#{name}" do |db|
						o = MessagePack.unpack(data)
						message =OpenStruct.new(o)
						next if db.has_key? message.uid
						begin
							yield message if block_given?
							db[message.uid] = message.payload
						rescue => exception
							p exception
						end		
					end
				end
				sleep 0.200
			end
		rescue Interrupt => e
			puts "#{name} stopped listening on #{on} -> Ok!"
		end
	end
end


