# zblog
  
 -[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)

该项目是使用spring boot + thymeleaf 开发个人博客项目.

初期开发已经完成,网站已经上线.

演示站: http://www.backender.cn

# 用户部分说明

作者抽空已经将用户修改，用户图像修改，密码修改等已经做了。
不过对裁剪图片的插件研究不深。做的比较粗糙。

此外需要注意的是，因为讲大部分公共信息已经封装在userinfo表中，所以此表不能为空。默认值作者已经给出了。

# 运行环境
- JDK 8
- Maven
- MySQL (or other SQL database)

# 主要技术

- Spring && Spring security && Spring boot
- Mybatis
- bootstrap
- flavr
- thymeleaf
- editor.md


# 安装步骤

0 - download or clone eumji-blog project

1 - Create the database using the **zblog.sql** file

2 - update the database info in resource/application.yml

3 - compile the modules using the command **mvn package -DskipTests**

4 - start the modules using the command **java -jar target/eumji-blog.jar**

5 - Type **http://localhost:8081/** into your browser


## 后台模块

登陆路径 /login

默认账号 admin
默认密码 admin

剩下的随意操作。

##注意事项

1.文章添加后默认是关闭的需要开启

2.用户相关的操作暂时没有做，后续在考虑进行开发

3.如果运行有问题，请先检查查看一下错误的原因，一般来说是不会有大问题。

## License

The eumji-blog is released under version 2.0 of the [Apache License](http://www.apache.org/licenses/LICENSE-2.0).

