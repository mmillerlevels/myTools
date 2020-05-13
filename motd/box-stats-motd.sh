#!/bin/bash

Theme=Blue
OsVersion=$(cat /etc/*release | head -n 1)

# Infrastructure
## Check for the common ones, or just go unknown
Dmi=$(dmesg | grep "DMI:")
if [[ $Dmi == *"QEMU"* ]] ; then
  Platform=$(dmesg | grep "DMI:" | sed 's/^.*QEMU/QEMU/' | sed 's/, B.*//')
elif [[ $Dmi == *"VMware"* ]] ; then
  Platform=$(dmesg | grep "DMI:" | sed 's/^.*VMware/VMware/' | sed 's/, B.*//')
elif [[ $Dmi == *"FUJITSU PRIMERGY"* ]] ; then
  Platform=$(dmesg | grep "DMI:" | sed 's/^.*FUJITSU PRIMERGY/Fujitsu Primergy/' | sed 's/, B.*//')
elif [[ $Dmi == *"Supermicro"* ]] ; then
  Platform=$(dmesg | grep "DMI:" | sed 's/^.*Supermicro/Supermicro/' | sed 's/, B.*//')
else
  Platform="Unknown"
fi

# CPU Utilisation
CpuUtil=$(LANG=en_GB.UTF-8 mpstat 1 1 | awk '$2 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $2 ~ /all/ { print 100 - $field}' | tail -1)
CpuProc="$(grep -c processor /proc/cpuinfo) core(s)."

# Memory usage Information
MemFreeB=$(grep MemFree /proc/meminfo | awk {'print $2'})
MemTotalB=$(grep MemTotal /proc/meminfo | awk {'print $2'})
MemUsedB=$(expr $MemTotalB - $MemFreeB)
MemFree=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$MemFreeB/1024/1024))
MemUsed=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$MemUsedB/1024/1024))
MemTotal=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$MemTotalB/1024/1024))

# Swap Usage Information
SwapFreeB=$(cat /proc/meminfo | grep SwapFree | awk {'print $2'})
SwapTotalB=$(cat /proc/meminfo | grep SwapTotal | awk {'print $2'})
SwapUsedB=$(expr $SwapTotalB - $SwapFreeB)
SwapFree=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$SwapFreeB/1024/1024))
SwapUsed=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$SwapUsedB/1024/1024))
SwapTotal=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$SwapTotalB/1024/1024))

# Root Usage Information
RootFreeB=$(df -k / | tail -1 | awk '{print $3}')
RootUsedB=$(df -k / | tail -1 | awk '{print $2}')
RootTotalB=$(expr $RootFreeB + $RootUsedB)
RootFree=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$RootFreeB/1024/1024))
RootUsed=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$RootUsedB/1024/1024))
RootTotal=$(printf "%0.2f\n" $(bc -q <<< scale=2\;$RootTotalB/1024/1024))

# Markup
MaxLeftOverChars=35
Hostname=$(hostname)
HostChars=$((${#Hostname} + 8))
LeftoverChars=$((MaxLeftOverChars - HostCHars -10))

# Pretty Colors
if [[ $Theme = "Blue" ]] ; then
        # 16 Color Blue Frame Scheme
        # Blue
        Sch1="\e[0;34m####"
        # Light Blue
        Sch2="\e[1;34m#####"
        # Light Cyan
        Sch3="\e[1;36m#####"
        # Cyan
        Sch4="\e[0;36m#####"
        # Pre-Host Scheme
        PrHS=$Sch1$Sch1$Sch2$Sch2
        # Host Scheme Top
        HST="\e[1;36m`head -c $HostChars /dev/zero|tr '\0' '#'`"
        # Host Scheme Top Filler
        HSF="\e[1;36m###"
        # Host Scheme Bot
        HSB="\e[1;34m`head -c $HostChars /dev/zero|tr '\0' '#'`"
        # Post Host Scheme
        PHS="\e[1;34m`head -c $LeftoverChars /dev/zero|tr '\0' '#'`"
        # Host Version Filler
        HVF="\e[1;34m`head -c 9 /dev/zero|tr '\0' '#'`"
        # Front Scheme
        FrS="\e[0;34m##"
        # Equal Scheme
        ES="\e[1;34m="
        # 16 Color Green Value Scheme
        # Host Color
        HC="\e[1;32m"
        # Green Value Color
        VC="\e[0;32m"
        # Light Green Value Color
        VCL="\e[1;32m"
        # Light Yellow Key Color
        KS="\e[1;33m"
        # Version Color
        SVC="\e[1;36m"
elif [[ $Theme = "Red" ]] ; then
        # 16 Color Red Frame Scheme
        # Red
        Sch1="\e[0;31m####"
        # Light Red
        Sch2="\e[1;31m#####"
        # Light Yellow
        Sch3="\e[1;33m#####"
        # Yellow
        Sch4="\e[0;33m#####"
        # Pre-Host Scheme
        PrHS=$Sch1$Sch1$Sch2$Sch2
        # Host Scheme Top
        HST="\e[1;33m`head -c $HostChars /dev/zero|tr '\0' '#'`"
        # Host Scheme Top Filler
        HSF="\e[1;33m###"
        # Host Scheme Bot
        HSB="\e[0;31m`head -c $HostChars /dev/zero|tr '\0' '#'`"
        # Post Host Scheme
        PHS="\e[2;31m`head -c $LeftoverChars /dev/zero|tr '\0' '#'`"
		# Host Version Filler
		HVF="\e[2;31m`head -c 9 /dev/zero|tr '\0' '#'`"
        # Front Scheme
        FrS="\e[0;31m##"
        # Equal Scheme
        ES="\e[1;31m="
        # 16 Color Yellow Value Scheme
        # Host Color
        HC="\e[1;37m"
        # Yellow Value Color
        VC="\e[0;33m"
        # Light Yellow Value Color
        VCL="\e[1;33m"
        # Light Yellow Key Color
        KS="\e[0;37m"
	# Version Color
	SVC="\e[1;33m"
fi

echo -e "
$PrHS$Sch2$HST$Sch2$PHS$Sch1
$PrHS$Sch2$HST$Sch2$PHS$Sch1
$FrS   ${KS}Hostname $ES ${VCL}$(cat /etc/hostname)
$FrS   ${KS}Ip $ES ${VCL}$(ip add | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -v '127.0.0.1' | grep -v -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.255')
$FrS   ${KS}Release $ES ${VC}$OsVersion
$FrS   ${KS}Kernel $ES ${VC}$(uname -rs)
$FrS   ${KS}Platform $ES ${VC}$Platform
$FrS   ${KS}Uptime $ES ${VC}$(awk '{print int($1/86400)" day(s) "int($1%86400/3600)":"int(($1%3600)/60)":"int($1%60)}' /proc/uptime)
$FrS   ${KS}CPU Util $ES ${VCL}$CpuUtil ${VC}% average CPU usage over $CpuProc
$FrS   ${KS}CPU Load $ES ${VC}$(uptime | grep -ohe '[s:][: ].*' | awk '{ print "1m: "$2 " 5m: "$3 " 15m: " $4}')
$FrS   ${KS}Memory $ES ${VC}Free: ${VCL}${MemFree}${VC} GB, Used: ${VCL}${MemUsed}${VC} GB, Total: ${VCL}${MemTotal}${VC} GB
$FrS   ${KS}Swap $ES ${VC}Free: ${VCL}${SwapFree}${VC} GB, Used: ${VCL}${SwapUsed}${VC} GB, Total: ${VCL}${SwapTotal}${VC} GB
$FrS   ${KS}Root $ES ${VC}Free: ${VCL}${RootFree}${VC} GB, Used: ${VCL}${RootUsed}${VC} GB, Total: ${VCL}${RootTotal}${VC} GB
$FrS   ${KS}Sessions $ES ${VCL}$(who | grep $USER | wc -l) ${VC}sessions
$FrS   ${KS}Processes $ES ${VCL}$(ps -Afl | wc -l) ${VC}running processes of ${VCL}$(ulimit -u) ${VC}maximum processes
$FrS   ${KS}Reach Webapp Version $ES ${VCL}$(grep '^version' /reachengine/tomcat/webapps/ROOT/META-INF/maven/com.levelsbeyond.re-studio/re-studio-server/pom.properties | sed 's/^version=//')
$FrS   ${KS} If you see blanks below, you're probably on 2.3.x!
$FrS   ${KS} If this is only a 2.7+ Webapp, you wont see Runtime data; only Workflow SDK!
$FrS   ${KS}Reach Workflow SDK Version $ES ${VCL}$(ls -ll /reachengine/extralib/studio-workflow-sdk.jar | grep studio-workflow-sdk- | cut -d / -f7 | cut -d - -f4)
$FrS   ${KS}Reach Workflow Runtime Version $ES ${VCL}$(ls -ll /reachengine/wfruntime/ | grep studio-workflow-runtime- | awk '{print $9}' | cut -d - -f4)
$FrS   ${KS}Reach Expiration $ES ${VCL}$(grep '^Expiration' /reachengine/tomcat/lib/license.lic | sed 's/^Expiration=//')
$FrS   ${KS}ReachEngine GC Count Today $ES ${VCL}$(grep "Full GC" /reachengine/tomcat/logs/gc.log | awk '{print $1}' | awk -FT '{print $1}'| uniq -c | head -1 | awk '{print $1}')
$PrHS$Sch2$HSB$Sch2$PHS$Sch1
\e[0;37m"

echo "This shell is for advanced ReachEngine users/admins!"
echo "Be careful!"
echo "Aut viam inveniam aut faciam"
echo " "