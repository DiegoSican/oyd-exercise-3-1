# Exercise 3.1

## Health Endpoint

```bash
curl http://34.220.43.131:8080/health
```

Response:

```json
{ "compute": "ec2", "status": "ok" }
```

## Echo Endpoint

```bash
curl -X POST http://34.220.43.131:8080/echo \
-H 'Content-Type: application/json' \
-d '{"msg":"hello"}'
```

Response:

```json
{ "compute": "ec2", "msg": "hello" }
```

## Evidence

```text
------------------------------------------------------------------------
|                           DescribeInstances                          |
+------------------+-----------------------+----------+----------------+
|  ruby-server-dev |  i-04909669ddfdd8748  |  running |  34.220.43.131 |
+------------------+-----------------------+----------+----------------+
```
