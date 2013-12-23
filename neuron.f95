module class_neuron
use types    
    public:: init_neuron, activeFunc,activeFuncD,adaptWeights,calcHiddenGradients,calcOutputGradients,feedForward


contains

    subroutine init_neuron(this,no,id,eta,alpha)
        
        type(Neuron) :: this
        integer :: i, id,no
        real eta, alpha
        this%id = id
        this%eta = eta
        this%alpha = alpha
        this%no = no -1
        
        allocate(this%outputWeights(0:this%no)) 
        init_loop: do, i=0, this%no
            call random_number(this%outputWeights(i)%weight)
        end do init_loop
         
    end subroutine init_Neuron

!activation func -----------------------------------------------------
    function activeFunc(x) result(f)
        real :: x, f
        
        f=1.0/(1.0+exp(-x))

    end function activeFunc

    function activeFuncD(x) result(fd)
        real :: x, fd, f
        
        f=activeFunc(x)
        fd=(1.0-f)*f
                
    end function activeFuncD    
           
!---------------------------------------------------------------------

    
    subroutine adaptWeights(this,prev)
        type(Neuron) :: this
        type(Layer) :: prev
        integer :: i        
        real oldDeltaWeight, newDeltaWeight
        

        main_loop: do, i=0, prev%n
           
           oldDeltaWeight = prev%neurons(i)%outputWeights(this%id)%deltaweight
           newDeltaWeight=this%eta*prev%neurons(i)%output*this%gradient+this%alpha*oldDeltaWeight
           prev%neurons(i)%outputWeights(this%id)%deltaweight = newDeltaWeight
          prev%neurons(i)%outputWeights(this%id)%weight = prev%neurons(i)%outputWeights(this%id)%weight + newDeltaWeight  
        end do main_loop
        


    end subroutine adaptWeights


    function sumNext(this, next) result(sum_)
       type(Neuron) :: this
       type(Layer) :: next
       real :: sum_
       integer :: i
       
       sum_ = 0.0
       suma: do,i=0,next%n
          sum_ = sum_ + this%outputWeights(i)%weight * next%neurons(i)%gradient
       end do suma
             

    end function sumNext
    
    
    subroutine calcHiddenGradients(this, next)
        type(Neuron) :: this
        type(Layer) :: next
        real :: snext

        snex = sumNext(this,next)
        this%gradient = snext * activeFuncD(output)
    end subroutine calcHiddenGradients
     
    subroutine calcOutputGradients(this, target_)
        
        type(Neuron) :: this
        real :: target_, delta
        delta = target_ - this%output 
        this%gradient = delta * activeFuncD(output)
    end subroutine calcOutputGradients

    subroutine feedForward(this, prev)
        type(Neuron) :: this
        type(Layer) :: prev
        real :: sum_
        integer :: i

        sum_ = 0.0

        main_loop: do, i=0, prev%n
            sum_ = sum_ + prev%neurons(i)%output * prev%neurons(i)%outputWeights(this%id)%weight
        end do main_loop
            
        this%output = activeFunc(sum_)    

    end subroutine feedForward  

end module class_neuron
