# Getting Started

    namespace my.event;
    using { Country ,managed} from '@sap/cds/common';

    entity Competition : managed {
        key ID          : Integer;
            name        : String;
            type: String;
            description : String;
            city   : String;
            country: Country;
            user: Association to User;
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