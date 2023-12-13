# Configure kubernetes in your own cloud provider for deployment

We have configured the Smart-X POC to run in AWS Cloud Infrastructure, but you can run Smart-X POC in your own cloud environments as well. However you will have to configure many things as an alternative to AWS services in your own cloud infrastructure.

List of AWS services, we are using.

-   Amazon S3

-   Amazon Route53

-   Amazon EC2

## Configurations in Cloud Server

-   Assuming you have configured a clean Ubuntu installation on the server.

-   Install `git` and `Docker`

-   Copy the folder structure given in the Cloud_Setup folder

-   Make a folder named `k8s` in the home directory.

    -   Copy all the files from k8s folder in this repo to the `k8s` folder on the server.

-   Make projects directory and clone all the repos

    -   API server

    ```
    git clone https://github.com/smartSenseSolutions/smartsense-gaia-x-api.git
    ```

    -   Frontend

    ```
    git clone https://github.com/smartSenseSolutions/smartsense-gaia-x-ui.git
    ```

    -   Signer Tool

        ```sh
        git clone https://github.com/smartSenseSolutions/smartsense-gaia-x-signer.git
        ```

        -   Just checkout to this branch for signer tool, as the lastest code is in this branch.

            ```sh
            cd smartsense-gaia-x-signer
            ```

            ```sh
            git checkout gaia-x-api-update
            ```

-   Install conntrack

    ```sh
    sudo apt install conntrack
    ```

-   Install `kubectl`

-   You will need to update the configuration according to your minikube and k8s installation.

-   Also, in our code base we are using S3 and Route53 which are AWS services, you will need to find the alternatives for that in your preferred cloud provider and make the code changes accordingly.
