package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

const (
	host = "localhost"
	port = "8080"
)

var (
	appName    = os.Getenv("APP_NAME")
	appVersion = os.Getenv("APP_VERSION")
)

func GetInfo(w http.ResponseWriter, r *http.Request) {
	info := fmt.Sprintf("Hello %s application version %s \n", appName, appVersion)
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, info)
}

func main() {
	fmt.Println("Initializing the router...")
	router := mux.NewRouter()
	router.HandleFunc("/hello", GetInfo).Methods("GET")

	fmt.Printf("Starting server %s on port %s..\n", host, port)

	hostname := fmt.Sprintf("%s:%s", host, port)
	err := http.ListenAndServe(hostname, router)
	if err != nil {
		message := fmt.Sprintf("Failing to start the %q server: %s", hostname, err)
		log.Fatal(message)
	}
}
