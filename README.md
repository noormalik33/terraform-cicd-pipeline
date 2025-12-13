# Terraform CI/CD Pipeline - Phase 3: Advanced Automation

## 📌 Project Overview
This project demonstrates a production-ready **Infrastructure as Code (IaC)** pipeline using **Terraform**, **AWS**, and **GitHub Actions**. 

The goal of "Phase 3" was to transition from basic resource creation to a robust, automated system featuring remote state management, modular architecture, and self-provisioning web servers. The pipeline automatically provisions and configures an Nginx web server on AWS whenever code is pushed to the repository.

## 🚀 Key Features (Phase 3 Implemented)

### 1. Remote State Management (Task 7)
- **S3 Backend:** Terraform state (`terraform.tfstate`) is stored remotely in an AWS S3 bucket (`au-tf-state-noor-2025`) rather than locally.
- **State Locking:** Integrated **DynamoDB** table to prevent concurrent writes and state corruption during team collaboration.

### 2. Modular Architecture (Task 5)
- Created a reusable module (`modules/web_server`) to standardize EC2 instance creation.
- Decoupled configuration (variables) from implementation (resources).

### 3. Automated Provisioning (Task 9)
- Utilized EC2 **User Data** scripts to automatically update the OS, install **Nginx**, and deploy a custom HTML landing page upon boot.
- Eliminates the need for manual SSH configuration.

### 4. Dynamic Resource Lookup (Task 6)
- Implemented `data "aws_ami"` to dynamically fetch the latest Ubuntu 22.04 AMI ID from AWS.
- Ensures the server always launches with the most secure and up-to-date operating system.

### 5. Lifecycle Management (Task 10)
- Configured `create_before_destroy = true` to minimize downtime during instance replacements.
- Implemented logic to handle instance type migrations (e.g., `t2` to `t3`).

---

## 🛠️ Tech Stack
- **IaC:** Terraform v1.5+
- **Cloud Provider:** AWS (EC2, S3, DynamoDB, VPC)
- **CI/CD:** GitHub Actions (Automated `plan` and `apply`)
- **Scripting:** Bash (User Data for Nginx)

---

## 📂 Project Structure

```bash
.
├── .github/workflows/
│   └── deploy.yml          # CI/CD Pipeline Configuration
├── modules/
│   └── web_server/         # Reusable EC2 Module
│       ├── main.tf         # Resource definitions & User Data
│       ├── variables.tf    # Input variables
│       └── outputs.tf      # Output definitions (IP address)
├── 03-production/          # Production Environment (Root)
│   ├── main.tf             # Module implementation
│   ├── provider.tf         # AWS Provider & S3 Backend config
│   └── terraform.tfvars    # Environment-specific variables
└── README.md
````

-----

## ⚙️ How It Works (The Pipeline)

1.  **Commit:** Code changes are pushed to the `main` branch.
2.  **Trigger:** GitHub Actions detects the change and starts the workflow.
3.  **Terraform Init:** Connects to the S3 Backend and downloads providers.
4.  **Terraform Plan:** Checks for drift and calculates required changes.
5.  **Terraform Apply:**
      * Provisions `t3.micro` instance.
      * Attaches Security Group (SSH/HTTP).
      * Runs `user_data` script to install Nginx.
6.  **Verify:** The new Public IP is outputted in the build logs.

-----

## 🔧 Troubleshooting & Lessons Learned

During the development of Phase 3, several critical DevOps challenges were resolved:

  * **Issue:** `InvalidParameterCombination: The specified instance type is not eligible for Free Tier.`
      * **Resolution:** Migrated infrastructure code from `t2.micro` to **`t3.micro`** to align with newer AWS account restrictions.
  * **Issue:** `InvalidKeyPair.NotFound`
      * **Resolution:** Enforced strict region consistency (`us-east-1`) and validated exact key pair naming conventions in AWS.
  * **Issue:** IAM Permission Errors (`AccessDenied`)
      * **Resolution:** Refined IAM policies to grant the CI/CD user correct access to S3 buckets for state storage.

-----

## 📝 Usage

To deploy this infrastructure manually (optional):

1.  **Configure Credentials:**
    ```bash
    aws configure
    ```
2.  **Initialize:**
    ```bash
    cd 03-production
    terraform init
    ```
3.  **Apply:**
    ```bash
    terraform apply --auto-approve
    ```

-----

## Contributing 🤝
Contributions are welcome! Please fork the repository, make changes, and submit a pull request. Report bugs or suggest features via GitHub Issues. 🌟
Contact 📬
For questions, feedback, or collaboration, reach out to:

## License 📝
This project is licensed under the MIT License. See the LICENSE file for details.


## 👩‍💻 Author

**Noor Malik**  
IT Student  
📍 Islamabad, Pakistan  
📧 Email: noormalik56500@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/noormalik56500/)

Social 📱

📧 Email: mailto:coreittech1@gmail.com  
📹 YouTube: https://www.youtube.com/@CoreITTech1  
📸 Instagram: https://www.instagram.com/coreit.tech  
📘 Facebook: https://www.facebook.com/share/1AmgLDUnc9/  

**Lab:** DevOps Lab 08 - Air University

💡 If you like this project, don’t forget to star ⭐ it on GitHub!


Happy coding! 🚀 Let’s build amazing UIs together! 💪

```
```