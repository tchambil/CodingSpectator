package edu.illinois.codingtracker.operations.starts;

import java.util.HashMap;
import java.util.Map;


import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceDescription;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IBundleGroup;
import org.eclipse.core.runtime.IBundleGroupProvider;
import org.eclipse.core.runtime.Platform;
import org.osgi.framework.Bundle;

import edu.illinois.codingtracker.compare.helpers.EditorHelper;
import edu.illinois.codingtracker.operations.OperationLexer;
import edu.illinois.codingtracker.operations.OperationSymbols;
import edu.illinois.codingtracker.operations.OperationTextChunk;
import edu.illinois.codingtracker.operations.UserOperation;

public class PluginsList extends UserOperation {
	
	public PluginsList() {
		super();
	}

	@Override
	protected char getOperationSymbol() {
		return OperationSymbols.PLUGINS_SYMBOL;
	}

	@Override
	public String getDescription() {
		return "List of installed plugins";
	}

	@Override
	protected void populateTextChunk(OperationTextChunk textChunk) {
		//Nothing to initialize
	}

	@Override
	protected void initializeFrom(OperationLexer operationLexer) {
		//Nothing to initialize		
	}

	@Override
	public void replay() throws CoreException {
		isReplayedRefactoring= false;
		//Close all editors (in case the previous Eclipse session ended abnormally, and thus close editor operations were not recorded).
		EditorHelper.closeAllEditors();
		//disable auto build
		IWorkspace workspace= ResourcesPlugin.getWorkspace();
		IWorkspaceDescription workspaceDesription= workspace.getDescription();
		workspaceDesription.setAutoBuilding(false);
		workspace.setDescription(workspaceDesription);
	}

	@Override
	public boolean isTestReplayRecorded() {
		return false;
	}

}
