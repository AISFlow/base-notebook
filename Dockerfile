# Stage 1: Builder
FROM quay.io/jupyter/all-spark-notebook@sha256:3c11d62e0aa0724aa2984f91066a56a072bcb4dc2cb59feaed634073f172cb21 AS builder

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

# # Clean up pip cache
# RUN pip cache purge

# # Stage 2: Final image
# FROM quay.io/jupyter/all-spark-notebook@sha256:3c11d62e0aa0724aa2984f91066a56a072bcb4dc2cb59feaed634073f172cb21 AS final

# # Copy the Conda environment and set ownership directly
# COPY --chown=1000:100 --from=builder /opt/conda /opt/conda
