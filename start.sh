#!/bin/zsh
# zsh start.sh `contest`

if [ $# -ne 1 ]; then
    echo Error: contest-id does not exist;
    exit 1
fi

if [ -e '.env' ]; then
    . ./.env
else;
    echo -n 'Your AtCoder Username: '
    read username
    echo -n 'Your AtCoder Password: '
    read password
    echo "username=$username\npassword=$password" >> .env
fi

echo 'login AtCoder'
poetry run oj login https://atcoder.jp/ <<< "$username\n$password"
acc login <<< "$username\n$password"

acc new $1 <<< 'a\n'

/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --print-to-pdf --headless "https://atcoder.jp/contests/$1/tasks_print?lang=ja"
mv output.pdf $1/problems.pdf