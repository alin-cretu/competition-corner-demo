using my.event as my from '../db/data-model';

service CompetitionService { // a service is a http endpoit. The visible part of an OData service.
    entity Competition   as projection on my.Competitions;
    entity User          as projection on my.Users;
    entity Registrations as projection on my.Registrations

}

service Stats {
    @readonly
    entity Stats as projection on my.Stats

}
