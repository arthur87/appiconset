# Appiconset

1024px x 1024pxの画像からmacOSアプリやiOSアプリで必要になるアプリアイコンを書き出すRubyスクリプトです。

以下の環境で動作確認をしています。  
* macOS High Sierra(10.13.1)

以下のプラットフォームのアイコン作成をサポートしています。
* iOS
* macOS
* Univarsal
* watchOS


# インストール

appiconsetは以下の方法でインストールできます。

```
$ gem install specific_install
$ gem specific_install -l 'git://github.com/arthur87/appiconset.git'
```

# 使い方

ヘルプは、以下の方法で表示できます。

```
$ appiconset -h
```


1024px x 1024px の画像からアプリアイコンを作成します。

```
$ appiconset icon.jpg
$ cd ./AppIcon.appiconset
$ ls
Contents.json    Icon-20@3x.png   Icon-40@1x.png   Icon-60@3x.png
Icon-1024@1x.png Icon-29@1x.png   Icon-40@2x.png   Icon-76@1x.png
Icon-20@1x.png   Icon-29@2x.png   Icon-40@3x.png   Icon-76@2x.png
Icon-20@2x.png   Icon-29@3x.png   Icon-60@2x.png   Icon-83.5@2x.png
```

Contents.jsonと複数のpngファイルが作成されます。  
これらのファイルをXcodeプロジェクトのAppIcon.appiconsetにコピーします。