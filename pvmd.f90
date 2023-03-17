program pvmd
    use iso_c_binding

    interface
        function pvm_start_pvmd(argc, argv, block_) bind(c)
            use iso_c_binding, only: c_int, c_ptr
            integer(c_int) :: pvm_start_pvmd
            integer(c_int), value :: argc
            type(c_ptr) :: argv(*)
            integer(c_int), value :: block_
        end function
        function pvm_halt() bind(c)
            use iso_c_binding, only: c_int
            integer(c_int) :: pvm_halt
        end function
        function setenv(name_, value_, overwrite) bind(c)
            use iso_c_binding, only: c_int, c_ptr
            type(c_ptr), value :: name_
            type(c_ptr), value :: value_
            integer(c_int), value :: overwrite
            integer(c_int) :: setenv
        end function
        function getenv(name_) bind(c)
            use iso_c_binding, only: c_ptr
            type(c_ptr), value :: name_
            type(c_ptr) :: getenv
        end function
    end interface

    integer(c_int) :: argc, info
    character(len=256), allocatable :: argv(:)
    integer :: i

    type(c_ptr) :: cpvm_root
    character(c_char), pointer :: fpvm_root(:)
    character(kind=c_char, len=:), allocatable :: pvm_root

    argc = command_argument_count()
    allocate(argv(argc))
    do i = 1, argc
        call get_command_argument(i, argv(i))
    end do
    info = setenv( &
        cstring("PVM_ROOT"), &
        cstring("/home/brian/workspace/spack/opt/spack/" // &
                "linux-ubuntu22.04-zen2/gcc-11.3.0/" // &
                "pvm-3.4.6-hxcifrgrma3eedh2r7o5252gymlrlkhn"), &
        0)
    print '("setenv: ",i0)', info
    cpvm_root = getenv(cstring("PVM_ROOT"))
    call c_f_pointer(cpvm_root, fpvm_root, [128])
    do i = 1, 256
        if (fpvm_root(i) == c_null_char) then
            allocate(character(i) :: pvm_root)
            exit
        end if
    end do
    do i = 1, len(pvm_root)
        pvm_root(i:i) = fpvm_root(i)
    end do
    print '("getenv: ",a)', pvm_root
    info = pvm_start_pvmd(argc, cstrings(argv), 0)
    print '("start_pvmd: ",i0)', info
    info = pvm_halt()
    print '("halt: ",i0)', info

contains

    type(c_ptr) function cstring(string)
        character(len=*) :: string
        
        character(c_char), pointer :: arr(:)
        integer :: i

        allocate(arr(len_trim(string) + 1))
        do i = 1, len_trim(string)
            arr(i) = string(i:i)
        end do
        arr(len_trim(string) + 1) = c_null_char
        cstring = c_loc(arr)
    end function
    
    function cstrings(strings)
        character(len=*) :: strings(:)
        type(c_ptr), pointer :: cstrings(:)

        integer :: i

        allocate(cstrings(size(strings)))
        do i = 1, size(strings)
            cstrings(i) = cstring(strings(i))
        end do
    end  function
end program pvmd
