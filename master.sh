sudo apt-get update
sudo apt upgrade -y
echo "##Setup Docker"
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock
echo "##Setup K8-Cluster using kubeadm [K8 Version-->1.28.1]"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings
echo "##Install Required Dependencies for Kubernetes"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings
echo "##Add Kubernetes Repository and GPG Key"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo " Update Package List"
sudo apt update
echo "Install Kubernetes Components"
sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1
echo "Initialize Kubernetes Master Node"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
echo "Configure Kubernetes Cluster"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo " Deploy Networking Solution (Calico) "
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
echo "Deploy Ingress Controller (NGINX)"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml

