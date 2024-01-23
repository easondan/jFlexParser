import java.io.InputStreamReader;
import java.util.Stack;

public class Scanner {
  private Lexer scanner = null;

  public Scanner(Lexer lexer) {
    scanner = lexer;
  }

  public Token getNextToken() throws java.io.IOException {
    return scanner.yylex();
  }

  public static void main(String argv[]) {
    Stack<String> tokens = new Stack<String>();
    boolean check = false;
    try {
      Scanner scanner = new Scanner(new Lexer(new InputStreamReader(System.in)));
      Token tok = null;
      while ((tok = scanner.getNextToken()) != null) {
        String currentToken = tok.toString().toUpperCase();
        if(currentToken.equals("OPEN-DOCID")){
          check = true;
        }

        if (currentToken.equals("OPEN-P")) {
          if (!tokens.empty()) {
            if (tokens.peek().equals("DOC") || tokens.peek().equals("TEXT") || tokens.peek().equals("DATE")
                || tokens.peek().equals("DOCNO") || tokens.peek().equals("HEADLINE")
                || tokens.peek().equals("LENGTH")) {
              check = false;
            }
          }

        }
        if (currentToken.matches("OPEN-\\w+([-]+\\w+)?")) {

          String value = currentToken.replaceAll("OPEN-", "");
          tokens.push(value);
        }

        if (currentToken.equals("OPEN-DOC") || currentToken.equals("OPEN-TEXT")
            || currentToken.equals("OPEN-DATE") || currentToken.equals("OPEN-DOCNO")
            || currentToken.equals("OPEN-HEADLINE") || currentToken.equals("OPEN-LENGTH")) {
          check = false;
        } else if (currentToken.equals("CLOSE-DOC") || currentToken.equals("CLOSE-TEXT")
            || currentToken.equals("CLOSE-DATE") || currentToken.equals("CLOSE-DOCNO")
            || currentToken.equals("CLOSE-HEADLINE") || currentToken.equals("CLOSE-LENGTH")) {
          System.out.println(tok);
          check = true;
        }

        if (currentToken.matches("CLOSE-\\w+")) {
          tokens.pop();
        }
        if (currentToken.equals("CLOSE-P")) {
          if (!tokens.empty()) {
            if (tokens.peek().equals("DOC") || tokens.peek().equals("TEXT") || tokens.peek().equals("DATE")
                || tokens.peek().equals("DOCNO") || tokens.peek().equals("HEADLINE")
                || tokens.peek().equals("LENGTH")) {
              check = true;
              System.out.println(tok);
            }
          }

        }
        if (check == false) {
          System.out.println(tok);
        }

      }
    }

    catch (Exception e) {
      System.out.println("Unexpected exception:");
      e.printStackTrace();
    }
  }
}
