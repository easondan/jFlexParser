import java.io.InputStreamReader;
import java.util.Stack;

public class Scanner {
  private Lexer scanner = null;

  public Scanner( Lexer lexer ) {
    scanner = lexer; 
  }

  public Token getNextToken() throws java.io.IOException {
    return scanner.yylex();
  }

  public static void main(String argv[]) {
    Stack <String>tokens = new Stack<String>();
    boolean check = false;
    boolean checkOpen = false;
    boolean checkClose = false;
    try {
      Scanner scanner = new Scanner(new Lexer(new InputStreamReader(System.in)));
      Token tok = null;
      while( (tok=scanner.getNextToken()) != null ){
 
        if(tok.toString().equals("OPEN-P")){
          if(!tokens.empty()){
            if( tokens.peek().equals("DOC") ||  tokens.peek().equals("TEXT") ||  tokens.peek().equals("DATE") || tokens.peek().equals("DOCNO") ||   tokens.peek().equals("HEADLINE") ||  tokens.peek().equals("LENGTH")){
              check = false;
           } 
          }
          
         }
        if(tok.toString().matches("OPEN-\\w+([-]+\\w+)?")){
          
          String value = tok.toString().replaceAll("OPEN-", "");
          tokens.push(value);
        }
      
       if(tok.toString().equals("OPEN-DOC")||tok.toString().equals("OPEN-TEXT")||tok.toString().equals("OPEN-DATE")||tok.toString().equals("OPEN-DOCNO")||tok.toString().equals("OPEN-HEADLINE")||tok.toString().equals("OPEN-LENGTH")){
         check = false;
        }else if(tok.toString().equals("CLOSE-DOC")||tok.toString().equals("CLOSE-TEXT")||tok.toString().equals("CLOSE-DATE")||tok.toString().equals("CLOSE-DOCNO")||tok.toString().equals("CLOSE-HEADLINE")||tok.toString().equals("CLOSE-LENGTH")){
          System.out.println(tok);
          check = true;
        }

        if(tok.toString().matches("CLOSE-\\w+")){
          tokens.pop();
        }
         if(tok.toString().equals("CLOSE-P")){
          if(!tokens.empty()){
            if( tokens.peek().equals("DOC") ||  tokens.peek().equals("TEXT") ||  tokens.peek().equals("DATE") || tokens.peek().equals("DOCNO") ||   tokens.peek().equals("HEADLINE") ||  tokens.peek().equals("LENGTH")){
              check = true;
              System.out.println(tok);
           } 
          }

         }

        // if(tok.toString().equals("OPEN-P")&& check==true){
        //   checkOpen = true;
        //   check=false;
        // }

        // if(tok.toString().equals("CLOSE-P")&& check==false&& checkOpen == true){
        //   checkOpen = false;
        //   check=true;
        // }

        // if(tok.toString().equals("OPEN-P")){
        //   if(tokens.empty()){
        //     check = true;

        //   }else if((tokens.pop().equals("DOC")||tokens.pop().equals("TEXT")||tokens.pop().equals("DATE")||tokens.pop().equals("DOCNO")||tokens.pop().equals("HEADLINE")||tokens.pop().equals("LENGTH"))){
        //     check = true;
        //   }else{
        //     check = false;
        //   }

        // }

        // if(tok.toString().equals("CLOSE-P")&& check==true){
        //   check = false;
        // }
        if(check == false){
          System.out.println(tok);
        }
      
      }
       //Use this to filter out the paragraphs :poggies:

    }

    catch (Exception e) {
      System.out.println("Unexpected exception:");
      e.printStackTrace();
    }
  }
}
