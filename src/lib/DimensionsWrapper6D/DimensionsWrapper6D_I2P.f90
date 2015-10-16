module DimensionsWrapper6D_I2P

USE DimensionsWrapper6D
USE IR_Precision, only: I2P

implicit none
private

    type, extends(DimensionsWrapper6D_t) :: DimensionsWrapper6D_I2P_t
        integer(I2P), allocatable :: Value(:,:,:,:,:,:)
    contains
    private
        procedure, public :: Set          => DimensionsWrapper6D_I2P_Set
        procedure, public :: Get          => DimensionsWrapper6D_I2P_Get
        procedure, public :: isOfDataType => DimensionsWrapper6D_I2P_isOfDataType
        procedure, public :: Free         => DimensionsWrapper6D_I2P_Free
        final             ::                 DimensionsWrapper6D_I2P_Final
    end type           

public :: DimensionsWrapper6D_I2P_t

contains


    subroutine DimensionsWrapper6D_I2P_Final(this) 
    !-----------------------------------------------------------------
    !< Final procedure of DimensionsWrapper6D
    !-----------------------------------------------------------------
        type(DimensionsWrapper6D_I2P_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        call this%Free()
    end subroutine


    subroutine DimensionsWrapper6D_I2P_Set(this, Value) 
    !-----------------------------------------------------------------
    !< Set I2P Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper6D_I2P_t), intent(INOUT) :: this
        class(*),                         intent(IN)    :: Value(:,:,:,:,:,:)
    !-----------------------------------------------------------------
        select type (Value)
            type is (integer(I2P))
                allocate(this%Value(size(Value,dim=1),  &
                                    size(Value,dim=2),  &
                                    size(Value,dim=3),  &
                                    size(Value,dim=4),  &
                                    size(Value,dim=5),  &
                                    size(Value,dim=6)), &
                                    source=Value)
        end select
    end subroutine


    subroutine DimensionsWrapper6D_I2P_Get(this, Value) 
    !-----------------------------------------------------------------
    !< Get I2P Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper6D_I2P_t), intent(IN)  :: this
        integer(I2P), allocatable,        intent(OUT) :: Value(:,:,:,:,:,:)
    !-----------------------------------------------------------------
        allocate(Value(size(this%Value,dim=1),  &
                       size(this%Value,dim=2),  &
                       size(this%Value,dim=3),  &
                       size(this%Value,dim=4),  &
                       size(this%Value,dim=5),  &
                       size(this%Value,dim=6)), &
                       source=this%Value)
    end subroutine


    subroutine DimensionsWrapper6D_I2P_Free(this) 
    !-----------------------------------------------------------------
    !< Free a DimensionsWrapper6D
    !-----------------------------------------------------------------
        class(DimensionsWrapper6D_I2P_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        if(allocated(this%Value)) deallocate(this%Value)
    end subroutine


    function DimensionsWrapper6D_I2P_isOfDataType(this, Mold) result(isOfDataType)
    !-----------------------------------------------------------------
    !< Check if Mold and Value are of the same datatype 
    !-----------------------------------------------------------------
        class(DimensionsWrapper6D_I2P_t), intent(IN) :: this          !< Dimensions wrapper 6D
        class(*),                         intent(IN) :: Mold          !< Mold for data type comparison
        logical                                      :: isOfDataType  !< Boolean flag to check if Value is of the same data type as Mold
    !-----------------------------------------------------------------
        isOfDataType = .false.
        select type (Mold)
            type is (integer(I2P))
                isOfDataType = .true.
        end select
    end function DimensionsWrapper6D_I2P_isOfDataType

end module DimensionsWrapper6D_I2P
