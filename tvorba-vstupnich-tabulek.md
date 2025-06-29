## Komentář k přípravě vstupních tabulek

### Tabulka 1 - soubor table1_prices+payroll.sql
(název tabulky: T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL)

Do tabulky jsem vybrala data, která mi připadala jako potřebná pro zodpovězení otázek projektu. Ponechány jak kódy tak i odpovídající názvy pro možnost následující kontroly. 
Důležitá byla především otázka, jakým způsobem spojit data z obou tabulek (zda použít sloupec date_from nebo date_to). Nad tím jsem přemýšlela kvůli údaji čtvrtletí v tabulce czechia_payroll: ne vždy je počáteční a konečné datum v czechia_price ve stejném čtvrtletí. Jedná se ale o malé procento záznamů (ze 108249 je to 2625), dále čtvrtletí není pro řešené otázky klíčové, takže zvoleno date_to (ověřeno na min. a max. roku z czechia_payroll - odpovídá czechia_price, také kontrola párování čtvrtletí - zde mě překvapilo, že v některých čtvrtletích - např. 3. čtvrtletí 2018 - je jen několik konečných datumů z tabulky czechia_price; přes select disctinct na czechia_price jsem ověřila, že to tak je i v původní tabulce)

### Tabulka 2 - soubor table2_europe-countries-data.sql
(název tabulky T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL)

K vytvoření této tabulky byla využita tabulka "economies": protože jsou potřeba jak ekonomické údaje, tak i populace, a dále je potřeba mít data za jednotlivé roky. Pro výběr evropských států využit subselect z tabulky countries, kde je uveden kontinent.
Vybrány sloupce s údaji podle zadání (HDP, gini, populace).

Pokud byl zadán dotaz na vytvoření tabulky bez řazení, hlásil Dbeawer chybu u poslední závorky, přestože dotaz jako takový byl správně, závorky seděly - vyřešeno přidáním řazení, nakonec po konzultaci s AI pomohlo také upřesnění "e.country" místo pouhého "country" v podmínce pro filtrování.

 