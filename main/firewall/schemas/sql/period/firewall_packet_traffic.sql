CREATE TABLE IF NOT EXISTS firewall_packet_traffic(
        `date` TIMESTAMP NOT NULL,
        `dropped_packets` BIGINT DEFAULT 0,
        INDEX(`date`)
);
