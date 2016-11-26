package wachtmeister.webapp;

public interface FlashBuilder {

	FlashBuilder addError(String error);
	FlashBuilder addNotice(String notice);

}
