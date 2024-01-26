## Warm Up Assignemnt 

This program will parse Tagged Documents and will output the tokens. The following tokens will be displayed

OPEN-TAG 
CLOSE-TAG
WORD
NUMBER
APOSTROPHE 
HYPENATED

To Run the Program 

1. Run the makefile using the make command
- This will generate a Lexer.Java in order to run the program fully

2. Run the following command java Scanner < filename 

(Where filename is the file you wish to parse)

(Recommmendation to pipe the output into a file)

Note you will need to have jflex installed as well a configured path in the makefile by changing the JFLEX variable to the downloaded package in the makefile if this is ran on the linux server the jflex package should already be preinstalled and can just be commented out.


Testing Plan

Scenarios:

1. Testing with file where an invalid tag is added.
2. Testing with file where an tag is missing
3. Testing with Nested Tags such as <DOC><DOC><P></P</DOC></DOC>
4. Testing with words such as Hello-World
5. Testing with words such as 123-456
6. Testing with words such as 126-456's
8. Testing with DOC-ID (Does it remove the DOC ID along with the number from the output)





Future Improvements