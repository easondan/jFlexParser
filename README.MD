## Warm Up Assignemnt 

This program will parse SGML Tagged Documents and will output the tokens. 
The following tokens will be displayed wthin the output.

OPEN-TAG 
CLOSE-TAG
WORD
NUMBER
APOSTROPHE 
HYPENATED
PUNCUATION

## To Run the Program 

The following files should be submitted: 
- makefile
- scanner.java
- Token.java
- README.MD

1. Run the makefile using the make command
- This will generate a Lexer.Java in order to run the program fully

2. Run the following command java Scanner < filename as Scanner.java is where the main is located

(Where filename is the file you wish to parse)

(Recommmendation to pipe the output into a file) With > output.txt (Will write output to file)


Note you will need to have jflex installed. 
As well a configured path in the makefile by changing the JFLEX variable to the downloaded package in the makefile. 
If this is ran on the linux server the jflex package should already be preinstalled and the director for that variable should be the following 

If you run into an error running to the makefile such as 
```bash
jflex SGML.flex
make: jflex: No such file or directory
make: *** [Lexer.java] Error 1
```

Please check the makefile to see if your JFLEX variable is configured to the location of the JFlex libary

The default variable that will work on the linux server is
JFLEX = jflex


## Assumptions and Limitations.

- Limitations that in the SGML Tags there are not nested non relevant tags
- Assume that .15 are not treated as real numbers. 
Instead should be puncutation followed by a number while 0.15 is considered a real number.
- Assume that cases such as robin's-egg would be treated as the following and listed as 3 tokens
   Apostrophe(robin's)
   puncuation(-)
   word(egg)
- Assume that attributes don't exist within the closing tags
-  Assume that a String such as 123'456 is treated as the following
   NUMBER(123)
   PUNCTUATION(')
   NUMBER(456)
- Assume that hypenated tokens must contains a word-word or else -word or word- would be treated a punctuation(-) word(word) and word(word) punctuation(-)


## Testing Plan

### Scenarios:

1. Testing with file where an invalid tag is added.
```xml
<DOC>
</DOC2>
```
2. Testing with file where an tag is missing
```
<DOC>
```
3. Testing with Nested Tags such as <DOC><DOC><P></P</DOC></DOC>
4. Testing with words such as Hello-World

5. Testing with words such as 123-456
```xml
<DOC>
<P> 123-456</P>
</DOC>
```

6. Testing with words such as 126-456's
```xml
<DOC>
<P> 123-456's</P>
</DOC>

```
7. Testing with DOC-ID (Does it remove the DOC ID along with the number from the output)
```xml
<DOC>
<DOCID> 123456 <DOCID>
</DOC>
```

8. Test with Extra tags in a <text> example the output should result in the stack outputing extra errors.

```xml
<doc>
    <docNo> 123 </docNo>
    <date> 2024-01-26 </date>
    <length> 1000 </length>
    <headline> Test Headline: Scanner Assignment </headline>
    <text>
        This is a test document for  law's the scanner assignment. 
        The document includes several tags like <docNo>, <date>, and <text>.
        It also includes various types of tokens:
        - Words like scanner, document, and assignment.
        - Numbers such as 1, 2, 3.
        - Apostrophized words: O'Reilly's, it's, you're.
        - Hyphenated words: mother-in-law, state-of-the-art.
        - Punctuation: commas, periods (.), and question marks (?).
    </text>
</doc>

```

10. Test for Spaces and Attribtues in Open Tags such as 

```xml
< DOC textAlign="left" > </DOC>
```

11. Test if Program can Handle case in a case sensitive manner.

```xml
<DOC> <docID> </DOCid ></doc>
```

12. Test if program can filter out correctly

```xml
<DOC> <DOCID>123456 </DOCID> 
<HELLO>
<P>
This should not print anything out
</P> 
</HELLO>
<P>
This should print something else as a token
</P>
</DOC>

```


## Future Improvements
- Some future improvements I would consider is looking to reduce the amount
of code written in the flex file one issue I found is how I implemented
the stack. There could have been cleaner and less code.
- Another improvement is the implementation of the regex the open and close 
tags. Currently the regex of both open and close tags accept the following
where any characters between <> would be accepted. From that within the jflex file. Java code is implemented to now filter the tags.
Where the tag filter out any attributes and also spaces in between.
- Another improvement that could be done is not for this assignment spefically. But instead utilizing JFLEX to create and understand parsers a bit better and would be fun to implement as a future project.