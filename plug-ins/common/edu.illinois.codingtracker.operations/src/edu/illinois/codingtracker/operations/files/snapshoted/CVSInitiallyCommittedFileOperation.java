/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingtracker.operations.files.snapshoted;

import org.eclipse.core.resources.IFile;

import edu.illinois.codingtracker.operations.OperationSymbols;
import edu.illinois.codingtracker.operations.OperationTextChunk;

/**
 * 
 * @author Stas Negara
 * 
 */
public class CVSInitiallyCommittedFileOperation extends CommittedFileOperation {

	public CVSInitiallyCommittedFileOperation() {
		super();
	}

	public CVSInitiallyCommittedFileOperation(IFile initiallyCommittedFile, String revision, String committedRevision) {
		super(initiallyCommittedFile, revision, committedRevision);
	}

	@Override
	public char getOperationSymbol() {
		return OperationSymbols.FILE_CVS_INITIALLY_COMMITTED_SYMBOL;
	}

	@Override
	public String getDescription() {
		return "CVS initially committed file";
	}
	
	@Override
	protected void populateXMLTextChunk(OperationTextChunk textChunk){
		textChunk.concat("<CVSInitiallyCommittedFileOperation>" + "\n");
		super.populateXMLTextChunk(textChunk);
		textChunk.concat("\t" + "<timestamp>");
		textChunk.concat("" + getTime());
		textChunk.concat("</timestamp>" + "\n");
		textChunk.concat("</CVSInitiallyCommittedFileOperation>" + "\n");
	}

}
