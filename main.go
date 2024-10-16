package main

import (
	"context"
	"encoding/json"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/gorilla/mux"

	"github.com/sirupsen/logrus"
)

func main() {
	Timeout := time.Minute * 1

	router := mux.NewRouter().StrictSlash(true)
	router.NotFoundHandler = http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)

		text := "Hello-World"

		resp, _ := json.Marshal(text)
		_, _ = w.Write(resp)
	})

	server := &http.Server{
		Addr:         "0.0.0.0:8000",
		WriteTimeout: Timeout,
		ReadTimeout:  Timeout,
		IdleTimeout:  Timeout,
		Handler:      router,
	}
	go func() {
		if err := server.ListenAndServe(); err != nil {
			logrus.Fatal(err)
		}
	}()

	// Process signals channel
	sigChannel := make(chan os.Signal, 1)

	// Graceful shutdown via SIGINT
	signal.Notify(sigChannel, os.Interrupt)

	logrus.Info("Service running...")
	<-sigChannel // Block until SIGINT received

	ctx, cancel := context.WithTimeout(context.Background(), Timeout)
	defer cancel()

	_ = server.Shutdown(ctx)

	logrus.Info("Http Service shutdown")

}
