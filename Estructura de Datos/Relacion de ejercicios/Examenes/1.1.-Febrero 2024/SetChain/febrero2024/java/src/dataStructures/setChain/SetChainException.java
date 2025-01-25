package dataStructures.setChain;

import java.io.Serial;

public class SetChainException extends RuntimeException {
	@Serial
	private static final long serialVersionUID = 2551856243837331348L;

	public SetChainException() {
		super();
	}

	public SetChainException(String msg) {
		super(msg);
	}
}
