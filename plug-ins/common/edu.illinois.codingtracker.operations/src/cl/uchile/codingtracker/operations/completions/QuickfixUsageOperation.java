	package cl.uchile.codingtracker.operations.completions;

	import org.eclipse.jface.text.contentassist.ContentAssistEvent;

	import edu.illinois.codingtracker.operations.OperationLexer;
	import edu.illinois.codingtracker.operations.OperationSymbols;
	import edu.illinois.codingtracker.operations.OperationTextChunk;
	import edu.illinois.codingtracker.operations.UserOperation;

public class QuickfixUsageOperation extends UserOperation {

		protected ContentAssistEvent event;
		
		public QuickfixUsageOperation() {
			super();
		}

		public QuickfixUsageOperation(ContentAssistEvent event) {
			super();
			this.event=event;	
		}

		@Override
		public char getOperationSymbol() {
			return OperationSymbols.QUICKFIX_USAGE_SYMBOL;
		}

		@Override
		public String getDescription() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		protected void populateTextChunk(OperationTextChunk textChunk) {
			textChunk.append("  "+event.assistant); 
		}
		
		@Override
		protected void populateXMLTextChunk(OperationTextChunk textChunk) {
			textChunk.concat("<QuickfixUsageOperation>" + "\n");
			textChunk.concat("\t" + "<ContentAssistEvent>" + "\n");
			textChunk.concat("\t" + event.assistant + "\n");
			textChunk.concat("\t" + "</ContentAssistEvent>" + "\n");
			textChunk.concat("\t" + "<timestamp>" + "\n");
			textChunk.concat("\t" + getTime() + "\n");
			textChunk.concat("\t" + "</timestamp>" + "\n");
			textChunk.concat("</QuickfixUsageOperation>" + "\n");
		}

		@Override
		protected void initializeFrom(OperationLexer operationLexer) {
			// TODO Auto-generated method stub

		}

		@Override
		public void replay() throws Exception {
			// TODO Auto-generated method stub

		}

	}
