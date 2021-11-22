/**
 * @description A simple Pub/Sub pattern implementation
 */
public with sharing class PubSubService {
    private PubSubService() { }

    Set<IHandleMessages>  incommingSubScriptions = new Set<IHandleMessages>();

    /**
     * @description A singleton for service interaction.
     */
    public static PubSubService Instance {
        get {
            if (Instance == null) {
                Instance = new PubSubService();
            }

            return Instance;
        }

        private set;
    }

    /**
     * @description Subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void subscribe(IHandleMessages implementation) {

        try {
            if(implementation == null)
            {
                ArgumentNullException.throwIfNull(implementation,'Argument Null Exception');
            }
            }
        catch(exception e) 
            {
                  System.debug('Exception type caught: ' + e.getTypeName());    
                  System.debug('Message: ' + e.getMessage());
            }

       // IncomingLeadHandler leadHandler = (IncomingLeadHandler) implementation;

        // Adding leadhandler to the set. As set does accept duplicates it will work even for duplicates calls.
        incommingSubScriptions.add(implementation);
    }

    /**
     * @description Un-subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void unsubscribe(IHandleMessages implementation) {

        try {
            if(implementation == null)
            {
                ArgumentNullException.throwIfNull(implementation,'Argument Null Exception');
            }
            
        boolean handlerExists = false;
        if  (incommingSubScriptions.size() > 0)
        {
		for (IHandleMessages searchHandler :  incommingSubScriptions)
        {
            if (searchHandler === implementation)
            {
                handlerExists = True;
                incommingSubScriptions.remove(implementation);
                break;
            } 
        }
        }
            
        system.debug('handlerExists :' +handlerExists);
        if (handlerExists == false)
        {
        throw new ArgumentException('Not a Subscriber');
        }
        } //try
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
    } //unsubscribe

    /**
     * @description Emits a message to a given channel containing the specified data.
     * @param channel The channel to emit a message on.
     * @param data The data to emit.
     * @throws ArgumentNullException if channel is null.
     */
    public void emit(String channel, SObject data) {

        try {
        if (string.isblank(channel)) 
        {
            ArgumentNullException.throwIfNull(channel,'Channel Null Exception');
        }

       if (data == null) 
        {
            ArgumentNullException.throwIfNull(data,'Data Null Exception');
        }
  	
        for (IHandleMessages subscriber :  incommingSubScriptions)
        {
            if (data instanceof Lead )
            {
                IncomingLeadHandler subscriberLead;
                subscriberLead = (IncomingLeadHandler) subscriber;
                subscriberLead.handleMessage(channel, data);
            }
        } //for  
        } //try

        catch(ArgumentNullException e) 
        {
             System.debug('Exception type caught: ' + e.getTypeName()); 
            System.debug('Message: ' + e.getMessage());
        }
        catch(exception e) 
        {
                System.debug('Message: ' + e.getMessage());
        } 
}
}
