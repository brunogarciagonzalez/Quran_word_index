# datastructure that can be sent as JSON
# every word of the Quran to value of its word_count
# build SDK for Quran math inshaALLAH

# imports
require("byebug");
require("rest-client");
require("JSON");

# $example = File.open("arabic.original.txt").read();
$arabic_Quran_string = File.open("arabic.original.txt").read();
$arabic_Quran_array = $arabic_Quran_string.split("\r\n") # split on line break

# [0..-1] not necessary, last "\r\n" (last few characters of arabic_Quran_string gets chomped

# below is the line parser
class QuranParser
    attr_reader(:arabic_Quran_string, :arabic_Quran_array)

    def initialize(filepath)
        @arabic_Quran_string = File.open(filepath).read();
        @arabic_Quran_array = $arabic_Quran_string.split("\r\n") # split on line break
    end

    def parse_verse_content(txt_file_line)
        # returns current verse content from line
        # !!! see Masjid Tucson .rb for newer split logic
        return txt_file_line.split("|")[2]
    end
    
    def parse_chapter_number(txt_file_line)
        # returns current chapter number
        return txt_file_line.split("|")[0].to_i
    end
    
    def parse_verse_number(txt_file_line)
        # returns current chapter number
        return txt_file_line.split("|")[1].to_i
    end

    def parse_chapter_and_verse_numbers(txt_file_line)
        return [ parse_chapter_number(txt_file_line), parse_verse_number(txt_file_line) ]
    end
    
    def get_chapter_title_map
        return {1=>"Al-Faatiha", 2=>"Al-Baqara", 3=>"Aal-i-Imraan", 4=>"An-Nisaa", 5=>"Al-Maaida", 6=>"Al-An'aam", 7=>"Al-A'raaf", 8=>"Al-Anfaal", 9=>"At-Tawba", 10=>"Yunus", 11=>"Hud", 12=>"Yusuf", 13=>"Ar-Ra'd", 14=>"Ibrahim", 15=>"Al-Hijr", 16=>"An-Nahl", 17=>"Al-Israa", 18=>"Al-Kahf", 19=>"Maryam", 20=>"Taa-Haa", 21=>"Al-Anbiyaa", 22=>"Al-Hajj", 23=>"Al-Muminoon", 24=>"An-Noor", 25=>"Al-Furqaan", 26=>"Ash-Shu'araa", 27=>"An-Naml", 28=>"Al-Qasas", 29=>"Al-Ankaboot", 30=>"Ar-Room", 31=>"Luqman", 32=>"As-Sajda", 33=>"Al-Ahzaab", 34=>"Saba", 35=>"Faatir", 36=>"Yaseen", 37=>"As-Saaffaat", 38=>"Saad", 39=>"Az-Zumar", 40=>"Ghafir", 41=>"Fussilat", 42=>"Ash-Shura", 43=>"Az-Zukhruf", 44=>"Ad-Dukhaan", 45=>"Al-Jaathiya", 46=>"Al-Ahqaf", 47=>"Muhammad", 48=>"Al-Fath", 49=>"Al-Hujuraat", 50=>"Qaaf", 51=>"Adh-Dhaariyat", 52=>"At-Tur", 53=>"An-Najm", 54=>"Al-Qamar", 55=>"Ar-Rahmaan", 56=>"Al-Waaqia", 57=>"Al-Hadid", 58=>"Al-Mujaadila", 59=>"Al-Hashr", 60=>"Al-Mumtahana", 61=>"As-Saff", 62=>"Al-Jumu'a", 63=>"Al-Munaafiqoon", 64=>"At-Taghaabun", 65=>"At-Talaaq", 66=>"At-Tahrim", 67=>"Al-Mulk", 68=>"Al-Qalam", 69=>"Al-Haaqqa", 70=>"Al-Ma'aarij", 71=>"Nooh", 72=>"Al-Jinn", 73=>"Al-Muzzammil", 74=>"Al-Muddaththir", 75=>"Al-Qiyaama", 76=>"Al-Insaan", 77=>"Al-Mursalaat", 78=>"An-Naba", 79=>"An-Naazi'aat", 80=>"Abasa", 81=>"At-Takwir", 82=>"Al-Infitaar", 83=>"Al-Mutaffifin", 84=>"Al-Inshiqaaq", 85=>"Al-Burooj", 86=>"At-Taariq", 87=>"Al-A'laa", 88=>"Al-Ghaashiya", 89=>"Al-Fajr", 90=>"Al-Balad", 91=>"Ash-Shams", 92=>"Al-Lail", 93=>"Ad-Dhuhaa", 94=>"Ash-Sharh", 95=>"At-Tin", 96=>"Al-Alaq", 97=>"Al-Qadr", 98=>"Al-Bayyina", 99=>"Az-Zalzala", 100=>"Al-Aadiyaat", 101=>"Al-Qaari'a", 102=>"At-Takaathur", 103=>"Al-Asr", 104=>"Al-Humaza", 105=>"Al-Fil", 106=>"Quraish", 107=>"Al-Maa'un", 108=>"Al-Kawthar", 109=>"Al-Kaafiroon", 110=>"An-Nasr", 111=>"Al-Masad", 112=>"Al-Ikhlaas", 113=>"Al-Falaq", 114=>"An-Naas"}
    end

    def build_Quran_including_unnumbered_verses
        # make copy of @arabic_Quran_array
            #  output_hash[[1,1]] = line
        output_hash = {};

        arabic_Quran_array().each do |line|
            key_array = parse_chapter_and_verse_numbers(line);
            output_hash[key_array] = parse_verse_content(line);
        end
        
        # inject proper [ x , 0 ] basmALLAH string in output_hash
        # for chapters 2 - 8 , 10 - 114
        (2..114).to_a.each do |ch_integer|
            # quick test:
            # current_line = "#{ch_integer}|0|بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
            # test = parse_chapter_and_verse_numbers(current_line);
            # byebug
            if ch_integer != 9 # if its not chapter 9
                output_hash[[ ch_integer , 0 ]] = output_hash[[1,1]]
            end
        end

        # construct output_array in correct order of verses
            # build array   --|
            #                 |-   ? efficient solution inshaALLAH
            # sort it       --|
        output_hash.each do | key_array , verse |

            byebug
        end

    end
end
#filename_string = "";


def freeze_1_verse_after(argument_chapter_and_verse_numbers_array)
    parser = QuranParser.new("arabic.original.txt")
    freeze_now = false;

    $arabic_Quran_array.each_with_index do | line , index |
        chapter_and_verse_numbers_array = parser.parse_chapter_and_verse_numbers(line);
        
        if freeze_now
            byebug
        end

        if chapter_and_verse_numbers_array == argument_chapter_and_verse_numbers_array
            freeze_now = true
        end
    end
    
    # return was frozen for x time_unit
    return true
end



# freeze_1_verse_after([ 2 , 1 ])

QuranParser.new("arabic.original.txt").build_Quran_including_unnumbered_verses()
# add basmALLAH to arabic.original.txt as [ x , 0 ]

# (2..114).to_a.each do |ch_integer|
#     if ch_integer != 9 # if its not chapter 9
#        puts "#{ch_integer}|0|بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
#         byebug
#     end
# end














# final byebug
byebug

Dir
3