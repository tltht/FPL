module DimensionsWrapper0D_I2P

USE DimensionsWrapper0D
USE IR_Precision, only: I2P

implicit none
private

    type, extends(DimensionsWrapper0D_t) :: DimensionsWrapper0D_I2P_t
        integer(I2P), allocatable :: Value
    contains
    private
        procedure, public :: Set          => DimensionsWrapper0D_I2P_Set
        procedure, public :: Get          => DimensionsWrapper0D_I2P_Get
        procedure, public :: isOfDataType => DimensionsWrapper0D_I2P_isOfDataType
        procedure, public :: Free         => DimensionsWrapper0D_I2P_Free
        final             ::                 DimensionsWrapper0D_I2P_Final
    end type           

public :: DimensionsWrapper0D_I2P_t

contains


    subroutine DimensionsWrapper0D_I2P_Final(this) 
    !-----------------------------------------------------------------
    !< Final procedure of DimensionsWrapper0D
    !-----------------------------------------------------------------
        type(DimensionsWrapper0D_I2P_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        call this%Free()
    end subroutine


    subroutine DimensionsWrapper0D_I2P_Set(this, Value) 
    !-----------------------------------------------------------------
    !< Set I2P Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper0D_I2P_t), intent(INOUT) :: this
        class(*),                         intent(IN)    :: Value
    !-----------------------------------------------------------------
        select type (Value)
            type is (integer(I2P))
                allocate(this%Value, source=Value)
        end select
    end subroutine


    subroutine DimensionsWrapper0D_I2P_Get(this, Value) 
    !-----------------------------------------------------------------
    !< Get I2P Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper0D_I2P_t), intent(IN)  :: this
        integer(I2P), allocatable,        intent(OUT) :: Value
    !-----------------------------------------------------------------
        allocate(Value, source=this%Value)
    end subroutine


    subroutine DimensionsWrapper0D_I2P_Free(this) 
    !-----------------------------------------------------------------
    !< Free a DimensionsWrapper0D
    !-----------------------------------------------------------------
        class(DimensionsWrapper0D_I2P_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        if(allocated(this%Value)) deallocate(this%Value)
    end subroutine


    function DimensionsWrapper0D_I2P_isOfDataType(this, Mold) result(isOfDataType)
    !-----------------------------------------------------------------
    !< Check if Mold and Value are of the same datatype 
    !-----------------------------------------------------------------
        class(DimensionsWrapper0D_I2P_t), intent(IN) :: this          !< Dimensions wrapper 0D
        class(*),                         intent(IN) :: Mold          !< Mold for data type comparison
        logical                                      :: isOfDataType  !< Boolean flag to check if Value is of the same data type as Mold
    !-----------------------------------------------------------------
        isOfDataType = .false.
        select type (Mold)
            type is (integer(I2P))
                isOfDataType = .true.
        end select
    end function DimensionsWrapper0D_I2P_isOfDataType

end module DimensionsWrapper0D_I2P
