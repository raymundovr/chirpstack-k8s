#!/bin/bash
kubectl create ns chirpstack
kubectl config set-context --current --namespace=chirpstack
kubectl apply -f mosquitto.yaml -f redis.yaml -f postgres.yaml
kubectl apply -f api.yaml -f bridge.yaml -f app.yaml
