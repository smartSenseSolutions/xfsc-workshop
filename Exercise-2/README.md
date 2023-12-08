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

-   To enable the scheduler, open the `application.yml` and set the `scheduler.ces.lookup.cron` property to `*/2 * * * * *`. This will run the scheduler every 2 seconds. You can modify the time interval to your liking.

-   As there are more than 400 credentials published to the CES, we recommend executing the below query in the Postgres database to only process the records that were added recently:

      `INSERT INTO public.ces_process_tracker(ces_id, reason, credential, status, created_at, updated_at)
	VALUES ('7a214a64-c9d5-4b89-ae06-360e0b7e71d9', '404 Not Found from GET https://gaia-x.eu/legalRegistrationNumberVC.json', '', 3, now(), now());`

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
