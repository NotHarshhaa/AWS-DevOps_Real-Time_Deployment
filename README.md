# 🚀 AWS DevOps Real-Time Deployment | Dev → Pre-PROD → Production  

![AWS DevOps](https://img.shields.io/badge/AWS-DevOps-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-Pipeline-blue?style=for-the-badge&logo=github-actions&logoColor=white)
![Nginx](https://img.shields.io/badge/Web%20Server-Nginx-green?style=for-the-badge&logo=nginx&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

![AWS DevOps](https://imgur.com/YlMBIaa.png)  

## 📌 Overview  

This repository demonstrates a **real-time AWS DevOps deployment pipeline** designed to streamline application releases across three environments:  

- **Development (Dev)** – Continuous integration and testing  
- **Pre-Production (Pre-PROD)** – Staging for validation and QA  
- **Production** – Final deployment for end users  

By leveraging AWS services and modern DevOps tools, this setup ensures a seamless, automated, and scalable CI/CD workflow.  

---

## 🏗️ Features & Tech Stack  

### 🚀 **Core Technologies**
✅ **Infrastructure as Code (IaC)** – Terraform & AWS CloudFormation  
✅ **Version Control & Source Code Management** – GitHub/Azure DevOps  
✅ **CI/CD Pipeline** – AWS CodePipeline & Jenkins  
✅ **Containerization & Orchestration** – Docker & Kubernetes (EKS)  
✅ **Monitoring & Logging** – AWS CloudWatch & Prometheus  
✅ **Security & Compliance** – IAM, AWS Secrets Manager, and best DevSecOps practices  

### 📋 **Project Structure**
```
├── appspec.yml              # AWS CodeDeploy application specification
├── buildspec.yml            # AWS CodeBuild build specification
├── index.html               # Main application file
├── scripts/
│   ├── install_nginx.sh    # Nginx installation script
│   ├── start_nginx.sh       # Nginx startup script
│   ├── validate_environment.sh  # Environment validation
│   └── validate_deployment.sh   # Deployment validation
└── README.md               # Project documentation
```

### 🔧 **Scripts Overview**
- **`validate_environment.sh`** - Pre-deployment system validation
- **`install_nginx.sh`** - Automated Nginx installation and configuration
- **`start_nginx.sh`** - Nginx service management with retry logic
- **`validate_deployment.sh`** - Post-deployment verification

This project is designed to enhance agility, reduce manual interventions, and ensure reliable software delivery.  

---

## 🚀 Quick Start

### Prerequisites
- AWS Account with appropriate permissions
- AWS CLI configured
- Git installed
- Basic understanding of DevOps concepts

### Deployment Steps
1. **Clone the repository**
   ```bash
   git clone https://github.com/NotHarshhaa/AWS-DevOps_Real-Time_Deployment.git
   cd AWS-DevOps_Real-Time_Deployment
   ```

2. **Configure AWS CodeDeploy**
   - Set up CodeDeploy application
   - Configure deployment groups
   - Update `appspec.yml` if needed

3. **Deploy the application**
   - Trigger deployment through AWS Console
   - Monitor deployment logs
   - Verify application is running

### 🧪 **Testing**
The deployment includes comprehensive testing:
- Environment validation
- Service health checks
- HTTP response testing
- Content delivery verification

---

## 📖 Step-by-Step Guide  

For a complete walkthrough with **detailed screenshots**, visit the blog post:  
📌 [AWS DevOps Real-Time Deployment – Full Guide](https://blog.prodevopsguytech.com/aws-devops-real-time-deployment-dev-pre-prod-production)  

---

## 🔍 **Monitoring & Logging**

### Log Files
- `/var/log/nginx-install.log` - Nginx installation logs
- `/var/log/nginx-start.log` - Nginx startup logs
- `/var/log/environment-validation.log` - Environment validation logs

### Health Checks
- Service status monitoring
- HTTP response validation
- Content delivery verification
- System resource monitoring

---

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 🛠️ Author & Credits

![text](https://imgur.com/2j7GSPs.png)

This project is built and maintained by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.  
Feel free to contribute, suggest improvements, or reach out for discussions!  

### 📧 **Contact & Links**
- **GitHub**: [@NotHarshhaa](https://github.com/NotHarshhaa)
- **Blog**: [Hashnode](https://blog.prodevopsguy.xyz)
- **LinkedIn**: [Connect with me](https://linkedin.com/in/harshhaa)

### 🔖 **License**
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📊 **Project Stats**

![GitHub stars](https://img.shields.io/github/stars/NotHarshhaa/AWS-DevOps_Real-Time_Deployment?style=social)
![GitHub forks](https://img.shields.io/github/forks/NotHarshhaa/AWS-DevOps_Real-Time_Deployment?style=social)
![GitHub issues](https://img.shields.io/github/issues/NotHarshhaa/AWS-DevOps_Real-Time_Deployment)
![GitHub last commit](https://img.shields.io/github/last-commit/NotHarshhaa/AWS-DevOps_Real-Time_Deployment)

---

## 🙏 **Acknowledgments**

- AWS for providing excellent cloud services
- The DevOps community for continuous learning and support
- All contributors who help improve this project

---

<div align="center">
  <strong>⭐ Star this repository if you found it helpful! ⭐</strong>
</div>
