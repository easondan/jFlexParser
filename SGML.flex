/*
File Name: SGML.flex
JFlex Specification for the SGML Parser
*/

import java.util.Stack;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
%%

%class Lexer
%type Token
%line
%column

%eofval{
    // If the stack is not empty at the end of parsing printout leftover tags
  if(!tagStack.isEmpty()){
      System.err.println("Mismatched Tags ERRORS"  );
      tagStack.forEach(tagStack-> System.out.println(tagStack));
  }
    return null;
%eofval};


%{
//initalize the Stack
private static Stack<String> tagStack = new Stack<String>();
// boolean used to check when we should be returning a token
Boolean checkReturnToken  = false;
%}
//Variables of regex
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]
digit = [0-9]
number = {digit}+
letter = [a-zA-Z]
alphaNum = [a-zA-Z0-9]+
%%

"<"\/[^>]*">" {
    // Parse out the non relevant character such as whitespace and <>/
String tagValue = yytext().replaceAll("[<>/ \\t\\f\\r\\n\\r\\n]", "").toUpperCase();
// if the stack is empty report the error and print the tag out
if (tagStack.empty()) {
     System.err.println("Error Invalid Closing Tag " + yytext());
     return new Token(Token.CLOSE, tagValue, yyline, yycolumn);
}
// set to upper case to make it case sensitve and also create an arraylist
tagValue = tagValue.toUpperCase();
ArrayList<String> validTags = new ArrayList<>(Arrays.asList("DOC", "TEXT", "DATE", "DOCNO", "HEADLINE", "LENGTH"));

//Check if the tag is a valid ending tag if it is we wanna return the tag but not return any other tag after that 
if (validTags.contains(tagValue)) {
    checkReturnToken = true;
    tagStack.pop();
    return new Token(Token.CLOSE, tagValue, yyline, yycolumn);
}
// pop the tag 
  tagStack.pop();

// check if the tag is P if it is then we wanna validate if it's between a relevant tag 
// Same thing here return the token but again we dont want to return anything after
if (tagValue.equals("P") && !tagStack.empty()) {
    String topStack = tagStack.peek();
    if (validTags.contains(topStack)) {
        checkReturnToken = true;
        return new Token(Token.CLOSE, tagValue, yyline, yycolumn);
    }
}

//If check is false then we should return the token 
if (!checkReturnToken) {
    return new Token(Token.CLOSE, tagValue, yyline, yycolumn);
}
}
"<"[^>]*">" {
// go through the regex and extract the first word that doesn't include an attribute
Pattern pattern = Pattern.compile("<\\s*([-A-Za-z1-9]+)\\s*");
Matcher matcher = pattern.matcher(yytext());
ArrayList<String> validTags = new ArrayList<>(Arrays.asList("DOC", "TEXT", "DATE", "DOCNO", "HEADLINE", "LENGTH"));
String value = "";

// if we find a match we will use that value
    if (matcher.find()) {
        //Drop any non relvant characters we only want the name of the tag that's it
        value = matcher.group(1).replaceAll("[<>/ \\t\\f\\r\\n\\r\\n]", "").toUpperCase();
    }else{
        return null;
    }
    // if we get a DOCID we don't wanna return any tokens between that
    if (value.equals("DOCID")) {
        checkReturnToken = true;
    }

    // Check if it's a P tag and the stack isn't empty
    if (value.equals("P") && !tagStack.empty()) {
        //Check the top of the stack check if it contains a relevant tag then we wanna print stuff in the p tags
        String topStack = tagStack.peek();
        if (validTags.contains(topStack)) {
            checkReturnToken = false;
        }
    }
    // verify that if all tags in the stack are relevant then we wanna print anything in the p tags.
    if (validTags.contains(value)) {
        if (!tagStack.empty()) {
            for (String element : tagStack) {
                if (!validTags.contains(element)) {
                    checkReturnToken = true;
                    break;
                } else {
                    checkReturnToken = false;
                }
            }
        } else {
            checkReturnToken = false;
        }
    }
    // push the open tag to use for check against the close tag.
    tagStack.push(value);

    // if it's false that means we want to return the token of the open tag.
    if (!checkReturnToken) {
        return new Token(Token.OPEN, value, yyline, yycolumn);
    }

    }

[$]  {if(checkReturnToken == false)return new Token(Token.PUNCTUATION,yytext(),yyline,yycolumn);}

[a-zA-Z\-0-9]+'{1}[a-zA-Z]+ { if(checkReturnToken == false)return new Token(Token.APOSTROPHIZED,yytext(),yyline,yycolumn);}

[a-zA-Z0-9]+-{1}[a-zA-Z0-9-]+ {if(checkReturnToken == false)return new Token(Token.HYPHENATED,yytext(),yyline,yycolumn);}

\p{P} {if(checkReturnToken == false) return new Token(Token.PUNCTUATION,yytext(),yyline,yycolumn);}

[-+]?({number}+)(\.{number}+)? {if(checkReturnToken == false){String value = yytext().replaceAll("[$+-]","");  return new Token(Token.NUMBER,value,yyline,yycolumn);}} 

{alphaNum} {if(checkReturnToken == false)return new Token(Token.WORD,yytext(),yyline,yycolumn);} 

{WhiteSpace}+      { /* skip whitespace */ }   

"{"[^\}]*"}"       { /* skip comments */ }

.                  { return new Token(Token.PUNCTUATION,yytext(),yyline,yycolumn); }