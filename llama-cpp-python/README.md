cd /Users/julian/github/docker/llama-cpp-python
docker container rm -f llama-cpp-python
docker image rm -f llama-cpp-python
docker build -t llama-cpp-python .
docker run -d -p 8000:8000 -v ./model:/model --cap-add SYS_RESOURCE --name llama-cpp-python llama-cpp-python

cap_add: - SYS_RESOURCE

# llama-cpp-python

**Docker container for llama-cpp-python - a python binding for [llama.cpp](https://github.com/ggerganov/llama.cpp).**

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/3x3cut0r/llama-cpp-python
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/3x3cut0r/llama-cpp-python
![Docker Pulls](https://img.shields.io/docker/pulls/3x3cut0r/llama-cpp-python
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/3x3cut0r/docker/llama-cpp-python.yml?branch=main)

`GitHub` - 3x3cut0r/llama-cpp-python - https://github.com/3x3cut0r/docker/tree/main/llama-cpp-python  
`DockerHub` - 3x3cut0r/llama-cpp-python - https://hub.docker.com/r/3x3cut0r/llama-cpp-python

## Index

1. [Usage](#usage)  
   1.1 [docker run](#dockerrun)  
   1.2 [docker-compose.yml](#docker-compose)
2. [Environment Variables](#environment-variables)
3. [Volumes](#volumes)
4. [Ports](#ports)
5. [Find Me](#findme)
6. [License](#license)

## 1 Usage <a name="usage"></a>

**IMPORTANT: you need to add SYS_RESOURCE capability to be able to run this container proberly**

```shell
# for docker run:
docker run -d --cap-add SYS_RESOURCE ...

# for docker compose:
version: '3.9'
services:
  llama-cpp-python:
    container_name: llama-cpp-python
    cap_add:
      - SYS_RESOURCE
    ...
```

### 1.1 docker run <a name="dockerrun"></a>

**Example 1 - run without arguments and use own model:**  
**This is the recommended way to use this container !!!**

````shell
docker run -d \
    --name llama-cpp-python \
    --cap-add SYS_RESOURCE \
    -e MODEL="/model/Llama-2-7b-Chat-GGUF/llama-2-7b-chat.Q2_K.gguf" \
    -v /path/to/your/llama/model:/model \
    -p 8000:8000/tcp \
    3x3cut0r/llama-cpp-python:latest
```-

**Example 2 - run without arguments and use default model:**
**this method downloads a default model from huggingface.co**

```shell
docker run -d \
    --name llama-cpp-python \
    --cap-add SYS_RESOURCE \
    -e DOWNLOAD_DEFAULT_MODEL="True" \
    -p 8000:8000/tcp \
    3x3cut0r/llama-cpp-python:latest
````

**Example 3 - run with arguments (most environment variables will be ignored):**  
**/venv/bin/python3 -B -m llama_cpp.server --host 0.0.0.0 \<your arguments\>**

```shell
docker run -d \
    --name llama-cpp-python \
    --cap-add SYS_RESOURCE \
    -v /path/to/your/llama/model:/model \
    -p 8000:8000/tcp \
    3x3cut0r/llama-cpp-python:latest \
    --model model/Llama-2-7b-Chat-GGUF/llama-2-7b-chat.Q2_K.gguf \
    --n_ctx 1024 \
    ...
```

**Example 4 - show help:**

```shell
docker run --rm \
    --name llama-cpp-python \
    --cap-add SYS_RESOURCE \
    3x3cut0r/llama-cpp-python:latest \
    --help
```

### 1.2 docker-compose.yml <a name="docker-compose"></a>

```shell
version: '3.9'

services:
  llama-cpp-python:
    image: 3x3cut0r/llama-cpp-python:latest
    container_name: llama-cpp-python
    cap_add:
      - SYS_RESOURCE
    environment:
        DOWNLOAD_DEFAULT_MODEL: False
        MODEL: "/model/Llama-2-7b-Chat-GGUF/llama-2-7b-chat.Q2_K.gguf"
    volumes:
      - /path/to/your/llama/model:/model
    ports:
      - 8000:8000/tcp
```

### 1.3 API <a name="api"></a>

**visit [http://llama-cpp-python:8000/docs](http://localhost:8000/docs) for api documentation**

### 2 Environment Variables <a name="environment-variables"></a>

- `TZ` - Specifies the server timezone - **default: UTC**
- `DOWNLOAD_DEFAULT_MODEL` - if True, download Llama-2-7b-Chat-GGUF/llama-2-7b-chat.Q2_K.gguf from Huggingface - **default: False**
- `MODEL` - **MANDATORY**: The path to the model to use for generating completions - **default: /model/Llama-2-7b-Chat-GGUF/llama-2-7b-chat.Q2_K.gguf**
- `MODEL_ALIAS` - The alias of the model to use for generating completions.
- `SEED` - Random seed. -1 for random - **default: 4294967295**
- `N_CTX` - The context size - **default: 2048**
- `N_BATCH` - The batch size to use per eval - **default: 512**
- `N_GPU_LAYERS` - The number of layers to put on the GPU. The rest will be on the CPU - **default: 0**
- `MAIN_GPU` - Main GPU to use - **default: 0**
- `TENSOR_SPLIT` - Split layers across multiple GPUs in proportion.
- `ROPE_FREQ_BASE` - RoPE base frequency - **default: 0.0**
- `ROPE_FREQ_SCALE` - RoPE frequency scaling factor - **default: 0.0**
- `MUL_MAT_Q` - if true, use experimental mul_mat_q kernels - **default: True**
- `F16_KV` - Whether to use f16 key/value - **default: True**
- `LOGITS_ALL` - Whether to return logits - **default: True**
- `VOCAB_ONLY` - Whether to only return the vocabulary - **default: False**
- `USE_MMAP` - Use mmap - **default: True**
- `USE_MLOCK` - Use mlock - **default: True**
- `EMBEDDING` - Whether to use embeddings - **default: True**
- `N_THREADS` - The number of threads to use - **default: 6**
- `LAST_N_TOKENS_SIZE` - Last n tokens to keep for repeat penalty calculation - **default: 64**
- `LORA_BASE` - Optional path to base model, useful if using a quantized base model and you want to apply LoRA to an f16 model.
- `LORA_PATH` - Path to a LoRA file to apply to the model.
- `NUMA` - Enable NUMA support - **default: False**
- `CHAT_FORMAT` - Chat format to use - **default: llama-2**
- `CACHE` - Use a cache to reduce processing times for evaluated prompts - **default: False**
- `CACHE_TYPE` - The type of cache to use. Only used if cache is True - **default: ram**
- `CACHE_SIZE` - The size of the cache in bytes. Only used if cache is True - **default: 2147483648**
- `VERBOSE` - Whether to print debug information - **default: True**
- `HOST` - Listen address - **default: 0.0.0.0**
- `PORT` - Listen port - **default: 8000**
- `INTERRUPT_REQUESTS` - Whether to interrupt requests when a new request is received - **default: True**

### 3 Volumes <a name="volumes"></a>

- `/model` - model directory -> **map your llama (\*.gguf) models here**

### 4 Ports <a name="ports"></a>

- `8000/tcp` - API Port

### 5 Find Me <a name="findme"></a>

![E-Mail](https://img.shields.io/badge/E--Mail-julianreith%40gmx.de-red)

- [GitHub](https://github.com/3x3cut0r)
- [DockerHub](https://hub.docker.com/u/3x3cut0r)

### 6 License <a name="license"></a>

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) - This project is licensed under the GNU General Public License - see the [gpl-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html) for details.