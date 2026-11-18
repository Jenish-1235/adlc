// Command api serves the service's HTTP API. It is the only place that wires
// dependencies together; business logic lives under internal/.
package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	logger := slog.New(slog.NewTextHandler(os.Stderr, nil))
	err := run(ctx, logger, os.Getenv)
	stop()
	if err != nil {
		logger.Error("api stopped", "err", err)
		os.Exit(1)
	}
}

// run serves until ctx is cancelled, then shuts down gracefully. PORT and HOST
// choose the listen address (default 127.0.0.1:8080).
func run(ctx context.Context, logger *slog.Logger, getenv func(string) string) error {
	addr := net.JoinHostPort(withDefault(getenv("HOST"), "127.0.0.1"), withDefault(getenv("PORT"), "8080"))
	srv := &http.Server{
		Addr:              addr,
		Handler:           newHandler(),
		ReadHeaderTimeout: 5 * time.Second,
	}

	var wg sync.WaitGroup
	serveErr := make(chan error, 1)
	wg.Go(func() { serveErr <- srv.ListenAndServe() })
	logger.InfoContext(ctx, "listening", "addr", addr)

	select {
	case err := <-serveErr:
		wg.Wait()
		return fmt.Errorf("serve on %s: %w", addr, err)
	case <-ctx.Done():
	}

	shutdownCtx, cancel := context.WithTimeout(context.WithoutCancel(ctx), 10*time.Second)
	defer cancel()
	err := srv.Shutdown(shutdownCtx)
	wg.Wait()
	if err != nil {
		return fmt.Errorf("shut down: %w", err)
	}
	if err := <-serveErr; !errors.Is(err, http.ErrServerClosed) {
		return fmt.Errorf("serve on %s: %w", addr, err)
	}
	return nil
}

func newHandler() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"status":"ok"}`))
	})
	return mux
}

func withDefault(value, fallback string) string {
	if value == "" {
		return fallback
	}
	return value
}
