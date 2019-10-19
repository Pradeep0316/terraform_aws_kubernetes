cat <<EOF | kubectl apply -f -
{
  "apiVersion": "v1",
  "kind": "Namespace",
  "metadata": {
    "name": "development",
    "labels": {
      "name": "development"
    }
  }
}
EOF
echo "done-ns"
date
sleep 2

sudo mkdir /mnt/data

sudo sh -c "echo 'Hello from Kubernetes storage' > /mnt/data/index.html"

echo "done-mnt"
date
sleep 2

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
EOF

echo "done-pv"
date
sleep 5

cat <<EOF >> PVC.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

echo "done-pvc"
date
sleep 5

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-config
  namespace: development
data:
  game.properties: |
    enemies=aliens
    lives=3
    enemies.cheat=true
    enemies.cheat.level=noGoodRotten
    secret.code.passphrase=UUDDLRLRBABAS
    secret.code.allowed=true
    secret.code.lives=30
EOF

echo "done-cm"
date
sleep 5

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: development
  name: nginx-deployment
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
       maxUnavailable: 0
       maxSurge: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: 100m
            memory: 250Mi
          requests:
            cpu: 10m
            memory: 125Mi
        volumeMounts:
        - name: test-volume
          mountPath: /tmp/redis
        - name: task-pv-storage
          mountPath: "/usr/share/nginx/html"
      volumes:
      - name: test-volume
        configMap:
          name: game-config
      - name: task-pv-storage
        persistentVolumeClaim:
          claimName: task-pv-claim
EOF

echo "done-dc"
date
sleep 2

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: development
spec:
  type: NodePort
  ports:
    - port: 80
      nodePort: 30180
      name: http
    - port: 443
      nodePort: 31443
      name: https
  selector:
    app: nginx
EOF

echo "done-svc"
date

echo "All are completed!!. Please expose your service at http:<nodename>:30180"
