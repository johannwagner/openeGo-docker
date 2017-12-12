#!/usr/bin/env sh

set -e

echo 'START SETUP'

if [ -z "$(ls -A /oeplatform)" ] 
then	
   # Clone entire repository and set up.
   git clone git@github.com:openego/oeplatform.git -b develop /oeplatform

   cat /oeplatform/oeplatform/securitysettings.py.default \
	| sed -e "s/databaseuser/postgres/" \
	-e "s/databasepassword/$POSTGRES_PASSWORD/" \
	-e "s/'HOST': 'localhost'/'HOST': 'postgresql'/" \
	-e "s/'NAME': 'django'/'NAME': 'openego'/" \
	-e "s/dbuser = \"\"/dbuser = 'postgres'/" \
	-e "s/dbpasswd = \"\"/dbpasswd = '$POSTGRES_PASSWORD'/" \
	-e "s/dbhost = \"\"/dbhost = 'postgresql'/" \
	-e "s/dbname = \"\"/dbname = 'dataedit'/" \
	-e "s/127\.0\.0\.1/0\.0\.0\.0/" \
	> /oeplatform/oeplatform/securitysettings.py

	cat /oeplatform/oeplatform/securitysettings.py

	cd /oeplatform

	cat requirements.txt \
	 | sed -e "s/django\$/django==1.11/" \
	> requirements_mod.txt

	echo >> requirements_mod.txt
	echo "shapely" >> requirements_mod.txt 
	echo "svn" >> requirements_mod.txt 



	cat requirements_mod.txt

	pip install --user -r requirements_mod.txt

	sed -i 's/""current_user"()"/"current_user()"/' src/package/egoio/db_tables/reference.py

	python manage.py migrate




fi

echo 'FINISHED SETUP'
echo 'START SERVER'

cd /oeplatform


python manage.py runserver 0.0.0.0:8000
echo 'STARTED SERVER'
