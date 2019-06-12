# Site UUID from Dashboard URL, eg 12345678-1234-1234-abcd-0123456789ab

read -p "Enter the site-slug: " SITE_SLUG
SITE_UUID=$(terminus site:lookup $SITE_SLUG)
`mkdir $SITE_SLUG`
read -p "Enter the environment: " ENV
for app_server in `dig +short appserver.$ENV.$SITE_UUID.drush.in`;
do
  rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV.$SITE_UUID@appserver.$ENV.$SITE_UUID.drush.in:logs/* $SITE_SLUG/app_server_$app_server
done

# Include MySQL logs
db_server=`dig dbserver.$ENV.$SITE_UUID.drush.in +short`
rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV.$SITE_UUID@dbserver.$ENV.$SITE_UUID.drush.in:logs db_server_$db_server
