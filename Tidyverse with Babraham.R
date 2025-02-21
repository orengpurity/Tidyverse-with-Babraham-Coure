library(tidyverse)
##Tidyverse packages##
#Tibble - data storage
#ReadR - reading data from files
#TidyR - Model data correctly
#DplyR - Manipulate and filter data
#Ggplot2 - Draw figures and graphs

#Uploading data#
child_variants <- read.csv ("C:/Users/Purity/Downloads/R_tidyverse_intro_data/Child_Variants.csv")
child_variants
str(child_variants)
glimpse(child_variants)

##More functions##
#substr() or substring() function #either used to extract characters in a data or manipulate data
substr(child_variants, 1, 5)
#rep() function, used to replicate values
rep("cat", times=3)
rep(3, times=10)

##Statistically testing vectors##
#using t-test
numbers <- c(1, 2, 3, 4, 5)
test <- c(32,22,55,66,77)
test
t.test(numbers, test)

#correlation, uses cor.test() function
cor.test(numbers, test)

#normal distribution, uses rnorm() function
rnorm(numbers)

### tibble ### :
##2D data structure where each column has a fixed data type (character, number, logical etc)
#nicer data frames

### readr ###
##Reading and Writing Files with readr##
#read from text files into tibbles
child_variants
read_csv("C:/Users/Purity/Downloads/R_tidyverse_intro_data/Child_Variants.csv") -> data
#or using read_delim() function, #reading a delimited file into a tibble (make nicer data frames)
read.delim("C:/Users/Purity/Downloads/R_tidyverse_intro_data/neutrophils.csv")
read_delim("C:/Users/Purity/Downloads/R_tidyverse_intro_data/trumpton.txt") -> trumpton
trumpton

#write from tibbles to text files
write_csv(data,"C:/Users/Purity/Downloads/R_tidyverse_intro_data/Child_Variants.csv")

### Dplyr ###
##Sub-setting and Filtering##
select 		#pick columns by name/position
filter 		#pick rows based on the data
slice 		#pick rows by position
arrange 	#sort rows
distinct #deduplicate rows

#selecting#, # columns using select() function
select(trumpton, 1,2)
# negative selections
select(trumpton, -LastName)
#Functional selections using filter() function
filter(trumpton, Height>=170)
filter(trumpton, FirstName == "Chris")
#transforming data in a filter
read_delim("C:/Users/Purity/Downloads/R_tidyverse_intro_data/transform_data.txt")
filter(transform.data, difference > 5)

#more select options"
starts_with()		-starts_with()
ends_with()		-ends_with()	
contains()		-contains()
matches()		-matches()

#slicing#
trumpton %>% 
  slice(1,4,7)

#arrange (sorting) and distinct (deduplication)#
trumpton %>%
  arrange(Height) %>%
  distinct(FirstName, .keep_all = TRUE)

##Multi-condition filter##
#uses:
#& = logical AND
#| = logical OR
#! = logical NOT
#using &
trumpton %>% 
  filter(Height > 170 & Age > 30)
#using |
trumpton %>% 
  filter(Height > 170 | Age > 30)
#using !
trumpton %>% 
  filter(!(Height > 170 | Age > 30))

##Pipping##
# uses %>% operator
trumpton %>% select(-LastName)
view(trumpton)
trumpton %>% filter(Height>=170) %>% filter(FirstName=="Chris") %>% select(Age,Weight)
trumpton %>% 
  select(LastName, Age, Height) %>% 
  slice(1,4,7)

##Adding or creating data##
add_row 		#adds a single new row
add_column 	#adds a column of new data
mutate		#create a new column from existing columns
#using add_row
trumpton %>%
  add_row(
    FirstName="Simon",
    LastName="Andrews",
    Age=39,
    Weight=80,
    Height=185
  )
#using add_column
trumpton %>%
  add_column(
    vegetarian = c(T,F,F,T,F,F,T)
  )
#using mutate, #create a new column by multiplying the current with a value
trumpton %>%
  mutate(
    weight_stones=Weight*0.16,
    height_feet=Height*0.033
  )
trumpton %>% 
  mutate(Category = if_else(Height > 180, "Tall", "Short"))
#Replacing values with mutate, #using replace 
#numericals
data.with.na %>%
  mutate(value = replace(value,value>10, 10))
#logicals
data.with.na %>%
  mutate(value = replace_na(value,0))

##Grouping and Summarizing##
group_by 	#sets groups for summarisation
ungroup 	#removes grouping information
summarise #collapse grouped variables
count 		#count grouped variables
#grouping
group.data %>% group_by(Genotype,Sex)
#count
group.data %>%
  group_by(Genotype,Sex) %>%
  count()
#summarizing
group.data %>%
  group_by(Genotype,Sex) %>%
  summarise(
    Height2 = mean(Height),
    Length  = median(Length),
    Counts  = n()
  )
#Ungrouping
#affects lots of operations
group.data %>%
  arrange(desc(Height)) %>%
  group_by(Sex) %>%
  slice(1) %>%
  ungroup()

##Joining Tibbles##
bind_rows		#join tibbles by row
bind_cols	#join tibbles by column
rename 		#rename a column
#renaming
trumpton %>% rename(Surname=LastName)
#joining
left_join	 #join matching values from y into x
right_join 	#join matching values of x into y
inner_join	#join x and y keeping only rows in both
full_join 	#join x and y keeping all values in both
gathered.data %>%
  arrange(desc(value)) %>%
  group_by(genotype) %>%
  slice(1) %>%
  ungroup() %>%
  left_join(gathered.annotation)

### tidyr ###
##Restructuring Data##

#Wide to Long# done in two ways;
#pivot_longer: #Takes multiple columns of the same type and puts them into a pair of key-value columns
#separate: #Splits a delimited column into multiple columns
non.normalised %>%
  
  pivot_longer(
    cols=WT_1:KO_2, 
    names_to="sample", 
    values_to="value"
  ) %>%
  
  separate(
    col=sample,
    into=c("genotype","replicate"),
    sep="_",
    convert = TRUE
  )

#Long to Wide# done in two ways;
#pivot_wider:Takes a key-value column pair and spreads them out to multiple columns of the same type 
#unite: Combines multiple columns into one
pivot.long %>%
  pivot_wider(
    names_from = Condition, 
    values_from = Count
  )



### ggplot2 ###
##Plotting##
#using pipes

# Geometries are types of plot
#geom_point() Point geometry, (x/y plots, stripcharts etc)
#geom_line() Line graphs
#geom_bar() Barplots
#geom_boxplot() Box plots
#geom_histogram() Histogram plots

# Aesthetics are ways to change the appearance of data in a plot:
#x,y variables
#color
#size
#angle
#shape
#fill
#stroke

# the syntax:
#data %>% ggplot(aes(x=weight, y=height, colour=genotype))
expr_data %>%
  ggplot (aes(x=WT, y=KO)) +
  geom_point(color="red2", size=5)
dogs %>%
  ggplot(aes(x=size)) +
  geom_bar()

