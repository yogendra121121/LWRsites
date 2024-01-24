public class Experiment {

    public static string registerUser(String firstName, String lastName, String username, String email, String communityNickname, String password){
        try {
            
            Set<String> communityNicknameSet = new Set<String>();
            
            for(User usr : [Select Id, CommunityNickname From User Where CommunityNickname != null]){
                
                communityNicknameSet.add(usr.CommunityNickname);
            }
            
            String uniqueCommunityNickName;
            
            if(communityNicknameSet.isEmpty()){
                
                if(communityNickname.length() > 4){
                    
                    uniqueCommunityNickName = communityNickname.substring(0, 4) + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                    
                } else {
                    
                    uniqueCommunityNickName = communityNickname + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                }
                
            } else {
                
                for(Integer i=1; i <= 9999 ; i++){
                    
                    if(communityNickname.length() > 4){
                        
                        uniqueCommunityNickName = communityNickname.substring(0, 4) + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                        
                    } else {
                        
                        uniqueCommunityNickName = communityNickname + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                    }
                    
                    if(!communityNicknameSet.contains(uniqueCommunityNickName)){
                        
                        break;
                    }
                }
            }
            
            System.debug('Set of Community nick name: '+communityNicknameSet);
            System.debug('Unique Nickname'+uniqueCommunityNickName);
            
            Account acc = [Select Id, Name From Account where Name = 'Customers' limit 1];
            System.debug('account:  '+acc);
            
            Contact con = new Contact();
            con.firstName = 'new';
            con.lastName = 'member';
            insert con;
            
            System.debug('Contact:  '+con);
            
            Experiment.createUser(username, uniqueCommunityNickName, email, password);
            
            User u = [Select Id, firstName,lastName,Username,Email,CommunityNickname,Alias,TimeZoneSidKey, LocaleSidKey,
                      EmailEncodingKey, ProfileId, UserRoleId, LanguageLocaleKey, ContactId From User where ProfileId = '00e5j000000vKItAAM'];
            
            String userId = Site.createPortalUser(u, acc.Id, password);
            
            if (userId != null) {
                
                String emailResult = sendWelcomeMail(u, userId);
                
                if (password != null && password.length() > 1) {
                    ApexPages.PageReference pageRef = Site.login(username, password, null);
                    if(pageRef != null) return pageRef.getUrl();
                }
                else {
                    ApexPages.PageReference page = System.Page.SiteRegisterConfirm;
                    page.setRedirect(true);
                    return page.getUrl();
                }
                System.debug('Sent Email'+ emailResult);
            }
            
            return null;
            
            
        } catch (Exception e) {
            system.debug('e.getMessage+   '+e.getMessage());
            
            if(!Test.isRunningTest()) throw new AuraHandledException(e.getMessage());
            
            return null;
            
        }
    }
    @future    
    public static void createUser(String username, String uniqueCommunityNickName, String email, String password){
        
        Contact con = [Select Id, firstName, lastName From Contact where Name = 'new member' limit 1];
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Customers' LIMIT 1];
		UserRole userRoleId = [SELECT Id FROM UserRole WHERE Name = 'Customer Manager' LIMIT 1];
        Account acc = [Select Id, Name From Account where Name = 'Customers' limit 1];
            
        User u = new User();
        u.firstName = con.firstName;
        u.lastName = con.lastName;
        u.Username = username;
        u.Email = email;
        u.CommunityNickname = uniqueCommunityNickName; 
        u.Alias = 'tname';
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.ProfileId = profileId.Id;
        u.UserRoleId = userRoleId.Id;
        u.LanguageLocaleKey = 'en_US';
        u.ContactId = con.Id;
        insert u;

        System.debug('User:  '+u);
    }
    
	public static string sendWelcomeMail(User usr, String userId){
        try {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            List<EmailTemplate> welcomeTemplate = new List<EmailTemplate>([Select Id from EmailTemplate where name = 'Welcome mail']);
                     
            mail.setSenderDisplayName(System.Label.Community_Email_Sender);
            mail.setTargetObjectId(userId);
            mail.setTemplateId(welcomeTemplate[0].Id);
            mail.setSaveAsActivity(false);

            Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail} );

            return 'success';

        } catch (Exception e) {            
            throw new AuraHandledException(e.getMessage());
        }
    }
}