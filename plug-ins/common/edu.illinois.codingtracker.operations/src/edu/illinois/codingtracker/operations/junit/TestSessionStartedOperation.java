/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingtracker.operations.junit;

import edu.illinois.codingtracker.operations.OperationSymbols;
import edu.illinois.codingtracker.operations.OperationTextChunk;
import edu.illinois.codingtracker.operations.OperationXMLTextChunk;

/**
 * 
 * @author Stas Negara
 * 
 */
public class TestSessionStartedOperation extends JUnitOperation {

	public TestSessionStartedOperation() {
		super();
	}

	public TestSessionStartedOperation(String testRunName) {
		super(testRunName);
	}

	@Override
	protected char getOperationSymbol() {
		return OperationSymbols.TEST_SESSION_STARTED_SYMBOL;
	}

	@Override
	public String getDescription() {
		return "Started test session";
	}
	
	@Override
	protected void populateXMLTextChunk(OperationXMLTextChunk textChunk){
		textChunk.concat("<TestSessionStartedOperation>" + "\n");
		super.populateXMLTextChunk(textChunk);
		textChunk.concat("\t" + "<timestamp>" + "\n");
		textChunk.concat("\t" + getTime() + "\n");
		textChunk.concat("\t" + "</timestamp>" + "\n");
		textChunk.concat("</TestSessionStartedOperation>" + "\n");
	}

}
