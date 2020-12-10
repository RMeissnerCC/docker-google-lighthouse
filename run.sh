poetry export -o requirements.txt

docker build -t oeh-search-meta_lighthouse:latest .

docker-compose -f docker-compose.yml up
