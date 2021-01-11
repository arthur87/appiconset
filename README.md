# Appiconset

1024px x 1024pxの画像からmacOSアプリやiOSアプリで必要になるアプリアイコンを書き出すRubyスクリプトです。

以下の環境で動作確認をしています。  
* macOS High Sierra(10.13.1)
* macOS Mojave(10.14.0)

以下のプラットフォームのアイコン作成をサポートしています。
* iOS/iPadOS
* macOS
* Universal
* watchOS
* Android
* tvOS

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
これらのファイルをXcodeプロジェクトの AppIcon.appiconset にコピーします。

## tvOSアプリ向けのアイコン

tvOSアプリ向けのアイコンを作成するためには、3種類の画像が必要です。 

App Icon.imagestack のアイコンを作成するためには、800px x 480px の画像を用意します。  
tv-xcode12.3 にアイコンが作成されます。

Top Shelf Image.imageset のアイコンを作成するためには、3840px x 1440px の画像を用意します。  
tv-top-shelf-xcode12.3 にアイコンが作成されます。

Top Shelf Image Wide.imageset のアイコンを作成するためには、4640px x 1440px の画像を用意します。  
tv-top-shelf-xcode12.3 にアイコンが作成されます。