      program day20
        type particle
            integer :: pos_x, pos_y, pos_z;
            integer :: vel_x, vel_y, vel_z; ! velocity
            integer :: acc_x, acc_y, acc_z; ! acceleration
        end type particle

        type(particle) :: particles(1000)
        character (len=100) :: foo1, foo2, foo3, foo4
        integer :: num_particles, i = 1
        integer :: closest, closest_val, manhattan
   30   format(A3,3I7,A6,3I7,A6,3I7,A)
        open(1, file="input")
        do
            read(1, 30, end=999) foo1,
     &      particles(i)%pos_x,
     &      particles(i)%pos_y,
     &      particles(i)%pos_z, foo2,
     &      particles(i)%vel_x,
     &      particles(i)%vel_y,
     &      particles(i)%vel_z, foo3,
     &      particles(i)%acc_x,
     &      particles(i)%acc_y,
     &      particles(i)%acc_z, foo4
            i = i + 1
        end do
  999   continue
        num_particles = i
        print *, num_particles
        do 
            ! Get closest
            closest_val = ABS(particles(1)%pos_x) +
     &      ABS(particles(1)%pos_y) +
     &      ABS(particles(1)%pos_z)
            closest = 0
            do i=1,num_particles-1,1
                manhattan = ABS(particles(i)%pos_x) +
     &          ABS(particles(i)%pos_y) +
     &          ABS(particles(i)%pos_z)
                if (manhattan < closest_val) then
                    closest = i-1
                    closest_val = manhattan
                endif
            enddo
            print *, closest
            ! Step forward
            do i=1,num_particles-1,1
                particles(i)%vel_x = particles(i)%vel_x +
     &          particles(i)%acc_x
                particles(i)%vel_y = particles(i)%vel_y +
     &          particles(i)%acc_y
                particles(i)%vel_z = particles(i)%vel_z +
     &          particles(i)%acc_z
                particles(i)%pos_x = particles(i)%pos_x +
     &          particles(i)%vel_x
                particles(i)%pos_y = particles(i)%pos_y +
     &          particles(i)%vel_y
                particles(i)%pos_z = particles(i)%pos_z +
     &          particles(i)%vel_z
            enddo
        enddo
      end program day20
