package wachtmeister.webapp.routes;

public class FormbasedLoginAttemptData {

	final String username;
	final String password;
	final String csrfTokenFromForm;	
	final String clienIpAdress;
	

	@Override
	public String toString() {
		return "FormbasedLoginAttemptData [username=" + username 
				+ ", password=" + password 
				+ ", csrfTokenFromForm=" + csrfTokenFromForm 
				+ ", clienIpAdress=" + clienIpAdress 
				+ "]";
	}

	public FormbasedLoginAttemptData(
			String xsrfTokenFromForm, 
			String username, 
			String password, 
			String clienIpAdress
	) {
		this.csrfTokenFromForm = xsrfTokenFromForm;
		this.username = username;
		this.password = password;
		this.clienIpAdress = clienIpAdress;
	}

}