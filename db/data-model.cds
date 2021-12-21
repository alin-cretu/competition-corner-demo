namespace my.event;

using {
    cuid,
    managed
} from '@sap/cds/common'; // import reuse packages that are already provided by the framework

entity Competitions { 
    key ID          : Integer;
        name        : String;
        type        : String;
        description : String;
        city        : String;
        country     : String;
        user        : Association to many Users ; // namaged association without a manual foreign key.
}


entity Users {
    key ID          : Integer;
        firstName   : String;
        lastName    : String;
        age         : Integer;
        city        : String;
        country     : String;

        competition : Association to many Competitions
                          on competition.user = $self;
}

entity Registrations:cuid,managed { //administrative fields provided by the cds
    competition: Association to Competitions;
    user: Association to  Users;
}

entity Stats : cuid {
    user        : Association to Users;
    competition : Association to Competitions;
}
