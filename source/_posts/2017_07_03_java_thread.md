---
title: JAVA线程总结
date: 2017-07-03 16:32:00
comments: false
tags: [java,线程,同步]
categories: 技术
permalink: java_thread
---
# 什么是线程？
线程是进程的一个实体，是CPU调度和分派的基本单位，它是比进程更小的能独立运行的基本单位。线程自己基本上不拥有系统资源，只拥有一点在运行中必不可少的资源(如程序计数器，一组寄存器和栈)，但是它可与同属一个进程的其他的线程共享进程所拥有的全部资源。

有时候我们说线程是轻量级进程。就象进程一样，线程在程序中是独立的、并发的执行路径，每个线程有它自己的堆栈、自己的程序计数器和自己的局部变量。但是，与分隔的进程相比，进程中的线程之间的隔离程度要小。它们共享内存、文件句柄和其它每个进程应有的状态。

Java语言是第一个在语言本身中显式地包含线程的主流编程语言，它没有把线程化看作是底层操作系统的工具。

# 为什么要用线程？
- 响应更快的 UI
（如GUI中事件线程）
- 利用多处理器系统
（单处理器多线程本质是处理器的短时间间隔复用，多处理器多线程就可以高效使用多处理器系统）
- 简化建模
（比如五大常用算法中的分治法，求多维数组的排序问题，多线程可以简化建模）
- 异步或后台处理
（这个很常见，比如轮询套接字，异步响应请求，servlet请求等等）

**先不管那么多，看一个简单线程：一个计时线程案例**
```java
/**
* 一个线程案例： （计时功能）
* 主线程开启一个打印素数的线程之后，主线程自己休息10秒，
* 10秒之后通过改变finished状态值，break新线程。
*/
public class CalculatePrimes extends Thread{
    public static final int MAX_PRIMES = 1000000;
    public static final int TEN_SECONDS = 10000;
    public volatile boolean finished = false;
    public void run(){
        int[] primes = new int[MAX_PRIMES];
        int count = 0;
        for (int i=2; count<MAX_PRIMES; i++){
            // Check to see if the timer has expired
            if (finished) {
            break;
            }
            boolean prime = true;
            for (int j=0; j<count; j++){
                if (i % primes[j] == 0){
                    prime = false;
                    break;
                }
            }
            if (prime){
                primes[count++] = i;
                System.out.println("Found prime: " + i);
            }
        }
    }

    public static void main(String[] args){
        CalculatePrimes calculator = new CalculatePrimes();
        calculator.start();
        try {
            Thread.sleep(TEN_SECONDS);
        }
        catch (InterruptedException e){
            // fall through
        }
        calculator.finished = true;
    }
}
```

# 线程的使用方法
## 从生命周期5状态说起
- 新建（new Thread）
当创建Thread类的一个实例（对象）时，此线程进入新建状态（未被启动）。
例如：Thread  t1=new Thread();
- 就绪（runnable）
线程已经被启动，正在等待被分配给CPU时间片，也就是说此时线程正在就绪队列中排队等候得到CPU资源。例如：t1.start();
- 运行（running）
线程获得CPU资源正在执行任务（run()方法），此时除非此线程自动放弃CPU资源或者有优先级更高的线程进入，线程将一直运行到结束。
- 死亡（dead）
当线程执行完毕或被其它线程杀死，线程就进入死亡状态，这时线程不可能再进入就绪状态等待执行。
自然终止：正常运行run()方法后终止
异常终止：调用stop()方法让一个线程终止运行
- 堵塞（blocked）
由于某种原因导致正在运行的线程让出CPU并暂停自己的执行，即进入堵塞状态。
正在睡眠：用sleep(longt)方法可使线程进入睡眠方式。一个睡眠着的线程在指定的时间过去可进入就绪状态。
正在等待：调用wait()方法。（调用motify()方法回到就绪状态）
被另一个线程所阻塞：调用suspend()方法。（调用resume()方法恢复）

## 三种创建线程的方法
1.继承Thread类创建线程类
（1）定义Thread类的子类，并重写该类的run方法，该run方法的方法体就代表了线程要完成的任务。因此把run()方法称为执行体。
（2）创建Thread子类的实例，即创建了线程对象。
（3）调用线程对象的start()方法来启动该线程。
```java
public class FirstThreadTest extends Thread{

    int i = 0;
    //重写run方法，run方法的方法体就是现场执行体
    public void run(){
        for(;i<100;i++){
        System.out.println(getName()+"  "+i);
        }
    }

    public static void main(String[] args){
        for(int i = 0;i< 100;i++){
            System.out.println(Thread.currentThread().getName()+"  : "+i);
            if(i==20){
                new FirstThreadTest().start();
                new FirstThreadTest().start();
            }
        }
    }
}
```
2.通过Runnable接口创建线程类
（1）定义runnable接口的实现类，并重写该接口的run()方法，该run()方法的方法体同样是该线程的线程执行体。
（2）创建 Runnable实现类的实例，并依此实例作为Thread的target来创建Thread，该Thread对象才是真正的线程对象。
（3）调用线程对象的start()方法来启动该线程。
```java
public class RunnableThreadTest implements Runnable{

    private int i;
    public void run(){
        for(i = 0;i <100;i++){
            System.out.println(Thread.currentThread().getName()+" "+i);
        }
    }
    public static void main(String[] args){
        for(int i = 0;i < 100;i++){
            System.out.println(Thread.currentThread().getName()+" "+i);
            if(i==20){
                RunnableThreadTest rtt = new RunnableThreadTest();
                new Thread(rtt,"新线程1").start();
                new Thread(rtt,"新线程2").start();
            }
        }
    }
}

```
3.通过Callable和Future创建线程
（1）创建Callable接口的实现类，并实现call()方法，该call()方法将作为线程执行体，并且有返回值。
（2）创建Callable实现类的实例，使用FutureTask类来包装Callable对象，该FutureTask对象封装了该Callable对象的call()方法的返回值。
（3）使用FutureTask对象作为Thread对象的target创建并启动新线程。
（4）调用FutureTask对象的get()方法来获得子线程执行结束后的返回值。
```java
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;

public class CallableThreadTest implements Callable<Integer>{

    @Override
    public Integer call() throws Exception{
        int i = 0;
        for(;i<100;i++){
            System.out.println(Thread.currentThread().getName()+" "+i);
        }
        return i;
    }

    public static void main(String[] args){
        CallableThreadTest ctt = new CallableThreadTest();
        FutureTask<Integer> ft = new FutureTask<>(ctt);
        for(int i = 0;i < 100;i++){
            System.out.println(Thread.currentThread().getName()+" 的循环变量i的值"+i);
            if(i==20){
                new Thread(ft,"有返回值的线程").start();
            }
        }
        try{
            System.out.println("子线程的返回值："+ft.get());
        } catch (InterruptedException e){
            e.printStackTrace();
        } catch (ExecutionException e){
            e.printStackTrace();
        }
    }
}
```
采用实现Runnable、Callable接口的方式创见多线程时，优势是：
线程类只是实现了Runnable接口或Callable接口，还可以继承其他类。
在这种方式下，多个线程可以共享同一个target对象，所以非常适合多个相同线程来处理同一份资源的情况，从而可以将CPU、代码和数据分开，形成清晰的模型，较好地体现了面向对象的思想。
劣势是：
编程稍微复杂，如果要访问当前线程，则必须使用Thread.currentThread()方法。

使用继承Thread类的方式创建多线程时优势是：
编写简单，如果需要访问当前线程，则无需使用Thread.currentThread()方法，直接使用this即可获得当前线程。
劣势是：
线程类已经继承了Thread类，所以不能再继承其他父类。

## 一些常见API
在介绍生命周期的时候，我们已经接触了一些常见API,建议直接看API文档[JDK7-API-java.lang.Thread](http://tool.oschina.net/apidocs/apidoc?api=jdk_7u4)
```java
/**
常用API
**/

//几毫秒加几纳秒之后调用线程将阻塞，直到目标线程完成为止.调用线程继续。
void join();
void join(long millis);
void join(long millis,int nanos);

//继承Object.导致线程进入等待状态，直到它被其他线程通过notify()或者notifyAll唤醒。该方法只能在同步方法中调用。如果当前线程不是锁的持有者，该方法抛出一个IllegalMonitorStateException异常。
void wait();
void wait(long millis);
void wait(long millis,int nanos);

//随机选择一个在该对象上调用wait方法的线程，解除其阻塞状态。该方法只能在同步方法或同步块内部调用。如果当前线程不是锁的持有者，该方法抛出一个IllegalMonitorStateException异常。
void notify();

//解除所有那些在该对象上调用wait方法的线程的阻塞状态。该方法只能在同步方法或同步块内部调用。如果当前线程不是锁的持有者，该方法抛出一个IllegalMonitorStateException异常。
void notifyAll();

/**
wait、notify和notifyAll方法是Object类的final native方法。所以这些方法不能被子类重写，Object类是所有类的超类，因此在程序中有以下三种形式调用wait等方法。

wait();//方式1：

this.wait();//方式2：

super.wait();//方式3
**/

//将使当前线程进入等待状态，直到过了一段指定时间，或者直到另一个线程对当前线程的Thread对象调用了Thread.interrupt()，从而中断了线程。
//当过了指定时间后，线程又将变成可运行的，并且回到调度程序的可运行线程队列中。
//如果线程是由对 Thread.interrupt() 的调用而中断的，那么休眠的线程会抛出InterruptedException，这样线程就知道它是由中断唤醒的，就不必查看计时器是否过期。
static void sleep(long millis);
static void sleep(long millis, int nanos);

//中断发起调用的线程。
void interrupt();

//就像sleep() 一样，但它并不引起休眠，而只是暂停当前线程片刻，这样其它线程就可以运行了。
//在大多数实现中，当较高优先级的线程调用Thread.yield() 时，较低优先级的线程就不会运行。
static void yield();

//指明某个线程是守护程序线程。
void setDaemon (boolean on)


//启动线程
void start();

//结束线程
void stop();


```

## 关于守护线程
大概是受到操作系统中守护进程的设计思路，在设计java线程的时候也同样的也有守护线程机制。

java的线程分为两类：User Thread(用户线程)、Daemon Thread(守护线程)，其实User Thread线程和Daemon Thread守护线程本质上来说去没啥区别的，唯一的区别之处就在虚拟机的离开：如果User Thread全部撤离，那么Daemon Thread也就没啥线程好服务的了，所以虚拟机也就退出了。

Java语言机制是构建在JVM的基础之上的，java内部的守护线程也存在与JVM中，比如GC线程。

守护线程并非虚拟机内部可以提供，用户也可以自行的设定守护线程，方法：public final void setDaemon(boolean on) ；但是有几点需要注意：

1. thread.setDaemon(true)必须在thread.start()之前设置，否则会跑出一个IllegalThreadStateException异常。你不能把正在运行的常规线程设置为守护线程。  （备注：这点与守护进程有着明显的区别，守护进程是创建后，让进程摆脱原会话的控制+让进程摆脱原进程组的控制+让进程摆脱原控制终端的控制；所以说寄托于虚拟机的语言机制跟系统级语言有着本质上面的区别）

2. 在Daemon线程中产生的新线程也是Daemon的。   （这一点又是有着本质的区别了：守护进程fork()出来的子进程不再是守护进程，尽管它把父进程的进程相关信息复制过去了，但是子进程的进程的父进程不是init进程，所谓的守护进程本质上说就是“父进程挂掉，init收养，然后文件0,1,2都是/dev/null，当前目录到/”）

3. 不是所有的应用都可以分配给Daemon线程来进行服务，比如读写操作或者计算逻辑。因为在Daemon Thread还没来的及进行操作时，虚拟机可能已经退出了。

**例子：**
```java
import java.io.*;

class TestRunnable implements Runnable{
    public void run(){
        try{
            Thread.sleep(1000);//守护线程阻塞1秒后运行
            File f=new File("daemon.txt");
            FileOutputStream os=new FileOutputStream(f,true);
            os.write("daemon".getBytes());
        }catch(IOException e1){
            e1.printStackTrace();
        }catch(InterruptedException e2){
            e2.printStackTrace();
        }
    }
}

public class TestDemo2{
    public static void main(String[] args) throws InterruptedException{
        Runnable tr=new TestRunnable();
        Thread thread=new Thread(tr);
        //thread.setDaemon(true);
        thread.setDaemon(true); //设置守护线程
        thread.start(); //开始执行分进程
    }
}

```
运行结果：文件daemon.txt中没有"daemon"字符串。

但是如果把thread.setDaemon(true); 注释掉，文件daemon.txt是可以被写入daemon字符串的。

JVM判断程序是否执行结束的标准是所有的前台执线程行完毕了，而不管后台线程（守护线程）的状态，因此，在使用守护线程的时候一定要注意这个问题。

举个例子，web服务器中的Servlet容器启动时后台初始化一个服务线程，即调度线程，负责处理http请求，然后每个请求过来调度线程从线程池中取出一个工作者线程来处理该请求，从而实现并发控制的目的。

## 同步的问题
为了确保可以在线程之间以受控方式共享数据，Java语言提供了两个关键字：synchronized 和 volatile。

Volatile 只适合于控制对基本变量（整数、布尔变量等）的单个实例的访问。当一个变量被声明成volatile，任何对该变量的写操作都会绕过高速缓存，直接写入主内存，而任何对该变量的读取也都绕过高速缓存，直接取自主内存。这表示所有线程在任何时候看到的 volatile 变量值都相同，这保证了变量的一致性，但是如果要保护比较大的代码段还需要用Synchronized。

Synchronized 同步：

同步使用监控器（monitor）或锁的概念，以协调对特定代码块的访问。

每个 Java 对象都有一个相关的锁。同一时间只能有一个线程持有 Java 锁。当线程进入synchronized代码块时，线程会阻塞并等待，直到锁可用，当它可用时，就会获得这个锁，然后执行代码块。当控制退出受保护的代码块时，即到达了代码块末尾或者抛出了没有在 synchronized 块中捕获的异常时，它就会释放该锁。

这样，每次只有一个线程可以执行受给定监控器保护的代码块。从其它线程的角度看，该代码块可以看作是原子的，它要么全部执行，要么根本不执行。

**例子：**
```java
public class SyncExample {
    private static lockObject = new Object();

    private static class Thread1 extends Thread {
        public void run() {
            synchronized (lockObject) {
                x = 0;
                y = 0;
                System.out.println(x);
            }
        }
    }

    private static class Thread2 extends Thread {
        public void run() {
            synchronized (lockObject) {
                x = 1;
                y = 1;
                System.out.println(y);
            }
        }
    }

    public static void main(String[] args) {
        new Thread1().run();
        new Thread2().run();
    }
}
```
使用 synchronized 块可以让您将一组相关更新作为一个集合来执行，而不必担心其它线程中断或看到计算的中间结果。以下示例代码将打印“10”或“01”。如果没有同步，它还会打印“1 1” 或“0 0”。

以上是synchronized 块的原理，除此之外还可以同步一个方法：
```java
public class Point {
    private x;private y;
    public synchronized void setXY(int x, int y) {
    this.x = x;
    this.y = y;
    }
}


```
对于普通的 synchronized 方法，这个锁是一个对象，将针对它调用方法。对于静态 synchronized方法，这个锁是本对象，在该对象中声明了方法。仅仅因为 setXY() 被声明成 synchronized 并不表示两个不同的线程不能同时执行 setXY()，只要
它们调用不同的 Point 实例的 setXY() 就可同时执行。对于一个 Point 实例，一次只能有一个线程执行 setXY()。

**示例：简单的线程安全的高速缓存：**
```java
public class SimpleCache{
    private final Map cache = new HashMap();

    public Object load(String objectName){
    // load the object somehow
    }

    public void clearCache(){
        synchronized (cache){
        cache.clear();
        }
    }

    public Object getObject(String objectName) {
        synchronized (cache){
            Object o = cache.get(objectName);
            if (o == null){
                o = load(objectName);
                cache.put(objectName, o);
            }
        }
    return o;
    }
}
```
***以上代码，使用 HashMap 为对象装入器提供了一个简单的高速缓存。load()方法知道怎样按对象的键装入对象。在一次装入对象之后，该对象就被存储到高速缓存中，这样以后的访问就会从高速缓存中检索它，而不是每次都全部地装入它。对共享高速缓存的每个访问都受到synchronized 块保护。由于它被正确同步，所以多个线程可以同时调用 getObject 和
clearCache 方法，而没有数据损坏的风险。***

## 同步？不同步？
什么时候必须同步？
- 需要保证在多线程中，一部分数据是一致的即用于一致性的同步
- 递增共享计数器（多线程共用一个计数器类或方法），本质还是一致性
- final字段是线程友好的，不必担心同步问题

什么时候不需要同步？
- 由静态初始化器（在静态字段上或 static{} 块中的初始化器）初始化数据时，JVM隐性的帮我们同步了
- 访问final变量时
- 死锁
- 性能考虑

同步准则？
- 使代码块保持简短。Synchronized块应该简短,在保证相关数据操作的完整性的同时，
尽量简短。把不随线程变化的预处理和后处理移出 synchronized 块
- 不要阻塞。不要在 synchronized块或方法中调用可能引起阻塞的方法，如InputStream.read()
- 在持有锁的时候，不要对其它对象调用方法。这听起来可能有些极端，但它消除了最常见的死锁源头。




# 其他一些案例
## 使用java.util.TimerTask解决计数器的问题
这是上文的案例，我们可以不让主线程休眠，方法如下：
```java
/**
* 一个线程案例： （计时功能）
* 主线程开启一个打印素数的线程之后，主线程自己休息10秒，
* 10秒之后通过改变finished状态值，break新线程。
*/
public class CalculatePrimes extends Thread{
    public static final int MAX_PRIMES = 1000000;
    public static final int TEN_SECONDS = 10000;
    public volatile boolean finished = false;
    public void run(){
        int[] primes = new int[MAX_PRIMES];
        int count = 0;
        for (int i=2; count<MAX_PRIMES; i++){
            // Check to see if the timer has expired
            if (finished) {
            break;
            }
            boolean prime = true;
            for (int j=0; j<count; j++){
                if (i % primes[j] == 0){
                    prime = false;
                    break;
                }
            }
            if (prime){
                primes[count++] = i;
                System.out.println("Found prime: " + i);
            }
        }
    }

    public static void main(String[] args){
        Timer timer = new Timer();
        final CalculatePrimes calculator = new CalculatePrimes();
        calculator.start();
        timer.schedule(
            new TimerTask() {
                public void run(){
                    calculator.finished = true;
                }
            }, TEN_SECONDS);
    }
}
```
## servlet 和 JavaServer Pages 技术
## 实现 RMI 对象