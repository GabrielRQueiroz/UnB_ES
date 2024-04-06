def palindrome?(string)
	string = string.downcase.gsub(/\W/, '')
	string == string.reverse
end

print palindrome?("A man, a plan, a canal -- Panama"), "\n" # => true
print palindrome?("Madam, I'm Adam!"), "\n" # => true
print palindrome?("Abracadabra"), "\n" # => false (nil is also ok)

def count_words (string)
	words = string.downcase.scan(/\w+/)
	counts = Hash.new(0)
	words.each { |word| counts[word] += 1 }
	counts
end

print count_words("A man, a plan, a canal -- Panama"), "\n" # => {'a' => 3, 'man' => 1, 'canal' => 1, 'panama' => 1, 'plan' => 1}
print count_words("Doo bee doo bee doo"), "\n" # => {'doo' => 3, 'bee' => 2}


#Rock paper scissors
def rps_game_winner(setup)
	raise WrongNumberOfPlayersError unless setup.length == 2
	raise NoSuchStrategyError unless setup.all? { |player| player[1] =~ /^[RPS]$/i }

	player1, player2 = setup
	winner = player1[1].upcase + player2[1].upcase
	case winner
		when "RS", "SP", "PR" then player1
		when "SR", "PS", "RP" then player2
		else "Draw"
	end
end

print rps_game_winner([["Kristen", "P"], ["Pam", "S"]]), "\n" # => ["Pam", "S"]

def rps_tournament_winner(tournament)
	if tournament[0][0].is_a? String
		rps_game_winner(tournament)
	else
		rps_game_winner([rps_tournament_winner(tournament[0]), rps_tournament_winner(tournament[1])])
	end
end

print rps_tournament_winner([
	[
		[["Kristen", "P"], ["Dave", "S"]],
		[["Richard", "R"], ["Michael", "S"]],
	],
	[
		[ ["Allen", "S"], ["Omer", "P"] ],
		[["David E.", "R"], ["Richard X.", "P"]]
	]
]), "\n" # => ["Pam", "S"]

# input: ['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams', 'scream']
# => output: [["cars", "racs", "scar"], ["four"], ["for"], ["potatoes"], ["creams", "scream"]]
# HINT: you can quickly tell if two words are anagrams by sorting their
# letters, keeping in mind that upper vs lowercase doesn't matter
def combine_anagrams(words)
	# {
	#		"acrs" => ["cars", "racs", "scar"],
	#		...
	#   "acemrs" => ["creams", "scream"]
	# }
	anagrams = Hash.new { |hash, key| hash[key] = [] }
	words.each do |word|
		key = word.downcase.chars.sort.join
		anagrams[key] << word
	end
	anagrams.values
end

print combine_anagrams(['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams', 'scream']), "\n"

class Dessert
	attr_accessor :name, :calories

	def initialize(name, calories)
		@name = name
		@calories = calories
	end

	def healthy?
		calories < 200
	end

	def delicious?
		true
	end
end

class JellyBean < Dessert
	attr_accessor :flavor

	def initialize(name, calories, flavor)
		super(name, calories)
		@flavor = flavor
	end

	def delicious?
		flavor != "black licorice"
	end
end

pancake = Dessert.new("Pancake", 400)
print pancake.healthy?, "\n" # => false
print pancake.delicious?, "\n" # => true

jelly_bean = JellyBean.new("Jelly Bean", 150, "black licorice")
print jelly_bean.healthy?, "\n" # => true
print jelly_bean.delicious?, "\n" # => false

class Class
	def attr_accessor_with_history(attr_name)
		attr_name = attr_name.to_s # make sure it's a string
		attr_reader attr_name # create the attribute's getter
		attr_reader attr_name+"_history" # create bar_history getter
		class_eval %Q{
			def #{attr_name}=(value)
				if !defined? @#{attr_name}_history
					@#{attr_name}_history = [@#{attr_name}]
				end
				@#{attr_name} = value
				@#{attr_name}_history << value
			end
		}
	end
end

class Foo
	attr_accessor_with_history :bar
end

f = Foo.new # => #<Foo:0x127e678>
f.bar = 3 # => 3
f.bar = :wowzo # => :wowzo
f.bar = 'boo!' # => 'boo!'
print f.bar, "\n" # => 'boo!'
print f.bar_history, "\n" # => [nil, 3, :wowzo, 'boo!']
