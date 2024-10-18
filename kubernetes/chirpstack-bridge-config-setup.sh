#!/bin/bash

# Directory containing your configuration files
CONFIG_DIR="../configuration/chirpstack-gateway-bridge"

# Output file for the ConfigMap
OUTPUT_FILE="chirpstack-gw-configmap.yaml"

# ConfigMap name
CONFIGMAP_NAME="chirpstack-gw-config"

# Write the initial part of the ConfigMap YAML to the output file
cat <<EOF > $OUTPUT_FILE
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CONFIGMAP_NAME
data:
EOF

# Loop through each file in the configuration directory
for file in "$CONFIG_DIR"/*; do
  # Get the base name of the file (without directory path)
  filename=$(basename "$file")
  
  # Append the file's contents to the ConfigMap
  echo "  $filename: |" >> $OUTPUT_FILE
  sed 's/^/    /' "$file" >> $OUTPUT_FILE
done

echo "ConfigMap created successfully in $OUTPUT_FILE"
