package wachtmeister.webapp;

public class Args {

  public static String either(String s1, String s2) {
    
    if (s1 != null)
      return s1;

    if (s2 != null)
      return s2;

    else
      return null;
  }

}
