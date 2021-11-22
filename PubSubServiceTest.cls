@isTest
private class PubSubServiceTest {
		private static final String INCOMING_LEAD_CHANNEL = 'IncomingLeads';
		private static final String BLANK_CHANNEL = '';

    private static List<Lead> getLeads(string fname) {
       // return [SELECT Id, FirstName, LastName, AssistantName FROM Lead];
       return [select firstName,lastName,company from Lead where firstname =:fname];
    }

    @isTest
    private static void subscribeTest() {
    
        Lead testLeadBlank = new Lead(
                FirstName = '',
                LastName = 'test11',
                company = 'test11');
        
		Lead testLead = new Lead(
                FirstName = 'test10',
                LastName = 'test10',
                company = 'test10');


        
		IncomingLeadHandler testHandler = new IncomingLeadHandler('TestSubscriber1');
		PubSubService.Instance.subscribe(testHandler);
        
        
        Test.startTest();
        //check to see when a lead with firstname null is passed
        PubSubService.Instance.emit(BLANK_CHANNEL, testLeadBlank);
        
        //check to see when a lead with non null firstname is passed
        PubSubService.Instance.emit(INCOMING_LEAD_CHANNEL, testLead);
        Test.stopTest();

        List<Lead> leads = getLeads( 'test11');
        //this time the lead should not be inserted 
        System.assertEquals(leads.size(),0);
  
        List<Lead> leads1 = getLeads( 'test10');
        //check to see if the Incoming test Lead is properly inserted
        System.assertEquals(leads1.size(),1);
       }
    
    @isTest
    private static void unSubscribeTest() {

        		Lead testLead3 = new Lead(
                FirstName = 'test20',
                LastName = 'test20',
                company = 'test20');
        
        Test.startTest();
		IncomingLeadHandler testHandler3 = new IncomingLeadHandler('TestSubscriber3');
        PubSubService.Instance.subscribe(testHandler3);
		PubSubService.Instance.Unsubscribe(testHandler3);
        //check to see if the lead is inserted after the only channel which is subscribed is also unsubscribed.
        PubSubService.Instance.emit(INCOMING_LEAD_CHANNEL, testLead3);
        Test.stopTest();

        List<Lead> leads = getLeads('test20');
        //this time there should not be any lead in the database.  
        System.assertEquals(leads.size(),0);
  
       }

}