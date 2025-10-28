package cmd

import "testing"

func TestValidateModuleName(t *testing.T) {
	cases := []struct {
		in string
		ok bool
	}{
		{"", false},
		{"github.com/user/project", true},
		{"invalid module", false},
		{"a", false},
		{"1invalid", false},
		{"github.com/user/project-1", true},
	}

	for _, c := range cases {
		err := validateModuleName(c.in)
		if (err == nil) != c.ok {
			t.Fatalf("validateModuleName(%q) expected ok=%v, got err=%v", c.in, c.ok, err)
		}
	}
}

func TestValidateArchitecture(t *testing.T) {
	for _, a := range supportedArchitectures {
		if err := validateArchitecture(a); err != nil {
			t.Fatalf("expected architecture %q to be valid, got err: %v", a, err)
		}
	}

	if err := validateArchitecture("not-an-arch"); err == nil {
		t.Fatalf("expected invalid architecture to return error")
	}
}
