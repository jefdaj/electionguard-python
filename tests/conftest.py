# Default to fast, deterministic tests during Nix builds.
# But also override it to be *more* careful than before in the Makefile,
# because there seem to be intermittent failures!

import os
from hypothesis import settings, HealthCheck

settings.register_profile("nix", derandomize=True, deadline=None,
                          suppress_health_check=[HealthCheck.too_slow])

settings.register_profile("careful", max_examples=10000, deadline=None)

settings.load_profile(os.getenv("HYPOTHESIS_PROFILE", "nix"))
