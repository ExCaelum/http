## HTTP - Yeah You Know Me
###### This Program requires the extension "Postman" from google chrome.
### Instructions
In order to run this program, open your terminal and type     
 $ Ruby run_server.rb     
 This will cause the server to run, at which point you can open Postman and enter the URL    
 "http://127.0.0.1:9297/hello"     
 This will display a welcome message.
 #### Functions
 For all functions you will need to have http://127.0.0.1:9297 as the beginning part of the URL. The function changes depending on the URL.
 1. http://127.0.0.1:9297/     
 This shows you all of the debugging info that your server has such as verb, path, protocol, and Host.
 2. http://127.0.0.1:9297/datetime     
 This will display the current Date and Time
 3. http://127.0.0.1:9297/hello    
 This displays the common 'Hello World!' message, as well as a counter that displays how many times it has been called
 4. http://127.0.0.1:9297/word_search?word=parameter     
 In order to use this functionality, you can replace the word parameter with any word of your choosing. It will tell you whether or not the word you have given is a valid word or not.
 5. http://127.0.0.1:9297/start_game     
 This instantiates a new game. The objective of the game is too guess the number that the computer is thinking.
 6. http://127.0.0.1:9297/game      
 Make sure to use this in Postman while using the 'POST' verb. In order to play the game, you will enter this URL and enter a number into the body of Postman. The computer will tell you what number you guessed, how many guesses you have made, and whether your guess was too high, too low, or correct.
 7. http://127.0.0.1:9297/shutdown     
 This shutdowns the server, and tells you how many total requests you have made.
