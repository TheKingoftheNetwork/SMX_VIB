numero_usuarios = 1000
precio_primer_mes = 0.99
precio_meses_posteriores = 2.99
meses = 12
costo_operativo_mensual = 500
costo_adquisicion_usuario = 10

ingresos_primer_mes = numero_usuarios * precio_primer_mes
ingresos_meses_posteriores = numero_usuarios * precio_meses_posteriores * (meses - 1)
ingresos_totales = ingresos_primer_mes + ingresos_meses_posteriores

costos_operacion = costo_operativo_mensual * meses
costos_adquisicion = costo_adquisicion_usuario * numero_usuarios
costos_totales = costos_operacion + costos_adquisicion

ganancias_netas = ingresos_totales - costos_totales
inversion_inicial = costos_adquisicion
roi = (ganancias_netas / inversion_inicial) * 100

meses_lista = list(range(1, meses + 1))

resultados_hoja3 = []

for mes in meses_lista:
    if mes == 1:
        ingresos_mes = ingresos_primer_mes
    else:
        ingresos_mes = numero_usuarios * precio_meses_posteriores
    
    costos_operativos_mes = costo_operativo_mensual
    costos_adquisicion_mes = costo_adquisicion_usuario * numero_usuarios
    costos_totales_mes = costos_operativos_mes + costos_adquisicion_mes
    ganancias_netas_mes = ingresos_mes - costos_totales_mes
    
    if costos_totales_mes > 0:
        roi_mensual = (ganancias_netas_mes / costos_totales_mes) * 100
    else:
        roi_mensual = 0
    
    resultados_mes = {
        "Mes": mes,
        "Ingresos totales": f"{ingresos_mes:.2f} €",
        "Costos totales": f"{costos_totales_mes:.2f} €",
        "Ganancias netas": f"{ganancias_netas_mes:.2f} €",
        "ROI mensual": f"{roi_mensual:.2f} %"
    }
    
    resultados_hoja3.append(resultados_mes)

resultados_hoja3
