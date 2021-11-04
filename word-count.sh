#!/usr/local/bin/bash

########################################################################
# word-count.sh
#
# DESCRIPTION
# The purpose of this script is to do an audit of the main sections of our docs
# to list the following:
#   1. The total number of documents (.mdx) files in each top-level directory.
#   2. List a count for each document of words we could translate.
#
# The count routine considers words as groups of characters separated by white space.
# It filters out the following:
#   * Front matter
#   * Code blocks marked by backticks.
#   * HTML-style tags, such as <table> and <Callout>.
#   * Heading hash symbols (##, ###, ####).
#
# INSTRUCTIONS
# To use this script:
#   1. Copy this script into the docs directory of your branch.
#   2. Open a command-line session and go to the docs directory.
#   3. Execute the script: bash word-count.sh
#   4. Locate the file results.csv in docs directory and import it into Google Sheets.
#   5. To clean up, remove the script and the results files from your branch.
#
# HISTORY: 
# Version  Who                When          What
# -------  -----------------  ------------  -----------------------------------------
#    1     Rob Siebens        11/4/2021     Created script
########################################################################

# Create an array contatining all the directories in the docs directory:
startingDirectoriesArray=($(find . -type d -maxdepth 1)) 
startingDirectoriesArrayLength=${#startingDirectoriesArray[@]}
    
for (( i=1; i<${startingDirectoriesArrayLength}; i++ )); # Start index at 1 because you don't want to start in the root!
do   

    echo "Here is the starting directory: " ${startingDirectoriesArray[$i]} # This just tells you what the script is looking at.
    # Count the number of files in the directory.
    directoryTotal=$(find ${startingDirectoriesArray[$i]} -type f -name "*.mdx" | wc -l) 
    echo -e "TOTAL FOR ${startingDirectoriesArray[$i]}: $directoryTotal" >> ~/Documents/git/docs-website/src/content/docs/results.csv 

    # Create an array that contains a list of the files to operate on:
    fileArray=($(find ${startingDirectoriesArray[i]} -type f -name "*.mdx" | sed -e "s/^.\///" ))
    fileArrayLength=${#fileArray[@]}

    # March through the files and run a word count on each:
    for (( h=0; h<${fileArrayLength}; h++ )); 
    do 

        (echo -n "${fileArray[$h]}, " ; sed -e '/```/,/```/d; /---/,/---/d; /<[^>]*>/d; /^## /d; /^### /d; /^#### /d' ${fileArray[$h]} | wc -w) >> ~/Documents/git/docs-website/src/content/docs/results.csv       

    done

done









