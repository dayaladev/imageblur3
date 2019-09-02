class Image
  def initialize(array)
    @image = array
  end

  def process_row(row)
    puts row.join
  end

  def output_image
    #@image.each {|row| process_row(row)}
    @image.each do |row|
      process_row(row)
    end
  end
  
  def copy_image
    new_array = []
    input_row = []
    row_counter = 0
    col_counter = 0
    @image.each do |row|
        new_array << []
        row.each do |col|
            if col == 1
                new_array[row_counter][col_counter] = 1
            else
                new_array[row_counter][col_counter] = 0
            end
            col_counter += 1
        end
        col_counter = 0
        row_counter += 1
    end
    return new_array
  end
  
  def transform
    new_array = []
    row_counter = 0
    col_counter = 0
    lower_bound = @image.length
    a = 0
    #recreate original image dimensions in array; fill with zeros
    while a < lower_bound
        new_array << [].fill(0,0,@image[a-1].length)
        a += 1
    end
    @image.each do |row|
        right_bound = row.length
        row.each do |col|
            if col == 1
                new_array[row_counter].fill(1, col_counter, 1)
                #do the top 1
                if row_counter > 0
                    new_array[row_counter-1].fill(1, col_counter, 1)
                end
                #do the bottom 1
                if row_counter < lower_bound - 1
                    new_array[row_counter+1].fill(1, col_counter, 1)
                end
                #do the left 1
                if col_counter > 0
                    new_array[row_counter].fill(1, col_counter-1, 1)
                end
                #do the right 1
                if col_counter < right_bound - 1
                    new_array[row_counter].fill(1, col_counter+1, 1)
                end
            else
            end
            col_counter += 1
        end
        col_counter = 0
        row_counter += 1
    end
    return new_array
  end
  
  def transform2(distance)
    new_array = []
    row_counter = 0
    col_counter = 0
    lower_bound = @image.length
    a = 0
    #recreate original image dimensions in array; fill with zeros
    while a < lower_bound
        new_array << [].fill(0,0,@image[a-1].length)
        a += 1
    end
    @image.each do |row|
        right_bound = row.length
        row.each do |col|
            x_counter = 0
            y_counter = 1
            if col == 1
                new_array[row_counter].fill(1, col_counter, 1)
                #do the top 1
                while y_counter <= distance
                    #row_counter - y_counter
                    x_counter = 0
                    if y_counter == distance && row_counter - y_counter >= 0
                        new_array[row_counter - y_counter].fill(1, col_counter, 1)
                    else
                        while x_counter < distance && row_counter - y_counter >= 0
                            #this, only if it is within right bound
                            if col_counter + x_counter < right_bound && x_counter + y_counter <= distance
                                new_array[row_counter - y_counter].fill(1, col_counter + x_counter, 1)
                            end
                            #this, only if it is within left bound
                            if col_counter - x_counter >= 0 && x_counter + y_counter <= distance
                                new_array[row_counter - y_counter].fill(1, col_counter - x_counter, 1)
                            end
                            x_counter += 1
                        end
                    end
                    y_counter += 1
                end
                y_counter = 1
##################################################################################################################
                #do the bottom 1
                while y_counter <= distance
                    #row_counter - y_counter
                    x_counter = 0
                    if y_counter == distance && row_counter + y_counter < lower_bound
                        new_array[row_counter + y_counter].fill(1, col_counter, 1)
                    else
                        while x_counter < distance && row_counter + y_counter < lower_bound
                            #this, only if it is within right bound
                            if col_counter + x_counter < right_bound && x_counter + y_counter <= distance
                                new_array[row_counter + y_counter].fill(1, col_counter + x_counter, 1)
                            end
                            #this, only if it is within left bound
                            if col_counter - x_counter >= 0 && x_counter + y_counter <= distance
                                new_array[row_counter + y_counter].fill(1, col_counter - x_counter, 1)
                            end
                            x_counter += 1
                        end
                    end
                    y_counter += 1
                end
##################################################################################################################
                #do the sides
                if col_counter - distance < 0
                    if col_counter + distance > right_bound - 1
                        #exceeds left and right bounds; stick to the limits
                        new_array[row_counter].fill(1,0,right_bound)
                    else
                        #exceeds left bound only
                        new_array[row_counter].fill(1,0,((distance*2)+1)+(col_counter-distance))
                    end
                elsif col_counter + distance > right_bound - 1
                    #exceeds right bound only
                    new_array[row_counter].fill(1,col_counter-distance,((distance*2)+1)-((col_counter+distance)-(right_bound-1)))
                else
                    #no bounds exceeded
                    new_array[row_counter].fill(1,col_counter-distance,(distance*2)+1)
                end
            else
            end
            col_counter += 1
        end
        col_counter = 0
        row_counter += 1
    end
    return new_array
  end
end

image = Image.new([[0,0,0,0],[0,1,0,0],[0,0,0,1],[0,0,0,0]])
#image2 = Image.new([[0,0,0,0],[0,0,0,0],[0,0,1,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]])
image2 = Image.new([[0,0,0,0,0,0],[0,1,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,1],[0,0,0,0,0,0],[0,0,0,0,0,0]])
image3 = Image.new([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[1,0,0,0],[0,0,0,0]])

#using image2 for testing
#image2.output_image
#copied_image = Image.new(image.copy_image)
transformed_image = Image.new(image2.transform2(2))
transformed_image.output_image