# Run Federated Catalogue and Discover Self-Descriptions

## Prerequisites

-   Docker & Docker Compose

-   `Note`: This document includes specific Docker commands. Depending on your system's Docker configuration and installation method, you might need to modify these commands accordingly.

    -   You may need to prepend `sudo` before any Docker command if your Docker setup requires elevated privileges for execution.

    -   Consider using `docker-compose` instead of `docker compose` as the command, especially if you've installed Docker via Compose, to ensure proper execution and compatibility.

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

## Start Catalogue Components with Docker compose

-   Go to `/docker` folder.

```sh
docker compose --env-file=dev.env up postgres neo4j keycloak nats
```

If you have Postgres Database, Keycloak, Neo4J or Nats server running in your system locally, the ports might conflict. For this you can stop your local application(s) and then try to run run the above command or make the necessary configuration changes to use the existing aapplication(s).

# Facing issues with postgres initialization scripts
If you are facing issues with running the postgres initialization script, please update the keycloak service in the `docker-compose.yml` as below. This will run your keycloak using its embedded database.
```
keycloak:
  container_name: "keycloak"
  environment:
#      KC_DB_URL: jdbc:postgresql://postgres:5432/keycloak
#      KC_DB_USERNAME: keycloak
#      KC_DB_PASSWORD: keycloak
#      KC_DB_SCHEMA: public
    KC_FEATURES: preview
    KEYCLOAK_ADMIN: "${KEYCLOAK_ADMIN}"
    KEYCLOAK_ADMIN_PASSWORD: "${KEYCLOAK_ADMIN_PASSWORD}"
    PROXY_ADDRESS_FORWARDING: "true"
  image: quay.io/keycloak/keycloak:20.0.2
  ports:
    - "8080:8080"
  networks:
    - "gaia-x"
  restart: unless-stopped
  volumes:
    - "../keycloak/providers:/opt/keycloak/providers"
    - "../keycloak/realms:/opt/keycloak/data/import"
  command:
    [
        'start --auto-build --hostname-strict-https false --hostname-strict false --proxy edge --http-enabled true --import-realm ',
        '--log-level=DEBUG,io.quarkus:INFO,liquibase:INFO,org.hibernate:INFO,org.infinispan:INFO,org.keycloak.services.scheduled:INFO,org.keycloak.transaction:INFO,io.netty.buffer.PoolThreadCache:INFO,org.keycloak.models.sessions.infinispan:INFO'
    ]
#    depends_on:
#      postgres:
#        condition: service_healthy
  healthcheck:
    test: ["CMD", "curl", "-f", "http://0.0.0.0:8080/realms/master"]
    start_period: 10s
    interval: 30s
    retries: 3
    timeout: 5s
```

## Configurations

-   Now, the needed components to run catalogue are running.

-   Keycloak login

    -   Open keycloak admin console at `http://localhost:8080/admin`
    -   You can login with following credentials
        ```
        username: admin
        password: admin
        ```
    -   select `gaia-x` realm from the top left corner

-   Generating Client Secret

    -   Go to `Clients` section and select `federated-catalogue` client
    -   Go to Credentials tab, Regenerate client Secret, copy it and set to `/docker/dev.env` file in `FC_CLIENT_SECRET` variable

-   Creating a new User

    -   Go to users and add a new user.
    -   Set its username and other attributes, save.
    -   Then go to Credentials tab, set its password, disable Temporary switch, save.
    -   Go to Role Mappings tab, click on `Assign role`, select `Filter by clients` from the drop-down and choose `federated-catalogue` client with `Ro-MU-CA` role and add it to Assigned Roles.


-   Scheduler configuration

    -   To enable the scheduler, open the `application.yml` located at `fc-service-server/src/main/resources/application.yml`

    -   Set the `scheduler.ces.lookup.cron` property to `*/2 * * * * *`. This will run the scheduler every 2 seconds. You can modify the time interval to your liking.


## Make a build of `fc-service` from the Dockerfile

-   Keep the Image name and tag as mentioned in the command below.

```sh
docker build -t fc-service:v1 .
```

NOTE: In case of too many logs and requests at startup - might have to wait 10-15 mins

 -   Now, deploy the fc-service
      ```
      docker compose --env-file=dev.env up server
      ```
  -   As there are more than 400 credentials published to the CES, we recommend executing the below query in the Postgres database to only process the records that were added recently:

        Host : `http://localhost:5432`, Authentication credenials: `postgres/postgres`

        ```sql
        INSERT INTO ces_process_tracker(ces_id, reason, credential, status, created_at, updated_at)
        VALUES ('9349c873-f46e-4253-bb1e-33f3b9f029b9', '404 Not Found from GET https://gaia-x.eu/legalRegistrationNumberVC.json', '', 3, now(), now());
        ```

## Now you can start using the XFSC Catalogue's APIs

-   You can Access the UI to Query and Discover Credentials here `http://localhost:8081/query`
-   Sample Cypher query to check if your service has been added (updated the `'pcf'` with a part of the name of your service):

```
MATCH (n:ServiceOffering) where n.name contains 'pcf' RETURN n LIMIT 25
```

-   To play around further with the catalogue, load the postmann collection from `/fc-service/fc-tools/Federated Catalogue API.postman_collection.json`. You may need to login for using the APIs, generate an access token using the client and user configured earlier.

## Remove Docker Containers

To stop and remove all the running containers execute:

```sh
docker compose down
```

## Happy Hacking! :)
