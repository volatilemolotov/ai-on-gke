## Before you begin
Ensure that you can do it

## Set up
Go to the `terraform` directory. Run the command below:
```bash
terraform init
terraform plan -var-file=var-file.tfvars
terraform apply -var-file=var-file.tfvars
```

## Tutorial

1. Let's create a bucket in Google Cloud Storage to store our documents. Replace `<BUCKET_NAME>` with any name. Run this command:
```
gcloud storage buckets create gs://<BUCKET_NAME> --location=us-central1
```

2. Give necessary permissions for you GKE cluster service account. Replace variables:
- `<BUCKET_NAME>` – your bucket name that you specified in the previous step.
- `<PROJECT_NUMBER>` – you can find it in Project Settings in the Google Console.
- `<PROJECT_ID>` – you can find it in Project Settings in the Google Console.
Run these commands:
```bash
export BUCKET_NAME=<BUCKET_NAME>
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME \
    --member "principal://iam.googleapis.com/projects/<PROJECT_NUMBER>/locations/global/workloadIdentityPools/<PROJECT_ID>.svc.id.goog/subject/ns/default/sa/default" \
    --role "roles/storage.objectAdmin"
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME \
    --member "principal://iam.googleapis.com/projects/<PROJECT_NUMBER>/locations/global/workloadIdentityPools/<PROJECT_ID>.svc.id.goog/subject/ns/default/sa/default" \
    --role "roles/storage.admin"
```

Go to the Google Cloud Storage and find your bucket. Give to your cluster's service account `Storage Admin` and `Storage Object Admin` permissions. You can find service account email by running this command:
```bash
gcloud container clusters describe $CLUSTER_NAME \
  --region $REGION \
  --format="value(nodeConfig.serviceAccount)"
```

3. Let's upload sample data to our cloud storage bucket. Inside your bucket create `datalake`, replace `<BUCKET_NAME>` with your GCS bucket name folder and run these commands below:
```
curl -s https://raw.githubusercontent.com/run-llama/llama_index/main/docs/docs/examples/data/paul_graham/paul_graham_essay.txt | \
gcloud storage cp - gs://<BUCKET_NAME>/datalake/paul_graham_essay.txt
```

4. Go to the `redis-stack` directory. Create redis-stack service for llamaindex:
```bash
kubectl apply -f redis-stack.yaml
```

5. Go to the `data-ingestion` directory. Let's build our deployment docker image so we can create a service in GKE cluster. First of all, give to you GKE cluster service account `Artifact Registry` reader permission. Then run the following command to build and submit Docker image:
```bash
gcloud builds submit .
```

Now we can run our data ingestion pipeline to prepare a Vectorstore Database for our RAG system. Run the following command:
```bash
kubectl apply -f ingest-data.yaml
```

6. Go to the `deploy-rag` directory. Run the following command to build and submit Docker image:
```bash
gcloud builds submit .
```

After data ingestion, we can deploy our RAG system as a service. Run the command below:
```bash
kubeclt apply -f deploy-rag-system.yaml
```

7. Create port-forwarding and go to the `http://127.0.0.1:8000/docs`. You will see a single API endpoint where you can invoke your RAG system.

## Clean up
```
terraform destroy -var-fiile=var-file.tfvars
gcloud storage buckets delete gs://<BUCKET_NAME>
```
