##一个瀑布流的设计与实现medo（已经实现缓存池功能，并集成上拉、下拉刷新）

<p align="center">

<img src = "http://images2015.cnblogs.com/blog/471463/201509/471463-20150912212457684-585830854.png">
<img src ="http://images2015.cnblogs.com/blog/471463/201509/471463-20150912213125372-589808688.png" alt = "瀑布流" title = "瀑布流">

用法：

与UITableView相似，需要遵守delegate\dataSource，实现对应的方法，详细请看medo
如果需要了解设计的思路，可以参考：http://www.cnblogs.com/ziyi--caolu/p/4803756.html