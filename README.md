# vault on docker

## Run container

ex)

```
$ docker run -t -p 8200:8200 -i --rm lorentzca/vault_on_centos7
```

## Init

ex)

```
$ curl -s -X PUT -d '{ "secret_shares": 3, "secret_threshold": 3 }' http://192.168.99.100:8200/v1/sys/init | jq .
{
  "keys": [
    "207227df2acb87c35f81992793d0bcc8c74d9a3955d9cf981227148bfadf37b301",
    "aa732f49abad59277bb0fbab255fe91f43ead8dfcf868b91cc0f31b93f31aea402",
    "85aa2679b48cb226d8ca421ce5efab237a9a6fe5696a14f40e8a189104a97a1903"
  ],
  "root_token": "8a062d3a-a98b-1bbd-160f-ddd5fcc83599"
}
```

## Set environment variable

ex)

```
$ export VAULT_TOKEN=8a062d3a-a98b-1bbd-160f-ddd5fcc83599
```

## Unseal vault

ex)

```
$ curl -s -X PUT -d '{ "key": "85aa2679b48cb226d8ca421ce5efab237a9a6fe5696a14f40e8a189104a97a1903" }' http://192.168.99.100:8200/v1/sys/unseal | jq .
{
  "sealed": true,
  "t": 3,
  "n": 3,
  "progress": 1
}

$ curl -s -X PUT -d '{ "key": "207227df2acb87c35f81992793d0bcc8c74d9a3955d9cf981227148bfadf37b301" }' http://192.168.99.100:8200/v1/sys/unseal | jq .
{
  "sealed": true,
  "t": 3,
  "n": 3,
  "progress": 2
}

$ curl -s -X PUT -d '{ "key": "aa732f49abad59277bb0fbab255fe91f43ead8dfcf868b91cc0f31b93f31aea402" }' http://192.168.99.100:8200/v1/sys/unseal | jq .
{
  "sealed": false,
  "t": 3,
  "n": 3,
  "progress": 0
}
```

## Set key/value

ex)

check mounts

```
$ curl -s -X GET -H "X-Vault-Token:$VAULT_TOKEN" http://192.168.99.100:8200/v1/sys/mounts | jq .
{
  "cubbyhole/": {
    "config": {
      "default_lease_ttl": 0,
      "max_lease_ttl": 0
    },
    "description": "per-token private secret storage",
    "type": "cubbyhole"
  },
  "secret/": {
    "config": {
      "default_lease_ttl": 0,
      "max_lease_ttl": 0
    },
    "description": "generic secret storage",
    "type": "generic"
  },
  "sys/": {
    "config": {
      "default_lease_ttl": 0,
      "max_lease_ttl": 0
    },
    "description": "system endpoints used for control, policy and debugging",
    "type": "system"
  }
}
```

put variavle

```
$ curl -s -X POST -H "X-Vault-Token:$VAULT_TOKEN" -H "Content-Type: application/json" -d '{ "value": "test value" }' http://192.168.99.100:8200/v1/secret/test_key | jq .
```

get variable

```
$ curl -s -X GET -H "X-Vault-Token:$VAULT_TOKEN" http://192.168.99.100:8200/v1/secret/test_key | jq .
{
  "lease_id": "",
  "renewable": false,
  "lease_duration": 2592000,
  "data": {
    "value": "test value"
  },
  "warnings": null,
  "auth": null
}
```