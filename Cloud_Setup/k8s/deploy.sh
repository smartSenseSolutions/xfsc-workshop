#!/bin/bash
set -e
PS3="Please select application : "

options=("api" "signer" "frontend" "CANCEL")

select opt in "${options[@]}"
do
    case $opt in

       "api")
            echo "Wait and watch!"
            cd /home/ubuntu/projects/smartsense-gaia-x-api
            git pull origin main
            ./gradlew clean build -i -x test -x javadoc --no-daemon
            echo "building docker image"
            docker build -t smartsense-gaia-x-api .
            echo "updating the deployment"
            kubectl patch deployment smartsense-gaia-x-api -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
            echo "The application has been deployed successfully."
            break
            ;;

       "signer")
            echo "Wait and watch!"
            cd /home/ubuntu/projects/smartsense-gaia-x-signer
            git pull origin gaia-x-api-update
            echo "building docker image"
            docker build -t smartsense-gaia-x-signer .
            echo "updating the deployment"
            kubectl patch deployment smartsense-gaia-x-signer -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
            echo "The application has been deployed successfully."
            break
            ;;

       "frontend")
            echo "Wait and watch!"
            cd /home/ubuntu/projects/smartsense-gaia-x-ui
            git pull origin main
            echo "building docker image"
            docker build -t smartsense-gaia-x-ui .
            echo "updating the deployment"
            kubectl patch deployment smartsense-gaia-x-ui -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
            echo "The application has been deployed successfully."
            break
            ;;

        "CANCEL")
            echo "The deployment has been cancelled."
            break
            ;;

        *) echo "invalid option $REPLY";;
    esac
done