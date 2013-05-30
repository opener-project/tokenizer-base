package org.vicomtech.opener.tokenizer;

import static org.junit.Assert.*;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import org.junit.Test;

public class TokenizerMainTest {

	@Test
	public void testTokenizerMain() {
		
		String str="This is a tokenizer test. It should work! More-or-less...";
		InputStream is = new ByteArrayInputStream(str.getBytes());
		String[]args={"-l","en","-t"};
		Main.execute(is, System.out, args);
		
		
		assertTrue(true);
	}

}
