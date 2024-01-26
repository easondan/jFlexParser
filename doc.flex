/*
File Name: doc.flex
JFlex Specification for the Doc Parser
*/


import java.util.Stack;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
%%

%class Lexer
%type Token
%line
%column

%eofval{
    //System.out.println("**** End of the File Reached ****");
    return null;
%eofval};


%{
private static Stack<String> tagStack = new Stack<String>();
Boolean check = false;
%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]
digit = [0-9]
number = {digit}+
letter = [a-zA-Z]
alphaNum = [a-zA-Z0-9]+
%%

"<"\/[^>]*">" {
    if (tagStack.empty()) {
      System.out.println("ERROR Invalid Closing Tag" + yytext());
      System.exit(0);
    }
    String value = tagStack.peek();
    if (!value.equals(temp)) {
      System.out.println("ERROR Invalid Closing Tag" + yytext());
      System.exit(0);
    }
    String temp = yytext().replaceAll("[<>/ \t\f\r\n\r\n]", "");
    if (temp.equals("DOC") || temp.equals("TEXT")
        || temp.equals("DATE") || temp.equals("DOCNO")
        || temp.equals("HEADLINE") || temp.equals("LENGTH")) {
      check = true;
      return new Token(Token.CLOSE, temp, yyline, yycolumn);
    }

    tagStack.pop();
    if (temp.equals("P")) {
      if (!tagStack.empty()) {
        if (tagStack.peek().equals("DOC") || tagStack.peek().equals("TEXT") || tagStack.peek().equals("DATE")
            || tagStack.peek().equals("DOCNO") || tagStack.peek().equals("HEADLINE")
            || tagStack.peek().equals("LENGTH")) {
          check = true;
          return new Token(Token.CLOSE, temp, yyline, yycolumn);
        }
      }
    }
    if (check == false) {
      return new Token(Token.CLOSE, temp, yyline, yycolumn);
    }

    
}
"<"[^>]*">" {
    Pattern pattern = Pattern.compile("<\\s*([-A-Za-z]+)\\s*");
    Matcher matcher = pattern.matcher(yytext());
    String value = "";
    if (matcher.find()) {
      // Extract and return the first word
      value = matcher.group(1).replaceAll("[<>/ \t\f\r\n\r\n]", "");
    }
    if (value.equals("DOCID")) {
      check = true;
    }
    if (value.equals("P")) {
      if (!tagStack.empty()) {
        if (tagStack.peek().equals("DOC") || tagStack.peek().equals("TEXT") || tagStack.peek().equals("DATE")
            || tagStack.peek().equals("DOCNO") || tagStack.peek().equals("HEADLINE")
            || tagStack.peek().equals("LENGTH")) {
          check = false;
        }
      }

    }
    tagStack.push(value);
    if (value.equals("DOC") || value.equals("TEXT")
        || value.equals("DATE") || value.equals("DOCNO")
        || value.equals("HEADLINE") || value.equals("LENGTH")) {
      check = false;
    }
    if (check == false) {
      return new Token(Token.OPEN, value, yyline, yycolumn);
    }

    }

[$]  {if(check==false)return new Token(Token.PUNCTUATION,yytext(),yyline,yycolumn);}

[a-zA-Z\-0-9]+'{1}[a-zA-Z]+ { if(check==false)return new Token(Token.APOSTROPHIZED,yytext(),yyline,yycolumn);}

[a-zA-Z0-9]+-{1}[a-zA-Z0-9-]+ {if(check==false)return new Token(Token.HYPHENATED,yytext(),yyline,yycolumn);}

\p{P} {if(check==false)return new Token(Token.PUNCTUATION,yytext(),yyline,yycolumn);}

[-+]?{number}+(\.{number}+)? {if(check==false){String value = yytext().replaceAll("[$+-]","");  return new Token(Token.NUMBER,value,yyline,yycolumn);}} 

{alphaNum} {if(check==false)return new Token(Token.WORD,yytext(),yyline,yycolumn);} 

{WhiteSpace}+      { /* skip whitespace */ }   

"{"[^\}]*"}"       { /* skip comments */ }

.                  { return new Token(Token.ERROR, yytext(), yyline, yycolumn); }