/*
 *  Name: Eason Liang
 *  StudentID: 1146154
 *  File Name: Token.java
 *  Class that will return the strings of each token.
 */
class Token {

  // Declare a Int for each token returned.
  public final static int OPEN = 0;
  public final static int CLOSE = 1;
  public final static int WORD = 2;
  public final static int NUMBER = 3;
  public final static int APOSTROPHIZED = 4;
  public final static int HYPHENATED = 5;
  public final static int PUNCTUATION = 6;
  public final static int DELIMITER = 7;
  public final static int ERROR = 8;

  //Token requrest the type, the value, the line value and column value.
  public int m_type;
  public String m_value;
  public int m_line;
  public int m_column;
  
  //Declare a new constructor and have the attributes equal to the values of the constructor.
  Token (int type, String value, int line, int column) {
    m_type = type;
    m_value = value;
    m_line = line;
    m_column = column;
  }

  // ToString function where it will return the tokens in a string format for the output 
  public String toString() {
    switch (m_type) {
      case OPEN:
        return "OPEN-"+m_value ;
      case CLOSE:
        return "CLOSE-"+m_value;
      case WORD:
        return "WORD("+m_value+")";
      case NUMBER:
        return "NUMBER("+m_value+")";
      case APOSTROPHIZED:
        return "APOSTROPHIZED("+m_value+")";
      case HYPHENATED:
        return "HYPHENATED("+m_value+")";
      case PUNCTUATION:
        return "PUNCTUATION("+ m_value +")";
      case DELIMITER:
        return "DELIMITER";
      case ERROR:
        return "ERROR(" + m_value + ")";
      default:
        return "UNKNOWN(" + m_value + ")";
    }
  }
}

