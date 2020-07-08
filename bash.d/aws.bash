if command -v aws_completer &> /dev/null; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
export AWS_DEFAULT_OUTPUT=json # json, yaml, text, table
export AWS_PAGER=""
