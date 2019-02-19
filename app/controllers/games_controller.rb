require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = Array.new(9) { ('A'..'Z').to_a[rand(26)] }
    @start_time = Time.now
  end

  def score
    grid = params[:grid].split('')
    @input = params[:input]
    start_time = params[:start_time].to_datetime

    end_time = Time.now
    @time_result = (end_time - start_time)
    run_game(@input, grid, start_time, end_time)
  end

  private

  BASE_URL = "https://wagon-dictionary.herokuapp.com/"

  def get_url(attempt)
    url = BASE_URL + attempt
    serialized_word = open(url).read
    word = JSON.parse(serialized_word)
    word
  end

  def compare(attempt, word, result, grid)
    attempt.upcase.chars.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        result[:message] = "not in the grid"
        return result
      end
    end
    result[:score] = word["length"] + [15 - result[:time], 1].max
    result[:message] = "well done"
    result
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    word = get_url(attempt)
    score = 0
    result = {
      time: end_time - start_time,
      score: score,
      message: "not an english word"
    }
    return result unless word["found"]

    compare(attempt, word, result, grid)
  end
end
