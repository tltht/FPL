!-----------------------------------------------------------------
! FPL (Fortran Parameter List)
! Copyright (c) 2015 Santiago Badia, Alberto F. Martín, 
! Javier Principe and Víctor Sande.
! All rights reserved.
!
! This library is free software; you can redistribute it and/or
! modify it under the terms of the GNU Lesser General Public
! License as published by the Free Software Foundation; either
! version 3.0 of the License, or (at your option) any later version.
!
! This library is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public
! License along with this library.
!-----------------------------------------------------------------

module DimensionsWrapper3D_I2P

USE DimensionsWrapper3D
USE IR_Precision, only: I2P, I4P, str, byte_size
USE ErrorMessages

implicit none
private

    type, extends(DimensionsWrapper3D_t) :: DimensionsWrapper3D_I2P_t
        integer(I2P), allocatable :: Value(:,:,:)
    contains
    private
        procedure, public :: Set            => DimensionsWrapper3D_I2P_Set
        procedure, public :: Get            => DimensionsWrapper3D_I2P_Get
        procedure, public :: GetShape       => DimensionsWrapper3D_I2P_GetShape
        procedure, public :: GetPointer     => DimensionsWrapper3D_I2P_GetPointer
        procedure, public :: GetPolymorphic => DimensionsWrapper3D_I2P_GetPolymorphic
        procedure, public :: DataSizeInBytes=> DimensionsWrapper3D_I2P_DataSizeInBytes
        procedure, public :: isOfDataType   => DimensionsWrapper3D_I2P_isOfDataType
        procedure, public :: Free           => DimensionsWrapper3D_I2P_Free
        procedure, public :: Print          => DimensionsWrapper3D_I2P_Print
        final             ::                   DimensionsWrapper3D_I2P_Final
    end type           

public :: DimensionsWrapper3D_I2P_t

contains


    subroutine DimensionsWrapper3D_I2P_Final(this) 
    !-----------------------------------------------------------------
    !< Final procedure of DimensionsWrapper3D
    !-----------------------------------------------------------------
        type(DimensionsWrapper3D_I2P_t), intent(INOUT) :: this
    !-----------------------------------------------------------------
        call this%Free()
    end subroutine


    subroutine DimensionsWrapper3D_I2P_Set(this, Value) 
    !-----------------------------------------------------------------
    !< Set I2P Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(INOUT) :: this
        class(*),                         intent(IN)    :: Value(:,:,:)
        integer                                         :: err
    !-----------------------------------------------------------------
        select type (Value)
            type is (integer(I2P))
                allocate(this%Value(size(Value,dim=1),  &
                                    size(Value,dim=2),  &
                                    size(Value,dim=3)), &
                                    stat=err)
                this%Value = Value
                if(err/=0) &
                    call msg%Error( txt='Setting Value: Allocation error ('//&
                                    str(no_sign=.true.,n=err)//')', &
                                    file=__FILE__, line=__LINE__ )
            class Default
                call msg%Warn( txt='Setting value: Expected data type (I2P)', &
                               file=__FILE__, line=__LINE__ )
        end select
    end subroutine


    subroutine DimensionsWrapper3D_I2P_Get(this, Value) 
    !-----------------------------------------------------------------
    !< Get I2P Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(IN)  :: this
        class(*),                         intent(OUT) :: Value(:,:,:)
    !-----------------------------------------------------------------
        select type (Value)
            type is (integer(I2P))
                if(all(this%GetShape() == shape(Value))) then
                    Value = this%Value
                else
                    call msg%Warn(txt='Getting value: Wrong shape ('//&
                                  str(no_sign=.true.,n=this%GetShape())//'/='//&
                                  str(no_sign=.true.,n=shape(Value))//')',&
                                  file=__FILE__, line=__LINE__ )
                endif
            class Default
                call msg%Warn(txt='Getting value: Expected data type (I2P)',&
                              file=__FILE__, line=__LINE__ )
        end select
    end subroutine


    function DimensionsWrapper3D_I2P_GetShape(this) result(ValueShape) 
    !-----------------------------------------------------------------
    !< Get Wrapper Value Shape
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(IN)  :: this
        integer(I4P), allocatable                     :: ValueShape(:)
    !-----------------------------------------------------------------
        allocate(ValueShape(this%GetDimensions()))
        ValueShape = shape(this%Value)
    end function


    function DimensionsWrapper3D_I2P_GetPointer(this) result(Value) 
    !-----------------------------------------------------------------
    !< Get Unlimited Polymorphic pointer to Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), target, intent(IN)  :: this
        class(*), pointer                                     :: Value(:,:,:)
    !-----------------------------------------------------------------
        Value => this%Value
    end function


    subroutine DimensionsWrapper3D_I2P_GetPolymorphic(this, Value) 
    !-----------------------------------------------------------------
    !< Get Unlimited Polymorphic Wrapper Value
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(IN)  :: this
        class(*), allocatable,            intent(OUT) :: Value(:,:,:)
    !-----------------------------------------------------------------
        allocate(Value(size(this%Value,dim=1),  &
                       size(this%Value,dim=2),  &
                       size(this%Value,dim=3)), &
                       source=this%Value)
    end subroutine


    subroutine DimensionsWrapper3D_I2P_Free(this) 
    !-----------------------------------------------------------------
    !< Free a DimensionsWrapper3D
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(INOUT) :: this
        integer                                         :: err = FPLSuccess
    !-----------------------------------------------------------------
        if(allocated(this%Value)) then
            deallocate(this%Value, stat=err)
            if(err/=0) call msg%Error(txt='Freeing Value: Deallocation error ('// &
                                      str(no_sign=.true.,n=err)//')',             &
                                      file=__FILE__, line=__LINE__ )
        endif
    end subroutine


    function DimensionsWrapper3D_I2P_DataSizeInBytes(this) result(DataSizeInBytes)
    !-----------------------------------------------------------------
    !< Return the size in bytes of the stored data
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(IN) :: this            !< Dimensions wrapper 3D
        integer(I4P)                                 :: DataSizeInBytes !< Size of the stored data in bytes
    !-----------------------------------------------------------------
        DataSizeInBytes = byte_size(this%value(1,1,1))*size(this%value)
    end function DimensionsWrapper3D_I2P_DataSizeInBytes


    function DimensionsWrapper3D_I2P_isOfDataType(this, Mold) result(isOfDataType)
    !-----------------------------------------------------------------
    !< Check if Mold and Value are of the same datatype 
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(IN) :: this          !< Dimensions wrapper 3D
        class(*),                         intent(IN) :: Mold          !< Mold for data type comparison
        logical                                      :: isOfDataType  !< Boolean flag to check if Value is of the same data type as Mold
    !-----------------------------------------------------------------
        isOfDataType = .false.
        select type (Mold)
            type is (integer(I2P))
                isOfDataType = .true.
        end select
    end function DimensionsWrapper3D_I2P_isOfDataType


    subroutine DimensionsWrapper3D_I2P_Print(this, unit, prefix, iostat, iomsg)
    !-----------------------------------------------------------------
    !< Print Wrapper
    !-----------------------------------------------------------------
        class(DimensionsWrapper3D_I2P_t), intent(IN)  :: this         !< DimensionsWrapper
        integer(I4P),                     intent(IN)  :: unit         !< Logic unit.
        character(*), optional,           intent(IN)  :: prefix       !< Prefixing string.
        integer(I4P), optional,           intent(OUT) :: iostat       !< IO error.
        character(*), optional,           intent(OUT) :: iomsg        !< IO error message.
        character(len=:), allocatable                 :: prefd        !< Prefixing string.
        integer(I4P)                                  :: iostatd      !< IO error.
        character(500)                                :: iomsgd       !< Temporary variable for IO error message.
    !-----------------------------------------------------------------
        prefd = '' ; if (present(prefix)) prefd = prefix
        write(unit=unit,fmt='(A,$)',iostat=iostatd,iomsg=iomsgd) prefd//' Data Type = I2P'//&
                        ', Dimensions = '//trim(str(no_sign=.true., n=this%GetDimensions()))//&
                        ', Bytes = '//trim(str(no_sign=.true., n=this%DataSizeInBytes()))//&
                        ', Value = '
        write(unit=unit,fmt=*,iostat=iostatd,iomsg=iomsgd) str(no_sign=.true., n=this%Value)

        if (present(iostat)) iostat = iostatd
        if (present(iomsg))  iomsg  = iomsgd
    end subroutine DimensionsWrapper3D_I2P_Print

end module DimensionsWrapper3D_I2P
