package cnb

import (
	"bytes"
	"fmt"
	"os/exec"
	"syscall"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestDetection(t *testing.T) {
	testCases := []struct {
		name     string
		exitCode int
	}{
		{
			name:     "happy_path",
			exitCode: 0,
		},
		{
			name:     "no_aptfile",
			exitCode: 100,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			cmd := exec.Command("sh", "-c", fmt.Sprintf("cd testdata/%s && ../../bin/detect", tc.name))
			out := bytes.Buffer{}
			cmd.Stdout = &out
			cmd.Stderr = &out
			err := cmd.Start()
			require.NoError(t, err, "starting detect cmd")

			err = cmd.Wait()
			if tc.exitCode == 0 {
				require.NoErrorf(t, err, "cmd output: %s", out.String())
				return
			}

			exiterr, ok := err.(*exec.ExitError)
			require.True(t, ok, "expected type *exec.ExitError")
			status, ok := exiterr.Sys().(syscall.WaitStatus)
			require.True(t, ok, "expected type syscall.WaitStatus")
			require.Equalf(t, tc.exitCode, status.ExitStatus(), "exit code not equal\ncmd output: %s", out.String())
		})
	}
}
