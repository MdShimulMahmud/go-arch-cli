package cmd

import (
	"testing"
)

func TestRootCmd(t *testing.T) {
	// Test that root command can be executed
	if rootCmd == nil {
		t.Error("rootCmd should not be nil")
	}

	if rootCmd.Use != "go-arch-cli" {
		t.Errorf("Expected command name to be 'go-arch-cli', got %s", rootCmd.Use)
	}
}

func TestVersion(t *testing.T) {
	if Version == "" {
		t.Error("Version should not be empty")
	}
}
