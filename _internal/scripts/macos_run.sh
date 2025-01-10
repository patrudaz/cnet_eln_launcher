#!/usr/bin/env bash

export MINECRAFT_HOME_DIR=$1
export INST_NAME=1.7.10
export INST_ID=1.7.10
export INST_DIR=$MINECRAFT_HOME_DIR/.minecraft/versions/1.7.10
export INST_MC_DIR=$MINECRAFT_HOME_DIR/.minecraft
export INST_JAVA=$MINECRAFT_HOME_DIR/java/mac/jdk1.8.0_281/Contents/Home/bin
export INST_FORGE=1

exec >> sh_log_cnet.txt
echo "Starting macos_run.sh ..."
cd $INST_MC_DIR
$INST_JAVA/java -Xmx4096m "-Dfile.encoding=UTF-8" "-Dsun.stdout.encoding=UTF-8" "-Dsun.stderr.encoding=UTF-8" "-Djava.rmi.server.useCodebaseOnly=true" "-Dcom.sun.jndi.rmi.object.trustURLCodebase=false" "-Dcom.sun.jndi.cosnaming.object.trustURLCodebase=false" "-Dlog4j2.formatMsgNoLookups=true" "-Dlog4j.configurationFile=$INST_DIR/log4j2.xml" "-Dminecraft.client.jar=$INST_DIR/1.7.10.jar" "-Xdock:name=Minecraft 1.7.10" "-Xdock:icon=$INST_MC_DIR/assets/objects/99/991b421dfd401f115241601b2b373140a8d78572" "-Duser.home=null" -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC "-XX:G1NewSizePercent=20" "-XX:G1ReservePercent=20" "-XX:MaxGCPauseMillis=50" "-XX:G1HeapRegionSize=32m" -XX:-UseAdaptiveSizePolicy -XX:-OmitStackTraceInFastThrow -XX:-DontCompileHugeMethods "-Dfml.ignoreInvalidMinecraftCertificates=true" "-Dfml.ignorePatchDiscrepancies=true" "-Djava.library.path=$INST_DIR/natives-osx-x86_64" "-Dminecraft.launcher.brand=HMCL" "-Dminecraft.launcher.version=3.5.5.236" -cp $INST_MC_DIR:$INST_MC_DIR/libraries/net/minecraftforge/forge/1.7.10-10.13.4.1614-1.7.10/forge-1.7.10-10.13.4.1614-1.7.10.jar:$INST_MC_DIR/libraries/net/minecraft/launchwrapper/1.12/launchwrapper-1.12.jar:$INST_MC_DIR/libraries/org/ow2/asm/asm-all/5.0.3/asm-all-5.0.3.jar:$INST_MC_DIR/libraries/com/typesafe/akka/akka-actor_2.11/2.3.3/akka-actor_2.11-2.3.3.jar:$INST_MC_DIR/libraries/com/typesafe/config/1.2.1/config-1.2.1.jar:$INST_MC_DIR/libraries/org/scala-lang/scala-actors-migration_2.11/1.1.0/scala-actors-migration_2.11-1.1.0.jar:$INST_MC_DIR/libraries/org/scala-lang/scala-compiler/2.11.1/scala-compiler-2.11.1.jar:$INST_MC_DIR/libraries/org/scala-lang/plugins/scala-continuations-library_2.11/1.0.2/scala-continuations-library_2.11-1.0.2.jar:$INST_MC_DIR/libraries/org/scala-lang/plugins/scala-continuations-plugin_2.11.1/1.0.2/scala-continuations-plugin_2.11.1-1.0.2.jar:$INST_MC_DIR/libraries/org/scala-lang/scala-library/2.11.1/scala-library-2.11.1.jar:$INST_MC_DIR/libraries/org/scala-lang/scala-parser-combinators_2.11/1.0.1/scala-parser-combinators_2.11-1.0.1.jar:$INST_MC_DIR/libraries/org/scala-lang/scala-reflect/2.11.1/scala-reflect-2.11.1.jar:$INST_MC_DIR/libraries/org/scala-lang/scala-swing_2.11/1.0.1/scala-swing_2.11-1.0.1.jar:$INST_MC_DIR/libraries/org/scala-lang/scala-xml_2.11/1.0.2/scala-xml_2.11-1.0.2.jar:$INST_MC_DIR/libraries/lzma/lzma/0.0.1/lzma-0.0.1.jar:$INST_MC_DIR/libraries/net/sf/jopt-simple/jopt-simple/4.5/jopt-simple-4.5.jar:$INST_MC_DIR/libraries/com/google/guava/guava/17.0/guava-17.0.jar:$INST_MC_DIR/libraries/org/apache/commons/commons-lang3/3.3.2/commons-lang3-3.3.2.jar:$INST_MC_DIR/libraries/com/mojang/netty/1.8.8/netty-1.8.8.jar:$INST_MC_DIR/libraries/com/mojang/realms/1.3.5/realms-1.3.5.jar:$INST_MC_DIR/libraries/org/apache/commons/commons-compress/1.8.1/commons-compress-1.8.1.jar:$INST_MC_DIR/libraries/org/apache/httpcomponents/httpclient/4.3.3/httpclient-4.3.3.jar:$INST_MC_DIR/libraries/commons-logging/commons-logging/1.1.3/commons-logging-1.1.3.jar:$INST_MC_DIR/libraries/org/apache/httpcomponents/httpcore/4.3.2/httpcore-4.3.2.jar:$INST_MC_DIR/libraries/java3d/vecmath/1.3.1/vecmath-1.3.1.jar:$INST_MC_DIR/libraries/net/sf/trove4j/trove4j/3.0.3/trove4j-3.0.3.jar:$INST_MC_DIR/libraries/com/ibm/icu/icu4j-core-mojang/51.2/icu4j-core-mojang-51.2.jar:$INST_MC_DIR/libraries/com/paulscode/codecjorbis/20101023/codecjorbis-20101023.jar:$INST_MC_DIR/libraries/com/paulscode/codecwav/20101023/codecwav-20101023.jar:$INST_MC_DIR/libraries/com/paulscode/libraryjavasound/20101123/libraryjavasound-20101123.jar:$INST_MC_DIR/libraries/com/paulscode/librarylwjglopenal/20100824/librarylwjglopenal-20100824.jar:$INST_MC_DIR/libraries/com/paulscode/soundsystem/20120107/soundsystem-20120107.jar:$INST_MC_DIR/libraries/io/netty/netty-all/4.0.10.Final/netty-all-4.0.10.Final.jar:$INST_MC_DIR/libraries/commons-io/commons-io/2.4/commons-io-2.4.jar:$INST_MC_DIR/libraries/commons-codec/commons-codec/1.9/commons-codec-1.9.jar:$INST_MC_DIR/libraries/net/java/jinput/jinput/2.0.5/jinput-2.0.5.jar:$INST_MC_DIR/libraries/net/java/jutils/jutils/1.0.0/jutils-1.0.0.jar:$INST_MC_DIR/libraries/com/google/code/gson/gson/2.2.4/gson-2.2.4.jar:$INST_MC_DIR/libraries/com/mojang/authlib/1.5.21/authlib-1.5.21.jar:$INST_MC_DIR/libraries/org/apache/logging/log4j/log4j-api/2.0-beta9/log4j-api-2.0-beta9.jar:$INST_MC_DIR/libraries/org/apache/logging/log4j/log4j-core/2.0-beta9/log4j-core-2.0-beta9.jar:$INST_MC_DIR/libraries/org/lwjgl/lwjgl/lwjgl/2.9.1/lwjgl-2.9.1.jar:$INST_MC_DIR/libraries/org/lwjgl/lwjgl/lwjgl_util/2.9.1/lwjgl_util-2.9.1.jar:$INST_MC_DIR/libraries/tv/twitch/twitch/5.16/twitch-5.16.jar:$INST_DIR/1.7.10.jar net.minecraft.launchwrapper.Launch --tweakClass cpw.mods.fml.common.launcher.FMLTweaker --username laSmart --version 1.7.10 --gameDir $INST_MC_DIR/ --assetsDir $INST_MC_DIR/assets --assetIndex 1.7.10 --uuid e2805b4632e43f8da191da394be7e45a --accessToken 6196c2cb1e4e4fa196851e716f617440 --userProperties "{}" --userType msa --width 854 --height 480
