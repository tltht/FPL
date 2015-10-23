module DimensionsWrapper7D_UP

USE Message_handler
USE DimensionsWrapper7D
USE IR_Precision, only: I4P, str

implicit none
private

    type, extends(DimensionsWrapper7D_t) :: DimensionsWrapper7D_UP_t
        class(*), allocatable :: Value(:,:,:,:,:,:,:)
    contains
    private
        procedure, public :: Set            => DimensionsWrapper7D_UP_Set
        procedure, public :: Get            => DimensionsWrapper7D_UP_Get
        procedure, public :: GetPolymorphic => DimensionsWrapper7D_UP_GetPolymorphic
        procedure, public :: isOfDataType   => DimensionsWrapper7D_UP_isOfDataType
        procedure, public :: Print          => DimensionsWrapper7D_UP_Print
        procedure, public :: Free           => DimensionsWrapper7D_UP_Free
        final             ::                   DimensionsWrapper7D_UP_Final
    end type           

public :: DimensionsWrapper7D_UP_t

contains


    subroutine DimensionsWrapper7D_UP_Final(this) 
    !-----------------------------------------------------------------
    !< Final procedure of DimensionsWrapper7D
    !-----------------------------------------------------------------
        type(DimensionsWrapper7D_UP_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        call this%Free()
    end subroutine


    subroutine DimensionsWrapper7D_UP_Set(this, Value) 
    !-----------------------------------------------------------------
    !< Set Unlimited Polymorphic Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper7D_UP_t), intent(INOUT) :: this
        class(*),                        intent(IN)   :: Value(:,:,:,:,:,:,:)
    !-----------------------------------------------------------------
        allocate(this%Value(size(Value,dim=1),  &
                            size(Value,dim=2),  &
                            size(Value,dim=3),  &
                            size(Value,dim=4),  &
                            size(Value,dim=5),  &
                            size(Value,dim=6),  &
                            size(Value,dim=7)), &
                            source=Value)
    end subroutine


    subroutine DimensionsWrapper7D_UP_Get(this, Value) 
    !-----------------------------------------------------------------
    !< Get Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper7D_UP_t), intent(IN)    :: this
        class(*),                        intent(INOUT) :: Value(:,:,:,:,:,:,:)
    !-----------------------------------------------------------------
        call msg%Error('Unregistered data type cannot be Getted. Try GetPolymorphic()')
    end subroutine


    subroutine DimensionsWrapper7D_UP_GetPolymorphic(this, Value) 
    !-----------------------------------------------------------------
    !< Get Unlimited Polymorphic Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper7D_UP_t), intent(IN)  :: this
        class(*), allocatable,           intent(OUT) :: Value(:,:,:,:,:,:,:)
    !-----------------------------------------------------------------
        allocate(Value(size(this%Value,dim=1),  &
                       size(this%Value,dim=2),  &
                       size(this%Value,dim=3),  &
                       size(this%Value,dim=4),  &
                       size(this%Value,dim=5),  &
                       size(this%Value,dim=6),  &
                       size(this%Value,dim=7)), &
                       source=this%Value)
    end subroutine


    subroutine DimensionsWrapper7D_UP_Free(this) 
    !-----------------------------------------------------------------
    !< Free a DimensionsWrapper7D
    !-----------------------------------------------------------------
        class(DimensionsWrapper7D_UP_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        if(allocated(this%Value)) deallocate(this%Value)
    end subroutine


    function DimensionsWrapper7D_UP_isOfDataType(this, Mold) result(isOfDataType)
    !-----------------------------------------------------------------
    !< Check if Mold and Value are of the same datatype 
    !-----------------------------------------------------------------
        class(DimensionsWrapper7D_UP_t), intent(IN) :: this              !< Dimensions wrapper 7D
        class(*),                     intent(IN) :: Mold              !< Mold for data type comparison
        logical                                  :: isOfDataType      !< Boolean flag to check if Value is of the same data type as Mold
    !-----------------------------------------------------------------
        isOfDataType = same_type_as(this%Value, Mold)
    end function DimensionsWrapper7D_UP_isOfDataType


    subroutine DimensionsWrapper7D_UP_Print(this, unit, prefix, iostat, iomsg)
    !-----------------------------------------------------------------
    !< Print Wrapper
    !-----------------------------------------------------------------
        class(DimensionsWrapper7D_UP_t), intent(IN)  :: this         !< DimensionsWrapper
        integer(I4P),                     intent(IN)  :: unit         !< Logic unit.
        character(*), optional,           intent(IN)  :: prefix       !< Prefixing string.
        integer(I4P), optional,           intent(OUT) :: iostat       !< IO error.
        character(*), optional,           intent(OUT) :: iomsg        !< IO error message.
        character(len=:), allocatable                 :: prefd        !< Prefixing string.
        integer(I4P)                                  :: iostatd      !< IO error.
        character(500)                                :: iomsgd       !< Temporary variable for IO error message.
    !-----------------------------------------------------------------
        prefd = '' ; if (present(prefix)) prefd = prefix
        write(unit=unit,fmt='(A,$)',iostat=iostatd,iomsg=iomsgd) prefd//' Data Type = UP'//&
                        ', Dimensions = '//trim(str(no_sign=.true., n=this%GetDimensions()))
        if (present(iostat)) iostat = iostatd
        if (present(iomsg))  iomsg  = iomsgd
    end subroutine DimensionsWrapper7D_UP_Print

end module DimensionsWrapper7D_UP