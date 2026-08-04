#!/bin/bash
# backup.sh - dumps the dummy Postgres DB, compresses, encrypts, uploads to S3,
# and always writes a status marker (success or failure) so Lambda can react.

set -euo pipefail
# -e: exit immediately if any command fails
# -u: error on any undefined variable (catches typos)
# -o pipefail: a failure anywhere in a pipeline counts as a failure


# Configuration
DB_NAME="insureflow_placeholder"
DB_USER="backup_user"
BACKUP_DIR="/home/ubuntu/backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DUMP_FILE="${BACKUP_DIR}/${DB_NAME}-${TIMESTAMP}.sql"
GPG_RECIPIENT="033F6CCC64777FB8B66229C76A3C642F1C277914"
S3_BUCKET="serverless-kazeem-db-backups-203637463799"

# These get set later in the script, once each step actually runs
COMPRESSED_FILE=""
ENCRYPTED_FILE=""


# Cleanup and status reporting 
cleanup_and_report() {
  local exit_code=$?
  # Remove any local files that still exist
  rm -f "${DUMP_FILE:-}" "${COMPRESSED_FILE:-}" "${ENCRYPTED_FILE:-}"

  if [ "$exit_code" -eq 0 ]; then
    STATUS="success"
  else
    STATUS="failed"
  fi

  STATUS_FILE="/tmp/${TIMESTAMP}-${STATUS}.json"
  echo "{\"status\": \"${STATUS}\", \"timestamp\": \"${TIMESTAMP}\", \"exit_code\": ${exit_code}}" > "$STATUS_FILE"
  aws s3 cp "$STATUS_FILE" "s3://${S3_BUCKET}/status/$(basename "$STATUS_FILE")" --sse AES256
  rm -f "$STATUS_FILE"

  echo "Backup finished with status: ${STATUS}"
}
trap cleanup_and_report EXIT
# Registered BEFORE anything that could fail


# Prepare staging directory
mkdir -p "$BACKUP_DIR"

# Authenticate to Postgres
export PGPASSWORD="${DB_BACKUP_PASSWORD}"

# Dump the database
pg_dump -h localhost -U "$DB_USER" -d "$DB_NAME" -F p -f "$DUMP_FILE"

# Compress
gzip "$DUMP_FILE"
COMPRESSED_FILE="${DUMP_FILE}.gz"

# Encrypt (asymmetric)
gpg --encrypt --recipient "$GPG_RECIPIENT" --trust-model always "$COMPRESSED_FILE"
ENCRYPTED_FILE="${COMPRESSED_FILE}.gpg"

# Upload encrypted backup to S3
aws s3 cp "$ENCRYPTED_FILE" "s3://${S3_BUCKET}/backups/$(basename "$ENCRYPTED_FILE")" --sse AES256
# Script ends here naturally on success - trap fires automatically,
# sees exit_code 0, writes a "success" status marker, and cleans up.