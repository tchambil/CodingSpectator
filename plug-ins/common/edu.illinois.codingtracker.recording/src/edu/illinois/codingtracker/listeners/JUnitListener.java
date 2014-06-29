/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingtracker.listeners;

import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.junit.JUnitCore;
import org.eclipse.jdt.junit.TestRunListener;
import org.eclipse.jdt.junit.model.ITestCaseElement;
import org.eclipse.jdt.junit.model.ITestRunSession;

/**
 * 
 * @author Stas Negara
 * 
 * @author Juraj Kubelka
 * @author Catalina Espinoza Inaipil - we modified testCaseFinished to save progress state and trace.
 */
public class JUnitListener extends BasicListener {

	public static void register() {
		JUnitCore.addTestRunListener(new MyTestRunListener());
	}

	static class MyTestRunListener extends TestRunListener {
		@Override
		public void sessionFinished(ITestRunSession session) {
			operationRecorder.recordFinishedTestSession(session.getTestRunName());
		}

		@Override
		public void sessionLaunched(ITestRunSession session) {
			IJavaProject launchedProject= session.getLaunchedProject();
			String launchedProjectName= "";
			if (launchedProject != null) {
				launchedProjectName= launchedProject.getElementName();
			}
			operationRecorder.recordLaunchedTestSession(session.getTestRunName(), launchedProjectName);
		}

		@Override
		public void sessionStarted(ITestRunSession session) {
			operationRecorder.recordStartedTestSession(session.getTestRunName());
		}
		@Override
		public void testCaseFinished(ITestCaseElement testCaseElement) {
			String result = testCaseElement.getTestResult(true).toString();
			String progressState = testCaseElement.getProgressState().toString();
			String trace;
			if (result.equals("OK")) {
				trace = "";
			} else {
				trace = testCaseElement.getFailureTrace().getTrace();
			};
			operationRecorder.recordFinishedTestCase(testCaseElement.getTestRunSession().getTestRunName(), result, progressState, trace);
		}

		@Override
		public void testCaseStarted(ITestCaseElement testCaseElement) {
			String testClassName= testCaseElement.getTestClassName();
			String testMethodName= testCaseElement.getTestMethodName();
			operationRecorder.recordStartedTestCase(testCaseElement.getTestRunSession().getTestRunName(), testClassName, testMethodName);
		}
	}

}
