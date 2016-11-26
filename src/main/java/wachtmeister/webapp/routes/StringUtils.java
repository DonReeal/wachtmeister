package wachtmeister.webapp.routes;

public class StringUtils {

  public static boolean isEmpty(String s) {
    return !isNonEmpty(s);
  }
  
  public static boolean isNonEmpty(String s) {
    
    if(s == null)
      return false;
    
    if(s.trim().isEmpty())
      return false;
    
    return true;
  }


}
