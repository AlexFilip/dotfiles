import gdb
import gdb.printing

# A pretty-printer for gdb to display custom string and array structs.
# This assumes you are using a struct with the following form
#   struct (string|array|dynamic_array) {
#       int Length;
#       type* Contents; // type is char for string and a template parameter for (dynamic_)array.
#   };
# Names of the members and types can be adjusted below. Any other members can be present in
# the struct. For example, dynamic_array has a Capacity member that is not shown here.
# This script also makes unions only display their member names and not their contents to avoid
# dereferencing an invalid pointer when an array or struct is contained inside of a union.
# If you would like to extend this functionality, the union code is at the bottom of the file.

# To use this script, copy it into ~/.gdb/python/gdb_print_string.py and add the .gdbinit file
# included with this gist. It will source all python files inside of ~/.gdb/python/

string_regex = '^string$'
array_regex  = '^(dynamic_)?array<[_A-Za-z0-9\\*<>\\s]+>$'
length_member_name = 'Length'
contents_member_name = 'Contents'

class StringPrinter(object):
    def __init__(self, val):
        self.val = val
        self.char_type = gdb.lookup_type('char')

    def children(self):
        length = self.val[length_member_name]
        contents = self.val[contents_member_name].string(length=length)
        return [("Length", length), ("Contents", '"' + contents + '"')]

class ArrayPrinter(object):
    def __init__(self, val):
        self.val = val

    def children(self):
        length = self.val[length_member_name]
        contents = self.val[contents_member_name]
        result = []
        result = [(str(index), contents[index]) for index in range(length)]
        return [("Length", length)] + result

    # This makes gdb only print the values. If you would like to enable this
    # you may want to remove the addition of "Length" above to avoid confusion
    # def display_hint(self):
    #     return 'array'

pretty_printer = gdb.printing.RegexpCollectionPrettyPrinter("CustomPrinter")
pretty_printer.add_printer('string', string_regex, StringPrinter)
pretty_printer.add_printer('array', array_regex, ArrayPrinter)

objfile = gdb.current_objfile()
gdb.printing.register_pretty_printer(
    objfile,
    pretty_printer,
    replace=True)

# ---

class UnionPrinter(object):
    def __init__(self, val):
        self.val = val

    def children(self):
        fields = self.val.type.fields()
        return [(field.name, "{...}") for field in fields]

def union_printer_lookup(val):
    if val.type.code == gdb.TYPE_CODE_UNION:
        return UnionPrinter(val)
    return None

gdb.pretty_printers.append(union_printer_lookup)
