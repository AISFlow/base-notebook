FROM quay.io/jupyter/all-spark-notebook@sha256:3c11d62e0aa0724aa2984f91066a56a072bcb4dc2cb59feaed634073f172cb21

# Install libraries for data processing, visualisation, machine learning, and extensions
## See `docker run --rm -it quay.io/jupyter/all-spark-notebook@sha256:3c11d62e0aa0724aa2984f91066a56a072bcb4dc2cb59feaed634073f172cb21 pip list`
RUN python3 -m pip install --no-cache-dir \
    tensorflow torch xgboost lightgbm pyspark dash streamlit

# Fix permissions
USER root
RUN fix-permissions /etc/jupyter/ && \
    fix-permissions /opt/conda && \
    fix-permissions /home/$NB_USER

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
