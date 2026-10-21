# Bash Scripting Exercises

If you encounter any problem or doubts (even if you are attempting the more difficult variants) please do not hesitate to reach out.

## Exercise 1 - Analyzing a table

Here's a file about cities (don't fact check them please!):
```table.csv
#NAME,COUNTRY,POPULATION
Trieste,Italy,200000
NYC,USA,7000000
Atlantis,Mars,1000000000
Killarney,Ireland,5000
Tokyo,Japan,15000000
```
Write a script that accepts the file name as input and that prints the largest possible number of inhabitants.
Remove the header (one way or another) before sorting.

Tip: remember that the character separating columns can be *anything*, even, say, a comma.
Tip: getting the largest number is like printing the last line of an ordered column. 

### Added difficulty

Modify the script so that prints a line like "The largest city ever is ... with ... inhabitants".

Tip: use the `$(...)` construct to assign different outputs of `cut` to different variables and then print those.

### Added difficulty+

Write an if clause that verifies quality of the input and fails the code if the file does not exist.

Tip: remember `exit`

### Added difficulty++

Add flags to:
- Print the country too
- Print the smallest city instead

Tip: you can also use `getopt` for this (the docs link to some useful examples...)

## Exercise 2 - Grepping in a loop

Write a script that performs a grep search of five different words or patterns over a file.
It should take as input the five patterns and the file name

Tip: use a for loop over `$1 $2 ...`.

### Added difficulty

Have the script save all the retrieved lines in a file called `my_lines.txt` that gets overwritten every time you launch the script (but not every time you change from a pattern to the other...!)

### Added difficulty+

Make it so the code accepts any number of patterns, not only five.
Remember to check that at least one pattern and one file name are passed!

Tip: it might be easier to pass the file name first and then isolate the array of patterns with `shift`.

## Excercise 3 - An interactive story

Write a short interactive story where you get a different ending depending on the user's choices.
Add at least two decisions.

*Example:*
"You are in a forest and see a fork in the road. Are you going left or right? [l/r]"
l
"You find a door, do you open it? [y/n]"
y
"Congrats! You found a treasure!"

Tip: use nested `if` statements and the `read` command.

### Added difficulty

Associate a different exit value to each ending.

### Added difficulty+

Provide a short description for each ending (e.g. "The good ending", "The one where you die :(", etc) and write a separate script that tells you which one you got on the last run depending on the exit status provided.

Tip: you'll see that `$?` is not carried into the script when it starts: you can pass it as an argument, as in `$ ending_info.sh $?`
Tip: a `case` statement would be great here (instead of `if`s).

### Added difficulty++

Make sure the user cannot input any unsupported choices (e.g. "b" if only "l" or "r" are available options) **without** exiting the code.
Bonus points if you create a function for that.
