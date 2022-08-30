# please reference
# https://github.com/cheshirekow/cmake_format#configuration

# ----------------------------------
# Options affecting listfile parsing
# ----------------------------------
with section("parse"):

    # Specify structure for custom cmake functions
    additional_commands = {
        "qt_add_qml_module": {
            "pargs": 1,
            "kwargs": {
                "URI": 1,
                "VERSION": 1,
                "QML_FILES": "*"
            }

        },
        "qt_add_library": {
            "pargs": [
                {
                    "nargs": 1
                },
                {
                    "flags": [
                        "STATIC", "SHARED", "MODULE", "INTERFACE", "OBJECT"
                    ]
                },
                {
                    "nargs": "?",
                    "flags": ["MANUAL_FINALIZATION"]
                },
                {
                    "nargs": "*"
                }
            ]
        },
        "add_mc_library": {
            "pargs": 1,
            "kwargs": {
                "DEPENDS": "+",
                "PUBLIC_DEPENDS": "+",
                "PUBLIC_INCLUDES": "+",
                "SOURCES": "+",
            }
        },
        "add_mc_plugin": {
            "pargs": 1,
            "kwargs": {
                "DEPENDS": "+",
                "PUBLIC_DEPENDS": "+",
                "SOURCES": "+",
            }
        }
    }

    # -----------------------------
# Options affecting formatting.
# -----------------------------
with section("format"):
    line_width = 120
    tab_size = 4
    dangle_parens = True
    # max_pargs_hwrap = 2
    layout_passes = {
        # "KwargGroupNode": [
        # (0, False),
        #     (1, True),
        #     (2, True),
        #     (3, True),
        # ],
    }
    pass


# ------------------------------------------------
# Options affecting comment reflow and formatting.
# ------------------------------------------------
with section("markup"):

    pass

# ----------------------------
# Options affecting the linter
# ----------------------------
with section("lint"):
    pass

# -------------------------------
# Options affecting file encoding
# -------------------------------
with section("encode"):
    pass
# -------------------------------------
# Miscellaneous configurations options.
# -------------------------------------
with section("misc"):
    pass
