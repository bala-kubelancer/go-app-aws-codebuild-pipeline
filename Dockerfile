# Stage 1: Build
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum first
COPY go.mod  ./
RUN go mod download

# Copy source code
COPY . .

# Build the Go binary
RUN go build -o server .

# Stage 2: Run
FROM alpine:3.20

WORKDIR /app

# Copy only necessary files
COPY --from=builder /app/server .
COPY --from=builder /app/templates ./templates

EXPOSE 8080

CMD ["./server"]
