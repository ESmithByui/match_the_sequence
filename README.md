## Overview

**Project Title**:
Match the Sequence Game

**Project Description**:
An erlang program that allows a person to generate a random sequence of number, atoms, or both. After the sequence is generated, you may guess what the correct sequence is. It keeps track of your guesses and gives hints for if the guess is partially correct, totally incorrect, or if something is in the right place or just in the sequence.

**Project Goals**:
Demonstrate my ability to code in erlang.

## Instructions for Build and Use

Steps to build and/or run the software:

1. Follow along with the steps to create the developement environment.
2. Download the match_the_sequence folder.
3. Open the folder in the terminal.
4. Type in wsl to open up the wsl command line, and then use code . to start Visual Studio Code.
5. In Visual Studio Code, open up a new terminal and type in rebar3 shell to start the program.

Instructions for using the software:

1. In the command line, start the process using match:start().
2. For best practice, save the process to a variable, like Game = match:start().
3. With the process started up, make guesses using match:guess(Game, [1,2,3,4,5]).
4. Game is replaced by the process id, which can be either the original or whatever your variable name is. Note, you cannot overwrite a saved variable. The list must consist of possible guesses and match the length of the sequence.
5. x means the guess is not in the sequence.
6. i means the guess is in the sequence, but not in the right place.
7. o means the guess is in the correct place.
8. Once the sequence has been guessed, you may exit the program or start a new game using a new process.
9. In addition to match:start()., there is also match:start(Length, List)., which takes a number for the length of the sequence, as well as a choice of what to use for your list. Possible lists include a number which gives a list of numbers from 1 to that number, color which gives a list of ROYGBIV, elements which gives water, earth, fire, and air, and mixed, which gives a list of numbers from 1 - 10 and the colors list.

## Development Environment 

To recreate the development environment, you need the following software and/or libraries with the specified versions:

* Install Visual Studio Code
* Get the erlang, Erlang LS, and WSL extensions on Visual Studio Code
* Using WSL, install Ubuntu Linux
* Set up Linux
* Update repositories using $ sudo apt update
* Install rebar3 using $ sudo apt install rebar3
* Ensure when Visual Studio Code is being run on Ubuntu, that erlang and Erlang LS is installed.

## Useful Websites to Learn More

I found these websites useful in developing this software:

* [erlang.org](https://www.erlang.org/docs)

## Future Work

The following items I plan to fix, improve, and/or add to this project in the future:

* [ ] Connect to better user interface.