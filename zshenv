export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH=/usr/local/bin/:$PATH
#PKG_CONFIG_PATH
export  PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

#GO
export GOROOT="/usr/lib/go"
export GOBIN="$GOROOT/bin"
export GOPATH="$HOME/Documents/work/go"
export GOPROXY=https://127.0.0.1:12333

export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"
#MKLROOT
export MKLROOT=/opt/intel/mkl/
export LD_LIBRARY_PATH=/opt/intel/lib/intel64:/opt/intel/mkl/lib/intel64:${LD_LIBRARY_PATH}

# rbenv 配置
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


#set -g default-terminal "tmux-256color"

# nvm 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
export PATH=$HOME/.nvm/versions/node/v14.15.3/bin:$PATH
export NODE_PATH="$HOME/.nvm/versions/node/14.18.3/lib/node_modules"

export PATH=/opt/BaiduPCS-Go/:$PATH

# nvm 淘宝镜像
export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node
alias cnpm="npm --registry=https://registry.npm.taobao.org \
    --cache=$HOME/.npm/.cache/cnpm \
    --disturl=https://npm.taobao.org/dist \
    --userconfig=$HOME/.cnpmrc"   
# CUDA
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH



#NDK
export NDK_ROOT=/usr/ndk/android-ndk-r16b
export PATH=$NDK_ROOT:$PATH

#ANDROID_SDK_ROOT
export ANDROID_SDK_ROOT=$HOME/.android/android-sdk
export PATH=$ANDROID_SDK_ROOT:$PATH
export ANDROID_HOME=$HOME/.android/android-sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools


# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT="/opt/cocos/cocos2d-x-latest/tools/cocos2d-console/bin"
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT="/opt/cocos"
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT="/opt/cocos/cocos2d-x-latest/templates"
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

# Cocos2d-x 的静态库
export LD_LIBRARY_PATH=/opt/lib:$LD_LIBRARY_PATH
# Cocos Creator的路径
export PATH=$PATH:/opt/cocos/cocos-creator

#UE4 
export UE_PYTHON_DIR=$HOME/.pyenv/shims/python
export UE4_ROOT=$HOME/Documents/github/UnrealEngine
#Flutter+镜像
export PATH=$PATH:/opt/flutter/bin
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn


#Qt ArcGIS
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/arcgis/runtime_sdk/qt100.4/sdk/linux/x64/lib/

export QT_QMAKE_EXECUTABLE=/usr/bin/
export CLASS_PATH=$CLASS_PATH:/opt/xmind-8-update8-linux/plugins

# Qt 
export QTDIR=/Applications/Qt/5.12.4/clang_64
export QML_IMPORT_PATH=$QML_IMPORT_PATH:$QTDIR/qml:/Applications/Spark\ AR\ Studio.app/Contents/Resources 
export QT_INSTALL_QML=$QTDIR/qml
export PATH=$PATH:/Applications/Qt/5.12.4/clang_64/bin

#JMeter
export PATH=$PATH:/opt/apache-jmeter-5.1.1/bin/

export GRADLE_USER_HOME="$HOME/.gradle"


# pyenv 配置
export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
#export PYTHON_BUILD_MIRROR_URL="http://pyenv.qiniudn.com/pythons/"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export QMK_HOME=$HOME/qmk_firmware

export PATH=$PATH:$HOME/Documents/github/depot_tools


# powerline
#POWERLINE_HOME=$(python3 -c "
#import pkg_resources
#
#try:
#    dist = pkg_resources.get_distribution('powerline-status')
#    print(dist.location)
#except pkg_resources.DistributionNotFound:
#    raise SystemExit(1)
#")
#if [ -d "$POWERLINE_HOME" ]
#then
#    source "$POWERLINE_HOME/powerline/bindings/bash/powerline.sh"
#    export POWERLINE_HOME
#fi
