pipeline {
  agent any

  environment {
    AWS_REGION     = 'us-east-1'
    AWS_ACCOUNT_ID = '115197149859'
    ECR_REPO       = 'devops-ecr'

    FRONTEND_TAG   = "frontend-${BUILD_NUMBER}"
    BACKEND_TAG    = "backend-${BUILD_NUMBER}"

    FRONTEND_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${FRONTEND_TAG}"
    BACKEND_IMAGE  = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BACKEND_TAG}"
  }

  stages {
    stage('Checkout from GitHub') {
      steps {
        script {
          checkout scmGit(
            branches: [[name: '*/main']], 
            extensions: [], 
            userRemoteConfigs: [[
              credentialsId: 'GITHUB_CREDENTIALS', 
              url: 'https://github.com/CircleQMinh/sd5038_aws_infastructure'
            ]]
          )
        }
      }
    }

    stage('Login to Amazon ECR') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'aws-ecr-creds', 
          usernameVariable: 'AWS_ACCESS_KEY_ID', 
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          sh '''
            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
            aws ecr get-login-password --region $AWS_REGION | \
            docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
          '''
        }
      }
    }

    stage('Build Docker Images') {
      steps {
        sh '''
          docker build -t $FRONTEND_IMAGE ./src/frontend
          docker build -t $BACKEND_IMAGE ./src/backend
        '''
      }
    }

    stage('Push Docker Images to ECR') {
      steps {
        sh '''
          docker push $FRONTEND_IMAGE
          docker push $BACKEND_IMAGE
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        script {
          // Update kubeconfig to access your EKS cluster
          sh 'aws eks update-kubeconfig --name sample --region us-east-1'

          // Confirm access
          sh 'kubectl get ns'

          // Replace {{BUILD_NUMBER}} in manifests and apply
          sh """
            sed 's/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g' manifests/backend.yaml > manifests/backend-gen.yaml
            sed 's/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g' manifests/frontend.yaml > manifests/frontend-gen.yaml
            kubectl apply -f manifests/mongo.yaml
            kubectl apply -f manifests/backend-gen.yaml
            kubectl apply -f manifests/frontend-gen.yaml
          """
        }
      }
    }
  }
}
