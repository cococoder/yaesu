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
	class Error < StandardError; end
	def self.transmit on:, data:
		Ost[on] << {uid: UUID.new.generate, payload: data}.to_msgpack
	end
	def self.listen name:, on:
		
		FileUtils.mkdir_p(".data/#{name}") unless Dir.exists? ".data"
		
		puts "listening on #{on}...."

		begin
			loop do
				Ost[on].items.each do |data|		
					SDBM.open "./.data/#{name}" do |db|
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
			puts "listening on #{on}....finished!"
		end
	end
end


