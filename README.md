# Restaurant Template

A template made with [Harp.js](http://harpjs.com/) with a front-end and back-end layout specifically for restaurants

## Getting Started


### Prerequisites

You must have harp.js installed on your system. Optionally, you can also install [Browsersync](https://www.browsersync.io/) in order to run the NPM script that is included with this repo.

You can do either of the two by running
```
npm install -g harp
```
```
npm install -g browser-sync
```

### Installing

You will want to fork this repo and clone into your local computer by running

```
git clone [repo-name] [directory] <--- optional
```

Then, traverse into the directory that was just made and run either of the two commands (based on if you have browser-sync or not)

#### With Browsersync

```
npm run dev
```

#### Without Browsersync

```
harp server [--port 8080] <---- optional
```

## Built With

* [Harp.js](http://harpjs.com) - A JavaScript based static site generator / server