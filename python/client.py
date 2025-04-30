# client.py
import asyncio
import websockets
import serial
import json

# Conexión con ESP32 (ajusta el puerto según tu sistema operativo)
ser = serial.Serial('/dev/ttyUSB0', 9600)  # Ejemplo para Linux o Mac
# ser = serial.Serial('COM3', 9600)       # Ejemplo para Windows

async def enviar_datos():
    async with websockets.connect("ws://localhost:3003") as websocket:
        print("🔗 Conectado al servidor Node.js")

        while True:
            if ser.in_waiting > 0:
                raw_data = ser.readline().decode('utf-8').strip()
                print("📩 Recibido de ESP32:", raw_data)

                try:
                    # El ESP32 debe enviar JSON como:
                    # {"ph":7.1,"tds":500,"temperatura":28.4,"turbidez":0.3}
                    data = json.loads(raw_data)
                    data['estacion_id'] = 1  # Cambia si tienes más de una estación

                    await websocket.send(json.dumps(data))
                    print("Enviado a Node.js:", data)
                except json.JSONDecodeError:
                    print("Error al decodificar JSON")
            
            await asyncio.sleep(5)  # Espera antes de leer el siguiente dato

asyncio.run(enviar_datos())
