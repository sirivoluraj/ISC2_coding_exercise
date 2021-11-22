/**
 * @description An implementation of IHandleMessages which validates the passed in Lead and inserts it.
 */
public with sharing class IncomingLeadHandler implements IHandleMessages {
    @testVisible private static final String INCOMING_LEAD_CHANNEL = 'IncomingLeads';
     public static string INCOMING_LEAD_SUBSCRIBER = 'IncomingLeadsSubscriber';

    /**
     * @description Constructs an instance of IncomingLeadHandler.
     */
    public IncomingLeadHandler(string subscriber)
        {
            Subscriber = subscriber == null ? INCOMING_LEAD_SUBSCRIBER : subscriber;
        }


    /**
     * @description Handles a message on a subscribed channel.
     * @param channel The channel emitting the message.
     * @param data The accompanying data for the message.                                                                                         
     * @throws ArgumentNullException if channel is null.
     * @throws ArgumentException if the lead is missing a FirstName.
     */
    public void handleMessage(String channel, SObject data) {
    try {
        system.debug('into handleMessage');
        if (string.isblank(channel)) 
        {
            ArgumentNullException.throwIfNull(channel,'Channel Null Exception');
        }

        List<string> leadChannelslist = getSubscribedChannels();
        for (string leadChannel:leadChannelslist)
        {
        if (channel.equalsIgnoreCase(leadChannel))
        {
             system.debug('data : ' +data);
            if (data == null) 
            {
                ArgumentNullException.throwIfNull(data,'Data Null Exception');
            }

        Lead passedLead;
        if (data instanceof Lead )
        {
        passedLead = (Lead) data;
        if (string.isblank(passedLead.FirstName))
        {
                ArgumentNullException.throwIfNull(lead.FirstName,'FirstName Null Exception');
        }            
           
            Database.insert(passedLead);
        }
        else {
            throw new ArgumentException('Not a Lead');
        }  
        } 
		} //for            
        }  // try      
		
        catch(ArgumentNullException e) 
        {
             System.debug('Exception type caught: ' + e.getTypeName()); 
            System.debug('Message: ' + e.getMessage());
        }
        catch(ArgumentException e) 
        {
             System.debug('Exception type caught: ' + e.getTypeName()); 
            System.debug('Message: ' + e.getMessage());
        }
        catch(exception e) 
        {
                System.debug('Message: ' + e.getMessage());
        }             
    }

    /**
     * @description Gets a list of channels an implementation subscribes to.
     * @return A List<String> of channel names this implementation is subscribed to.
     */
    public List<String> getSubscribedChannels() {
        return new List<String> {
                    INCOMING_LEAD_CHANNEL
            };
    }
}