# maml- migration apathy markup lanaguage
# integer, float,  date, datetime, timestamp, time, text, string, binary, boolean
#
# specify field type by symbol prefix as follows
# default type is string, except where field has _id suffice- then it's integer (override by adding prefix as shown below)
# .integer, ..float,  %date, %%datetime, @time, @@timestamp, :string, ::text, =boolean, &binary
#
# level 1: module, level 2: class, level 3: field
# maml.yml is a sample file for a starting point. maml sample copies it to current directory.
@too_few_levels= <<END_STRING
  expensa:
    - day_id  # any _id defaults to integer
    - meal_id 50 true
END_STRING

@too_many_levels= <<END_STRING
  expensa:
    report:
      item:
        - day_id  # any _id defaults to integer
        - meal_id 50 true
END_STRING

@correct_level_structure_and_type=<<END_STRING
expensa:
  report:
    - day_id  # any _id defaults to integer
    - meal_id 50 true
END_STRING

@error_on_multiple_roots=<<END_STRING
application:
expensa:
  report:
    - day_id  # any _id defaults to integer
    - meal_id 50 true
END_STRING

@incorrect_level_structure_and_type=<<END_STRING
- expensa:
  report:
    - day_id  # any _id defaults to integer
    - meal_id 50 true
END_STRING

@miscellaneous_good_fields= <<END_STRING
  - the_recordid_id  # any _id defaults to integer
  - .the_record_id2_id
  - .the_integer
  - ..cost
  - %the_date
  - %%the_date_time
  - @the_time
  - @@the_time_stamp
  - the_string 
  - #the_string2
  - ##the_text
  - =the_boolean
  - &the_binary
END_STRING

@miscellaneous_bad_fields= <<END_STRING
- the_recordid_id  # any _id defaults to integer
- .the_record_id2_id
- .the_integer
- ..cost
- %the_date
- %%the_date_time
- @the_time
- @@the_time_stamp
- the_string 
- #the_string2
- ##the_text
- =the_boolean
- &the_binary
END_STRING

@miscellaneous_good_options= <<END_STRING
- the_recordid_id  # any _id defaults to integer
- .the_record_id2_id
- .the_integer
- ..cost
- %the_date
- %%the_date_time
- @the_time
- @@the_time_stamp
- the_string 
- #the_string2
- ##the_text
- =the_boolean
- &the_binary
END_STRING

@miscellaneous_bad_options= <<END_STRING
- the_recordid_id  # any _id defaults to integer
- .the_record_id2_id
- .the_integer
- ..cost
- %the_date
- %%the_date_time
- @the_time
- @@the_time_stamp
- the_string 
- #the_string2
- ##the_text
- =the_boolean
- &the_binary
END_STRING

