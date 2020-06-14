require_relative './player'

class CPU < Player
  def initialize pieces = nil
    @color = :black
    @pieces = pieces.nil? ? [] : pieces
  end

  %w[piece move].each do |item|
    define_method("choose_#{item}") do |ary|
      chosen = ary[rand(ary.size)]
    end
  end
end