from django.shortcuts import render, redirect
from django.db import connection

def register_view(request):
    error = None
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO login (username, password) VALUES (%s, %s)",
                    [username, password]
                )
            return redirect('/login/')
        except Exception:
            error = "Roll No already exists."
    return render(request, 'register.html', {'error': error})

def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT 1 FROM login WHERE username = %s AND password = %s",
                [username, password]
            )
            if cursor.fetchone():
                request.session['username'] = username
                return redirect('/')
    return render(request, 'login.html')

def home_view(request):
    if 'username' not in request.session:
        return redirect('/login/')
    return render(request, 'home.html', {'roll_no': request.session['username']})

def logout_view(request):
    request.session.flush()
    return redirect('/login/')