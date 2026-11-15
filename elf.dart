import 'dart:io';
import 'dart:typed_data';

class ByteReader {
  ByteReader(this.data);
  Endian endian = Endian.big;
  final ByteData data;
  late bool is32bit;
  int index = 0;
  int uint32() {
    int value = data.getUint32(index, endian);
    index += 4;
    return value;
  }
  int uint16() {
    int value = data.getUint16(index, endian);
    index += 2;
    return value;
  }
  int uint8() {
    int value = data.getUint8(index);
    index += 1;
    return value;
  }
  int uint64() {
    int value = data.getUint64(index, endian);
    index += 8;
    return value;
  }
  int uint() {
    return is32bit ? uint32() : uint64();
  }
}

void main(List<String> args) {
  ByteReader file = ByteReader(File(args.isEmpty ? "/bin/ls" : args.single).readAsBytesSync().buffer.asByteData());
  if(file.uint32() == 0x7f454c46) {
    print("parsing ELF file...");
  } else {
    throw "is not ELF file";
  }
  file.is32bit = file.uint8() == 1;
  file.endian = file.uint8() == 1 ? Endian.little : Endian.big;
  if(file.uint8() != 1) {
    throw "Unsupported ELF version";
  }
  if(file.uint8() != 0) {
    throw "EI_OSABI not 0";
  }
  if(file.uint64() != 0) {
    throw "EI_PAD not 0";
  }
  int e_type = file.uint16();
  if(e_type != 2 && e_type != 3) {
    throw "e_type not 2 (ET_EXEC) or 3 (ET_DYN), is $e_type";
  }
  int e_machine = file.uint16(); // should be 0x28 (ARM) for executables for this computer (note from later me: i found this program on a mac, but i think those use mach-o, which leads me to believe "this computer" actually means an rpi, but i copied it onto the mac as a backup.)
  print("This file is meant for " + getMachineName(e_machine));
  if(file.uint32() != 1) {
    throw "Unsupported ELF version";
  }
  int e_entry = file.uint();
  int e_phoff = file.uint();
  int e_shoff = file.uint();
  int e_flags = file.uint32();
  int e_ehsize = file.uint16();
  int e_phentsize = file.uint16();
  int e_phnum = file.uint16();
  int e_shentsize = file.uint16();
  int e_shnum = file.uint16();
  int e_shstrndx = file.uint16();
  if(file.index != e_ehsize) {
    print("Wrong index at end of file header: ${file.index}");
  }
  file.index = e_phoff;
  for (int i = 0; i < e_phnum; i++) {
    int p_flags;
    int p_type_raw = file.uint32();
    Ptype p_type;
    if (p_type_raw < 8) {
      p_type = Ptype.values[p_type_raw];
    } else if (p_type_raw >= 0x60000000 && p_type_raw <= 0x6FFFFFFF) {
      p_type = Ptype.OS;
    } else if (p_type_raw >= 0x70000000 && p_type_raw <= 0x7FFFFFFF) {
      p_type = Ptype.PROC;
    } else {
      throw "Unrecognized p_type: ${p_type_raw.toRadixString(16)}";
    }
    //print("p_type of program header $i $p_type");
    if(file.is32bit) p_flags = file.uint32();
    int p_offset = file.uint();
    int p_vaddr = file.uint();
    int p_paddr = file.uint();
    int p_filesz = file.uint();
    int p_memsz = file.uint();
    if(!file.is32bit) p_flags = file.uint32();
    int p_align = file.uint();
    if(e_phoff + (e_phentsize * (i+1)) != file.index) {
      throw StateError("Wrong index at end of program header table entry ${file.index.toRadixString(16)}");
    }
  }
  file.index = e_shoff;
  List<SectionHeader> sectionHeaders = [];
  for(int i = 0; i < e_shnum; i++) {
    int sh_name = file.uint32();
    Shtype sh_type;
    int sh_type_raw = file.uint32();
    if(sh_type_raw < 20) {
      sh_type = Shtype.values[sh_type_raw];
    } else if(sh_type_raw >= 0x60000000 && sh_type_raw <= 0x6FFFFFFF) {
      sh_type = Shtype.OS;
    } else if(sh_type_raw >= 0x70000000 && sh_type_raw <= 0x7FFFFFFF) {
      sh_type = Shtype.PROC;
    } else if(sh_type_raw >= 0x80000000 && sh_type_raw <= 0xFFFFFFFF) {
      sh_type = Shtype.USER;
    } else {
       throw "Unrecognized sh_type: ${sh_type_raw.toRadixString(16)}";
    }
    int sh_flags = file.uint();
    int sh_addr = file.uint();
    int sh_offset = file.uint();
    int sh_size = file.uint();
    int sh_link = file.uint32();
    int sh_info = file.uint32();
    int sh_addr_align = file.uint();
    int sh_ent_size = file.uint();
    SectionHeader sectionHeader = SectionHeader(sh_name, sh_type, sh_flags, sh_addr, sh_offset, sh_size, sh_link, sh_info, sh_addr_align, sh_ent_size);
    sectionHeaders.add(sectionHeader);
    if(e_shoff + (e_shentsize * (i+1)) != file.index) {
      throw StateError("Wrong index at end of section header table entry ${file.index.toRadixString(16)}");
    }
  }
  for(SectionHeader header in sectionHeaders) {
    StringBuffer buffer = StringBuffer();
    file.index = sectionHeaders[e_shstrndx].sh_offset + header.sh_name;
    while(true) {
      int char = file.uint8();
      if(char == 0) break;
      buffer.write(String.fromCharCode(char));
    }
    //print(buffer.toString() + " (${header.sh_type})");
  }
  file.index = e_entry;
  while(true) {
    int instruction = file.uint32();
    int cond = instruction >> 28;
    if(cond != 0xE) {
      throw("Cond not AL (always), is $cond");
    }
    int op = (instruction & (15 << 24)) >> 26;
    if(op != 0xF) {
      throw("Op not 15, is $op");
    }
    print("Software Interrupt");
  }
}

String getMachineName(int machine) {
  switch (machine) { // note from later me: iirc this list is copied from wikipedia
    case 0x0: return "Unspecified";
    case 0x1: return "AT&T WE 32100";
    case 0x2: return "SPARC";
    case 0x3: return "x86";
    case 0x4: return "Motorola 68000";
    case 0x5: return "Motorola 88000";
    case 0x6: return "Intel MCU";
    case 0x7: return "Intel 80860";
    case 0x8: return "MIPS";
    case 0x9: return "IBM_System/370";
    case 0xA: return "MIPS RS3000 Little endian";
    case 0xE: return "Hewlette-Packard PA-RISC";
    case 0x13: return "Intel 80960";
    case 0x14: return "PowerPC";
    case 0x15: return "PowerPC (64 bit)";
    case 0x16: return "S390";
    case 0x17: return "IBM SPU/SPC";
    case 0x24: return "NEC V800";
    case 0x25: return "Fujitsu FR20";
    case 0x26: return "TRW RH-32";
    case 0x27: return "Motorola RCE";
    case 0x28: return "ARM";
    case 0x29: return "Digital Alpha";
    case 0x2A: return "SuperH";
    case 0x2B: return "SPARC Version 9";
    case 0x2C: return "Siemens Tri-Core embedded proccesor";
    case 0x2D: return "Argonaut RISC Core";
    case 0x2E: return "Hitachi H8/300";
    case 0x2F: return "Hitachi H8/300H";
    case 0x30: return "Hitachi H8S";
    case 0x31: return "Hitachi H8/500";
    case 0x32: return "IA-64";
    case 0x33: return "Stanford MIPS-X";
    case 0x34: return "Motorola Cold Fire";
    case 0x35: return "Motorola M68HC12";
    case 0x36: return "Fujitsu MMA Multimedia Accelerator";
    case 0x37: return "Siemens PCP";
    case 0x38: return "Sony nCPU embedded RISC proccesor";
    case 0x39: return "Denso NDR1 microproccesor";
    case 0x3A: return "Motorola Star*Core proccesor";
    case 0x3B: return "Toyota ME16 proccessor";
    case 0x3C: return "STMicroelectronics ST100 processor";
    case 0x3D: return "Advanced Logic Corp. TinyJ embedded processor family";
    case 0x3E: return "AMD x86-64";
    case 0x8C: return "TMS320C6000 Family";
    case 0xAF: return "MCST Elbrus e2k";
    case 0xB7: return "ARM 64-bits";
    case 0xF3: return "RISC-V";
    case 0xF7: return "Berkeley Packet Filter";
    case 0x101: return "WDC 65C816";
    default: throw "Unrecognised E_MACHINE";
  }
}

class SectionHeader {
  SectionHeader(this.sh_name, this.sh_type, this.sh_flags, this.sh_addr, this.sh_offset, this.sh_size, this.sh_link, this.sh_info, this.sh_addr_align, this.sh_ent_size);
  final int sh_name;
  final Shtype sh_type;
  final int sh_flags;
  final int sh_addr;
  final int sh_offset;
  final int sh_size;
  final int sh_link;
  final int sh_info;
  final int sh_addr_align;
  final int sh_ent_size;
}

enum Ptype {
  PT_NULL,
  PT_LOAD,
  PT_DYNAMIC,
  PT_INTERP,
  PT_NOTE,
  PT_SHLIB,
  PT_PHDR,
  PT_TLS,
  OS,
  PROC,
}

enum Shtype {
  SHT_NULL,
  SHT_PROGBITS,
  SHT_SYMTAB,
  SHT_STRTAB,
  SHT_RELA,
  SHT_HASH,
  SHT_DYNAMIC,
  SHT_NOTE,
  SHT_NOBITS,
  SHT_REL,
  SHT_SHLIB,
  SHT_DYNSYM,
  RESERVED,
  RESERVED2,
  SHT_INIT_ARRAY,
  SHT_FINI_ARRAY,
  SHT_PREINIT_ARRAY,
  SHT_GROUP,
  SHT_SYMTAB_SHNXD,
  SHT_NUM,
  OS,
  PROC,
  USER,
}
