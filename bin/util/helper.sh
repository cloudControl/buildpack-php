function indent_head() {
    sed -u "s/^/-----> /"
}

function indent() {
    sed -u "s/^/       /"
}

# parameters: $ABSOLUTE_DIR
function clean_directory() {
    rm -rf $1
    mkdir $1
}
