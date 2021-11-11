import pandas as pd
from tqdm import tqdm
import glob
# Записываем в файл


def writeToFile(filename,result):
    writer = pd.ExcelWriter(f"result/{filename}.xls", engine='xlsxwriter')
    result.to_excel(writer, 'result', index=False)
    writer.save()
# устанавливаем количество рабочих и стоимость экспорта


def setKolvoRabAndStoimEksp():
    result.drop_duplicates(subset='ИНН', inplace=True)
    chisl_rab.columns = ['', 'Название компании', 'ИНН',
                         'ОКВЭД 2014, основной код', 'Number of Employees\n2019',
                         'Number of Employees\n2018', 'Number of Employees\n2017',
                         'Number of Employees\n2016', 'Number of Employees\n2015',
                         'Number of Employees\n2014', 'Number of Employees\n2013',
                         'Number of Employees\n2012', 'Number of Employees\n2011',
                         'Number of Employees\n2010']
    years = result.columns.intersection(
        chisl_rab.columns).drop('ИНН', 'Название компании')
    stoimost_eksp.columns = ['ИНН', 'Стоимость экспорта 2013, USD',
                             'Стоимость экспорта 2014, USD', 'Стоимость экспорта 2015, USD',
                             'Стоимость экспорта 2016, USD', 'Стоимость экспорта 2017, USD']
    for i in tqdm(range(len(chisl_rab.index))):
        for year in years:
            result.loc[result['ИНН'] == (
                chisl_rab.iloc[i]['ИНН']), year] = chisl_rab.iloc[i][year]
    eksp_years = result.columns.intersection(stoimost_eksp.columns).drop('ИНН')
    for i in tqdm(range(len(stoimost_eksp.index))):
        for eksp_year in eksp_years:
            result.loc[result['ИНН'] == (
                stoimost_eksp.iloc[i]['ИНН']), eksp_year] = stoimost_eksp.iloc[i][eksp_year]

# добавляем не получателей


# def NePoluchat(nepol,result):
    

# добавляем по оквэду получателей


def addOKVED(startWith,result):
    for i in tqdm(range(len(tabl_with_comp.index))):
        if str(tabl_with_comp.iloc[i]['ОКВЭД 2014']).startswith(startWith):
            result = result.append(tabl_with_comp.iloc[[i]], ignore_index=True)
    # добавляем столбец Dummy
    result['Dummy'] = 1
    last_index_result = len(result.index)
    return result


if __name__ == '__main__':
    tabl_with_comp = pd.read_excel(
        "Таблица по компаниям с экспортом.xls", sheet_name='ИТОГ.Без дубликатов', dtype=str)
    stoimost_eksp = pd.read_excel(
        'Таблица по компаниям с экспортом.xls', sheet_name='Экспорт', dtype=str)

    nepolList = [f for f in glob.glob("неполучатели/*.xls*")]
    chislRabList = [f for f in glob.glob("Численность работников/*.xls*")]
    for nepol in nepolList:
        result = pd.DataFrame(columns=range(97))
        fileNumber = nepol[13:15]
        print(fileNumber)
        nepolDF = pd.read_excel(nepol,
                                sheet_name='Результаты', dtype=str)
        for chisl_rab in chislRabList:
            if fileNumber in chisl_rab:
                chisl_rabDF = pd.read_excel(
                    chisl_rab, sheet_name='Результаты', dtype=str)
                break;
        print(nepol, "---",chisl_rab)
        print("Добавляем по ОКВЭДУ получателей")
        result.columns = tabl_with_comp.columns
        result = addOKVED(fileNumber,result)
        # добавляем не получателей
        print("Добавляем не получателей")
        columns_name = ['', 'Название компании ', 'Название компании (коротко)', 'ИНН', 'Код субъекта', 'Форма ', 'Дата основания', 'Код основного раздела', 'ОКВЭД 2014',
                    'Fixed Assets\nth RUB\nLast avail. yr', 'Fixed Assets\nth RUB\n2019',
                    'Fixed Assets\nth RUB\n2018', 'Fixed Assets\nth RUB\n2017',
                    'Fixed Assets\nth RUB\n2016', 'Fixed Assets\nth RUB\n2015',
                    'Fixed Assets\nth RUB\n2014', 'Fixed Assets\nth RUB\n2013',
                    'Fixed Assets\nth RUB\n2012', 'Fixed Assets\nth RUB\n2011',
                    'Fixed Assets\nth RUB\n2010',
                    'Operating Revenue / Turnover\nth RUB\nLast avail. yr',
                    'Operating Revenue / Turnover\nth RUB\n2019',
                    'Operating Revenue / Turnover\nth RUB\n2018',
                    'Operating Revenue / Turnover\nth RUB\n2017',
                    'Operating Revenue / Turnover\nth RUB\n2016',
                    'Operating Revenue / Turnover\nth RUB\n2015',
                    'Operating Revenue / Turnover\nth RUB\n2014',
                    'Operating Revenue / Turnover\nth RUB\n2013',
                    'Operating Revenue / Turnover\nth RUB\n2012',
                    'Operating Revenue / Turnover\nth RUB\n2011',
                    'Operating Revenue / Turnover\nth RUB\n2010',
                    'Cost of Goods Sold\nth RUB\nLast avail. yr',
                    'Cost of Goods Sold\nth RUB\n2019', 'Cost of Goods Sold\nth RUB\n2018',
                    'Cost of Goods Sold\nth RUB\n2017', 'Cost of Goods Sold\nth RUB\n2016',
                    'Cost of Goods Sold\nth RUB\n2015', 'Cost of Goods Sold\nth RUB\n2014',
                    'Cost of Goods Sold\nth RUB\n2013', 'Cost of Goods Sold\nth RUB\n2012',
                    'Cost of Goods Sold\nth RUB\n2011', 'Cost of Goods Sold\nth RUB\n2010',
                    'Profit (Loss) before Taxation\nth RUB\nLast avail. yr',
                    'Profit (Loss) before Taxation\nth RUB\n2019',
                    'Profit (Loss) before Taxation\nth RUB\n2018',
                    'Profit (Loss) before Taxation\nth RUB\n2017',
                    'Profit (Loss) before Taxation\nth RUB\n2016',
                    'Profit (Loss) before Taxation\nth RUB\n2015',
                    'Profit (Loss) before Taxation\nth RUB\n2014',
                    'Profit (Loss) before Taxation\nth RUB\n2013',
                    'Profit (Loss) before Taxation\nth RUB\n2012',
                    'Profit (Loss) before Taxation\nth RUB\n2011',
                    'Profit (Loss) before Taxation\nth RUB\n2010',
                    'Taxation\nth RUB\nLast avail. yr',
                    'Taxation\nth RUB\n2019', 'Taxation\nth RUB\n2018',
                    'Taxation\nth RUB\n2017', 'Taxation\nth RUB\n2016',
                    'Taxation\nth RUB\n2015', 'Taxation\nth RUB\n2014',
                    'Taxation\nth RUB\n2013', 'Taxation\nth RUB\n2012',
                    'Taxation\nth RUB\n2011', 'Taxation\nth RUB\n2010', 'Стоимость раб силы последний год',
                    'wages and salaries\nth RUB\n2019', 'wages and salaries\nth RUB\n2018',
                    'wages and salaries\nth RUB\n2017', 'wages and salaries\nth RUB\n2016',
                    'wages and salaries\nth RUB\n2015', 'wages and salaries\nth RUB\n2014',
                    'wages and salaries\nth RUB\n2013', 'wages and salaries\nth RUB\n2012',
                    'wages and salaries\nth RUB\n2011',
                    'Стоимость раб силы 2010']
        nepolDF.columns = columns_name
        nepolDF.drop(['', 'Название компании (коротко)', 'Стоимость раб силы 2010',
                   'Стоимость раб силы последний год'], axis=1, inplace=True)
        result = pd.concat([result, nepolDF], ignore_index=True)
        result['Dummy'] = [0 if x != 1 else 1 for x in result['Dummy']]
        # устанавливаем количество рабочих и стоимость экспорта
        result.drop_duplicates(subset='ИНН', inplace=True)
        chisl_rabDF.columns = ['', 'Название компании', 'ИНН',
                             'ОКВЭД 2014, основной код', 'Number of Employees\n2019',
                             'Number of Employees\n2018', 'Number of Employees\n2017',
                             'Number of Employees\n2016', 'Number of Employees\n2015',
                             'Number of Employees\n2014', 'Number of Employees\n2013',
                             'Number of Employees\n2012', 'Number of Employees\n2011',
                             'Number of Employees\n2010']
        years = result.columns.intersection(
            chisl_rabDF.columns).drop('ИНН', 'Название компании')
        stoimost_eksp.columns = ['ИНН', 'Стоимость экспорта 2013, USD',
                                 'Стоимость экспорта 2014, USD', 'Стоимость экспорта 2015, USD',
                                 'Стоимость экспорта 2016, USD', 'Стоимость экспорта 2017, USD']
        print("Устанавливаем количество работников")
        for i in tqdm(range(len(chisl_rabDF.index))):
            for year in years:
                result.loc[result['ИНН'] == (
                    chisl_rabDF.iloc[i]['ИНН']), year] = chisl_rabDF.iloc[i][year]
        eksp_years = result.columns.intersection(stoimost_eksp.columns).drop('ИНН')
        print("Устанавливаем стоимость экспорта")
        for i in tqdm(range(len(stoimost_eksp.index))):
            for eksp_year in eksp_years:
                result.loc[result['ИНН'] == (
                    stoimost_eksp.iloc[i]['ИНН']), eksp_year] = stoimost_eksp.iloc[i][eksp_year]
        writeToFile(fileNumber,result)


import pandas as pd
from tqdm import tqdm
import glob
if __name__ == "__main__":
    vse_otrasli = pd.read_excel("other_1.xlsx",sheet_name="result",dtype=str)
    gos_forma = [f for f in glob.glob("Гос форма/*.xls*")]
    for comp in gos_forma:
        print(comp)
        compDF = pd.read_excel(comp,sheet_name="Results",dtype=str)
        print("Merge")
        vse_otrasli = pd.merge(vse_otrasli,compDF,on=['Tax number (INN/Tax/BIN)'], how='left')
writer = pd.ExcelWriter("result.xlsx", engine='xlsxwriter')
vse_otrasli.to_excel(writer, 'result', index=False)
writer.save()
        
