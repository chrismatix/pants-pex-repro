python_sources(
    name = "lib",
)

pex_binary(
    name = "bin",
    dependencies = [
        ":lib",
    ],
    entry_point = "__init__.py",
)

pex_binary(
    name = "script",
    entry_point = "script.py",
)
