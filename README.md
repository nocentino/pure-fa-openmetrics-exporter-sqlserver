
## Docker Compose Implementation

This Docker Compose manifest starts up three Services, prometheus, grafana and the pure-fa-openmetrics exporter. Each Service has a basic configuration to help you get off the ground as fast as possible with this monitoring stack. 

1. Edit `./prometheus/prometheus.yml` for the scrape configuration for your enviroment. A basic implementation is provided for a single Array, its Hosts and Volumes. You will need to update `authorization.credential` and `params.endpoint` in each scrape config.
1. Edit `./telegraf/telegraf.conf` adding in the connection strings to your SQL Server instances.
    ```
    servers = [
        "Server=aen-sql-01;Port=1433;User Id=telegraf;Password=S0methingS@Str0ng!;app name=Telegraf;",
        "Server=aen-sql-02;Port=1433;User Id=telegraf;Password=S0methingS@Str0ng!;app name=Telegraf;",
        "Server=aen-sql-03;Port=1433;User Id=telegraf;Password=S0methingS@Str0ng!;app name=Telegraf;",
        "Server=aen-sql-04;Port=1433;User Id=telegraf;Password=S0methingS@Str0ng!;app name=Telegraf;",
        "Server=aen-sql-dr-01;Port=1433;User Id=telegraf;Password=S0methingS@Str0ng!;app name=Telegraf;",
    ]
    ```
1. Change your working directory to the same as the `docker-compose.yaml` file
1. Then use `docker compose up --detach` to launch the monitoring stack. 
1. Open a browser to [http://localhost:3000](http://localhost:3000). The username is `admin` and the password is `admin!`.