reweibo-picker
==============

基于BTC blockhash的新浪微博转发抽奖程序。输入微博地址，例如 `http://weibo.com/user/eerThs1F`，根据最新的blockhash抽出一名中奖用户。

## 安装

### 克隆仓库

```
git@github.com:weakish/reweibo-picker.git
```

### 安装依赖

```
sudo npm install -g coffeescript
npm install
```

### 添加`access-token`

修改`app.coffee`，加上weibo access token。

### 运行服务

```
coffee app.coffee
```

好了，可以通过 http://localhost:3000 访问。

## 贡献

Fork and send pull request.

