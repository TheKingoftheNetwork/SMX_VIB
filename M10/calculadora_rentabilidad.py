def calcular_rentabilidad(ingresos, costo_bienes_vendidos, gastos_operativos, inversion, deuda, activos_totales, capital_propio, pais):
    tasas_impuestos = {
        "USA": 0.21,
        "Canadá": 0.26,
        "Reino Unido": 0.19,
        "Australia": 0.30,
        "España": 0.25
    }
    monedas = {
        "USA": "USD",
        "Canadá": "CAD",
        "Reino Unido": "GBP",
        "Australia": "AUD",
        "España": "EUR"
    }

    if pais not in tasas_impuestos or pais not in monedas:
        raise ValueError(f"País '{pais}' no reconocido.")

    tasa_impuesto = tasas_impuestos[pais]
    moneda = monedas[pais]

    ganancia_bruta = ingresos - costo_bienes_vendidos
    ganancia_neta_antes_de_impuestos = ganancia_bruta - gastos_operativos
    impuestos = ganancia_neta_antes_de_impuestos * tasa_impuesto
    ganancia_neta_despues_de_impuestos = ganancia_neta_antes_de_impuestos - impuestos
    roi_porcentaje = (ganancia_neta_despues_de_impuestos / inversion) * 100
    roi_dinero = ganancia_neta_despues_de_impuestos - inversion
    margen_ganancia_neta = (ganancia_neta_despues_de_impuestos / ingresos) * 100
    interes_sobre_deuda = deuda * 0.05
    razon_cobertura_intereses = ganancia_neta_antes_de_impuestos / interes_sobre_deuda
    inventario = 10000
    razon_liquidez = (activos_totales - inventario) / deuda
    razon_solvenica = activos_totales / deuda
    roa = (ganancia_neta_despues_de_impuestos / activos_totales) * 100
    roe = (ganancia_neta_despues_de_impuestos / capital_propio) * 100

    print(f"País: {pais}")
    print(f"Ingresos: {ingresos} {moneda}")
    print(f"Costo de Bienes Vendidos: {costo_bienes_vendidos} {moneda}")
    print(f"Gastos Operativos: {gastos_operativos} {moneda}")
    print(f"Inversión: {inversion} {moneda}")
    print(f"Ganancia Bruta: {ganancia_bruta} {moneda}")
    print(f"Ganancia Neta antes de impuestos: {ganancia_neta_antes_de_impuestos} {moneda}")
    print(f"Impuestos: {impuestos} {moneda}")
    print(f"Ganancia Neta después de impuestos: {ganancia_neta_despues_de_impuestos} {moneda}")
    print(f"Retorno de la Inversión (ROI): {roi_porcentaje:.2f}%")
    print(f"Retorno de la Inversión en dinero: {roi_dinero} {moneda}")
    print(f"Margen de Ganancia Neta: {margen_ganancia_neta:.2f}%")
    print(f"Razón de Cobertura de Intereses: {razon_cobertura_intereses:.2f}")
    print(f"Razón de Liquidez: {razon_liquidez:.2f}")
    print(f"Razón de Solvencia: {razon_solvenica:.2f}")
    print(f"Rentabilidad de los Activos (ROA): {roa:.2f}%")
    print(f"Rentabilidad del Capital (ROE): {roe:.2f}%")

    umbral_roi = 10
    umbral_roa = 5
    umbral_roe = 10
    umbral_razon_cobertura_intereses = 3
    umbral_razon_liquidez = 1.5
    umbral_margen_ganancia_neta = 15
    umbral_razon_solvenica = 1.5

    print("\nAnálisis de Rentabilidad:")

    es_rentable = True

    if roi_porcentaje < umbral_roi:
        print(f"- El retorno de la inversión (ROI) es bajo: {roi_porcentaje:.2f}%.")
        es_rentable = False
    else:
        print(f"- El retorno de la inversión (ROI) es alto: {roi_porcentaje:.2f}%.")
        
    if roi_dinero > 0:
        print(f"- El retorno de la inversión en dinero es positivo: {roi_dinero} {moneda}.")
    elif roi_dinero < 0:
        print(f"- El retorno de la inversión en dinero es negativo: {roi_dinero} {moneda}.")
        es_rentable = False
    else:
        print(f"- El retorno de la inversión en dinero es nulo: {roi_dinero} {moneda}.")

    if margen_ganancia_neta < umbral_margen_ganancia_neta:
        print(f"- El margen de ganancia neta es bajo: {margen_ganancia_neta:.2f}%.")
        es_rentable = False
    else:
        print(f"- El margen de ganancia neta es alto: {margen_ganancia_neta:.2f}%.")
        
    if razon_cobertura_intereses < umbral_razon_cobertura_intereses:
        print(f"- La razón de cobertura de intereses es baja: {razon_cobertura_intereses:.2f}.")
        es_rentable = False
    else:
        print(f"- La razón de cobertura de intereses es alta: {razon_cobertura_intereses:.2f}.")
        
    if razon_liquidez < umbral_razon_liquidez:
        print(f"- La razón de liquidez es baja: {razon_liquidez:.2f}.")
        es_rentable = False
    else:
        print(f"- La razón de liquidez es alta: {razon_liquidez:.2f}.")

    if razon_solvenica < umbral_razon_solvenica:
        print(f"- La razón de solvencia es baja: {razon_solvenica:.2f}.")
        es_rentable = False
    else:
        print(f"- La razón de solvencia es alta: {razon_solvenica:.2f}.")
        
    if roa < umbral_roa:
        print(f"- La rentabilidad de los activos (ROA) es baja: {roa:.2f}%.")
        es_rentable = False
    else:
        print(f"- La rentabilidad de los activos (ROA) es alta: {roa:.2f}%.")
        
    if roe < umbral_roe:
        print(f"- La rentabilidad del capital (ROE) es baja: {roe:.2f}%.")
        es_rentable = False
    else:
        print(f"- La rentabilidad del capital (ROE) es alta: {roe:.2f}%.")
        
    print("\nEVALUACIÓN FINAL:")
    
    if es_rentable:
        print("\033[1m\033[32mLA EMPRESA ES RENTABLE.\033[0m")
    else:
        print("\033[1m\033[31mLA EMPRESA NO ES RENTABLE.\033[0m")

calcular_rentabilidad(
    ingresos=120000,
    costo_bienes_vendidos=45000,
    gastos_operativos=15000,
    inversion=40000,
    deuda=20000,
    activos_totales=100000,
    capital_propio=50000,
    pais="España"
)
