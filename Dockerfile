FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

WORKDIR /root
ENV HOME /root

#install vscode
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    git \
    libssl-dev \
    libbz2-dev \
    libsqlite3-dev \
    libreadline-dev \
    zlib1g-dev \
    libasound2-dev \
    libxss1 \
    libxtst6 \
    gdebi \
    vim \
    tmux 

RUN wget -O vscode-amd64.deb https://go.microsoft.com/fwlink/?LinkID=760868
RUN yes | gdebi vscode-amd64.deb
RUN rm vscode-amd64.deb
RUN echo 'alias code="code --user-data-dir"' >> ~/.bashrc


#install pyenv and anacodna
RUN git clone https://github.com/yyuu/pyenv.git ~/.pyenv \
    && git clone https://github.com/yyuu/pyenv-pip-rehash.git ~/.pyenv/plugins/pyenv-pip-rehash
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN pyenv install anaconda3-5.1.0 && pyenv global anaconda3-5.1.0
ENV PATH $PYENV_ROOT/versions/anaconda3-5.1.0/bin:$PATH

RUN pip install --upgrade pip


#install pytorch
RUN pip install https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl
RUN pip install torchvision

#install machina
RUN pip install machina-rl


#install Jupyterlab
RUN pip install jupyterlab
#port open for jupyter
EXPOSE 8888

#make script
RUN echo '#!/bin/bash' > /tmp/run-script.sh && \
    echo 'code --user-data-dir' >> /tmp/run-script.sh && \
    echo '/usr/bin/xvfb-run -s "-screen 0 1280x720x24" jupyter lab --no-browser --allow-root --ip=0.0.0.0 --notebook-dir=/root --NotebookApp.password="sha1:71247b1fba50:6334281a44d2134e85492be9ad7426a3cf9caf90"' >> /tmp/run-script.sh && \
    chmod +x /tmp/run-script.sh
#auto run script    
#CMD ["/tmp/run-script.sh"]


#install gym
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
        build-essential \
        g++  \
        git  \
        curl  \
        cmake \
        zlib1g-dev \
        libjpeg-dev \
        xvfb \
        xorg-dev \
        libboost-all-dev \
        libsdl2-dev \
        swig \
        libopenblas-base  \
        cython3  \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

RUN pip install \
    PyOpenGL \
    piglet \
    pyglet==1.2.4 \
    JSAnimation \
    ipywidgets

#install gym except mujoco
RUN pip install gym[atari] gym[box2d]  gym[classic_control]