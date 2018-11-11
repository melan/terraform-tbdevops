resource "datadog_timeboard" "host_status" {
  description = "A dashboards about status of a host"
  read_only   = true

  "graph" {
    "request" {
      q          = "avg:system.uptime{$host}"
      aggregator = "last"
    }

    title     = "Uptime"
    viz       = "query_value"
    autoscale = true
  }

  graph {
    "request" {
      q          = "avg:system.cpu.user{$host}"
      aggregator = "avg"
    }

    title = "CPU Usage, User"
    viz   = "timeseries"
  }

  graph {
    "request" {
      q          = "avg:system.cpu.user{$host}"
      aggregator = "avg"
    }

    title = "CPU Usage, System"
    viz   = "timeseries"
  }

  graph {
    "request" {
      q          = "avg:system.disk.free{$host} by {host,device}/avg:system.disk.total{$host} by {host,device}"
      aggregator = "avg"
    }

    title     = "Disk free space, %"
    viz       = "distribution"
    autoscale = true
  }

  template_variable {
    name    = "host"
    prefix  = "host"
    default = "*"
  }

  title = "Host status"
}
