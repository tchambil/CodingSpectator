/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingtracker.tests.postprocessors.ast.refactoring.properties;



/**
 * This class represents a deleted reference to a variable.
 * 
 * @author Stas Negara
 * 
 */
public class DeletedVariableReferenceRefactoringProperty extends RefactoringProperty {

	private final String variableName;

	private final long parentID;


	public DeletedVariableReferenceRefactoringProperty(String variableName, long parentID) {
		this.variableName= variableName;
		this.parentID= parentID;
	}

	public String getVariableName() {
		return variableName;
	}

	public long getParentID() {
		return parentID;
	}

}