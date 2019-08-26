REPO_FOLDER=$1
REPO_ITEMS=$2

REPOPATH="/var/www/html/"
REPOFILE="${REPOPATH}/${REPO_FOLDER}/local.repo"

mkdir -p $REPOPATH
rm $REPOFILE 2> /dev/null
touch $REPOFILE
 
echo "${REPOPATH}${REPO_FOLDER}"

reposync -n -l --repoid=$REPO_ITEMS --download_path=/var/www/html/general_mirror/$REPO_ITEMS --downloadcomps --download-metadata
wait

createrepo -v /var/www/html/general_mirror/$REPO_ITEMS -g comps.xml

for DIR in `find ${REPOPATH}/general_mirror/ -maxdepth 1 -mindepth 1 -type d`; do
    REPO_ITEM=$(basename $DIR)
    if [[ "${REPO_ITEMS}" =~ "${REPO_ITEM}" ]]; then
       echo -e "[${REPO_ITEM}]" >> $REPOFILE
       echo -e "name=${REPO_ITEM}" >> $REPOFILE
       echo -e "baseurl=http://10.[state].10.19/general_mirror/${REPO_ITEM}/" >> $REPOFILE
       echo -e "enabled=1" >> $REPOFILE
       echo -e "gpgcheck=0" >> $REPOFILE
       echo -e "\n" >> $REPOFILE
    fi
done;
