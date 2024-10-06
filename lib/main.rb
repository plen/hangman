require 'yaml'

module Hangman
    class Board
        def initialize(word)
            @gameboard = Array.new(word.length, "_")
            @guessed_letters = Array.new
            @selected_word = word
            @matched_letters = 0
        end

        def update(letter, array_of_positions)

            if array_of_positions.empty?
                @guessed_letters.push(letter)
            else
                array_of_positions.each do |number|
                    if @gameboard[number] == "_" && @matched_letters < @selected_word.length
                        @gameboard[number] = letter
                        @matched_letters += 1
                    else
                        puts "the letter you entered seems to have been entered before."
                    end
                end
            end
        end

        def print_board
            puts "\n----------\n"
            print @gameboard.join(" ")
            puts "\n----------\n"
            print "letters guessed: ", @guessed_letters.join(" "), "\n"
        end

        def win?
            if @matched_letters == @selected_word.length
                puts "You have won!"
                return true
            end
        end
    end

    class Game
        def initialize(word_min_length, word_max_length)
            @words_array = File.open('google-10000-english-no-swears.txt').read.split("\n")
            @turns_counter = 0
            shortlisted_words = @words_array.select {|word| word.length >=word_min_length && word.length <= word_max_length }
            @selected_word = shortlisted_words.sample
            @board = Board.new(@selected_word)
            #@selected_word_array = Array.new(@selected_word.length, "")
            #@selected_word.split("").each_with_index {|x,y| @selected_word_array[y] = x}
        end

        def letter_match(letter)
            if @selected_word.include?(letter)
                @selected_word.split("").each_with_index.select {|key, value| key == letter}.map {|x,y| y}
            else 
                []
            end
        end

        def play()
            until @board.win? || @turns_counter > @selected_word.length
                puts "enter a letter: "
                input = gets.chomp
                if input.to_s == 'ss'
                    save_and_exit
                elsif input.match?(/\A[a-zA-Z]\z/)
                    @board.update(input,letter_match(input))
                    @board.print_board
                    @turns_counter +=1 if letter_match(input).empty?
                else
                    puts "Invalid input. Pls enter ONE letter, or ss to save and quit."
                end
            end

            puts "Game Over. The word was #{@selected_word}"
        end

        def start
            puts "Welcome to Hangman.\nEnter 1 to play and 2 to load game.\n"
            input = gets.chomp.to_i
            if input == 1
                play
            elsif input == 2
                game_params = YAML.safe_load(File.read('save.txt'), permitted_classes: [Hangman::Board, Symbol])
                @selected_word = game_params[:selected_word]
                @board = game_params[:board]
                @turns_counter = game_params[:turns_counter]
                play
            end
        end

        def save_and_exit
            File.open('save.txt', 'w') do |file|
                yams = {selected_word: @selected_word, board: @board, turns_counter: @turns_counter}
                file.write(yams.to_yaml)
            end
            puts "Game saved. Exiting..."
            exit
        end
    end
end