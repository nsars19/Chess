require_relative 'board'
require_relative 'player'
Dir["./modules/*"].each { |file| require "#{file}" }
Dir["./pieces/*"].each  { |file| require "#{file}" }