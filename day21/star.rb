require 'set'

def addr(reg, a, b, c)
  reg[c] = reg[a] + reg[b]
  reg
end

def addi(reg, a, b, c)
  reg[c] = reg[a] + b
  reg
end

def mulr(reg, a, b, c)
  reg[c] = reg[a] * reg[b]
  reg
end

def muli(reg, a, b, c)
  reg[c] = reg[a] * b
  reg

end

def banr(reg, a, b, c)
  reg[c] = reg[a] & reg[b]
  reg
end

def bani(reg, a, b, c)
  reg[c] = reg[a] & b
  reg
end

def borr(reg, a, b, c)
  reg[c] = reg[a] | reg[b]
  reg
end

def bori(reg, a, b, c)
  reg[c] = reg[a] | b
  reg
end

def setr(reg, a, b, c)
  reg[c] = reg[a]
  reg
end

def seti(reg, a, b, c)
  reg[c] = a
  reg

end

def gtir(reg, a, b, c)
  reg[c] = a > reg[b] ? 1 : 0
  reg
end

def gtri(reg, a, b, c)
  reg[c] = reg[a] > b ? 1 : 0
  reg
end

def gtrr(reg, a, b, c)
  reg[c] = reg[a] > reg[b] ? 1 : 0
  reg
end

def eqir(reg, a, b, c)
  reg[c] = (a == reg[b] ? 1 : 0)
  reg
end

def eqri(reg, a, b, c)
  reg[c] = (reg[a] == b ? 1 : 0)
  reg
end

def eqrr(reg, a, b, c)
  reg[c] = (reg[a] == reg[b] ? 1 : 0)
  reg
end

code_list = [
    method(:addr),
    method(:addi),
    method(:mulr),
    method(:muli),
    method(:banr),
    method(:bani),
    method(:borr),
    method(:bori),
    method(:setr),
    method(:seti),
    method(:gtir),
    method(:gtri),
    method(:gtrr),
    method(:eqir),
    method(:eqri),
    method(:eqrr)
]

OPCODES = {}

code_list.each do |m|
  OPCODES[m.name] = m
end

class Device

  def initialize(instruction_reg)
    @registers = [0, 0, 0, 0, 0, 0]
    @ip = 0
    @instruction_reg = instruction_reg
  end

  def run(instr, a, b, c)
    meth = OPCODES[instr]
    if meth.nil?
      raise "Couldn't find #{instr}"
    end
    @registers[@instruction_reg] = @ip

    meth.call(@registers, a, b, c)
    @ip = @registers[@instruction_reg] + 1
  end

  def run_program(lines)
    program = lines.map do |line|
      it = line.split(" ")
      [it[0].to_sym, it[1].to_i, it[2].to_i, it[3].to_i]
    end

    count = 0

    until @ip >= program.size
      register = @registers.dup
      register[@instruction_reg] = @ip
      ip = @ip
      run(*program[@ip])
      puts "#{ip}: #{register.inspect} -> #{@registers.inspect}"
      if @ip == 28
        if count == 0
          exit(0)
        end
        count +=1
      end
    end

    puts @registers.inspect

  end
end

input = File.read("day21-input.txt").split("\n")
instruction_register = input.shift.split(" ")[1].to_i

Device.new(instruction_register).run_program(input)