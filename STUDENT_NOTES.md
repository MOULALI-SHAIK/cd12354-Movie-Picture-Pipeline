# Student Notes - Movie Picture Pipeline CI/CD

## Project Completion Summary

This document contains the deployment verification screenshots and workflow references for the Movie Picture Pipeline CI/CD project.

---

## 1. Frontend Continuous Integration (Frontend CI)

**Workflow File:** [.github/workflows/frontend-ci.yaml](.github/workflows/frontend-ci.yaml)

**Implementation:** 
- ✅ Parallel `lint` job - Runs ESLint checks
- ✅ Parallel `test` job - Runs React test suite
- ✅ `build` job with `needs: [lint, test]` - Docker image build after both pass

The workflow runs on:
- Pull requests to `main` branch when frontend code changes
- Manual trigger via `workflow_dispatch`

---

## 2. Frontend Continuous Deployment (Frontend CD)

**Workflow File:** [.github/workflows/frontend-cd.yaml](.github/workflows/frontend-cd.yaml)

**Implementation:**
- ✅ Parallel `lint` and `test` jobs (same as CI)
- ✅ `build` job with `needs: [lint, test]`
- ✅ `deploy` job with `needs: [build]` - Deploys to EKS using Kustomize
- ✅ Docker image tagged with git SHA

### Frontend Application Screenshot

**Frontend ELB URL:** `http://<FRONTEND_ELB_URL>`

Below is the Movie List displayed in the deployed React application:

```
[SCREENSHOT PLACEHOLDER]
Address Bar: http://a1b2c3d4-1234567.us-east-1.elb.amazonaws.com
Shows: Movie List with all three movies displayed
- Top Gun: Maverick - Fighter planes
- Sonic the Hedgehog - Blue Sega character
- A Quiet Place - Scary monsters
```

To capture this screenshot:
1. Navigate to your Frontend ELB URL (found in AWS Console under Load Balancers)
2. The Movie List page should display all movies fetched from the backend API
3. Screenshot should show the ELB address in the browser address bar

---

## 3. Backend Continuous Integration (Backend CI)

**Workflow File:** [.github/workflows/backend-ci.yaml](.github/workflows/backend-ci.yaml)

**Implementation:**
- ✅ Parallel `lint` job - Runs flake8 linting
- ✅ Parallel `test` job - Runs pytest
- ✅ `build` job with `needs: [lint, test]`

The workflow runs on:
- Pull requests to `main` branch when backend code changes
- Manual trigger via `workflow_dispatch`

---

## 4. Backend Continuous Deployment (Backend CD)

**Workflow File:** [.github/workflows/backend-cd.yaml](.github/workflows/backend-cd.yaml)

**Implementation:**
- ✅ Parallel `lint` and `test` jobs
- ✅ `build` job - Docker image creation and push to ECR
- ✅ `deploy` job - Kubernetes deployment via Kustomize

### AWS Secrets Configuration

Required secrets in GitHub Actions:
- `AWS_ACCESS_KEY_ID` - AWS access key for github-action-user
- `AWS_SECRET_ACCESS_KEY` - AWS secret access key
- `AWS_SESSION_TOKEN` - Session token (if using temporary credentials)
- `AWS_REGION` - AWS region (e.g., us-east-1)
- `EKS_CLUSTER_NAME` - EKS cluster name
- `REACT_APP_MOVIE_API_URL` - Frontend API endpoint

### Backend API Screenshot

**Backend ELB URL:** `http://<BACKEND_ELB_URL>:5000`

Below is the `/movies` JSON endpoint response from the deployed Flask API:

```
[SCREENSHOT PLACEHOLDER]
Address Bar: http://a9b8c7d6-9876543.us-east-1.elb.amazonaws.com:5000/movies
Shows: JSON response with movie data
{
  "movies": [
    {
      "id": "123",
      "title": "Top Gun: Maverick",
      "description": "Fighter planes"
    },
    {
      "id": "456",
      "title": "Sonic the Hedgehog",
      "description": "Blue Sega character"
    },
    {
      "id": "789",
      "title": "A Quiet Place",
      "description": "Scary monsters"
    }
  ]
}
```

To capture this screenshot:
1. Navigate to your Backend ELB URL with `/movies` endpoint (e.g., `http://your-backend-elb:5000/movies`)
2. The JSON response should display all three movies
3. Screenshot should show the ELB address in the browser address bar
4. Screenshot should show the complete JSON response

---

## Workflow Execution Links

### GitHub Actions Workflows

1. **Frontend CI:** Navigate to Actions tab → Select "Frontend Continuous Integration" workflow
2. **Frontend CD:** Navigate to Actions tab → Select "Frontend Continuous Deployment" workflow
3. **Backend CI:** Navigate to Actions tab → Select "Backend Continuous Integration" workflow
4. **Backend CD:** Navigate to Actions tab → Select "Backend Continuous Deployment" workflow

You can also access workflows directly:
- CI/CD Workflows: [Repository Actions Tab](../../actions)

---

## Deployment Verification Checklist

- [ ] Frontend CI workflow runs lint and test in parallel
- [ ] Frontend CI build job depends on both lint and test
- [ ] Frontend CD includes parallel lint and test jobs
- [ ] Frontend CD successfully deploys to EKS
- [ ] Frontend Movie List displays correctly with ELB URL
- [ ] Backend CI workflow runs lint and test in parallel
- [ ] Backend CD successfully deploys to EKS
- [ ] Backend `/movies` endpoint returns JSON with all movies
- [ ] Backend accessible via ELB URL
- [ ] All AWS secrets properly configured in GitHub

---

## Environment Setup

### Infrastructure Created with Terraform

Run the following to set up AWS infrastructure:

```bash
cd setup/terraform
terraform apply
```

### Add GitHub Action User to Kubernetes

```bash
cd setup
./init.sh
```

### Add AWS Secrets to GitHub

1. Generate AWS access keys for `github-action-user` IAM user
2. In GitHub repository settings, go to Secrets and variables → Actions
3. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_SESSION_TOKEN`
   - `AWS_REGION`
   - `EKS_CLUSTER_NAME`
   - `REACT_APP_MOVIE_API_URL` (format: `http://<backend-elb>:5000`)

---

## Notes

- All Docker images are tagged with the git SHA for traceability
- Kustomize is used for dynamic Kubernetes manifest configuration
- Both frontend and backend use the same CI/CD pattern: lint → test → build → deploy
- CORS is enabled on the backend to allow frontend requests
- Environment variable `REACT_APP_MOVIE_API_URL` is injected at frontend build time

---

**Last Updated:** 2026-08-30
