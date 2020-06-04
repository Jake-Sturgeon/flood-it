#include required ruby gems to gmae
require 'console_splash'
require 'colorize'

#returns array with randomly assigned values
def get_board(width, height)
  boardChange = Array.new(height){Array.new(width)}
  (0..height - 1).each do |i|
    (0..width - 1).each do |j|
      boardChange[i][j] = getRandomColor
    end  
  end
  return boardChange
end

#method to return a random colour
def getRandomColor()
  num = Random.rand(1..6)
  if num == 1 then return :red
  elsif num == 2 then return :blue
  elsif num == 3 then return :green
  elsif num == 4 then return :yellow
  elsif num == 5 then return :cyan
  elsif num == 6 then return :magenta
  end
end
    
#retuns colour from given input i.e. "r" = red
def getColor(c)
  if c == "r" then return :red
  elsif c == "b" then return :blue
  elsif c == "g" then return :green
  elsif c == "y" then return :yellow
  elsif c == "c" then return :cyan
  elsif c == "m" then return :magenta
  end
end
    
#method used to print a cell. Uses colorize gem 
#It iterates through all the elements in the array and prints
#it to the screen 
def printGrid(boardGame)
  (0..boardGame.length - 1).each do |i|
    (0..boardGame[i].length - 1).each do |j|
      print "  ".colorize(:background => boardGame[i][j])
      if boardGame[i].length - 1 == j then
        puts
      end
    end  
  end
end

#Draws splashscreen. Uses console_splash gem 
def splashScreen(width, height)
  splash = ConsoleSplash.new(height, width);
  splash.write_header("Welcome to Flood-It", "Jake Sturgeon", "1.0")
  splash.write_center(-3, "<Press enter to continue>")
  splash.write_horizontal_pattern("*")
  splash.write_vertical_pattern("*")
  splash.splash
  puts ""
end

  
#method that handles flood-it
def game(boardGame)
  #init local game variables
  completed = 0
  turns = 0
  quit = false
  
  #begin game loop
  begin
    #get old colour from top left and check the games completion 
    oldColor = boardGame[0][0]
    completed = completion boardGame, oldColor
    
    #if completed >= 100 then the game will end
    if completed < 100 then
      printGrid boardGame
      puts "Number of turns: #{turns}"
      puts "Current completion: #{completed}%"
      print "Choose a colour: "
      color = gets.chomp
      
      #checks if input is a valid colour.
      #true --> game is updated
      #if q --> quit to menuMain
      #else re-print board and wait for an other input 
      if isColor(color.downcase) then
        turns += 1
        setColors boardGame, getColor(color.downcase), oldColor, 0, 0
        system("clear")
      elsif color == "q" then
        quit = true
      else
        system("clear")
      end
    else
      quit = true
    end
  end while quit == false
  #update bestGame score
  if completed >= 100 then
    if turns < $bestGame or $bestGame == 0 then
      $bestGame = turns
    end
    puts "You won after #{turns} turns"
  end
  #when game closes
  puts "Thanks for playing"
  gets
  system("clear")  
end
     
#method to check the completion of the game
#Returns an percentage
def completion(boardGame, oldColor)
  count = 0.0;
  (0..boardGame.length - 1).each do |i|
    (0..boardGame[i].length - 1).each do |j|
      if boardGame[i][j] == oldColor then
        count += 1
      end
    end  
  end
  return ((count/(boardGame.length*boardGame[0].length))*100.0).floor
end
      
#method to recursivly upade the board
def setColors(boardGame, newColor, oldColor, i, j) 
  #checks if the pointer is within the bounds of the array and the colour that needs to be replaced 
  #but not the new colour as this can lead to a stackoverflow
  if (i >= 0 and i <= boardGame.length - 1) and (j >= 0 and j <= boardGame[i].length - 1) and (boardGame[i][j] == oldColor) and (newColor != oldColor) then 
    boardGame[i][j] = setColors boardGame, newColor, oldColor, i - 1, j
    boardGame[i][j] = setColors boardGame, newColor, oldColor, i + 1, j
    boardGame[i][j] = setColors boardGame, newColor, oldColor, i, j + 1
    boardGame[i][j] = setColors boardGame, newColor, oldColor, i, j - 1 
  else
    return newColor
  end
end
  
#method that returns true if it is a valid colour
def isColor(c)
  if c == "r" or c == "b" or c == "g" or c == "y" or c == "c" or c == "m" then
    return true
  else
    return false
  end
end
  
#method that handles the menu interface
def menuMain(boardHeight, boardWidth)
  #init game board
  boardGame = get_board boardWidth, boardHeight
  #init local variables
  played = false
  leave = false  
  #begin menu loop
  begin
    puts "Main menu:"
    puts "s = Start game"
    puts "c = Change size"
    puts "q = quit game"
    
    #checks if player has played. 
    #if true --> print best
    #else print "No games played yet" 
    if(played == false) then
      puts "No games played yet"
    else
      puts "Best game: #{$bestGame} turns"
    end
    
    #wait for and get user input
    print "Please enter your choice: "
    choice = gets.chomp
      
    #handles user input
    #Start game
    if choice == 's' then
      puts "Start the game"
      system("clear")
      #start game
      game boardGame
      #after the game has finish program returns here
      #if user had finished the game and got a best score
      #set played to true
      if($bestGame > 0) then
        played = true
      end
      #make new board incase they wish to play again
      boardGame = get_board boardWidth, boardHeight
    #start choice interface
    elsif choice == 'c' then
      #loops until valid input. valid > 0
      begin
        print "Width (Currently #{boardGame[0].length()}?) "
        boardWidth = gets.chomp.to_i
      end while boardWidth <= 0
      #loops until valid input. valid > 0
      begin
        print "Height (Currently #{boardGame.length()}?) "
        boardHeight = gets.chomp.to_i
      end while boardHeight <= 0
      #update game game board
      boardGame = get_board boardWidth, boardHeight  
    #quits game if user inputs q 
    elsif choice == 'q' then
      puts "You have quited the game"
      puts "Thank you for playing"
      leave = true     
    else
      puts "Not a valid input"
    end
  end while leave == false 
end
      
#----start of main----#
#init global
$bestGame = 0
#init game width and height     

#init splashscreen constants
WIDTH = 40
HEIGHT = 15
splashScreen WIDTH, HEIGHT

#wait for user input of enter
gets
#start game with width and height
boardHeight = 9
boardWidth = 14
menuMain boardHeight, boardWidth
##----End of main----#
