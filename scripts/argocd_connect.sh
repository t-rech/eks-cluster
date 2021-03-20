kill_connection() {
    if PID="$(lsof -ti tcp:8080)"; then
      printf 'Killing the following command running on 8080:\n%s\n' "$(ps -p "$PID")"
      kill -SIGTERM "$PID"
    fi
}

connect() {
    kill_connection
    kubectl port-forward svc/argocd-server -n argocd 8080:443 2>&1 >/dev/null &
    PORT_FORWARD_PID=$!
    while ! nc -zv 127.0.0.1 8080 2>/dev/null; do
    if ! kill -0 "$PORT_FORWARD_PID" 2>/dev/null; then
        printf '\n[ Error ] Unable to connect to ArgoCD. Timeout waiting for connection.\n' > /dev/stderr
        return 1
    fi
    sleep 1
    done
}

connect