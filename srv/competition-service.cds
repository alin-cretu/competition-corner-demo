using my.event as my from '../db/data-model';

service CompetitionService { // a service is a http endpoit. The visible part of an OData service.
    entity Competitions   as projection on my.Competitions;
    entity Users         as projection on my.Users;
    entity Registrations as projection on my.Registrations

}


