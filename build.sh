#! /bin/bash
set -ex

set -o pipefail

: ${ANT_HOME:="c:/apache-ant-1.9.2"}
ANT_HOME=$(cygpath -m "${ANT_HOME}")

: ${JAVA_HOME:="c:/jdk"}
export JAVA_HOME=$(cygpath -m "${JAVA_HOME}")

: ${SELENIUM_DRIVERS:="c:/selenium-drivers"}

if [[ "${OSTYPE}" == "cygwin" ]] ; then
    jhu="$(cygpath -u "${JAVA_HOME}")"
    ahu="$(cygpath -u "${ANT_HOME}")"
    sdu="$(cygpath -u "${SELENIUM_DRIVERS}")"
else
    jhu="${JAVA_HOME}"
    ahu="${ANT_HOME}"
    sdu="${SELENIUM_DRIVERS}"
fi

export PATH="${sdu}:${jhu}/bin:${ahu}/bin:/bin:/usr/bin:$(cygpath -uW):$(cygpath -uS)"

# The following Cygwin-to-Windows-native helper corrupts PATH by reparsing the
# drive letter delimiter as a path separator.
# export PATH=$(cygpath -pw "${PATH}")

echo "${PWD}" > build.log
echo "+ $0 $*" >> build.log

echo "+ taskkill /f /im phantomjs.exe /im java.exe || :" >> build.log
( taskkill /f /im phantomjs.exe /im java.exe || : ) 2>&1 | tee -a build.log

h=$(hostname -f | tr '[[:upper:]]' '[[:lower:]]')

# ...Launcher -diagnostics
cmd=("${jhu}/bin/java" \
    -classpath "${ANT_HOME}/lib/ant-launcher.jar" \
    -Dant.home="${ANT_HOME}" \
    org.apache.tools.ant.launch.Launcher \
    -f "build.xml" \
    -Djava.home="${JAVA_HOME}" \
    -Dzap.target="https://${h}/" \
    -Dzap.targetApp="https://${h}/bodgeit/" \
    -Dzap.addr="${h}" \
    -Dzap.port="8090" \
    -Dzap.dir='C:\\Program Files (x86)\\OWASP\\Zed Attack Proxy' \
    "$@")

echo "+ ${cmd[*]}" >> build.log
"${cmd[@]}" 2>&1 | tee -a build.log

