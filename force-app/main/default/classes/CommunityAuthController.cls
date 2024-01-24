public with sharing class CommunityAuthController {
    public CommunityAuthController() {

    }
    @AuraEnabled
    public static string doLogin(String username, String password){
        try {
            String startUrl = System.Label.Community_Url;
            ApexPages.PageReference pageRef = Site.login(username, password, startUrl);

            if(pageRef != null){
                return pageRef.getUrl();
            }
        } catch (Exception e) {
            system.debug('e.getMessagelogin+   '+e.getMessage());
        }
        return 'null';
    }
    @AuraEnabled
    public static string cerateContact(String firstName, String lastName, String email, String username, String communityNickname, String Alias){
        Account acc = [Select Id, Name From Account where Name = 'Customers' limit 1];
        System.debug('account:  '+acc);
        
        Contact con = new Contact();
        con.firstName = firstName;
        con.lastName = lastName;
        con.email = email;
        con.AccountId = acc.Id;
        insert con;
        
        System.debug('Contact:  '+con);

        CommunityAuthController.createUser(con.firstName, con.lastName, con.email, username, communityNickname, Alias, con.Id);

        return 'null';
    }
    @future    
    public static void createUser(String firstName, String lastName, String email, String username, String uniqueCommunityNickName, String Alias, String contactId){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Customers' LIMIT 1];
		//UserRole userRoleId = [SELECT Id FROM UserRole WHERE Name = 'Customer Manager' LIMIT 1];
            
        User u = new User();
        u.firstName = firstName;
        u.lastName = lastName;
        u.Username = username;
        u.Email = email;
        u.CommunityNickname = uniqueCommunityNickName; 
        u.Alias = 'user';
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.ProfileId = profileId.Id;
        //u.UserRoleId = userRoleId.Id;
        u.LanguageLocaleKey = 'en_US';
        u.ContactId = contactId;
        u.IsActive = true;
        insert u;

        System.debug('User:  '+u);

        if (u.Id != null) {

            String emailResult = CommunityAuthController.sendWelcomeMail(u, u.Id);
        }
    }

    @AuraEnabled
    public static string sendWelcomeMail(User usr, String userId){
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<EmailTemplate> welcomeTemplate = new List<EmailTemplate>([Select Id from EmailTemplate where name = 'Welcome mail']);
            
            mail.setSenderDisplayName(System.Label.Community_Email_Sender);
            mail.setTargetObjectId(userId);
            mail.setTemplateId(welcomeTemplate[0].Id);
            mail.setSaveAsActivity(false);

            Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail} );

        } catch (Exception e) {
            System.debug('Error: '+e.getMessage());
        }
        return 'success';
    }

}