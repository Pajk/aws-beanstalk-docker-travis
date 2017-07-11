echo
echo == CREATE ECR REPOSITORY
echo

# Required vars: RDS_NAME, RDS_MASTER_PASSWORD

{
    aws rds describe-db-instances \
        --db-instance-identifier $RDS_NAME 2> /dev/null
} || {
    # http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
    aws rds create-db-instance \
        --db-instance-identifier $RDS_NAME \
        --db-name ${RDS_DB_NAME:-staging} \
        --db-instance-class ${RDS_INSTANCE_CLASS:-db.t2.micro} \
        --engine ${RDS_ENGINE:-postgres} \
        --engine-version ${RDS_ENGINE_VERSION:-9.6.2} \
        --allocated-storage ${RDS_STORAGE:-5} \
        --master-username ${RDS_MASTER_USERNAME:-root} \
        --master-user-password ${RDS_MASTER_PASSWORD} \
        --backup-retention-period ${RDS_BACKUP_RETENTION:-1} \
        --port ${RDS_PORT:-5432} \
        --storage-type ${RDS_STORAGE_TYPE:-gp2} \
        ${RDS_OPTIONS:---no-multi-az}
}

echo WAIT db-instance-available

aws rds wait db-instance-available --db-instance-identifier $RDS_NAME

export RDS_URL=$(aws rds describe-db-instances --db-instance-identifier $RDS_NAME | jq -r ".DBInstances[0].Endpoint.Address")
export RDS_PORT=$(aws rds describe-db-instances --db-instance-identifier $RDS_NAME | jq -r ".DBInstances[0].Endpoint.Port")
