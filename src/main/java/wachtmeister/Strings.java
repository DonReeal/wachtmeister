package wachtmeister;

public class Strings {

	public static boolean isEmpty(String s) {
		return !isNonEmpty(s);
	}

	public static boolean isNonEmpty(String s) {
		if (s == null)
			return false;
		if (s.trim().isEmpty())
			return false;
		return true;
	}
	
	public static boolean hasMinLen(String val, int len) {
		if(isNonEmpty(val)) {
			return val.length() > len;
		}
		return false;
	}
	

	public static boolean equalValue(String a, String b) {
		if(isNonEmpty(a) && isNonEmpty(b)) {
			return a.equals(b);
		}
		return false;
	}

}
