# To make this file executable, run the following at the command line (from the bin directory).
# Be sure to not include the leading # or it will be a comment and nothing will happen!

chmod u+x httpd-ctl.sh

# After doing so, in the bin directory run the following at the command prompt:

#    ./httpd-ctl.sh

echo "Hi you are in Leisa's httpd-ctl.sh script."

# defaulting port value (even though docker does it automatically)

P_VALUE=8080

usage() {
  # arguments in [] signals that is an optional argument.  This script has 2 optoinal arguments,
  # both have an associated value.
  echo "Usage: $0 [-d <directory>] [-p <string>] -h"
#  docker stop my-apache-app
#  echo "Container is stopped after help"
#  docker rm my-apache-app
#  echo "Container has been removed after help"
  exit 0
}

while getopts "hd:p:" opt; do
    case "${opt}" in
        d)
          # 	-d <directory> - (optional argument) uses the specified directory
          # 	as the directory containing the content for the web server to serve.
          # 	If the -d parameter isn't used then no volume mount should be used.
          # 	Test this by running bin/httpd-ctl.sh -d $PWD/www start
            DIR_VALUE="-v $(pwd)/${OPTARG}:/usr/local/apache2/htdocs/"
            ;;
        p)
            # 	-p <port> - (optional argument) specifies the port httpd should listen
            # 	on when starting. The default port (if the -p option is not specified) should be 8080.

            P_VALUE=${OPTARG}
            ;;
        h)
            # 	-h - (optional argument) display help and exit with an exit code 0.
            # 	The help should look similar to what you see when you pass --help to standard commands
            # 	(e.g. grep --help). Hint: Create a usage function that prints out the correct command usage.

            usage
            ;;
    esac

done

echo  "DIR_VALUE = "${DIR_VALUE}
echo "P_VALUE = "${P_VALUE}

# As getopts processes options it updates an internal counter, OPTIND, of the number of command-line
# arguments it has handled.  Sometimes you want to read values after the optional values.  To do so,
# you can use the 'shift' command to bypass what getopts has handled and see what else is there.
shift $((OPTIND-1))

if [ "$1" = "start" ]
then
  docker run -dit --name my-apache-app -p $P_VALUE:80 $DIR_VALUE httpd:2.4
  echo "Started!"
fi

if [ "$1" = "stop" ]
then
    docker stop my-apache-app
    echo "Stopped!"
fi

if [ "$1" = "destroy" ]
then
  docker stop my-apache-app
  docker rm my-apache-app
  echo "Destroyed"
fi

#docker run -dit --name my-apache-app -p $P_VALUE:80 $DIR_VALUE httpd:2.4

#docker stop my-apache-app
#echo "Container is stopped"
#docker rm my-apache-app
#echo "Container has been removed"