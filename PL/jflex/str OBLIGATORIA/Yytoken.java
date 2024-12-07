public class Yytoken {
     public final static int S1 = 127;
     public final static int S2 = 33;
     public final static int S3= 22;
     public final static int X = 69;
     private int token;
     private String subs;

     public Yytoken(int token, String subs) {
          this.token = token;
          this.subs=subs;

     }

     public Yytoken(int token) {
          this.token = token;
     }

     public String getSubs(){
          return subs;
     }

     public int getToken() {
          return token;
     }

     public String toString() {
          return "<" + token + ">";
     }

    
}
