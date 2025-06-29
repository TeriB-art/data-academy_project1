## 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

V průběhu let 2006 až 2018 nedochází k růstu mezd ve všech odvětvích. Skriptem 1 je možné vypsat odvětví, kde došlo k poklesu. 
Skript 2 zobrazí komplexnější tabulku, kde je vidět i v jakých letech pro jaká odvětví k poklesu došlo. Už v tomto pohledu to vypadá, že kritický byl rok 2013, potvrdit je to možné úpravou skriptu na výpočet, kolikrát se určitý rok v tabulce vyskytuje - skript 3, případně také určitý obor - skript 4. Tak je potvrzeno, že v roce 2013 došlo k poklesu u výrazně více odvětví. V rámci porovnání odvětví takový rozdíl patrný není. 

Základní otázka - který typ mzdy do hodnocení zahrnout? (Pro každé odvětví uváděna mzda na základě fyzického a také přepočteného výpočtu)
V tomto případě zvolena mzda podle přepočteného počtu zaměstnanců (kód 200).
### Dohledané informace:
Průměrná mzda na fyzický počet zaměstnanců se vypočítá jako celková mzdová suma dělená celkovým počtem zaměstnanců v podniku, bez ohledu na délku jejich úvazku. Tento ukazatel odráží průměrnou mzdu, kterou by teoreticky pobíral každý zaměstnanec, pokud by se mzdy rozdělily rovnoměrně. 

Průměrná mzda na přepočtený počet zaměstnanců na plný úvazek se počítá tak, že se celková mzdová nákladovost podělí přepočteným počtem zaměstnanců, kde se zohledňují i zkrácené úvazky. Tento přepočet dává přesnější obraz o mzdových nákladech ve vztahu k pracovní síle, než by to dělalo pouhé dělení celkové mzdy počtem zaměstnanců v "hrubém" počtu.
Trend by navíc mohl být stejný u obou typů výpočtů.


## 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Za první srovnatelné období (2.1.2006 - 8.1.2006)je možné si koupit 1186 kg chleba a 1239 l mléka. 
Za poslední srovnatelné období (10.12.2018 - 16.12.2018) pak 1331 kg chleba a 1684 l mléka. Tedy větší množství obou typů potravin.

Řešené body:
Co je srovnatelné období? 
Na základě vstupních dat zjištěno, že se cena potravin mění v rámci jednoho kraje i mezi týdny, zvolen tedy týden.

Cena je zprůměrovaná za všechny kraje.

Výsledek také záleží na tom, v jakém odvětví pracuji - to není v otázce specifikováno, využiji tedy průměr za všechna odvětví - což by mělo odpovídat hodnotě NULL ve sloupci industry_branch_code (uvedeno na webu v informacích k datové sadě). 

V tomto případě do výpočtu zahrnuta mzda získaná na základě fyzického výpočtu (s ohledem na to, že nám jde více o jednotlivce - co si může nějaká osoba koupit).



## 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

Touto potravinou je Cukr krystalový, jehož cena je na konci roku 2018 o 27,5% nižší než v roce 2006.

Přemýšlela jsem, jak k řešení přistoupit. Zda porovnat první a poslední sledovaný rok či zprůměrovat meziroční nárůsty za všechny roky (nejnižší průměrný meziroční nárůst = nejpomalejší zdražování). Druhá možnost je myslím ovlivnitelná výrazným cenovým propadem v průběhu období - tedy by mohl nejnižší průměr vyjít u kategorie potravin, která v posledním roce stojí více než v prvním, a výsledek by pak byl provokativní. Proto jsem se rozhodla pro porovnání cen v prvním a posledním sledovaném roce, zde ale bylo nutné vzít v úvahu, že pro některé kategorie nemusí být uváděny ceny ve všech letech (tak tomu bylo u vína, jehož vývoj cen byl zkontrolován samostatně; to jsem zjistila díky tomu, že výsledný počet řádků neodpovídal součinu roků (13) a kategorií (27), a to mě zarazilo). 
Při porovnání obou navržených způsobů ale vyšla stejná kategorie potravin. Nejsem si jistá, zda to je náhoda anebo jsou oba přístupy nakonec správné. 


## 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Ano, těchto roků je několik. Konkrétně se jedná o roky 2007, 2008, 2010, 2011 - 2013, 2015, 2017, 2018.
Komplexnější data zahrnující rok, kategorii potravin a meziroční nárůst oproti předchozímu roku poskytuje Skript 3, výpis pouze let je dle Skriptu 4.
Skript 1 a 2 slouží k vytvoření dočasných tabulek používaných ve výsledných skriptech. 

Cesta pomocí dočasných tabulek zvolena proto, že při výpočtu ze vstupní připravené tabulky byl problém v současném použití funkce Lag pro změnu ceny potravin a změnu mzdy (vycházely mi nesmyslné údaje jako různá změna mzdy pro stejný rok). 
Také bylo nutné zachovat v tabulkách kategorie potravin. Předně z důvodu, že pak by chyběl sloupec, přes který provádět lag, a pak také proto, že průměrná cena za všechny kategorie potravin není vhodný údaj (zjištěno při práci na poslední otázce). 
Následně byly vypsány roky, kde je poměr změny ceny potravin a změny mzdy > 1,1.
Vzhledem k tomu, že nám šlo o data, kdy je nárůst cen potravin větší než nárůst mezd, měl by tento postup být funkční i pro případ, že potraviny v některém roce zlevnily - zde je změna ceny potravin menší než 1 a muselo by tedy dojít také k výraznému poklesu platu, aby poměr byl > 1,1; z dat jsem navíc zjistila, že plat v podstatě neklesl - jen v roce 2013 byl o méně než 1 % nižší než v předchozím roce, takže by výsledky neměly být zkresleny poklesem ceny potravin.

## 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Podle získaných korelačních koeficientů (přesněji Pearsonova korelačního koeficientu; skripty 4 až 7) je patrná souvislost mezi HDP a výší mezd  a to výrazněji v následujícím roce (koeficient 0.89 a 0.95).
a pro některé kategorie potravin, 
Pro ceny potravin má ale odpověď pouze na základě korelace své limity, neboť ceny potravin jsou ovlivněné více faktory. Korelační koeficient vyšší než 0,8 byl získán pro několik kategorií potravin, tyto kategorie potravin nejsou totožné při porovnání aktuálního a následujícího roku.

Nejprve jsem zvažovala, zda porovnat změny HDP, mezd a cen potravin a pokud dochází k nárůstu u všech, tyto roky vypsat.(Navíc bych mohla např. použít funkci CASE WHEN, kterou jsem v ani jedné otázce nepoužila:-)) To ale bylo obtížně proveditelné, postup tedy konzultován s internetem a AI - na základě toho použita korelace s tím, že hodnoty korelačního koeficientu rovny anebo vyšší než 0,8 jsou brány jako ty, které ukazují vysokou souvislost mezi hodnocenými parametry. 
Také bylo důležité si uvědomit, že je nutné korelaci provádět pro jednotlivé kategorie potravin. 

Při zpracování zjištěno, že v druhé připravené tabulce (T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL) jsou totožná data uvedena třikrát - takto to již bylo v původní tabulce economies, ale zjištěno až nyní. Bylo by možné upravit původní tabulku, řešením je ale také použít příkaz SELECT DISTINCT.


