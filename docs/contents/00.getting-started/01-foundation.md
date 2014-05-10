
# Foundation

This guide will go over the foundation of what a Koding App is, where they are
located, and some general tips. In the following sections we'll cover creating
applications, modifying them, and publishing them. So let's get started!

## What are Koding apps?

Koding applications are essentially WebApps for your VM. More precisely, when
you open a Koding application a single JavaScript file is loaded and executed in
your browser. Once loaded in your browser, the JavaScript of the application is
able to add html to a special DOM element created for it. To do this, it uses
the KDFramework.

The KDFramework covers everything from DOM manipulation to I/O with your VM.
Enabling you to combine the best of HTML5 Interfaces with a full Unix
environment.

## File Structure

A Koding application is located in a folder found within the `~/Applications` 
directory. This folder is in the format of `appname.kdapp`, with at least two 
important files in it; A `manifest.json` file and a `index.js` file.

Any files beyond this are optional, and depend on whatever the application
author decided that they want. Traditionally KDApps are programmed in
CoffeeScript and compiled into the main `index.js` file. Technically speaking
you're free to use whatever language you want, such as JavaScript, Dart,
TypeScript, or LiveScript. Just be aware that the KDFramework itself is written
in CoffeeScript, and much of the usage revolves around Coffee-centric class
structure. At the end of the day though, it's all "just JavaScript".

## Compilation

When a KDApp is requested, such as by visiting 
`https://koding.com/YourAppName`, the `index.js` file is loaded. If it doesn't 
exist however, a compilation tool called `kdc` is executed in the application 
directory to compile the files specified in the `"files":[]` list.

`kdc` then compiles the files to JavaScript, and concatenates them one after
another and finally writes the product to the `index.js` file.

## Creating your first KDApp

Now that we've talked about what KDApps are, lets [create one][1]!


[1]: ./02-hello.md
