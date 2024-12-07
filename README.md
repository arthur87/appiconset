# Appiconset

1024px x 1024pxの画像からmacOSアプリやiOSアプリで必要になるアプリアイコンを書き出すRubyスクリプトです。

以下の環境で動作確認をしています。  
* macOS 15.1

以下のプラットフォームのアイコン作成をサポートしています。
* iOS/iPadOS
* macOS
* Universal
* watchOS
* Android
* tvOS

## 使い方

1024px x 1024px の画像からアプリアイコンを作成します。

```
$ appiconset icons -i='sample.jpg' -o='output'   
```

Contents.jsonと複数のpngファイルが作成されます。  
これらのファイルをXcodeプロジェクトの AppIcon.appiconset にコピーします。


## tvOSのアイコンについて

tvOSアプリ向けのアイコンを作成するには。4640px x 1440px の画像を用意します。  
この画像からApp Icon.imagestack、Top Shelf Image.imageset、Top Shelf Image Wide.imagesetのアイコンを作成します。


```
$ appiconset tvos -i='sample.jpg' -o='output'   
```