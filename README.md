# tensorflow-ios-vad
基于TensorFlow的iOS本地Vad，整个vad检测的过程都在本地完成，不需要通过网络传输到服务器解码。

该项目当前编译TensorFlow版本号为1.14

该vad项目是在TensorFlow上解码，所以将TensorFlow编译成iOS使用的静态库。
编译成功后，按照TensorFlow官方文档在Xcode上集成。集成完成编译无误后，即可执行该项目进行vad体验。
cocoapod方式因为github限制单个文件大小，没有开放出来，所以只在内网部署。

编译及集成可参考官方：https://github.com/tensorflow/tensorflow/tree/master/tensorflow/examples/ios

vad模型网络结构：CNN+LSTM

目前vad内部已做平滑处理，直接输出某段音频状态（有效声音/无效声音），亦可输出音频每一帧的vad状态（1/0）。
