#!/usr/bin/env bash
set -euo pipefail

# adjust these paths if different
VENV="$HOME/cassandra-env"
CASSANDRA_HOME="$HOME/apache-cassandra-5.0.5"


# activate virtualenv
# shellcheck disable=SC1090
source "$VENV/bin/activate"

# start Cassandra in background and save PID
"$CASSANDRA_HOME/bin/cassandra" -R &
CASSANDRA_PID=$!

# wait until Cassandra is ready to accept clients (basic loop)
for i in {1..30}; do
  if nc -z localhost 9042 2>/dev/null; then
    break
  fi
  sleep 1
done

# run cqlsh (will run in foreground)
#"$CASSANDRA_HOME/bin/cqlsh"
qterminal -e "$CASSANDRA_HOME/bin/cqlsh"

# when cqlsh exits, optionally stop Cassandra
kill "$CASSANDRA_PID" 2>/dev/null || true
wait "$CASSANDRA_PID" 2>/dev/null || true
