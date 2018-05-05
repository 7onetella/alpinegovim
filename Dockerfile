FROM golang:1.9.2-alpine3.7

ENV LANG C.UTF-8

RUN rm -rf /go

ENV GOPATH /root
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

RUN apk add --update \
  && apk add --no-cache git openssh ca-certificates curl zsh sed vim ctags python py-pip nodejs nodejs-npm htop \
  && rm -rf /var/cache/apk/*

RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" ; exit 0

# Install plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && git clone https://github.com/fatih/vim-go.git ~/.vim/plugged/vim-go \
    # Install pathgen
    && mkdir -p ~/.vim/autoload ~/.vim/bundle \
    && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim \
    # Molokai
    && mkdir -p ~/.vim/colors \
    && curl -o ~/.vim/colors/molokai.vim https://raw.githubusercontent.com/fatih/molokai/master/colors/molokai.vim \
    # vim-go
    && git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go \
    # tagbar
    && go get github.com/jstemmer/gotags \
    && git clone https://github.com/majutsushi/tagbar.git ~/.vim/bundle/tagbar \
    # nerdtree
    && git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree \
    # glide
    && curl https://glide.sh/get | sh \
    # godep
    && go get github.com/tools/godep \
    # aws cli
    && pip install awscli \
    # esc
    && go get github.com/mjibson/esc \
    # gox
    && go get github.com/mitchellh/gox \
    # httpstat
    && go get github.com/davecheney/httpstat \
    # vim-go tutorial
    && go get github.com/fatih/vim-go-tutorial

COPY .zshrc /root/
COPY bullet-train.zsh-theme /root/.oh-my-zsh/themes/
COPY .vimrc /root/
COPY .init.sh /root/

ENV SHELL /bin/zsh

COPY bin/entrypoint.sh /
COPY bin/gotty /
RUN  chmod +x /entrypoint.sh && chmod +x /gotty

EXPOSE 9000

CMD /entrypoint.sh
