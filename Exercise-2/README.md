# Run Federated Catalogue and Discover Self-Descriptions

## Clone the Repo

```sh
git clone https://gitlab.eclipse.org/eclipse/xfsc/cat/fc-service.git
```

```sh
cd fc-service
```

```sh
git checkout feat-ces-event-integration
```

## Make a build of `fc-service` from the Dockerfile

-   Keep the Image name and tag as mentioned in the command below.

```sh
docker build -t fc-service:v1 .
```

## Start Catalogue Components with Docker compose

-   Go to `/docker` folder.

```sh
docker compose up
```

If you have Postgres Database running in your system locally, the ports might conflict. For this you can stop your local postgres db and then try to run `docker compose up`

## Configurations

-   Now, the needed components to run catalogue is running.

-   Open keycloak admin console at `http://localhost:8080/admin`, with `admin/admin` credentials, select `gaia-x` realm.

-   Go to `Clients` section, select `federated-catalogue` client, go to Credentials tab, Regenerate client Secret, copy it and set to `/docker/.env` file in `FC_CLIENT_SECRET` variable

-   Go to users and create one to work with. Set its username and other attributes, save. Then go to Credentials tab, set its password twice, disable Temporary switch, save. Go to Role Mappings tab, in Client Roles drop-down box choose `federated-catalogue` client, select `Ro-MU-CA` role and add it to Assigned Roles.

-   Restart fc-service-server container to pick up changes applied at the second step above. Use the below command to restart `fc-service` container.

```sh
docker compose restart server
```

NOTE: Too many logs and requests at startup - might have to wait 10-15 mins

## Now you can start using the FC API's

-   You can Access the UI to Query and Discover Credentials here `http://localhost:8081/query`

```
MATCH (n:ServiceOffering) where n.name contains 'pcf' RETURN n LIMIT 25
```

-   load the postmann collection from `/fc-service/fc-tools/Federated Catalogue API.postman_collection.json`
