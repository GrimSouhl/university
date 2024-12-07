public class Yytoken {
     public final static int PALABRA = 127;
     public final static int CARACTER = 33;
     public final static int EOLN = 69;
     private int token;
     private int len;

     public Yytoken(int token, int len) {
          this.token = token;
          this.len = len;

     }

     public Yytoken(int token, String lexema) {
          this(token, lexema.length());

     }

     public int getLen() {
          return len;
     }

     public int getToken() {
          return token;
     }

     public String toString() {
          return "<" + token + ">";
     }
}
