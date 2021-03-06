# Basic tests for the docker service
import pytest


def test_service_is_installed(host):
    docker = host.package("docker-ce")
    assert docker.is_installed
    assert docker.version.startswith("18.03")


def test_service_is_running(host):
    docker = host.service("docker")
    assert docker.is_running
    assert docker.is_enabled


def test_systemd_service_is_changed(host):
    systemd = host.file("/lib/systemd/system/docker.service")
    assert "$DOCKER_OPTS" in systemd.content
    assert "EnvironmentFile" in systemd.content
