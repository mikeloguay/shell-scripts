# =============================================================================
# rabbitmq-utils.plugin.ps1 – RabbitMQ management helpers for PowerShell
#
# Requires: PowerShell 7+ (uses Invoke-RestMethod with basic auth)
# Default target: http://localhost:15672 (RabbitMQ Management UI default)
#
# Override defaults via environment variables or by setting them in $PROFILE:
#   $env:RABBITMQ_HOST  = 'http://my-rabbit:15672'
#   $env:RABBITMQ_USER  = 'admin'
#   $env:RABBITMQ_PASS  = 'secret'
#   $env:RABBITMQ_VHOST = '%2F'   # URL-encoded "/" (default vhost)
# =============================================================================

# ---------------------------------------------------------------------------
# Defaults – use env vars when set, fall back to RabbitMQ dev defaults
# ---------------------------------------------------------------------------
function script:Get-RmqConfig {
    [CmdletBinding()]
    param()
    return @{
        Host  = if ($env:RABBITMQ_HOST)  { $env:RABBITMQ_HOST }  else { 'http://localhost:15672' }
        User  = if ($env:RABBITMQ_USER)  { $env:RABBITMQ_USER }  else { 'guest' }
        Pass  = if ($env:RABBITMQ_PASS)  { $env:RABBITMQ_PASS }  else { 'guest' }
        Vhost = if ($env:RABBITMQ_VHOST) { $env:RABBITMQ_VHOST } else { '%2F' }
    }
}

# ---------------------------------------------------------------------------
# Invoke-RmqApi – Internal helper: calls the RabbitMQ HTTP Management API
# ---------------------------------------------------------------------------
function script:Invoke-RmqApi {
    param(
        [string]$Method,
        [string]$Path,
        [object]$Body = $null
    )

    $cfg  = Get-RmqConfig
    $cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($cfg.User):$($cfg.Pass)"))
    $uri  = "$($cfg.Host)$Path"

    $params = @{
        Uri     = $uri
        Method  = $Method
        Headers = @{ Authorization = "Basic $cred" }
    }

    if ($Body) {
        $params['Body']        = ($Body | ConvertTo-Json -Depth 10)
        $params['ContentType'] = 'application/json'
    }

    try {
        Invoke-RestMethod @params
    }
    catch {
        Write-Error "RabbitMQ API error: $_"
    }
}

# ---------------------------------------------------------------------------
# Get-RmqQueues (rmq-queues) – List all queues with message counts
# ---------------------------------------------------------------------------
function Get-RmqQueues {
    $cfg = Get-RmqConfig
    Write-Host "📋 Queues on $($cfg.Host):" -ForegroundColor Cyan

    $queues = Invoke-RmqApi -Method GET -Path '/api/queues'

    $queues | Select-Object name,
        @{N='messages';  E={$_.messages}},
        @{N='consumers'; E={$_.consumers}},
        @{N='state';     E={$_.state}} |
        Format-Table -AutoSize
}
Set-Alias -Name rmq-queues -Value Get-RmqQueues -Scope Global -Option AllScope -Force

# ---------------------------------------------------------------------------
# Clear-RmqQueue (rmq-purge) – Purge all messages from a queue
# Usage: rmq-purge <queue-name> [-Vhost '%2F']
# ---------------------------------------------------------------------------
function Clear-RmqQueue {
    param(
        [Parameter(Mandatory)]
        [string]$QueueName,

        [string]$Vhost = $null
    )

    $cfg   = Get-RmqConfig
    $vhost = if ($Vhost) { $Vhost } else { $cfg.Vhost }

    Write-Host "🗑️  Purging queue '$QueueName'..." -ForegroundColor Yellow
    Invoke-RmqApi -Method DELETE -Path "/api/queues/$vhost/$QueueName/contents" | Out-Null
    Write-Host "✅ Done." -ForegroundColor Green
}
Set-Alias -Name rmq-purge -Value Clear-RmqQueue -Scope Global -Option AllScope -Force

# ---------------------------------------------------------------------------
# Send-RmqMessage (rmq-publish) – Publish a test message via the default exchange
# Usage: rmq-publish -QueueName myqueue -Message 'hello'
# ---------------------------------------------------------------------------
function Send-RmqMessage {
    param(
        [Parameter(Mandatory)]
        [string]$QueueName,

        [Parameter(Mandatory)]
        [string]$Message,

        [string]$Vhost = $null
    )

    $cfg   = Get-RmqConfig
    $vhost = if ($Vhost) { $Vhost } else { $cfg.Vhost }

    $body = @{
        routing_key      = $QueueName
        payload          = $Message
        payload_encoding = 'string'
        properties       = @{}
    }

    Write-Host "📤 Publishing to '$QueueName'..." -ForegroundColor Yellow
    $result = Invoke-RmqApi -Method POST -Path "/api/exchanges/$vhost/amq.default/publish" -Body $body
    Write-Host "✅ Result: $($result | ConvertTo-Json -Compress)" -ForegroundColor Green
}
Set-Alias -Name rmq-publish -Value Send-RmqMessage -Scope Global -Option AllScope -Force

# ---------------------------------------------------------------------------
# Get-RmqStatus (rmq-status) – Show cluster overview
# ---------------------------------------------------------------------------
function Get-RmqStatus {
    $cfg = Get-RmqConfig
    Write-Host "🐰 RabbitMQ cluster overview ($($cfg.Host)):" -ForegroundColor Cyan

    $overview = Invoke-RmqApi -Method GET -Path '/api/overview'

    [PSCustomObject]@{
        rabbitmq_version = $overview.rabbitmq_version
        erlang_version   = $overview.erlang_version
        messages         = $overview.queue_totals.messages
        consumers        = $overview.object_totals.consumers
        queues           = $overview.object_totals.queues
        exchanges        = $overview.object_totals.exchanges
        connections      = $overview.object_totals.connections
    } | Format-List
}
Set-Alias -Name rmq-status -Value Get-RmqStatus -Scope Global -Option AllScope -Force
