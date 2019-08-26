REPO_FOLDER=$1
REPO_ITEMS=$2

REPOPATH="/var/www/html/"
REPOFILE="${REPOPATH}/${REPO_FOLDER}/local.repo"

mkdir -p $REPOPATH
rm $REPOFILE 2> /dev/null
touch $REPOFILE
 
echo "${REPOPATH}${REPO_FOLDER}"

for i in $(echo $REPO_ITEMS | sed "s/,/ /g")
do
    reposync -n -l --repoid=$i --download_path=/var/www/html/general_mirror/ --downloadcomps --download-metadata
    wait

    createrepo -v /var/www/html/general_mirror/$i -g comps.xml
    wait
done

for DIR in `find ${REPOPATH}/general_mirror/ -maxdepth 1 -mindepth 1 -type d`; do
    REPO_ITEM=$(basename $DIR)
    if [[ "${REPO_ITEMS}" =~ "${REPO_ITEM}" ]]; then
       echo -e "[${REPO_ITEM}]" >> $REPOFILE
       echo -e "name=${REPO_ITEM}" >> $REPOFILE
       echo -e "baseurl=http://[your.ip.or.url.goes.here]/general_mirror/${REPO_ITEM}/" >> $REPOFILE
       echo -e "enabled=1" >> $REPOFILE
       echo -e "gpgcheck=0" >> $REPOFILE
       echo -e "\n" >> $REPOFILE
    fi
done;
