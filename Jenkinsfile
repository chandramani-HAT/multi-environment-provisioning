pipeline {
  agent any

  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'stage', 'prod'], description: 'Select Terraform environment')
  }

  environment {
    PEM_FILE = credentials('terraform_ansible.pem')  
  }

  stages {
    stage('Checkout') {
      steps {
        git(
          branch: 'main',
          credentialsId: 'github-repo',
          url: 'https://github.com/chandramani-HAT/multi-environment-provisioning.git'
        )
      }
    }

    stage('Terraform Init & Validate') {
      steps {
        dir("terraform/environments/${params.ENVIRONMENT}") {
          sh 'terraform init'
          sh 'terraform validate'
          sh 'terraform plan -out=tfplan'
        }
      }
    }

stage('Notify Teams for Approval') {
  when {
    expression { params.ENVIRONMENT == 'prod' }
  }
  steps {
    script {
      def teamsWebhookUrl = credentials('teams-webhook-url')

      def message = [
        '@type': 'MessageCard',
        '@context': 'http://schema.org/extensions',
        'summary': 'Deployment Approval Required',
        'themeColor': '0076D7',
        'title': "Approval Needed for PROD Deployment",
        'text': "Please review and approve the Jenkins pipeline: ${env.BUILD_URL}"
      ]

      def payload = groovy.json.JsonOutput.toJson(message)

      // Write JSON payload to a file
      writeFile file: 'teams_payload.json', text: payload

      // Send the payload file with curl
      sh """
        curl -H 'Content-Type: application/json' --data @teams_payload.json ${teamsWebhookUrl}
      """
    }
  }
}


    stage('Approval for Production') {
      when {
        expression { params.ENVIRONMENT == 'prod' }
      }
      steps {
        script {
          // Pause pipeline and wait for manual approval
          def approved = input(
            id: 'ApproveDeployment',
            message: 'Approve deployment to PROD?',
            parameters: [
              booleanParam(defaultValue: false, description: 'Check to approve', name: 'Approve')
            ]
          )
          if (!approved) {
            error("Deployment to PROD not approved. Aborting pipeline.")
          }
        }
      }
    }



    stage('Terraform Apply') {
      steps {
        dir("terraform/environments/${params.ENVIRONMENT}") {
          sh 'terraform apply -auto-approve tfplan'
        }
      }
    }

    stage('Fetch EC2 Public IPs') {
      steps {
        script {
          dir("terraform/environments/${params.ENVIRONMENT}") {
            def ipsJson = sh(script: "terraform output -json ec2_instance_public_ips", returnStdout: true).trim()
            env.EC2_IPS_JSON = ipsJson
          }
          echo "EC2 Public IPs JSON: ${env.EC2_IPS_JSON}"
        }
      }
    }

stage('Generate Ansible Inventory') {
  steps {
    dir('ansible') {
      script {
        // Parse the JSON string containing EC2 public IPs
        def ips = readJSON text: env.EC2_IPS_JSON

        // Initialize inventory content with YAML structure
        def inventoryContent = """all:
  hosts:
"""

        // Add each EC2 instance as a host with connection details
        ips.eachWithIndex { ip, idx ->
          def hostname = "ec2-${idx + 1}"
          inventoryContent += """    ${hostname}:
      ansible_host: ${ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ${env.PEM_FILE}
"""
        }

        // Add a group 'ec2_instances' containing all hosts
        inventoryContent += """  children:
    ec2_instances:
      hosts:
"""
        ips.eachWithIndex { ip, idx ->
          def hostname = "ec2-${idx + 1}"
          inventoryContent += "        ${hostname}: {}\n"
        }

        // Write the inventory content to a YAML file
        writeFile file: 'inventory.yaml', text: inventoryContent

        // Echo the generated inventory for debugging
        echo "Generated ansible/inventory.yaml:\n${inventoryContent}"
      }
    }
  }
}

stage('Establish Passwordless SSH') {
  steps {
    dir('ansible') {
      script {
        // Parse the JSON string into a list
        def ips = readJSON text: env.EC2_IPS_JSON

        def pemPublicKeyFile = "${env.PEM_FILE}.pub"

        sh """
          mkdir -p ~/.ssh
          if [ ! -f '${pemPublicKeyFile}' ]; then
            ssh-keygen -y -f '${env.PEM_FILE}' > '${pemPublicKeyFile}'
          fi
        """

        ips.each { ip ->
          sh """
            for i in {1..30}; do
              if ssh -o StrictHostKeyChecking=no -i '${env.PEM_FILE}' -o ConnectTimeout=5 ubuntu@${ip} 'echo SSH is up' 2>/dev/null; then
                echo "SSH is ready on ${ip}"
                break
              fi
              echo "Waiting for SSH on ${ip}..."
              sleep 5
            done

            ssh-keygen -R ${ip} || true
            ssh-copy-id -i '${pemPublicKeyFile}' -o StrictHostKeyChecking=no ubuntu@${ip}
          """
        }
      }
    }
  }
}


    stage('Run Ansible Playbook') {
      steps {
        dir('ansible') {
          sh 'ansible-playbook -i inventory.yaml playbook.yaml'
        }
      }
    }
  }
}
