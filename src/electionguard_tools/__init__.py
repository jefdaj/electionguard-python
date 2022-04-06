import importlib.metadata

# <AUTOGEN_INIT>
from electionguard_tools import factories
from electionguard_tools import helpers
from electionguard_tools import scripts
from electionguard_tools import strategies

from electionguard_tools.factories import (
    AllPrivateElectionData,
    AllPublicElectionData,
    BallotFactory,
    ElectionFactory,
    NUMBER_OF_GUARDIANS,
    QUORUM,
    ballot_factory,
    election_factory,
    get_contest_description_well_formed,
    get_selection_description_well_formed,
    get_selection_poorly_formed,
    get_selection_well_formed,
)
from electionguard_tools.helpers import (
    CIPHERTEXT_BALLOT_PREFIX,
    COEFFICIENTS_FILE_NAME,
    CONSTANTS_FILE_NAME,
    CONTEXT_FILE_NAME,
    DEVICES_DIR,
    DEVICE_PREFIX,
    ELECTION_RECORD_DIR,
    ENCRYPTED_TALLY_FILE_NAME,
    GUARDIANS_DIR,
    GUARDIAN_PREFIX,
    KeyCeremonyOrchestrator,
    MANIFEST_FILE_NAME,
    PLAINTEXT_BALLOT_PREFIX,
    PRIVATE_DATA_DIR,
    PRIVATE_GUARDIAN_PREFIX,
    SPOILED_BALLOTS_DIR,
    SPOILED_BALLOT_PREFIX,
    SUBMITTED_BALLOTS_DIR,
    SUBMITTED_BALLOT_PREFIX,
    TALLY_FILE_NAME,
    TallyCeremonyOrchestrator,
    accumulate_plaintext_ballots,
    export,
    export_private_data,
    export_record,
    key_ceremony_orchestrator,
    tally_accumulate,
    tally_ceremony_orchestrator,
)
from electionguard_tools.scripts import (
    DEFAULT_NUMBER_OF_BALLOTS,
    DEFAULT_SAMPLE_MANIFEST,
    DEFAULT_SPEC_VERSION,
    DEFAULT_SPOIL_RATE,
    DEFAULT_USE_ALL_GUARDIANS,
    DEFAULT_USE_PRIVATE_DATA,
    ElectionSampleDataGenerator,
    sample_generator,
)
from electionguard_tools.strategies import (
    CiphertextElectionsTupleType,
    ElectionsAndBallotsTupleType,
    annotated_emails,
    annotated_strings,
    ballot_styles,
    candidate_contest_descriptions,
    candidates,
    ciphertext_elections,
    contact_infos,
    contest_descriptions,
    contest_descriptions_room_for_overvoting,
    election,
    election_descriptions,
    election_types,
    elections_and_ballots,
    elements_mod_p,
    elements_mod_p_no_zero,
    elements_mod_q,
    elements_mod_q_no_zero,
    elgamal,
    elgamal_keypairs,
    geopolitical_units,
    group,
    human_names,
    internationalized_human_names,
    internationalized_texts,
    language_human_names,
    languages,
    party_lists,
    plaintext_voted_ballot,
    plaintext_voted_ballots,
    referendum_contest_descriptions,
    reporting_unit_types,
    two_letter_codes,
)

__all__ = [
    "AllPrivateElectionData",
    "AllPublicElectionData",
    "BallotFactory",
    "CIPHERTEXT_BALLOT_PREFIX",
    "COEFFICIENTS_FILE_NAME",
    "CONSTANTS_FILE_NAME",
    "CONTEXT_FILE_NAME",
    "CiphertextElectionsTupleType",
    "DEFAULT_NUMBER_OF_BALLOTS",
    "DEFAULT_SAMPLE_MANIFEST",
    "DEFAULT_SPEC_VERSION",
    "DEFAULT_SPOIL_RATE",
    "DEFAULT_USE_ALL_GUARDIANS",
    "DEFAULT_USE_PRIVATE_DATA",
    "DEVICES_DIR",
    "DEVICE_PREFIX",
    "ELECTION_RECORD_DIR",
    "ENCRYPTED_TALLY_FILE_NAME",
    "ElectionFactory",
    "ElectionSampleDataGenerator",
    "ElectionsAndBallotsTupleType",
    "GUARDIANS_DIR",
    "GUARDIAN_PREFIX",
    "KeyCeremonyOrchestrator",
    "MANIFEST_FILE_NAME",
    "NUMBER_OF_GUARDIANS",
    "PLAINTEXT_BALLOT_PREFIX",
    "PRIVATE_DATA_DIR",
    "PRIVATE_GUARDIAN_PREFIX",
    "QUORUM",
    "SPOILED_BALLOTS_DIR",
    "SPOILED_BALLOT_PREFIX",
    "SUBMITTED_BALLOTS_DIR",
    "SUBMITTED_BALLOT_PREFIX",
    "TALLY_FILE_NAME",
    "TallyCeremonyOrchestrator",
    "accumulate_plaintext_ballots",
    "annotated_emails",
    "annotated_strings",
    "ballot_factory",
    "ballot_styles",
    "candidate_contest_descriptions",
    "candidates",
    "ciphertext_elections",
    "contact_infos",
    "contest_descriptions",
    "contest_descriptions_room_for_overvoting",
    "election",
    "election_descriptions",
    "election_factory",
    "election_types",
    "elections_and_ballots",
    "elements_mod_p",
    "elements_mod_p_no_zero",
    "elements_mod_q",
    "elements_mod_q_no_zero",
    "elgamal",
    "elgamal_keypairs",
    "export",
    "export_private_data",
    "export_record",
    "factories",
    "geopolitical_units",
    "get_contest_description_well_formed",
    "get_selection_description_well_formed",
    "get_selection_poorly_formed",
    "get_selection_well_formed",
    "group",
    "helpers",
    "human_names",
    "internationalized_human_names",
    "internationalized_texts",
    "key_ceremony_orchestrator",
    "language_human_names",
    "languages",
    "party_lists",
    "plaintext_voted_ballot",
    "plaintext_voted_ballots",
    "referendum_contest_descriptions",
    "reporting_unit_types",
    "sample_generator",
    "scripts",
    "strategies",
    "tally_accumulate",
    "tally_ceremony_orchestrator",
    "two_letter_codes",
]

# </AUTOGEN_INIT>

# single source version from pyproject.toml
try:
    __version__ = importlib.metadata.version(__package__.split("_", maxsplit=1)[0])
except importlib.metadata.PackageNotFoundError:
    __version__ = "0.0.0"
