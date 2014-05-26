/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingtracker.operations.refactorings;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.ltk.core.refactoring.RefactoringDescriptor;

import edu.illinois.codingtracker.operations.OperationSymbols;
import edu.illinois.codingtracker.operations.OperationTextChunk;

/**
 * This operation is no longer recorded.
 * 
 * {@see NewStartedRefactoringOperation, FinishedRefactoringOperation}.
 * 
 * @author Stas Negara
 * 
 */
public class UndoneRefactoringOperation extends RefactoringOperation {

	public UndoneRefactoringOperation() {
		super();
	}

	public UndoneRefactoringOperation(RefactoringDescriptor refactoringDescriptor) {
		super(refactoringDescriptor);
	}

	@Override
	protected char getOperationSymbol() {
		return OperationSymbols.REFACTORING_UNDONE_SYMBOL;
	}

	@Override
	public String getDescription() {
		return "Undone refactoring";
	}

	@Override
	public void replayRefactoring(RefactoringDescriptor refactoringDescriptor) throws CoreException {
		if (!unperformedRefactorings.contains(getTime())) {
			getRefactoringUndoManager().performUndo(null, null);
		}
	}
	@Override
	protected void populateXMLTextChunk(OperationTextChunk textChunk) {
		textChunk.append("<UndoneRefactoringOperation>"+"\n");
		super.populateXMLTextChunk(textChunk);
		textChunk.append("\t" + "<timestamp>" + "\n");
		textChunk.append("\t" + getTime() + "\n");
		textChunk.append("\t" + "</timestamp>" + "\n");
		textChunk.append("</UndoneRefactoringOperation>"+"\n");
		
	}

}
