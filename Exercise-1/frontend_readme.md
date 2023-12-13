# Setup Smart X Frontend in Your Local Machines 🧑🏻‍💻

## Clone the Frontend Repo

```sh
git clone https://github.com/smartSenseSolutions/smartsense-gaia-x-ui.git
```

```sh
cd smartsense-gaia-x-ui
```

There are two ways you can run the frontend in your local machines, you can try either one of them.

-   [Using Docker](#run-using-doceker)
-   [Running Locally](#run-locally-for-dev)

Change config

-   [Changing Config](#changing-environment-variables)

### Run Using Docker

#### Prerequisites

-   **Docker**

#### Make a Docker Image

```sh
docker build -t smart-x-ui .
```

If you get an error regarding `permission denied`, try to prepend `sudo` to your docker commands. (e.g. `sudo docker build -t smart-x-ui .`)

#### Run the Docker Container

```sh
docker run -d -p 8000:80 smart-x-ui
```

#### Frontend is Running

Frontend is now running in your local machine on port 8000. You can visit [http://localhost:8000/](http://localhost:8000/) and try using the frontned.

#### Stop and Remove the Docker Container

-   List the running Docker containers by:

```sh
docker ps
```

-   Copy the container ID with Image name `smart-x-ui`, and stop the Container using:

```sh
docker stop {container-id}
```

-   Remove the Docker Container using:

```sh
docker rm {container-id}
```

### Run Locally for Dev

#### Prerequisites

-   **Node.js version `16.14.2` installed**

#### Run the application locally

-   Install the required dependencies:

```bash
npm ci
```

-   Start the development server:

```bash
npm start
```

-   Open your web browser and go to [http://localhost:4200/](http://localhost:4200/) and try using the frontend.

### Changing Environment Variables

#### To Update Base URL in Environment File, follow these steps:

-   Go to environment file at:

```bash
src/environments/environment.ts
```

-   locate the **BASE_URL** variable and update its value with your specific base URL.

-   After changing the variable, if you are running the application with Docker, build the Docker image again, and run the container.

-   If you are running the application locally, just run `npm start` again.
