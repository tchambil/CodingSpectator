/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingtracker.operations.resources;

import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;

import edu.illinois.codingtracker.operations.OperationSymbols;
import edu.illinois.codingtracker.operations.OperationTextChunk;

/**
 * 
 * @author Stas Negara
 * 
 */
public class CopiedResourceOperation extends ReorganizedResourceOperation {

	public CopiedResourceOperation() {
		super();
	}

	public CopiedResourceOperation(IResource resource, IPath destination, int updateFlags, boolean success) {
		super(resource, destination, updateFlags, success);
	}

	@Override
	public char getOperationSymbol() {
		return OperationSymbols.RESOURCE_COPIED_SYMBOL;
	}

	@Override
	public String getDescription() {
		return "Copied resource";
	}

	@Override
	public void replayReorganizedResourceOperation(IResource resource) throws CoreException {
		resource.copy(new Path(destinationPath), updateFlags, null);
	}
	
	@Override
	protected void populateXMLTextChunk(OperationTextChunk textChunk){
		textChunk.concat("<CopiedResourceOperation>" + "\n");
		super.populateXMLTextChunk(textChunk);
		textChunk.concat("\t" + "<timestamp>" + "\n");
		textChunk.concat("\t" + getTime() + "\n");
		textChunk.concat("\t" + "</timestamp>" + "\n");
		textChunk.concat("</CopiedResourceOperation>" + "\n");
	}

}
