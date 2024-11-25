# Leveranser for kandidat 13

- **Oppgave 1**
  - **Leveranse 1**: Lenke til Lambda-funksjonen - https://2ncrw2zcob.execute-api.eu-west-1.amazonaws.com/Prod/generate-image/
  - **Leveranse 2**: Lenke til kjørt GitHub Actions - https://github.com/khvitmyhr/PGR301-exam-2024/actions/runs/11951338050/job/33314752313

---

- **Oppgave 2**
  - **Leveranse 1**: URL til SQS - https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue_13
  - **Leveranse 2**: Terraform plan - https://github.com/khvitmyhr/PGR301-exam-2024/actions/runs/11839948036/job/32992620037
  - **Leveranse 3**: Terraform apply - https://github.com/khvitmyhr/PGR301-exam-2024/actions/runs/11951255263/job/33314507495

---

- **Oppgave 3**
  - **Leveranse 1**: Beskrivelse av tagstrategi:
    - Jeg bruker `:latest`-tagen ved bygg og publisering for å alltid representere den nyeste versjonen av imaget. Dette skaper mer forutsigbarhet og stabilitet i programmet.
    - Ved build bruker jeg `-t` tag + variabel for å opprette navn på Docker-imaget. Ved bruk av variabel får jeg et tilpasset navn basert på brukernavn.
    
  - **Leveranse 2**: Container image - `kihv/java-sqs-client`
    - *Obs. Jeg har hatt problemer med å kjøre denne lokalt, men det fungerer helt fint via workflow. Har derfor lagt til
    run kommandoen i workflow fila. 
  
  - SQS URL - https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue_13

  

---

- **Oppgave 5**
  - **1**: 
    - CI/CD piplines: 
        - Ved serverless har vi fordelen av å slippe å bygge containere og kan deploye små selvstendige enheter. Leverandørene (fesk AWS)
          håndterer infrastrukturen som kan gjøre programmet mindre sårbart, da utviklere slipper å håndtere denne kompleksiteten. Dette skaper både effektivitetet (utviklerne har mer tid til kode),
          og mindre sårbarhet for menneskeskapte feil i infrastrukturen. I tillegg gjøres all endring i kode sporbar når vi bruker VCS.
        
        - Dette vil likefullt ha den ulempen at programmereren har noe mindre kontroll (på godt og vondt), som også kan være en ulempe hvis et problem oppstår. Det kan være vanskeligere å ha oversikt
          og komme til bunns i problemet, da deltaljer kan være skjult for utviklerne. 
        - Det er også noe vanskeligere å utføre testing da funksjoner avhenger av skytjenester og det ikke alltid er så enkelt å simulere et korrekt produksjonsmiljø.
         
    
    - Automatisering: 
        - Med serverless kan vi ha hendelsesbaserte triggerne og fokus på etterspørsel. Russursallokering blir tatt hånd om av skytjenesten, og det at man kan ta hensyn til etterspørsel kan gi kostnadsbesparelser. 
        - Hendelsesbaserte triggere gjør det mulig å utløse fonksjoner på spesifikke hendeser og forenkler arbeidsflyen. Eksempel på hendelse kan være meldingskø, slik vi har gjort i oppgaven nå.
        - Mye av tester som blir laget for applikasjoner kan også automatisereres og trenger ikke bruk av menneskelig ressurs hver gang.
         
        - Men all automatisering kommer også mindre kontroll, som kan ha sine utfoprdringer. Man kan oppleve mindre fleksibilitet, vanskeligere å gjøre ting manuelt, og feilsøking i automatiserte 
          systemer kan være noe mer utfordrende for å finne feil da utviklerne gjerne har mindre innsikt og tilgang til visse ressurser. 
        - Man kan også støte på problemer hvor nye serverless programmer skal integreses med eldre systemer da det kan være vesentlige forksjeller i arkitektur.
        
    - Utrullingsstrategier: 
        - Fordelen med serverless-arkitektur er at man får mulighet til å rulle ut flere mindre, hyppigere prosesser også uten å måtte stoppe programmet (nedetid). Dette gjør det enklere å stadig teste ny produksjon.
        - Det er mindre risiko for nedetid, sammenlignet med vanlig mikrotjenester, og enklere å gjøre oppdateringer.
     
        - Ulempe kan være dersom applikasjonen har mange avhengigheter mellom funsksjonene, da det kan skape utfordringer når disse skal koordinereres i sanntid. 
        
    - Ved bruk av automatisering og jevnlig utrullig slipper man også unødvendig ventetid som er en del av Lean prinsippet. Man ønsker å optimalisere flyt, gjøre arbeid som kan gjøres- parallellt, fremfor
      én ting av gangen (som ved papirfly eksempelet fra timen). Dette legger også til rette for kontinuerlig levering. 
        
         
    
  - **2**:
    - En fordel med serverless aritektur er at skyleverandører som feks AWS har innebygd overvåkning, logging og feilsøking. Her har vi feks brukt CloudWatch hvor man finner det meste av logging, og kan bruke
      dette videre for feilsøking. I tillegg ved logging i Cloadwatch blir arbeid synlig som igjen er en positiv del av serverless som gjør det enklere å feilsøke og finne roten til problemet.
    - I CloudWatch kan man også bruke alarm ved spesifikke betingelse og man kan enkelt sette opp hvordan en alarm skal trigges. 
    - Inne på AWS har man generelt en god oversikt over det som er deployet, og man har god tilgang til ressurser for feilsøking. 
    
    - Allikevel kan ulempen være at man mister oversikt over det helhetlige bildet. Man har feks innsikt i loggingen til én og en lambda funksjon, og det kan være litt utfoprdrende å feilsøke dersom det er flere mindre
      deler som avhenger av hverandre.

    - For å løse problemet med fragmnentert logging kan man implementere sentralisert logging for en mer helhetlig oversikt. 

  - **3**:
    - Som nevnt i svar 1, er en av serverless store fordeler nettopp skalerbarhet og kostadnskontroll. I stedetfor å betale for en server som ruller og går døgnet rundt, har man ved serverless den fordelen å kun
      betale for det som brukes. Dette er spesielt en fordel hvor deler av applikajsonen bare brukes en gang i blandt. Man betaler hver gang feks en lambda funksjon kjører.
      Pga. denne automatiseringen som gjerne kommer med serverless får vi også muligheten til å kun bruke de ressursene vi til en hver tid trenger.

    - En ulempe kan være "cold starts", som er at funsjoner som kjører med lang tids mellomrom kan bruke lang tid på å starte opp. Det kan gi treghet og ventetid for brukeren.
    - Ved bruk av lambda funksjoner kan man oppleve ressursbegrensninger da disse har minne opptil 10GB, som gir en begrensning i midlertidig diskplass (Bech, 2024).
    - Det kan også tenkes at ved et program hvor de fleste funksjoner kjører tilnærmet hele tiden, kan en fastpris på containere i mikrotjenester allikevel lønne seg.
    
    - Hva som i størst grad lønner seg av serverless eller mikrotjeneste arkitektur kan derfor avnhenge av hvor stor belastning programmet har, både totalt sett og for enkelte funksjoner. Her er derfor ikke et
      gitt fasitsvar, men avhenger av programmets behov. 
  
  - **4**: 
    - Som tidligere nevnt vil ansvarset for infrastrukturen ved en serverless arkitektur settes over til en skytjestes leverandør, og ikke DevOps teamet selv, som ved en mikrotjeneste. Her vil det være rammer
      for feks økomisk ansvar og garantier, hvor leverandøren sitt ansvarsområde ligger på garantier og ansvar når det kommer til å unngå nedetid og feil i infrastruktur.
      Devops teamet selv har ansvar for kode og implementering av ny funksjonalitetet, men skal ikke ha snsvar for å måtte overvåke servere.

    - Ulempen med dette er igjen, dersom noe galt skjer i infrastrukturen sitter utviklerne med mindre "makt" til å påvirke. Her må de gjerne vente til leverandøren selv har ordnet problemene. 
    - I tillegg gjøres Devops teamet seg avhengig av en andrepart (leverandøren), og må tilpasse seg demmes økosystem. Dette vil også være en utfordring dersom teamet senere skulle ønske å bytte leverandør. 
    
    - Generelt er det på godt og vondt å sette bort deler av produksjonen til en annen part. Man slipper noe ansvar og frigjør tid og ressurser, samtidig som man sier fra seg noe av kontrollen, "makten",
     og fleksibiliteten dersom et problem skulle oppstå. 
     
     - I forhold til eierskap og ansvar er det relevant å nevne "single piece flow". Et prinsipp som omhandler kontinuerlig og heller mindre leveranser hvor man kan fokusere på én ting av gangen.
      Dette gjør at hvert teammedlem kan ha sitt eget ansvarseområde av gangen, uten å måtte kooordinere hele teamet i alle ledd. 
      - I tillegg er et annet devops prinsipp "færrest mulig overleveringer". Ved at oppgavene er delt opp i mindre deler og hver og én har sitt ansvarsområde, unngår vi også nettopp dette, vi får mindre
      avhengigheter som igjen gir færre overleveringer. 
     
     
     
 -  **Kilder oppgave 5**:
     
    - Bech, G. (2024) Devops i Skyen, AWS COMPUTE. Høyskolen Kristiania. https://kristiania.instructure.com/courses/12534/files/folder/03?preview=1454390
     