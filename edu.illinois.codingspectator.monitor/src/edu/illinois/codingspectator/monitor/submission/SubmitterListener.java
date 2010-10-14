/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingspectator.monitor.submission;

/**
 * 
 * @author Mohsen Vakilian
 * @author nchen
 * @authro Stas Negara
 * 
 */
public interface SubmitterListener {

	public void preSubmit();

	public void postSubmit();

}
