require("require_relative");
require_relative("./quran_parser.rb");
# def freeze_1_verse_after(argument_chapter_and_verse_numbers_array)
#     parser = QuranParser.new("arabic.original.txt")
#     freeze_now = false;
#     $arabic_Quran_array.each_with_index do | line , index |
#         chapter_and_verse_numbers_array = parser.parse_chapter_and_verse_numbers(line);
#         if freeze_now
#             byebug
#         end
#         if chapter_and_verse_numbers_array == argument_chapter_and_verse_numbers_array
#             freeze_now = true
#         end
#     end
#     # return was frozen for x time_unit
#     return true
# end
# freeze_1_verse_after([ 2 , 1 ])

parser = QuranParser.new("arabic.original.txt")

array = [];
parser.phrases_count_hash.each do |key, value|
  if (value % 19) == 0
    array << key
  end
end

# final byebug
byebug
19
