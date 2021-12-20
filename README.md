### 1.Create a new project with the CDS cli.

` cds init competition-corner`

### 2. Create  data model 

Create a new file called 'data-model.cds' in the /db folder.

``` 
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
```

### 3.Create a service definition

Create a new file in the /srv folder called 'competition-service.cds'.

```
using my.event as my from '../db/data-model';

service CompetitionService {
     entity Competition as projection on my.Competition;
     entity User as projection on my.User;
}

```

### 4. Deploy the service to a persistence layer

The OData service has no storage, so we will install a local SQLite DB as a first step.

``` npm install -D sqlite3```

After deploy the data model and service definition to a new SQLite-based database.

``` cds deploy --to sqlite:competition-corner-demo.db ```

Explore the database with the command :

```sqlite3 competition-corner.db```

### 5. Connect the SQLTools from SAP BAS to the the local SQLite DB.

File>Preferences>Open Preferences >sqltools > connections

### 6. Insert a new competition from BAS http plug-in.

```
### Insert a new competition
POST http://localhost:4004/competition/Competition
Content-Type: application/json

{
"ID": 10,
"name": "Roma Marathon",
"type": "Running Competition",
"description": "The biggest running marathon from Italy",
"city": "Roma",
"country": "Italy",
"user_ID": null
}

### List all competitions
GET http://localhost:4004/competition/Competition

```

### 7. Deploy to Hana Cloud.

