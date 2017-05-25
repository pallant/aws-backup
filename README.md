# Useful Backup Scripts

## Installation
Just clone the repo somewhere onto your EC2 instance.

If you want to use the db-backup script, you will need to create a `.conf` file as per `/example.conf`.

## Usage

### Backup Database
The `db-backup.sh` script requires one parameter (the config file) e.g.

```bash
. db-backup.sh example.conf
```

#### Cron
Most likely you'll want to schedule these backups using crons like so;

```
# Backup the database every 6 hours
0 */6 * * * /path/to/repo/db-backup.sh
```

### Backup EC2 Instance

You can backup the EC2 instance by running the ebs-backup.sh script e.g.

```bash
. ebs-backup.sh
```

#### Cron

```bash
# Take snapshots of the server every hour
0 * * * * sudo /path/to/repo/ebs-snapshot.sh
```



## Credits
Original ebs-backup script from https://github.com/CaseyLabs/aws-ec2-ebs-automatic-snapshot-bash