      program part2
        type particle
            integer :: pos_x, pos_y, pos_z;
            integer :: vel_x, vel_y, vel_z; ! velocity
            integer :: acc_x, acc_y, acc_z; ! acceleration
        end type particle

        type(particle) :: particles(1000)
        integer :: collided(1000)
        character (len=100) :: foo1, foo2, foo3, foo4
        integer :: num_particles, num_collided=1, i = 1, j, k
        integer :: closest, closest_val
        logical :: found = .FALSE.
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
            ! Get particles that collide
            do i=1,num_particles-1,1
                found = .FALSE.
                ! Skip if already destroyed
                do j=1,num_collided-1,1
                    if (collided(j) == i) then
                        found = .TRUE.
                    endif
                enddo

                ! Else, get all particles with same position
                if (.NOT. found) then
                    do j=i,num_particles-1,1
                        do k=1,num_collided-1,1
                            if (collided(k) == j) then
                                found = .TRUE.
                            endif
                        enddo
                        ! Not the same, not already destroyed and same position
                        if ((j /= i) .AND. (.NOT. found) .AND.
     &                  (particles(i)%pos_x == particles(j)%pos_x
     &                   ) .AND.
     &                   (particles(i)%pos_y == particles(j)%pos_y
     &                   ) .AND.
     &                   (particles(i)%pos_z == particles(j)%pos_z
     &                   )) then
                                ! Add them to destroyed if not already present
                                ! i
                                found = .FALSE.
                                do k=1,num_collided-1,1
                                    if (collided(k) == i) then
                                        found = .TRUE.
                                    endif
                                enddo
                                if (.NOT. found) then
                                    collided(num_collided) = i
                                    num_collided = num_collided+1
                                endif
                                ! j
                                found = .FALSE.
                                do k=1,num_collided-1,1
                                    if (collided(k) == j) then
                                        found = .TRUE.
                                    endif
                                enddo
                                if (.NOT. found) then
                                    collided(num_collided) = j
                                    num_collided = num_collided+1
                                endif
                        endif
                    enddo
                endif
            enddo
            !print *, "----------------"
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
            print *, (num_particles-1)-(num_collided-1)
        enddo
      end program part2
