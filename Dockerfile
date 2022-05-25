FROM python:3.9.6-buster

# パッケージインストールとlocaleの設定
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install sudo vim locales graphviz && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF_8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9

# キャッシュクリア
RUN apt-get clean

# pythonライブラリインストール
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade setuptools
COPY requirements.txt /tmp/
RUN python -m pip install -r /tmp/requirements.txt

# ユーザーを作成。ビルド時に渡す。
ARG u_id
ARG u_name
ARG u_passwd
ENV DOCKER_UID=${u_id}
ENV DOCKER_USER=${u_name}
ENV DOCKER_PASSWORD=${u_passwd}
## 作成したユーザをsudoグループに加える
RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} \
  && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

## 作成したユーザーに切り替える
USER ${DOCKER_USER}
# ワーキングディレクトリ変更
WORKDIR /home/dogscox