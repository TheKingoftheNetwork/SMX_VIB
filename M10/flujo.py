import pandas as pd

meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
calendario_flujo_caja = pd.DataFrame(index=meses)

ingresos = [5000, 5200, 5400, 5600, 5800, 6000, 6200, 6400, 6600, 6800, 7000, 7200]
calendario_flujo_caja['Ingresos'] = ingresos

gastos = [3500, 3700, 3900, 4100, 4300, 4500, 4700, 4900, 5100, 5300, 5500, 5700]
calendario_flujo_caja['Gastos'] = gastos

calendario_flujo_caja['Saldo Neto'] = calendario_flujo_caja['Ingresos'] - calendario_flujo_caja['Gastos']

gastos_anuales_totales = calendario_flujo_caja['Gastos'].sum()
fondo_emergencia = gastos_anuales_totales * 0.25
fondo_emergencia = round(fondo_emergencia, 2)

print("Calendario de Flujo de Caja:")
print(calendario_flujo_caja)
print("\nFondo de Emergencia:", fondo_emergencia)
