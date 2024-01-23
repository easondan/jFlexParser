/*
File Name: doc.flex
JFlex Specification for the Doc Parser
*/


import java.util.Stack;
import java.util.Arrays;
import java.util.List;
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

// "<DOCID>"\s*(\d+)\s*"</DOCID>" {}

// Add statement to check if the pop are the same are the yyText
"<" \s*({letter}[^\s>]*)\s* ">" {
        String value = yytext().replaceAll ("[<>/]",""); 
        tagStack.push(value); 
        return new Token(Token.OPEN,value,yyline,yycolumn);
    }
"<" \/\s*({letter}[^\s>]*)\s* ">" {
        if(tagStack.empty()){
            System.out.println("ERROR Invalid Closing Tag" + yytext() );
            System.exit(0);
        }
        String temp = yytext().replaceAll("[<>/]",""); 
        String value = tagStack.pop();
            if(!value.equals(temp)){
                System.out.println("ERROR Invalid Closing Tag" + yytext());
                System.exit(0);
                return new Token(Token.ERROR,temp,yyline,yycolumn);
            }else{
                return new Token(Token.CLOSE,temp,yyline,yycolumn);
            } 
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