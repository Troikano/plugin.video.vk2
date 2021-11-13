INSTANCE="travisci/ci-sardonyx:packer-1606895335-7957c7a9"
BUILDID="build-$RANDOM"
sudo docker run --name $BUILDID -dit $INSTANCE /sbin/init
sudo docker cp test_script_docker.sh $BUILDID:test_script_docker.sh
sudo docker exec -it $BUILDID bash -l -c "bash -v test_script_docker.sh"

#In docker
su - travis
curl -sSf --retry 5 -o python-3.8.tar.bz2 https://storage.googleapis.com/travis-ci-language-archives/python/binaries/ubuntu/16.04/x86_64/python-3.8.tar.bz2
sudo tar xjf python-3.8.tar.bz2 --directory /
git clone --depth=50 --branch=develop https://github.com/Troikano/plugin.video.vk.git Troikano/plugin.video.vk
cd Troikano/plugin.video.vk
git checkout -qf 1ed9382796dc83057d0bf28d52fc2eafbe509d73
read -p "VK USER LOGIN:" LOGIN
read -p "VK USER PASSWORD:" PSWD
export VKUSER_LOGIN=$LOGIN
export VKUSER_PSWD=$PSWD
export TRAVIS_TAG=2.0.0-dev
export PWD=$(pwd)
export TESTPATH=$PWD/resources/lib/tests
export PROFILEPATH=$PWD/tmp/addon_data
export DISTPATH=$PWD/tmp/dist
export PYTHONPATH=$PYTHONPATH:$PWD:$PWD/resouces/lib:$PWD/resources/lib/tinydb:$PWD/resources/lib/vk:$TESTPATH:$PROFILEPATH
source ~/virtualenv/python3.8/bin/activate
pip install -r requirements.txt
mkdir -p $PROFILEPATH
cd $TESTPATH
cd ..
pytest -v -rA
