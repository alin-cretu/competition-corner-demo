using my.event as my from '../db/data-model';

service CompetitionService {                                  // a service is a http endpoit. The visible part of an OData service. 
     entity Competition as projection on my.Competition;
     entity User as projection on my.User;
}