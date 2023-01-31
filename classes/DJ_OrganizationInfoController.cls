

public with sharing class DJ_OrganizationInfoController {

    public List<DJ_UserWrapper> organizationUsers { get; set; }
    public List<UserLicense> userLicenses { get; set;}
    public Integer vfPages { get; set; }
    public Integer apexClasses { get; set; }
    public Organization org { get; set; }
    public String selectedUserId { get; set; }
    public Integer usedLicenses { get; set; }
    public Integer remainingLicenses { get; set; }

    public DJ_OrganizationInfoController(){
        usedLicenses = 0;
        remainingLicenses = 0;
        getOrganizationInfo();
        getOrganizationUsers();
        getUserLicenses();
    }


    public List<DJ_UserWrapper> getOrganizationUsers(){
        organizationUsers = new List<DJ_UserWrapper>();
        List<User> users = [SELECT FirstName, LastName, ProfileId, Username, IsActive FROM User];
        Set<Id> userProfileIds = new Set<Id>();
        for(User user : users){
            userProfileIds.add(user.ProfileId);
        }
        List<Profile> profiles = [SELECT Name, UserLicense.Name FROM Profile WHERE Id in :userProfileIds];
        for(Profile profile: profiles){
            for(User user : users){
                if(user.ProfileId == profile.Id) {
                    organizationUsers.add(new DJ_UserWrapper(user, profile, this));
                }
            }
        }
        return organizationUsers;
    }


    public List<UserLicense> getUserLicenses(){
        userLicenses = [SELECT Name, TotalLicenses, UsedLicenses FROM UserLicense];
        for(UserLicense license : userLicenses){
            usedLicenses += license.UsedLicenses;
            remainingLicenses += (license.TotalLicenses - license.UsedLicenses);
        }
        return userLicenses;
    }


    public void changeActiveUser() {
        User user = [SELECT IsActive, FirstName, LastName FROM User WHERE Id =:selectedUserId];
        if (user != null) {
            try {
                user.IsActive = !user.IsActive;
                update user;
                if (user.IsActive) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.DJ_UserActivationSuccess
                            + user.FirstName + ' ' + user.LastName));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.DJ_UserDeactivationSuccess
                            + user.FirstName + ' ' + user.LastName));
                }
            }
            catch(Exception e){
                if(user.isActive){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.DJ_UserDeactivationError
                    + user.firstName + ' ' + user.lastName));
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.DJ_UserActivationError
                    + user.firstName + ' ' + user.lastName));
                }
            }
        }
        getOrganizationUsers();
    }


    private void getOrganizationInfo(){
        org = [SELECT Name, IsSandbox, PrimaryContact, OrganizationType FROM Organization LIMIT 1].get(0);
        vfPages = (Integer)[SELECT COUNT(Id) pages FROM ApexPage].get(0).get('pages');
        apexClasses = (Integer)[SELECT COUNT(Id) classes FROM ApexClass].get(0).get('classes');
    }
}