#!/bin/zsh

if [ ! -e $(which poetry) ] ; then
    echo 'You should install poetry manually at first'
    exit 1
fi

if [ ! -e $(which acc) ]; then
    npm install -g atcoder-cli
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

poetry install
poetry run oj login https://atcoder.jp/ <<< "$username\n$password"
acc login <<< "$username\n$password"

acc_path=$(acc config-dir)
cp $acc_path/config.json $acc_path/config-copy.json
: > $acc_path/config.json
while read -r line; do
    if echo $line | grep -q '^{'; then
        echo $line  >> $acc_path/config.json
    elif echo $line | grep -q 'default-test-dirname-format'; then
        echo '\t"default-test-dirname-format": "test",' >> $acc_path/config.json
    elif echo $line | grep -q 'default-template'; then
        echo '\t"default-template": "python"' >> $acc_path/config.json
    else
        echo "\t$line" >> $acc_path/config.json
    fi
done < $acc_path/config-copy.json
echo '}' >> $acc_path/config.json
rm $acc_path/config-copy.json

mkdir -p $acc_path/python
touch $acc_path/python/main.py
cat > $acc_path/python/template.json << EOF
{
    "task": {
        "program": [
            "main.py"
        ],
        "submit": "main.py"
    }
}
EOF