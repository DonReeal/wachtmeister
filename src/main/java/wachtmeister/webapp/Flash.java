package wachtmeister.webapp;

public final class Flash /* implements FlashBuilder */{

	public final String error;
	public final String notice;


	private Flash(String notice, String error) {
		this.notice = notice;
		this.error = error;
	}

	public static Flash error(String error) {
		return new Flash("", error);
	}

	public static Flash notice(String notice) {
		return new Flash(notice, "");
	}

//	
//	private List<String> notices= new ArrayList<>(0);
//	private List<String> errors = new ArrayList<>(0);
//
//	@Override
//	public FlashBuilder addError(String error) {
//		this.errors.add(error);
//		return this;
//	}
//
//	@Override
//	public FlashBuilder addNotice(String notice) {
//		this.notices.add(notice);
//		return this;
//	}

}
