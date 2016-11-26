package wachtmeister.logins;

import java.time.Instant;

public class LoginDt {

	protected long id;
	protected long created;
	protected long revision;
	protected String username;
	protected String digest;
	protected String email;
	protected long passwordChangeDate;

	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}

	public long getCreated() {
		return created;
	}
	public void setCreated(long created) {
		this.created = created;
	}
	
	public long getRevision() {
		return revision;
	}
	public void setRevision(long revision) {
		this.revision = revision;
	}
	

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getDigest() {
		return digest;
	}
	public void setDigest(String digest) {
		this.digest = digest;
	}

	public long getPasswordChangeDate() {
		return passwordChangeDate;
	}
	public void setPasswordChangeDate(long passwordChangeDate) {
		this.passwordChangeDate = passwordChangeDate;
	}

	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	

	@Override
	public String toString() {
		return "UsrIdentity " + "[" + "login=" + username + ", " + "digest=" + digest + ", " + "passwordChangeDate="
				+ Instant.ofEpochMilli(passwordChangeDate) + "]";
	}

}
