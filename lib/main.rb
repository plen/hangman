module Hangman
    class Game

        def initialize
            @words_array = File.open('google-10000-english-no-swears.txt').read.split("\n")
            @turns_counter = 0
            @selected_word = String.new
            @guessed_letters = Array.new
        end

        def get_word(word_min_length, word_max_length)
            shortlisted_words = Array.new
            shortlisted_words = @words_array.select {|word| word.length >=5 && word.length <= 12 }
            @selected_word = shortlisted_words.sample
            @progress = @selected_word.split("").to_h {|x| [x.to_sym, "_"] } # the mix of dashes and letters showing game progress
        end

        def letter_match?(letter)
            return @selected_word.include?(letter)
        end

        def print_result
            puts "\n----------\n"
            print @progress.values
            puts "\n----------\n"
            print "letters guessed: ", @guessed_letters, "\n"
        end

        def guesses(selected_letter)
            if letter_match?(selected_letter)
                @progress[selected_letter.to_sym] = selected_letter.to_s
            else
                puts "Letter doesn't exist. One step closer now."
                @turns_counter += 1
                @guessed_letters.push(selected_letter)
            end
        end

        def play()

            get_word(5,12)

            while @turns_counter < @selected_word.length+1
                puts "enter a letter: "
                guesses(gets.chomp)
                print_result
            end

            if @turns_counter == @selected_word.length+1
                puts "Game Over. The word was #{@selected_word}"
            end
        end
    end
end