#! /usr/bin/bash 

COUNT=$(jq '.metadata.count ' newdata.json)
echo "Count of features is " + $COUNT
rm hour_data
touch hour_data

timestamp() {
  date +"%Y%m%d%H-%M-%S"
}

FEATURE=""
for (( I=0; I<$COUNT; I++ ))
do

	echo "Extracting details for feature " $I
	FEATURE+=$(jq '.features['${I}'].geometry.coordinates[1]' newdata.json) 
        FEATURE+="|"
		
	FEATURE+=$(jq '.features['${I}'].geometry.coordinates[0]' newdata.json)
	FEATURE+="|"

	FEATURE+=$(jq '.features['${I}'].properties.place' newdata.json) 
	FEATURE+="|"

	FEATURE+=$(jq '.features['${I}'].properties.mag' newdata.json)
	FEATURE+="\r\n"
done

echo -e $FEATURE >> hour_data
echo "Running cliapp on the latest hourly data"
FILENAME="dataset"_$(timestamp) 
echo $FILENAME "created"
echo $(cliapp -i hour_data) >> $FILENAME
echo $(cliapp -i hour_data --dataset-name latest)



# for each feature
# get the first longitude
# # then ge th elatitude
	# # then get hte place name
		# # get the magnitude

