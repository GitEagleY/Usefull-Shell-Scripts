#!/bin/bash

read -p "Name of script to create->" SCRIPT_NAME

touch ${SCRIPT_NAME}

echo "#!/bin/bash" >> ${SCRIPT_NAME}
echo "#AUTO CREATED SCRIPT" >> ${SCRIPT_NAME}

chmod +x ${SCRIPT_NAME}

echo "SCRIPT ${SCRIPT_NAME} CREATED!"
