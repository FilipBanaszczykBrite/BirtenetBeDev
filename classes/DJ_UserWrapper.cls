

public with sharing class DJ_UserWrapper {

    public Id id {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String userName {get; set;}
    public Boolean isActive {get; set;}
    public String profileName {get; set;}
    public String licenseName {get; set;}
    private DJ_OrganizationInfoController controller;

    public DJ_UserWrapper(User user, Profile profile, DJ_OrganizationInfoController con){
        id = user.Id;
        firstName = user.FirstName;
        lastName = user.LastName;
        userName = user.Username;
        isActive = user.IsActive;
        profileName = profile.Name;
        licenseName = profile.UserLicense.Name;
        controller = con;
    }
}