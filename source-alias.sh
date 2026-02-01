grep -qxF "alias rebash='source ~/.bashrc'" ~/.bashrc || \
echo "alias rebash='source ~/.bashrc'" >> ~/.bashrc
source ~/.bashrc
