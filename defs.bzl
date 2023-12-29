load("@rules_python//python:defs.bzl", "py_binary")

def _run_notebook_impl(ctx):
    runfiles = ctx.runfiles()
    file_to_run = ctx.attr.py_binary

    runfiles = runfiles.merge(file_to_run.default_runfiles)
    run_file = ctx.actions.declare_file("run")
    # just start in --core-mode https://github.com/jupyterlab/jupyterlab/blob/0a5e152dfb7e9d1dc6f8ba994c3f7fe2bc481420/jupyterlab/labapp.py#L434
    # I think long term itd be better to make a repo rule that sets up an app dir for jupyterlab so users could get extensions
    # but core-mode works for now
    run_file_contents = "./" + file_to_run.files_to_run.executable.short_path + " --core-mode\n"

    ctx.actions.write(
        content = run_file_contents,
        is_executable = True,
        output = run_file,
    )

    runfiles = runfiles.merge(ctx.runfiles([run_file]))

    return DefaultInfo(
        executable = run_file,
        runfiles = runfiles,
    )

run_notebook = rule(
    attrs = {
        "py_binary": attr.label(
            executable = True,
            cfg = "exec",
        ),
    },
    executable = True,
    implementation = _run_notebook_impl,
)

def py_notebook(name, deps = []):
    deps = deps + ["@external_py//jupyterlab"]

    py_binary(
        name = "{}.py_binary".format(name),
        srcs = ["jupyter.py"],
        main = "jupyter.py",
        deps = deps,
    )

    run_notebook(
        name = name,
        py_binary = ":{}.py_binary".format(name),
        tags = [
            "manual",
            "no-sandbox",
            "no-cache",
            "no-remote",
            "local",
            "requires-network",
        ],
    )
