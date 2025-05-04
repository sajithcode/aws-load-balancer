#!/bin/bash

# Start containers
docker-compose up -d

# Wait for services to start
sleep 10

# Test without load balancing
echo "Testing without load balancing..."
ab -n 1000 -c 100 http://nginx-backend1/ > results_no_lb.txt

# Test with load balancing
echo "Testing with load balancing..."
ab -n 1000 -c 100 http://nginx-lb/ > results_with_lb.txt

# Compare results
echo "Results without LB:"
cat results_no_lb.txt | grep "Requests per second"
echo "Results with LB:"
cat results_with_lb.txt | grep "Requests per second"

# Cleanup
docker-compose down