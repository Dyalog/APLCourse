# External Interfaces
In an ideal world, we'd spend our entire lives blissfully in the warm comfort of the APL session. All of our data would magically appear and we would write perfect, beautiful algorithms to solve idealised problems.

In the real world, we must interface with external systems. After all, the entire point of learning this tool is to use it to solve real world problems.

## Name Association
Sufficiently knowledgeable programmers can interface directly between APL and a compiled library using `⎕NA`. Input and output data types must be explicitly declared. For more information see [the online documentation about ⎕NA](http://help.dyalog.com/latest/#Language/System%20Functions/na.htm).

## APL as a Shared Library
It is also possible to bundle an APL application as a compiled native shared or static object (.dll, .dylib or .so) which exposes APL functions and makes them accessible via another programming language or application's [foreign function interface](https://en.wikipedia.org/wiki/Foreign_function_interface). 

Examples of usage and links to documentation are available on [github.com/Dyalog/NativeLib](https://github.com/Dyalog/NativeLib)

## Py'n'APL
Start instances of Python from Dyalog, and start instances of Dyalog from Python. Leverage the convenience of Python's vast collection of libraries and combine it with the expressive power of APL. See [github.com/Dyalog/pynapl](https://github.com/Dyalog/pynapl) for more information.

## RSConnect and RConnect
R is a very popular language with a large collection of statistical libraries. Two R interfaces exist for Dyalog:

[RSconnect R interface for Dyalog](https://github.com/kimmolinna/rsconnect) using Rserve

[RConnect R interface for Dyalog](https://docs.dyalog.com/latest/R%20Interface%20Guide.pdf) using rscproxy

## .NET
Microsoft's .NET Framework contains a plethora of useful libraries for business applications. 

To enable reference to .NET namespaces, set `⎕USING`:
```APL
      ⎕USING←''
      System.TimeZone.CurrentTimeZone.StandardName
GMT Standard Time
```

Set the system variable `⎕USING` in order to access names within .NET namespaces.  
```APL
      ⎕USING←'System'
      TimeZone.CurrentTimeZone.StandardName
GMT Standard Time
```

In recent years, Microsoft have been developing a cross-platform equivalent called .NET Core (or .NET 5). This allows the same libraries to be used on Microsoft Windows, macOS and Linux. It must be installed separately and enabled by setting the [configuration parameter](http://help.dyalog.com/latest/#UserGuide/Installation%20and%20Configuration/Configuration%20Parameters.htm) `DYALOG_NETCORE=1`.

## COM/OLE
Dyalog is able to directly control certain Microsoft applications using the [Component Object Model](https://en.wikipedia.org/wiki/Component_Object_Model). For examples, see:

- [Dyalog Webinar: APL and Microsoft Excel](https://dyalog.tv/Webinar/?v=hs90SdUc9dE)
- [Document: Charting the APL/Excel waters](https://www.dyalog.com/uploads/conference/dyalog11/presentations/C05_using_excel_under_apl/officeauto11.pdf)
- [Chapter 9 of the Dyalog for Microsoft Windows Interfaces Guide](https://docs.dyalog.com/latest/Dyalog%20for%20Microsoft%20Windows%20Interface%20Guide.pdf#page=185).

## ⎕NULL
The core APL language does not have a "null" value as such. While you might think that the empty numeric vector `⍬` could be considered a type of "null", it already has type information associated with it so it doesn't really work - it is more accurate to call it an *empty numeric vector*. In order to cooperate with the COM and .NET interfaces described above, Dyalog has a proper null value which can be invoked with `⎕NULL`.

## Conga and HTTP
[Conga]() is the core TCP/IP framework for Dyalog. On top of this, there are several higher level utilities for various web-based applications.

[HttpCommand](../Data/#downloading-data-from-the-internet) can be used to issue requests to web servers and retrieve data.

[Jarvis](https://github.com/Dyalog/Jarvis) is a very convenient way to expose APL functions as either a JSON or RESTful web service. It can even serve a simple static web interface and is the web service component of [TryAPL](https://tryapl.org).

[DUI](https://github.com/Dyalog/DUI/) (Dyalog User Interface) is a cross-platform GUI framework for building web-based front-ends in APL. It includes its own web server, so the same code can be used for a standalone desktop application, web app and website. There is an example site for its predecessor (identical in most ways, but without standalone desktop deployment) called [MiServer](https://miserver.dyalog.com).
