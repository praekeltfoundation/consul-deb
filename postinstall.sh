# Create group
if ! getent group consul >/dev/null; then
    addgroup --system consul
fi

# Create user
if ! getent passwd consul >/dev/null; then
    adduser --ingroup consul \
            --home /var/lib/consul --no-create-home \
            --disabled-password \
            --system --shell /bin/false \
            --gecos "Consul user" consul
fi

# Set permissions for directories
for path in /var/run/consul /var/lib/consul /etc/consul.d; do
    chown -R consul:consul $path
    chmod 755 $path
done
