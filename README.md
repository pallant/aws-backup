# Useful Backup Scripts

## Installation
Clone this repo somewhere onto your EC2 instance. You may need to chmod the scripts so that they are executable;

```bash
chmod +x aws-backup/*.sh
```

If you want to use the db-backup script, you will need to create a `.conf` file as per `/example.conf`.

## Usage

### Backup Database

Given the correct credentials, this script should back up all tables on the database and store them in s3.

The `db-backup.sh` script requires one parameter (the config file) e.g.

```bash
. db-backup.sh example.conf
```

Backups are kept on the server for as long as the 'lifespan' config variable.

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
