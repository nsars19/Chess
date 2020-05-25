require_relative 'board'
require_relative 'player'
Dir["./pieces/*"].each { |file| require "#{file}" }