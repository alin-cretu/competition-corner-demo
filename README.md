### 1.Create a new project using the CAP Template.

run 'npm install'

### 2. Create data model

Create a new file called 'data-model.cds' in the /db folder.

```cds
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
        user        : Association to Users // CAP uses Associations to capture relationships between entities.
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

```

### 3.Create a service definition

Create a new file in the /srv folder called 'competition-service.cds'.

```
using my.event as my from '../db/data-model';

service CompetitionService { // a service is a http endpoit. The visible part of an OData service.
    entity Competition   as projection on my.Competitions;
    entity User          as projection on my.Users;
    }

```

### 4. Load data from CSV files

Create a new folder in the /db folder called /data. Create the CSV files based
on the naming conventions. 


### 5. Deploy the service to a persistence layer

The OData service has no storage, so we will install a local SQLite DB as a
first step.


After deploy the data model and service definition to a new SQLite-based
database.

`cds deploy --to sqlite:competition-corner-demo.db`

Explore the database with the command :

`sqlite3 competition-corner.db`

### 6. Connect the SQLTools from SAP BAS to the the local SQLite DB.

File>Preferences>Open Preferences >sqltools > connections

### 7. Insert a new competition from BAS http plug-in.

```json
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

### 8. Insert a new user from BAS http plug-in.

```json
### Get all users
GET http://localhost:4004/competition/User

### Add a new User

POST http://localhost:4004/competition/User
Content-Type: application/json

{
"ID":20,
"firstName":"Ion",
"lastName":"Popescu",
"age": 20,
"city":"Bucuresti",
"country":"Romania"
}
```

### 9. Defining a second service

I will create a second service that sits on top of the same data model. You can
define as many services on the same data model as you need, either in the same
service definition file, or in separate files.

In the data-model.cds create a new entity:

```cds

entity Registrations:cuid,managed, temporal { //administrative fields provided by the cds
    competition: Association to Competitions;
    user: Association to  Users;
}

```

Add a new service definition:

```cds

using my.event as my from '../db/data-model';

service RegistrationService{
entity Registration as projection on my.Registrations
}


```

Deploy the chages to the DB.

Add a registration with the BAS http plug-in.

```json
### Create a competition registration
POST http://localhost:4004/competition/Registrations
Content-Type: application/json

{
"competition_ID": 1 ,
"user_ID":1
}

```

### 10. Add custom logic

Create a 'competition-service.js' in the srv folder.
```js
module.exports = (srv) => {
  console.log(`>>>Service name: ${srv.name}, is served at path ${srv.path}`);

  srv.after("READ", "Competition", (data) => {
    const newComp = [];

    data.forEach((item) => {
      if (item.country === "Romania") {
        item.description =
          "10% off from the registration fee >>>" + item.description;
      }

      newComp.push(item);
    });
    console.log(newComp);
    return newComp;
  });
};

```

### 9.Common Types & Aspects @sap/cds/common

### 12. Add the UI layer

Add an UI layer using the Fiori Template.

### 13. Deploy to Hana Cloud.

When you’re moving from the development phase to the production phase, use SAP
HANA Cloud as your database.

update mta.yaml file

Update the CDS section in the package.json file:

```json
 "cds": {
    "build": {
      "target": "."
    },
    "requires": {
      "db": {
        "kind": "hana"
      }
    },
    "hana": {
      "deploy-format": "hdbtable"
    }
  }

```

run 'hana-cli createModule'

Build the project with 'cds build'

Connect to Hana Cloud using the the Hana tools from BAS.
