from email import message
from webbrowser import BackgroundBrowser
from inputs import get_gamepad
import math
import threading
import socket
import time
import keyboard

Stem = input("Введите уникальный канал Stem ")

sock = socket.socket()

def safe_send(s):
  if isinstance(s, int): s = chr(s).encode('ascii')
  if isinstance(s, str): s = s.encode('utf-8')
  i = 0
  while i < len(s): i += sock.send(s[i:])

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

def send(channel, msg):
  try:
    send_package(0, channel, msg)
  except ConnectionAbortedError:
    global sock
    sock = socket.socket()
    sock.connect(('stem.fomalhaut.me', 5733))
    send_package(0, channel, msg)


sock.connect(('stem.fomalhaut.me', 5733))


class XboxController(object):
    MAX_TRIG_VAL = math.pow(2, 8)
    MAX_JOY_VAL = math.pow(2, 15)

    def __init__(self):

        self.LeftJoystickY = 0
        self.LeftJoystickX = 0
        self.RightJoystickY = 0
        self.RightJoystickX = 0
        self.LeftTrigger = 0
        self.RightTrigger = 0
        self.LeftBumper = 0
        self.RightBumper = 0
        self.A = 0
        self.X = 0
        self.Y = 0
        self.B = 0
        self.LeftThumb = 0
        self.RightThumb = 0
        self.Back = 0
        self.Start = 0
        self.LeftDPad = 0
        self.RightDPad = 0
        self.UpDPad = 0
        self.DownDPad = 0

        self._monitor_thread = threading.Thread(target=self._monitor_controller, args=())
        self._monitor_thread.daemon = True
        self._monitor_thread.start()


    def read(self):
        X = self.RightJoystickX
        Y = self.RightJoystickY
        Alt = self.LeftJoystickY
        Place = self.RightBumper
        Break = self.LeftBumper
        Leash = self.Y #X
        UnLeash = self.X #Y
        Take = self.A
        Drop = self.B
        Quit = self.LeftThumb
        Forward = self.UpDPad
        Right = self.RightDPad
        Back = self.DownDPad
        Left = self.LeftDPad
        
        if Alt <= -0.5 :
          send(Stem, 'z')
          print("Вниз")
          time.sleep(1)

        elif Alt >= 0.5 :
          send(Stem, "x")
          print("ВВерх")
          time.sleep(1)

        elif Y <= -0.5 :
          send(Stem, "s")
          print("Назад")
          time.sleep(0.5)

        elif Y >= 0.5 :
          send(Stem, "w")
          print("Вперёд")
          time.sleep(0.5)

        elif X <= -0.5 :
          send(Stem, "a")
          print("Влево")
          time.sleep(0.5)

        elif X >= 0.5 :
          send(Stem, "d")
          print("Вправо")
          time.sleep(0.5)

        if Place == 1 :
          send(Stem, 'f')
          print("Поставить")
          time.sleep(0.5)

        elif Break == 1 :
          send(Stem, 'r')
          print("Сломать")
          time.sleep(0.5)

        elif Take == 1 :
          send(Stem, 'e')
          print("Взять")
          time.sleep(0.5)

        elif Drop == 1 :
          send(Stem, 'q')
          print("Выкинуть")
          time.sleep(0.5)

        elif Leash == 1 :
          send(Stem, 'g')
          print("Привязать")
          time.sleep(0.5)

        elif UnLeash == 1 :
          send(Stem, 't')
          print("Отвязать")
          time.sleep(0.5)
        
        elif Quit == 1 :
          send(Stem, "quit")
          print("Выход")
          time.sleep(0.5)
        
        elif Forward == 1 :
          send(Stem, "forward")
          print("Выбранная сторона - вперёд")
          time.sleep(0.5)

        elif Right == 1 :
          send(Stem, "Right")
          print("Выбранная сторона - вправо")
          time.sleep(0.5)
        
        elif Back == 1 :
          send(Stem, "Back")
          print("Выбранная сторона - назад")
          time.sleep(0.5)

        elif Left == 1 :
          send(Stem, "Left")
          print("Выбранная сторона - влево")
          time.sleep(0.5)

        
    def _monitor_controller(self):
        while True:
            events = get_gamepad()
            for event in events:
                if event.code == 'ABS_Y':
                    self.LeftJoystickY = event.state / XboxController.MAX_JOY_VAL # normalize between -1 and 1
                elif event.code == 'ABS_X':
                    self.LeftJoystickX = event.state / XboxController.MAX_JOY_VAL # normalize between -1 and 1
                elif event.code == 'ABS_RY':
                    self.RightJoystickY = event.state / XboxController.MAX_JOY_VAL # normalize between -1 and 1
                elif event.code == 'ABS_RX':
                    self.RightJoystickX = event.state / XboxController.MAX_JOY_VAL # normalize between -1 and 1
                elif event.code == 'ABS_Z':
                    self.LeftTrigger = event.state / XboxController.MAX_TRIG_VAL # normalize between 0 and 1
                elif event.code == 'ABS_RZ':
                    self.RightTrigger = event.state / XboxController.MAX_TRIG_VAL # normalize between 0 and 1
                elif event.code == 'BTN_TL':
                    self.LeftBumper = event.state
                elif event.code == 'BTN_TR':
                    self.RightBumper = event.state
                elif event.code == 'BTN_SOUTH':
                    self.A = event.state
                elif event.code == 'BTN_NORTH':
                    self.X = event.state
                elif event.code == 'BTN_WEST':
                    self.Y = event.state
                elif event.code == 'BTN_EAST':
                    self.B = event.state
                elif event.code == 'BTN_THUMBL':
                    self.LeftThumb = event.state
                elif event.code == 'BTN_THUMBR':
                    self.RightThumb = event.state
                elif event.code == 'BTN_SELECT':
                    self.Back = event.state
                elif event.code == 'BTN_START':
                    self.Start = event.state
                elif event.code == 'BTN_TRIGGER_HAPPY1':
                    self.LeftDPad = event.state
                elif event.code == 'BTN_TRIGGER_HAPPY2':
                    self.RightDPad = event.state
                elif event.code == 'BTN_TRIGGER_HAPPY3':
                    self.UpDPad = event.state
                elif event.code == 'BTN_TRIGGER_HAPPY4':
                    self.DownDPad = event.state


if __name__ == '__main__':
    joy = XboxController()
    while True:
      joy.read()
