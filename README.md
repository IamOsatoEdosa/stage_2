# 📘 Blue/Green Deployment with Automatic Failover

## Overview
This project demonstrates a **Blue/Green deployment** pattern using Docker Compose and Nginx as a reverse proxy.

Key features:
- Two identical application containers (`app_blue` and `app_green`) running the provided image.
- Nginx reverse proxy configured for **automatic failover**: if the active pool fails, requests are retried against the backup.
- **Manual toggle** supported via `.env` → `ACTIVE_POOL` variable.
- Chaos testing supported via `/chaos/start` endpoint to simulate failures.

---

## 🗂️ Repository Contents

.
├── docker-compose.yml
├── .env
├── render-nginx.sh
├── nginx/ 
    │   
    └── nginx.conf.template 
└── README.md


---

## ⚙️ Prerequisites
- Docker and Docker Compose installed  
- Linux, macOS, or WSL2 on Windows  

---

## 🚀 Usage

### 1. Clone the repo
```bash
git clone <my-repo-url>
cd bluegreen

### 2. Render nginx config 
chmod +x render-nginx.sh
./render-nginx.sh

### 3. Start the Stack 
docker compose up -d


### 4. Verify Baseline
curl -i http://localhost:8080/version

### 5. Trigger chaos
curl -X POST http://localhost:8081/chaos/start?mode=error

### 6. Verify failover
curl -i http://localhost:8080/version

