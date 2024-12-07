public class Yytoken {
    public final static int A = 127;
    public final static int B = 128;
    public final static int C = 10;
    public final static int D = 12;

    private int token;
   

    public Yytoken(int token) {
         this.token = token;
        
    }

    public int getToken()  {
         return token;
    }

   
    public String toString() {
         return "<"+token+">";
    }
}
