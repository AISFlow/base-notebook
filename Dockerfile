# Stage 1: Builder
FROM quay.io/jupyter/all-spark-notebook@sha256:3c11d62e0aa0724aa2984f91066a56a072bcb4dc2cb59feaed634073f172cb21 AS builder

USER root

ENV TZ="Asia/Seoul"

RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
            locales \
            fonts-noto-cjk \
            language-pack-ko \
            fonts-noto-cjk-extra \
            msttcorefonts && \
        sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
        sed -i 's/# \(ko_KR.UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=ko_KR.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # D2Coding 폰트 설치
    wget -O /usr/share/fonts/truetype/D2Coding.zip https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip && \
    unzip /usr/share/fonts/truetype/D2Coding.zip -d /usr/share/fonts/truetype/ && \
    rm /usr/share/fonts/truetype/D2Coding.zip && \
    # D2Coding Nerd 폰트 설치
    mkdir -p /usr/share/fonts/truetype/D2CodingNerd && \
    wget -O /usr/share/fonts/truetype/D2CodingNerd/D2CodingNerd.ttf https://github.com/kelvinks/D2Coding_Nerd/raw/master/D2Coding%20v.1.3.2%20Nerd%20Font%20Complete.ttf && \
    # 파일 권한 조정
    chmod -R 644 /usr/share/fonts/truetype/* && \
    find /usr/share/fonts/truetype/ -type d -exec chmod 755 {} + && \
    # 폰트 캐시 갱신
    fc-cache -f -v

RUN set -eux; \
        dpkgArch="$(dpkg --print-architecture)"; \
            case "${dpkgArch##*-}" in \
                amd64) mecabArch='x86_64';; \
                arm64) mecabArch='aarch64';; \
                *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
            esac; \
        mecabKoUrl="https://github.com/Pusnow/mecab-ko-msvc/releases/download/release-0.999/mecab-ko-linux-${mecabArch}.tar.gz"; \
        mecabKoDicUrl="https://github.com/Pusnow/mecab-ko-msvc/releases/download/release-0.999/mecab-ko-dic.tar.gz"; \
                wget "${mecabKoUrl}" -O - | tar -xzvf - -C /opt; \
                wget "${mecabKoDicUrl}" -O - | tar -xzvf - -C /opt/mecab/share && \
    chown -R ${NB_UID}:${NB_GID} /opt/mecab

USER ${NB_UID}

# Install libraries for data processing, visualisation, machine learning, and extensions
RUN python3 -m pip install --no-cache-dir tensorflow && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir torch && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir xgboost && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir lightgbm && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir pyspark && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir dash && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir streamlit && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir line_profiler && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir memory_profiler && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir pandas-datareader && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir dart-fss && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir opendartreader && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir finance-datareader && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir pgsql && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir psycopg2 && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir PyMySQL && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \; 

RUN python3 -m pip install --no-cache-dir pymongo && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \; 

RUN python3 -m pip install --no-cache-dir SQLAlchemy && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

RUN python3 -m pip install --no-cache-dir konlpy && \
    find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

# RUN python3 -m pip install --no-cache-dir mecab-ko-msvc mecab-ko-dic-msvc && \
#     find /opt/conda -type f \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \) -exec bash -c 'echo "Deleting {}"; rm -f {}' \;

# # Clean up pip cache
# RUN pip cache purge

# # Stage 2: Final image
# FROM quay.io/jupyter/all-spark-notebook@sha256:3c11d62e0aa0724aa2984f91066a56a072bcb4dc2cb59feaed634073f172cb21 AS final

# # Copy the Conda environment and set ownership directly
# COPY --chown=1000:100 --from=builder /opt/conda /opt/conda
