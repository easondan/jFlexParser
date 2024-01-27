/*
File Name: doc.flex
JFlex Specification for the Doc Parser
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
  if(!mismatchTag.isEmpty()){
      System.out.println("Mismatched Tags ERRORS");
      mismatchTag.forEach(mismtagTag-> System.out.println(mismatchTag));
  }

    return null;
%eofval};


%{
private static Stack<String> tagStack = new Stack<String>();
Boolean check = false;
private static ArrayList<String> mismatchTag = new ArrayList<String>();
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
      
    }
    String temp = yytext().replaceAll("[<>/ \t\f\r\n\r\n]", "");
    ArrayList<String> list = new ArrayList<String>(Arrays.asList("DOC","TEXT","DATE","DOCNO","HEADLINE","LENGTH"));
    
    if(list.contains(temp)){
       check = true;
      return new Token(Token.CLOSE, temp, yyline, yycolumn);
    }

    String value = tagStack.pop();
    if (!value.equals(temp)) {
      mismatchTag.add(value);
    }

    if (temp.equals("P")) {
      if (!tagStack.empty()) {
        String topStack = tagStack.peek();
        if(list.contains(topStack)){
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
    ArrayList<String> list = new ArrayList<String>(Arrays.asList("DOC","TEXT","DATE","DOCNO","HEADLINE","LENGTH"));
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
        String topStack  = tagStack.peek();
        if(list.contains(topStack)){
          check = false;
        }
      }
    }
    tagStack.push(value);
    if(list.contains(value)){
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