# Appiconset

1024px x 1024pxの画像からmacOSアプリやiOSアプリで必要になるアプリアイコンを書き出すRubyスクリプトです。

以下の環境で動作確認をしています。  
* macOS High Sierra(10.13.1)
* macOS Mojave(10.14.0)

以下のプラットフォームのアイコン作成をサポートしています。
* iOS
* macOS
* Universal
* watchOS
* Android

# インストール

appiconsetは以下の方法でインストールできます。

```
$ gem install specific_install
$ gem specific_install -l 'git://github.com/arthur87/appiconset.git'
```

# 使い方

ヘルプは以下の方法で表示できます。

```
$ appiconset -h
```


1024px x 1024px の画像からアプリアイコンを作成します。

```
$ appiconset icon.jpg
$ cd ./appiconset-generated
```

Contents.jsonと複数のpngファイルが作成されます。  
これらのファイルをXcodeプロジェクトのAppIcon.appiconsetにコピーします。