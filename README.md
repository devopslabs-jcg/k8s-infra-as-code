Multi-Cloud EKS & AKS 클러스터 인프라 (IaC)
1. 프로젝트 개요
이 프로젝트는 Terraform을 사용하여 AWS와 Azure에 프로덕션 수준의 Kubernetes 클러스터를 구축하기 위한 IaC(Infrastructure as Code) 리포지토리다.

확장성과 유지보수성을 높이기 위해 모듈화되고 환경별로 분리된 구조를 채택했다. 이 인프라에는 클라우드 벤더별로 안전한 격리 네트워크(VPC/VNet), 적절한 권한을 가진 IAM 역할, 관리형 Kubernetes 클러스터(EKS/AKS), 외부 트래픽을 위한 로드 밸런서, 스토리지, 웹 보안 기능이 포함된다.

또한, kubernetes-addons 디렉토리를 통해 클러스터 내에 컨테이너 네이티브 스토리지 솔루션인 Rook-Ceph를 배포하여 Stateful 애플리케이션을 위한 영구 볼륨을 제공한다.

2. 아키텍처 다이어그램
아래는 본 프로젝트가 구성하는 인프라의 개념적인 아키텍처다. (AWS 예시)

graph TD
    subgraph "인터넷"
        A[사용자]
    end

    subgraph "AWS Cloud"
        subgraph "VPC"
            subgraph "Public Subnets"
                C{Application <br> Load Balancer};
            end
            subgraph "Private Subnets"
                D[EKS 클러스터 <br> (Worker Nodes)];
                D -- Ingress --> E[애플리케이션 Pods];
                E <--> F[Rook-Ceph <br> (Persistent Storage)];
            end
        end
        B[Route 53] --> C;
        C -- WAF 검사 --> D;
    end

    A --> B;

3. 디렉토리 구조
.
├── kubernetes-addons/
│   └── rook-ceph/      # Rook-Ceph 클러스터 배포를 위한 매니페스트
└── terraform/
    ├── environments/
    │   ├── dev/        # 개발 환경 구성 (terraform apply 실행 위치)
    │   ├── stg/        # 스테이징 환경 구성
    │   └── prod/       # 운영 환경 구성
    └── modules/
        ├── aws/        # 재사용 가능한 AWS 인프라 모듈
        │   ├── alb/
        │   ├── eks/
        │   ├── iam/
        │   ├── s3/
        │   ├── security/
        │   └── vpc/
        └── azure/      # 재사용 가능한 Azure 인프라 모듈
            ├── aks/
            └── vnet/

terraform/modules/: 재사용 가능한 인프라 단위(VPC, EKS, VNet, AKS 등)를 정의한 "부품" 디렉토리.

terraform/environments/: 각 환경(dev, stg, prod)에서 모듈을 호출하여 실제 인프라를 "조립"하는 디렉토리. 각 환경은 독립된 상태 파일(.tfstate)을 가짐.

kubernetes-addons/: Terraform으로 프로비저닝된 클러스터 위에 설치될 추가 기능들의 Kubernetes 매니페스트를 관리.

4. 사전 준비 사항
Terraform v1.3 이상

AWS CLI v2 이상 (액세스 키 및 시크릿 키 설정 완료)

Azure CLI v2 이상 (az login 완료)

kubectl

helm (선택 사항, 애드온 관리 시 유용)

5. 배포 절차
주의: 모든 Terraform 명령어는 배포하려는 환경의 디렉토리 내에서 실행해야 한다. (예: terraform/environments/dev/)

리포지토리 클론

git clone <your-repository-url>
cd k8s-infra-as-code

개발 환경 디렉토리로 이동

cd terraform/environments/dev

terraform.tfvars 파일 생성 및 Git 설정
배포에 필요한 변수 값을 정의하기 위해 terraform.tfvars 파일을 생성한다.

# terraform.tfvars

# 클라우드 인프라 관련 변수
acm_certificate_arn = "arn:aws:acm:ap-northeast-2:123456789012:certificate/your-cert-id"

# Git Repository 자동 구성을 위한 변수
github_organization = "devopslabs-jcg"

보안 경고: github_token 관리

GitHub 토큰과 같은 민감 정보는 절대 코드에 직접 저장하면 안 된다. 아래 방법 중 하나를 사용하여 안전하게 토큰을 주입하는 것을 권장한다.

방법 1: 환경 변수 사용 (가장 추천)

Terraform 실행 전, 터미널에서 환경 변수를 설정한다.

export TF_VAR_github_token="ghp_YourGitHubTokenHere"
terraform plan

방법 2: 별도 파일 사용

secret.auto.tfvars와 같은 파일을 만들어 토큰을 저장하고, 이 파일명을 .gitignore에 추가하여 Git에 커밋되지 않도록 한다.

Terraform 초기화
필요한 프로바이더 플러그인을 다운로드한다.

terraform init

실행 계획 검토
어떤 리소스가 생성될지 미리 확인한다.

terraform plan

인프라 배포
yes를 입력하여 실제로 인프라를 생성한다.

terraform apply

kubectl 설정
배포 완료 후, 아래 명령어를 실행하여 로컬 kubectl이 클러스터를 제어할 수 있도록 설정한다.

# AWS EKS
aws eks update-kubeconfig --region ap-northeast-2 --name my-eks-cluster

# Azure AKS
az aks get-credentials --resource-group <resource-group-name> --name <aks-cluster-name>

Rook-Ceph 애드온 배포
프로젝트 루트 디렉토리로 이동 후, Rook-Ceph 관련 매니페스트를 적용한다.

cd ../../../kubernetes-addons/rook-ceph
kubectl apply -f crds.yaml -f common.yaml -f operator.yaml
kubectl apply -f cluster.yaml
kubectl apply -f storageclass.yaml

6. Terraform 모듈 상세
aws/vpc: Multi-AZ에 걸쳐 Public/Private Subnet, NAT Gateway, IGW 등을 포함하는 AWS 네트워크 환경을 구축.

aws/iam: EKS가 AWS 서비스와 통신하는 데 필요한 IAM 역할과 정책을 생성.

aws/eks: AWS 관리형 Kubernetes 서비스(EKS) 클러스터와 노드 그룹을 프로비저닝.

aws/alb: 외부 트래픽을 위한 Application Load Balancer를 생성.

aws/s3: 정적 에셋, 로그 등을 저장하기 위한 S3 버킷을 생성.

aws/security: ALB에 AWS WAF를 연결하여 웹 공격으로부터 애플리케이션을 보호.

azure/vnet: Azure의 가상 네트워크(VNet)와 서브넷을 구성.

azure/aks: Azure 관리형 Kubernetes 서비스(AKS) 클러스터를 프로비저닝.
