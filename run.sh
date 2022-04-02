# 1-) Criar o arquivo de segurança

# 2-) Criar o role de segurança na AWS

aws iam create-role \
    --role-name lambda-exemplo \
    --assume-role-policy-document file://politicas.json \
    | tee logs/role.log

# 3-) Criar arquivo com conteúdo e zipa-lo

tar -cvzf function.zip index.js

aws lambda create-function \
    --function-name hello-cli \
    --zip-file fileb://function.zip \
    --handler index.handler \
    --runtime nodejs14.x \
    --role arn:aws:iam::278345320462:role/lambda-exemplo \
    | tee logs/lambda-create.log

# 4-) Invoke lambda function

aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec.log

# 5-) Zipar e atualizar

tar -cvzf function.zip index.js

aws lambda update-function-code \
    --zip-file fileb://function.zip \
    --function-name hello-cli \
    --publish
    | tee logs/lambda-update.log

# 6-) Invoke denovo para ver o resultado

aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec-update.log

# 7-) Remover lambda function

aws lambda delete-function \
    --function-name hello-cli

aws iam delete-role \
    --role-name lambda-exemplo