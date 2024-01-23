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
%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]
digit = [0-9]
number = {digit}+
letter = [a-zA-Z]
alphaNum = [a-zA-Z0-9]+
%%

"<"\/[^>]*">" {
        if(tagStack.empty()){
            System.out.println("ERROR Invalid Closing Tag" + yytext() );
            System.exit(0);
        }
        String temp = yytext().replaceAll("[<>/ \t\f\r\n\r\n]",""); 
        String value = tagStack.pop();
            if(!value.equals(temp)){
                System.out.println("ERROR Invalid Closing Tag" + yytext());
                System.exit(0);
                return new Token(Token.ERROR,temp,yyline,yycolumn);
            }else{
                return new Token(Token.CLOSE,temp,yyline,yycolumn);
            } 
    }
"<"[^>]*">" {
        Pattern pattern = Pattern.compile("<\\s*([-A-Za-z]+)\\s*");
        Matcher matcher = pattern.matcher(yytext());
        String value = "";
         if (matcher.find()) {
            // Extract and return the first word
            value = matcher.group(1).replaceAll("[<>/ \t\f\r\n\r\n]",""); 
         }
        tagStack.push(value); 
        return new Token(Token.OPEN,value,yyline,yycolumn);
    }

[$]  {return new Token(Token.PUNCTUATION,yytext(),yyline,yycolumn);}

[a-zA-Z\-0-9]+'{1}[a-zA-Z]+ {return new Token(Token.APOSTROPHIZED,yytext(),yyline,yycolumn);}

[a-zA-Z0-9]+-{1}[a-zA-Z0-9-]+ {return new Token(Token.HYPHENATED,yytext(),yyline,yycolumn);}

\p{P} {return new Token(Token.PUNCTUATION,yytext(),yyline,yycolumn);}

[-+]?{number}+(\.{number}+)? {String value = yytext().replaceAll("[$+-]","");  return new Token(Token.NUMBER,value,yyline,yycolumn);} 

{alphaNum} {return new Token(Token.WORD,yytext(),yyline,yycolumn);} 

{WhiteSpace}+      { /* skip whitespace */ }   

"{"[^\}]*"}"       { /* skip comments */ }

.                  { return new Token(Token.ERROR, yytext(), yyline, yycolumn); }