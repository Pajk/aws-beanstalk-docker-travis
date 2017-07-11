echo
echo == CREATE ELASTICACHE
echo

{
    aws elasticache describe-cache-clusters \
        --cache-cluster-id $ELASTICACHE_NAME \
        --profile $AWS_PROFILE
} || {
    aws elasticache create-cache-cluster \
        --cache-cluster-id $ELASTICACHE_NAME \
        --cache-node-type $ELASTICACHE_NODE_TYPE \
        --engine ${ELASTICACHE_ENGINE-redis} \
        --engine-version ${ELASTICACHE_VERSION-3.2.4} \
        --profile $AWS_PROFILE \
        --num-cache-nodes $ELASTICACHE_NUM_NODES
}

echo WAIT cache-cluster-available

aws elasticache wait cache-cluster-available --cache-cluster-id $ELASTICACHE_NAME

export ELASTICACHE_ENDPOINT=$(aws elasticache describe-cache-clusters --show-cache-node-info --cache-cluster-id $ELASTICACHE_NAME --profile $AWS_PROFILE | jq -r ".CacheClusters[0].CacheNodes[0].Endpoint.Address")
export ELASTICACHE_PORT=$(aws elasticache describe-cache-clusters --show-cache-node-info --cache-cluster-id $ELASTICACHE_NAME --profile $AWS_PROFILE | jq -r ".CacheClusters[0].CacheNodes[0].Endpoint.Port")

ECHO ElastiCache Endpoint: $ELASTICACHE_ENDPOINT:$ELASTICACHE_PORT
