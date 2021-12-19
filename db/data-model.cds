namespace my.event;
using { Country ,managed} from '@sap/cds/common';  // import reuse packages that are already provided by the framework

entity Competition : managed { //administrative fields provided by the cds 
    key ID          : Integer;
        name        : String;
        type: String;
        description : String;
        city   : String;
        country: Country;  // reuse type from common packages 
        user: Association to User; // namaged association without a manual foreign key.
}


entity User: managed {
    key ID : Integer;
    firstName: String;
    lastName: String;
    age: Integer;
    city: String;
    country: Country;
    
    competition: Association to many Competition on competition.user =$self;
}