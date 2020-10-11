# Wait for Container

## Build and Publish Image

```bash
docker build -t bramalho/wait-for-container:latest .
docker push bramalho/wait-for-container:latest
```

## Using in your jobs/hooks

```yaml
apiVersion: batch/v1
kind: Job
# ...
spec:
  # ...
  template:
    # ...
    spec:
      containers:
      # ...
      initContainers:
      - name: wait-for-container
        image: docker.io/bramalho/wait-for-container:latest
        command: ["/entrypoint.sh"]
        args: ["wait_for", "mysql:DATABASE_URL"]
        envFrom:
        - secretRef:
            name: {{ include "app.fullname" . }}-dotenv
      # ...
```
