# =============================================================================
# rabbitmq-utils.plugin.zsh – RabbitMQ management helpers
#
# Requires: curl, jq
# Default target: http://localhost:15672 (RabbitMQ Management UI default)
# Override via environment variables:
#   export RABBITMQ_HOST=http://my-rabbit:15672
#   export RABBITMQ_USER=admin
#   export RABBITMQ_PASS=secret
# =============================================================================

# ---------------------------------------------------------------------------
# Defaults (override in your own ~/.zshrc or shell profile)
# ---------------------------------------------------------------------------
: "${RABBITMQ_HOST:=http://localhost:15672}"
: "${RABBITMQ_USER:=guest}"
: "${RABBITMQ_PASS:=guest}"
: "${RABBITMQ_VHOST:=%2F}"   # %2F = URL-encoded "/"

# ---------------------------------------------------------------------------
# _rmq_api – Internal helper: calls the RabbitMQ HTTP API
# Usage: _rmq_api GET /api/queues
# ---------------------------------------------------------------------------
function _rmq_api() {
  local method="$1"
  local path="$2"
  shift 2
  curl -s -u "${RABBITMQ_USER}:${RABBITMQ_PASS}" \
    -X "$method" \
    "${RABBITMQ_HOST}${path}" \
    "$@"
}

# ---------------------------------------------------------------------------
# rmq-queues – List all queues with message counts
# ---------------------------------------------------------------------------
function rmq-queues() {
  echo "📋 Queues on ${RABBITMQ_HOST}:"
  _rmq_api GET "/api/queues" \
    | jq -r '.[] | "\(.name)\t messages: \(.messages)\t consumers: \(.consumers)"' \
    | column -t
}

# ---------------------------------------------------------------------------
# rmq-purge – Purge all messages from a queue
# Usage: rmq-purge <queue-name> [vhost]
# ---------------------------------------------------------------------------
function rmq-purge() {
  local queue="$1"
  local vhost="${2:-${RABBITMQ_VHOST}}"

  if [[ -z "$queue" ]]; then
    echo "Usage: rmq-purge <queue-name> [vhost]"
    return 1
  fi

  echo "🗑️  Purging queue '${queue}'..."
  local result
  result=$(_rmq_api DELETE "/api/queues/${vhost}/${queue}/contents")
  echo "✅ Done. Response: ${result:-<empty>}"
}

# ---------------------------------------------------------------------------
# rmq-publish – Publish a test message to a queue via the default exchange
# Usage: rmq-publish <queue-name> <message> [vhost]
# ---------------------------------------------------------------------------
function rmq-publish() {
  local queue="$1"
  local message="$2"
  local vhost="${3:-${RABBITMQ_VHOST}}"

  if [[ -z "$queue" || -z "$message" ]]; then
    echo "Usage: rmq-publish <queue-name> <message> [vhost]"
    return 1
  fi

  local payload
  payload=$(jq -n \
    --arg routing_key "$queue" \
    --arg payload "$message" \
    '{
      routing_key: $routing_key,
      payload: $payload,
      payload_encoding: "string",
      properties: {}
    }')

  echo "📤 Publishing to '${queue}'..."
  _rmq_api POST "/api/exchanges/${vhost}/amq.default/publish" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    | jq .
}

# ---------------------------------------------------------------------------
# rmq-status – Show cluster overview
# ---------------------------------------------------------------------------
function rmq-status() {
  echo "🐰 RabbitMQ cluster overview (${RABBITMQ_HOST}):"
  _rmq_api GET "/api/overview" \
    | jq '{
        rabbitmq_version: .rabbitmq_version,
        erlang_version: .erlang_version,
        messages: .queue_totals.messages,
        consumers: .object_totals.consumers,
        queues: .object_totals.queues,
        exchanges: .object_totals.exchanges,
        connections: .object_totals.connections
      }'
}
