require_relative 'board'
require_relative 'pieces'
Dir["./pieces/*"].each { |file| require "#{file}" }