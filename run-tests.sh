#!/bin/bash

# Start containers
docker-compose up -d

# Wait for services to start
sleep 10

# Get container IPs
BACKEND1_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' aws-load-balancer-nginx-backend1-1)
LB_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' aws-load-balancer-nginx-lb-1)

# Test without load balancing (direct to backend)
echo "Testing without load balancing..."
ab -n 1000 -c 100 http://$BACKEND1_IP/ > results_no_lb.txt

# Test with load balancing
echo "Testing with load balancing..."
ab -n 1000 -c 100 http://$LB_IP/ > results_with_lb.txt

# Compare results
echo "Results without LB:"
cat results_no_lb.txt | grep "Requests per second"
echo "Results with LB:"
cat results_with_lb.txt | grep "Requests per second"

# Cleanup
docker-compose down