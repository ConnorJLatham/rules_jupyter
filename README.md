bazel rules for running jupyter notebooks.

If you run
```bazel
bazel run //:jupyter
```
a jupyterlab setup will start in --core-mode, meaning no extensions are enabled. This notebook will also not have access to the local src files, just the generated ones. It can be useful for quickly creating notebooks and testing them.

TODOs
1. Make a notebook_directory rule that has access to the notebooks in that source directory. This also collects all the notebooks and runs them as part of a test so that failing notebooks are not kept around. Could look at using https://github.com/treebeardtech/nbmake and https://github.com/caseyduquettesc/rules_python_pytest/tree/main
1. Make a jupyterlab application directory using a repo rule and allow users to install extensions to it. Then use this as the jupyterlab server that notebooks interact with. Could declare multiple different ones similar to declaring different python pypis or using different rust toolchains.

