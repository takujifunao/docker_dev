## 手順

### VirtualBoxをダウンロード

- 通常の方法でVirtualBoxをインストール
http://pc-karuma.net/mac-virtualbox-install/

- brewでVirtualBoxインストール
http://yamacent.hatenablog.com/entry/2015/05/06/233618


### Dockerをダウンロード

1. `brew update`
1. `brew tap homebrew/binary`
1. `brew install docker docker-machine`

### dockerを起動し、仮想の中に入る

1. `docker-machine create --driver virtualbox dev`
1. `docker-machine env dev`
1. `eval "$(docker-machine env dev)"`
1. `docker-machine ssh dev`

### 仮想の中でdockerファイルをダウンロードし、環境設定して、ローカルプロジェクトと同期

1. `git clone https://github.com/takujifunao/docker_dev.git`
1. `cd docker_dev`
1. `docker build --build-arg USER_NAME=hogehoge -t rails_dev:dev .` ※hogehogeを変更
1. `docker run -v YOURPROJECT_PATH:/home/YOURNAME/ -d -P --name rails_go rails_dev:dev` 例）docker run -v /Users/takujifunao/Hack/03_tsukuruba/cowcamo-rails:/home/takuji/ -d -P --name railstest2 rails_dev:dev



1. `docker port rails_go 22`
1. `docker-machine ip dev`
1. `ssh root@xxx.xxx.xx.xxx -p xxxxx` ※以下のコマンドで取得`docker-machine ip dev`と`docker port rails_go 22`
1. `cd /home/$USER_NAME`
1. `gem install bundler --version=1.10.3`
1. `gem install rbenv-rehash`
1. `npm install -g coffee-script`
1. `bundle config build.nokogiri --use-system-libraries`
1. `bundle install`
1. `bundle exec sidekiq -d -q default event`
1. `vim .env`
1. `DATABASE_HOST='0.0.0.0'` に変更する
1. `rake db:create` *動かない場合は`/etc/init.d/mysqld restart`
1. `rake db:migrate`
1. `rake db:seed_fu`
1. `rails s -b 0.0.0.0`
1. `docker port rails_go 3000` 別のwindowでdocker-machine ssh devしてから行う
1. `xxx.xxx.xx.xxx:xxxxx`にアクセス *`docker-machine ip dev`と`docker port rails_go 3000`

### 参考URL

http://qiita.com/kohey18/items/b7e48ad70f97680041e5
