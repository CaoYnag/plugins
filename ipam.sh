#!/bin/bash
contid=111
pid=111
netnspath=/proc/$pid/ns/net # 这个我们需要


NETCONFPATH=${PWD}/conf

# 这里设置了几个环境变量，CNI命令行工具就可以获取到这些参数
export CNI_COMMAND=$(echo $1 | tr '[:lower:]' '[:upper:]')
export CNI_PATH=$PWD/bin
export PATH=$PATH:$CNI_PATH # 这个指定CNI bin文件的路径
export CNI_CONTAINERID=$contid 
export CNI_NETNS=$netnspath

echo CNI_COMMAND: $CNI_COMMAND
echo CNI_CONTAINERID: $contid
echo CNI_NETNS: $netns

for netconf in $(echo $NETCONFPATH/*.conf | sort); 
do
	name=$(jq -r '.name' <$netconf)
	plugin=$(jq -r '.ipam.type' <$netconf) # CNI配置文件的type字段对应二进制程序名
    echo $plugin
	export CNI_IFNAME=$(printf eth%d $i) # 容器内网卡名

	# 这里执行了命令行工具
	res=$($plugin <$netconf) # 这里把CNI的配置文件通过标准输入也传给CNI命令行工具
    echo $res
	if [ $? -ne 0 ]; then
		# 把结果输出到标准输出，这样kubelet就可以拿到容器地址等一些信息
		errmsg=$(echo $res | jq -r '.msg')
		if [ -z "$errmsg" ]; then
				errmsg=$res
		fi

		echo "${name} : error executing $CNI_COMMAND: $errmsg"
		exit 1
	fi
	let "i=i+1"
done
