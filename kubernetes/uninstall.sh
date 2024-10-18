#!/bin/bash
kubectl config set-context --current --namespace=chirpstack
kubectl delete -f mosquitto.yaml -f redis.yaml -f postgres.yaml
kubectl delete -f configmaps/chirpstack-config-1.yaml -f configmaps/chirpstack-config-2.yaml -f configmaps/chirpstack-gw-configmap.yaml
kubectl delete -f api.yaml -f bridge.yaml -f app.yaml
kubectl delete ns chirpstack
kubectl config set-context --current --namespace=default