# Stage 1: Builder
FROM quay.io/jupyter/all-spark-notebook@sha256:3c11d62e0aa0724aa2984f91066a56a072bcb4dc2cb59feaed634073f172cb21 AS builder

USER root

ENV TZ="Asia/Seoul"

RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        --no-install-recommends \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

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
