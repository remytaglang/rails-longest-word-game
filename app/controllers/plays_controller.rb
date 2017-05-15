require 'open-uri'
require 'json'

class PlaysController < ApplicationController


  def game
    @grid = generate_grid(9)
  end

  def score

    # def generate_grid(grid_size)
    # @grille = Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
    # @belle_grille = @grille.join(" ")
    # end

    @attempt = params[:attempt]
    @grid = params[:grid]
    @result = run_game(@attempt, @grid)
  end


    def included?(guess, grid)
      guess.split("").all? { |letter| guess.split("").count(letter) <= grid.count(letter) }
    end

    def compute_score(attempt)
      score_a = 20
    end

    def run_game(attempt, grid)
      result = {}
      result[:translation] = get_translation(attempt)
      result[:score], result[:message] = score_and_message(
        attempt, result[:translation], grid)

      result
    end

    def score_and_message(attempt, translation, grid)
      if included?(attempt.upcase, grid)
        if translation
          score = compute_score(attempt)
          [score, "well done"]
        else
          [0, "not an english word"]
        end
      else
        [0, "not in the grid"]
      end
    end

    def get_translation(word)
      api_key = "f344bd65-939f-4a5d-be99-c0e46f227389"
      begin
        response = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api_key}&input=#{word}")
        json = JSON.parse(response.read.to_s)
        if json['outputs'] && json['outputs'][0] && json['outputs'][0]['output'] && json['outputs'][0]['output'] != word
          return json['outputs'][0]['output']
        end
      rescue
        if File.read('/usr/share/dict/words').upcase.split("\n").include? word.upcase
          return word
        else
          return nil
        end
      end
    end


    def generate_grid(grid_size)
      Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
    end







end
