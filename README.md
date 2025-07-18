# Pure FlashArray and SQL Server Monitoring Stack

This repository contains a complete monitoring solution for SQL Server workloads running on Pure Storage FlashArray. The stack provides integrated metrics collection and visualization to help you correlate database performance with storage performance.

## Overview

This monitoring solution combines:
- SQL Server metrics collection via Telegraf
- Pure Storage FlashArray metrics via the Pure FA OpenMetrics Exporter
- Prometheus for metrics storage
- Grafana for visualization with pre-built dashboards

The integrated dashboard allows you to see the complete picture of your SQL Server performance and how it relates to your Pure Storage FlashArray metrics.

## Repository Structure

```
pure-fa-openmetrics-exporter-sqlserver/
├── docker-compose.yaml        # Docker Compose configuration
├── prometheus/                # Prometheus configuration
│   └── prometheus.yml         # Main Prometheus config file
├── telegraf/                  # Telegraf configuration
│   └── telegraf.conf          # SQL Server monitoring config
├── grafana/                   # Grafana configuration
│   ├── datasources/           # Grafana datasource definitions
│   └── dashboards/            # Grafana dashboard definitions
│       ├── default.yaml       # Dashboard provisioning config
│       └── json/              # JSON dashboard definitions
└── README.md                  # This file
```

## Components

- **Pure FA OpenMetrics Exporter**: Collects metrics from Pure Storage FlashArray
- **Pure FB OpenMetrics Exporter**: Collects metrics from Pure Storage FlashBlade
- **Telegraf**: Collects SQL Server metrics using the SQL Server input plugin
- **Prometheus**: Time-series database that stores all the collected metrics
- **Grafana**: Visualization platform with pre-configured dashboards

## Prerequisites

- Docker and Docker Compose
- Access to a Pure Storage FlashArray with API credentials
- SQL Server instance(s) (SQL Server 2016 or newer recommended)
- A user with appropriate permissions for SQL Server monitoring

## Volume to SQL Server Instance Correlation

The dashboards automatically correlate FlashArray volumes with SQL Server instances through pattern matching. This works by:
- Looking for SQL Server instance names within the volume names on the FlashArray
- Matching metrics from both systems when a pattern match is found

For data correlation between FlashArray volumes and SQL Server instances, incorporate the SQL Server instance name within your volume naming convention (e.g., "vol-SQLSERVER01-data" for a SQL Server instance named "SQLSERVER01"). You can identify your specific instance name by executing a query with the [@@SERVERNAME](https://learn.microsoft.com/en-us/sql/t-sql/functions/servername-transact-sql?view=sql-server-ver17) variable in SQL Server Management Studio. This consistent naming strategy allows the dashboard to automatically establish connections between storage performance metrics and their corresponding SQL Server instances, providing comprehensive end-to-end visibility of your database workloads.

## Getting Started

### 1. Clone this repository:

```bash
git clone https://github.com/nocentino/pure-fa-openmetrics-exporter-sqlserver.git
cd pure-fa-openmetrics-exporter-sqlserver
```

### 2. Configure Pure Storage FlashArray access:

1. Create an API token for your FlashArray:
   - Log into your FlashArray management interface
   - Navigate to Settings > Users and Policies
   - Create or Select a user with read only privileges for monitoring.
   - Generate an API token for this user
   - Copy the API token for configuration

3. Add your FlashArray information to the config file. Examples provided in: [prometheus/prometheus.yml](prometheus/prometheus.yml)

### 3. Configure SQL Server monitoring:

1. Edit the Telegraf configuration file: [telegraf/telegraf.conf](telegraf/telegraf.conf)
 
2. Update the SQL Server connection details:
   ```
   [[inputs.sqlserver]]
     servers = [
        "Server=aen-sql-25-a.fsa.lab;Port=1433;User Id=telegraf;Password=S0methingS@Str0ng!;app name=Telegraf;",
        "Server=aen-sql-25-b.fsa.lab;Port=1433;User Id=telegraf;Password=S0methingS@Str0ng!;app name=Telegraf;"
       # Add additional servers as needed
     ]
   ```

3. Ensure the SQL Server user has appropriate permissions:
   - The user needs `VIEW SERVER STATE` and `VIEW ANY DEFINITION` permissions
   - For optimal monitoring, consider using a user with sysadmin role

### 4. Start the monitoring stack:

```bash
docker compose up -d
```

### 5. Access Grafana:

- Open your browser and navigate to `http://localhost:3000`
- Login with username `admin` and password `admin!` (change this in production)
- Navigate to the **"SQL Server and FlashArray"** dashboard in the **Dashboards** menu.

## Dashboard Features

The pre-configured dashboard includes:
- SQL Server CPU usage metrics
- Memory performance and page life expectancy
- SQL Server wait statistics
- Database read and write metrics per database
- Database read and write latency
- FlashArray read and write latency in microseconds
- FlashArray volume throughput metrics
- FlashArray I/O size analysis

## Customization

You can customize this solution by:
- Adding more SQL Server instances to monitor
- Creating additional dashboards for specific use cases
- Extending the telegraf configuration to collect more metrics

## Troubleshooting

### Common Issues

1. **Cannot connect to FlashArray**:
   - Verify API token is valid and has not expired
   - Check network connectivity from Docker host to FlashArray
   - Ensure the FlashArray address is correct in the configuration

2. **SQL Server metrics not showing**:
   - Verify SQL Server credentials in [telegraf/telegraf.conf](telegraf/telegraf.conf)
   - Check that SQL Server is accessible from Docker host
   - Ensure the SQL user has appropriate permissions

3. **Missing metrics in dashboard**:
   - Check Prometheus targets at http://localhost:9090/targets
   - Examine the logs: `docker compose logs telegraf`

### Getting Support

For more detailed troubleshooting information, check the logs for the specific component:

```bash
docker compose logs pure-fa-om-exporter
docker compose logs telegraf
docker compose logs prometheus
```

## License

[Include appropriate license information]

## Support

For questions or issues, please open an issue in this repository.