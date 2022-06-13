from http import client
import socket
import discord


#Тут указываем канал stem
Stem = input("Введите уникальный канал Stem ")
#Token дискорд бота
Token = input("Введите токин своего дискорд бота ")

sock = socket.socket()

def safe_send(s):
  if isinstance(s, int): s = chr(s).encode('ascii')
  if isinstance(s, str): s = s.encode('utf-8')
  i = 0
  while i < len(s): i += sock.send(s[i:])

def safe_recv(n):
  data = b''
  while len(data) < n: data += sock.recv(n - len(data))
  return data

def send_package(_type, _id, _message=None):
  pack = chr(_type).encode('ascii')
  if _type == 3 or _type == 4:
    pack += _id
  else:
    pack += chr(len(_id)).encode('ascii')
    pack += _id.encode('utf-8')
    if _message: pack += _message.encode('utf-8')
  
  safe_send(len(pack) // 256)
  safe_send(len(pack) % 256)
  safe_send(pack)

def subscribe(channel):
  send_package(1, channel)

def send(channel, msg):
  send_package(0, channel, msg)

sock.connect(('stem.fomalhaut.me', 5733))


class MyClient(discord.Client):
  async def on_message(self, message):
    if message.content.startswith('w'):
      await message.channel.send('Forward')
      print("Forward")
      safe_recv(1)
      send(Stem, 'w')

    elif message.content.startswith('s'):
      await message.channel.send('Back')
      print("Back")
      safe_recv(1)
      send(Stem, 's')

    elif message.content.startswith('d'):
      await message.channel.send('Turn Right')
      print("Turn Right")
      safe_recv(1)
      send(Stem, 'd')

    elif message.content.startswith('a'):
      await message.channel.send('Turn Left')
      print("Turn Left")
      safe_recv(1)
      send(Stem, 'a')
    
    elif message.content.startswith('z'):
      await message.channel.send('Down')
      print("Down")
      safe_recv(1)
      send(Stem, 'z')

    elif message.content.startswith('x'):
      await message.channel.send('Up')
      print("Up")
      safe_recv(1)
      send(Stem, 'x')

    elif message.content.startswith('g'):
      await message.channel.send('Place')
      print("Place")
      safe_recv(1)
      send(Stem, 'g')
    
    elif message.content.startswith('t'):
      await message.channel.send('Drop')
      print("Drop")
      safe_recv(1)
      send(Stem, 't')

client = MyClient()
client.run(Token)
safe_recv(1)