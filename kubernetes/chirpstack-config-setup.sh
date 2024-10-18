#!/bin/bash

# Directory containing your configuration files
CONFIG_DIR="../configuration/chirpstack"

# Output file for the ConfigMap
CONFIGMAP_NAME="chirpstack-config"
OUTPUT_DIR="./configmaps"
mkdir -p $OUTPUT_DIR

# Size limit for each ConfigMap (Kubernetes limit is 262144 bytes, leaving some buffer)
MAX_SIZE=250000

# Variables to track current size and config map index
current_size=0
config_index=1

# Create the first ConfigMap file
OUTPUT_FILE="$OUTPUT_DIR/$CONFIGMAP_NAME-$config_index.yaml"
cat <<EOF > $OUTPUT_FILE
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CONFIGMAP_NAME-$config_index
data:
EOF

# Function to start a new ConfigMap when size exceeds the limit
new_configmap() {
  config_index=$((config_index+1))
  OUTPUT_FILE="$OUTPUT_DIR/$CONFIGMAP_NAME-$config_index.yaml"
  current_size=0

  cat <<EOF > $OUTPUT_FILE
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CONFIGMAP_NAME-$config_index
data:
EOF
}

# Loop through each file in the configuration directory
for file in "$CONFIG_DIR"/*; do
  filename=$(basename "$file")
  
  # Calculate file size and check if it fits in the current ConfigMap
  file_size=$(wc -c <"$file")
  
  if (( current_size + file_size > MAX_SIZE )); then
    new_configmap
  fi
  
  # Append the file to the current ConfigMap
  echo "  $filename: |" >> $OUTPUT_FILE
  sed 's/^/    /' "$file" >> $OUTPUT_FILE
  current_size=$((current_size + file_size))
done

echo "ConfigMaps created successfully in $OUTPUT_DIR"
