import java.io.InputStreamReader;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Scanner {
  private Lexer scanner = null;

  public Scanner(Lexer lexer) {
    scanner = lexer;
  }

  public Token getNextToken() throws java.io.IOException {
    return scanner.yylex();
  }

  public static void main(String argv[]) {

    try {
      Scanner scanner = new Scanner(new Lexer(new InputStreamReader(System.in)));
      Token tok = null;
      while ((tok = scanner.getNextToken()) != null) {
        System.out.println(tok);

      }
    }

    catch (Exception e) {
      System.out.println("Unexpected exception:");
      e.printStackTrace();
    }
  }
}
