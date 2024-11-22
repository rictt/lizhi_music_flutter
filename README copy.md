# 前沿

  本项目是基于flutter开发的李志听歌软件

## 功能

## 打包

- 打包apk

  ```sh
  flutter build apk  --no-tree-shake-icons    
  ```

## 其他
  - iconfont快速生成MyIcons代码

    ```js
    // 在控制台运行
    copy(Array.from(document.querySelectorAll('.icon-item')).map(e => {
    let [code, name] = e.querySelectorAll('.icon-code');
    code = code.innerText.replace(";", "").replace("&#", "0");
    name = name.title;
    // return {code, name}
    return `static IconData ${name} = createMyIcon(${code});`
}).join(''));
    ```