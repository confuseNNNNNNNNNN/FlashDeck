import socket
import json
import threading
from database_manager import DatabaseManager

def start_server():
    db = DatabaseManager()
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Localhost port for internal app communication
    server.bind(('127.0.0.1', 65432))
    server.listen(5)
    print("Python 3.13 Bridge Active...")

    while True:
        try:
            client, _ = server.accept()
            data = client.recv(8192).decode('utf-8')
            if not data: break
            
            req = json.loads(data)
            res = {"status": "error"}

            if req['action'] == 'GET_DECKS':
                res = {"status": "success", "data": db.get_decks()}
            
            elif req['action'] == 'GET_CARDS':
                res = {"status": "success", "data": db.get_due_cards(req['deck_id'])}
            
            elif req['action'] == 'ADD_CARD':
                db.add_card(req['payload'])
                res = {"status": "success"}
                
            elif req['action'] == 'REVIEW_CARD':
                db.process_review(req['card_id'], req['quality'])
                res = {"status": "success"}

            client.send(json.dumps(res).encode('utf-8'))
            client.close()
        except Exception as e:
            print(f"Bridge Error: {e}")

if __name__ == "__main__":
    start_server()