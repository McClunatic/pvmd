# pvmd

Simple programs to test on-the-fly assignment of `PVM_ROOT` to the env't.

* `pvmd.f90`: Uses C-interoperability to confirm good behavior of
  `pvm_start_pvmd`.
* `fpvmd.f90`: Uses the Fortran binding, `pvmfstart_pvmd`.

In both programs, `setenv` and `getenv` are called through C-interoperability,
managing conversion between Fortran and C representations of strings.
