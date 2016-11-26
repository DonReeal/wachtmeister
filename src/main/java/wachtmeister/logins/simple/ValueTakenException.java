package wachtmeister.logins.simple;

import wachtmeister.ClientException;

public class ValueTakenException extends ClientException {
	private static final long serialVersionUID = 1L;	
	public ValueTakenException(String message) {
		super(message);
	}
}
