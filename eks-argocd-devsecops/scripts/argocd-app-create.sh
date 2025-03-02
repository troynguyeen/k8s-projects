#!/bin/bash

set -e # Exit script if any command fails

read -p "Enter application name: " APP_NAME
read -p "Enter repository URL: " REPO_URL
read -p "Enter path in repository: " PATH_REPO
read -p "[OPTION] Enter K8s cluster URL (default: https://kubernetes.default.svc): " DEST_SERVER
read -p "Enter K8s target namespace: " DEST_NAMESPACE
read -p "[OPTION] Enter ArgoCD namespace (default: argocd): " APP_NAMESPACE

APP_NAME=$APP_NAME
REPO_URL=$REPO_URL
PATH_REPO=$PATH_REPO
DEST_SERVER=${DEST_SERVER:-"https://kubernetes.default.svc"}
DEST_NAMESPACE=$DEST_NAMESPACE
APP_NAMESPACE=${APP_NAMESPACE:-"argocd"}

# Create an Application on ArgoCD
echo -e "\e[34m[INFO]\e[0m Create an Application on ArgoCD..."
echo -e "\e[32m[RUN]\e[0m argocd app create \e[1;36m$APP_NAME\e[0m --repo \e[1;36m$REPO_URL\e[0m --path \e[1;36m$PATH_REPO\e[0m --dest-server \e[1;36m$DEST_SERVER\e[0m --dest-namespace \e[1;36m$DEST_NAMESPACE\e[0m --app-namespace \e[1;36m$APP_NAMESPACE\e[0m"
argocd app create $APP_NAME --repo $REPO_URL --path $PATH_REPO --dest-server $DEST_SERVER --dest-namespace $DEST_NAMESPACE --app-namespace $APP_NAMESPACE

# Check application after creating...
echo -e "\e[34m[INFO]\e[0m Check application after creating..."
echo -e "\e[32m[RUN]\e[0m argocd app get \e[1;36m$APP_NAME\e[0m"
argocd app get $APP_NAME