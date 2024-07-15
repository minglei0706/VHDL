--  In Synchronous FIFO, data read and write operations use the same clock frequency. 
--  Usually, they are used with high clock frequency to support high-speed systems.
--  用同一时钟频率进行读写操作的同步FIFO，通常用于支持高速系统。

--  In a synchronous FIFO, both read and write operations use the same clock signal. 
--  This means that data read and write operations occur within the same clock domain.

--  同步FIFO的应用
--  
--  	1.	高速数据缓冲：
--  	•	场景：在一个高性能处理器与其缓存之间的数据传输。
--  	•	原因：处理器和缓存通常工作在相同的时钟频率下。使用同步FIFO可以确保数据传输的高效和低延迟。
--  	2.	视频帧缓冲：
--  	•	场景：在一个视频处理流水线中，处理多个时钟周期内生成的像素数据。
--  	•	原因：视频处理流水线的各个阶段通常使用相同的时钟信号，因此同步FIFO可以有效地缓冲和传输帧数据。
--  	3.	音频数据处理：
--  	•	场景：在数字音频处理器内部，从ADC（模数转换器）到DSP（数字信号处理器）的数据传输。
--  	•	原因：ADC和DSP通常在相同的时钟域中操作，使用同步FIFO可以确保音频数据的无缝传输和处理。

library ieee;
