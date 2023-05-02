#cli 
logman query providers

logman create trace spotless-tracing -ets

logman query spotless-tracing -ets

logman update spotless-tracing -p Microsoft-Windows-Kernel-Process 0x50 -ets

logman update trace spotless-tracing --p Microsoft-Windows-Kernel-Process 0x50 -ets

logman stop spotless-tracing -ets

logman query providers -pid $pid