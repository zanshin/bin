echo checkout idm from head
rm -rf idm
cvs -Q co idm
echo copy snapshot properties file 
echo cp project.properties idm/project.properties
cp project.properties idm/project.properties

echo starting build at on veld
pwd

cd idm
echo
echo cd idm/commons/config
cd commons
cd core
#echo maven 2>&1
#maven 2>&1
echo cd ../config
cd ../config
echo maven 2>&1
maven 2>&1
echo cd ../process-scheduler
cd ../process-scheduler
echo maven 2>&1
maven 2>&1
echo cd ../lazi
cd ../lazi
echo maven 2>&1
maven 2>&1
echo cd ../request-framework
cd ../request-framework
echo maven 2>&1
maven 2>&1
echo cd ../sanity
cd ../sanity
echo maven 2>&1
maven 2>&1
#echo cd ../struts2
#cd ../struts2
#echo maven 2>&1
#maven 2>&1
echo cd ../../keas
cd ../../keas
echo maven 2>&1
maven 2>&1
echo cd ../ws-clients
cd ../ws-clients
echo maven 2>&1
maven 2>&1
echo cd ../webapps/portal-services
cd ../webapps
cd portal-services
echo maven 2>&1
maven 2>&1
echo cd ../keas-ws
cd ../keas-ws
echo maven 2>&1
maven 2>&1
echo cd ../keas-events
cd ../keas-events
echo maven 2>&1
maven 2>&1
echo cd ../ksuAlerts
cd ../ksuAlerts
echo maven 2>&1
maven 2>&1
echo cd ../eProfile
cd ../eProfile
echo maven 2>&1
maven 2>&1
echo cd ../KEAS-support
cd ../KEAS-support
echo maven 2>&1
maven 2>&1
echo cd ../deploy/services
cd ../deploy/services
echo maven 2>&1
maven 2>&1
echo cd ../../../
cd ../../../
pwd

