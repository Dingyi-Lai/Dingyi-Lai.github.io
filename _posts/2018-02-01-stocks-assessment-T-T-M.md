---
layout: post
author: Dingyi Lai
---

Updated: The following report was written in Chinese originally at the end of 2017, so lots of observation and analysis are outdated and biased due to my limited knowledge and perspective at that time, and the translation could be flawed. But the paradigm of stock assessment is still practical, because according to the performance of TTM subsequently, my assessment and prediction conforms perfectly to the reality afterwards. Codes in stock price assessment is in [this repo](https://github.com/Dingyi-Lai/Data-Science/blob/main/%5BProject%5DTTM_Stock_Assessment.R)

# Abstract
TATA MOTOR Ltd. has experienced intense volatility of share price under the ticker symbol TTM since it was listed on the New York Stock Exchange (NYSE) in 2004. Generally, foreigners are optimistic about the Indian market according to both my field study and the Indian index. However, the financial reports of Tata Motors over the years infers that Tata Motors is unfortunately in a poor financial situation. Its most competitive advantage is Jaguar Land Rover, which was acquired from Ford in 2008, and its main market is in China. Recently, Tata Group has stepped up efforts to prevent other groups from acquiring Tata Motors, which is worrying. However, we can infer from the relationship among the stock price, the price-to-book value ratio and the price-earnings ratio that Tata Motors' current EPS has risen sharply. In terms of the stock price, Tata Motors will rise sharply in the short term in the near future, and investors can take a long positon from the end of 2017 to the beginning of 2018. However, from the financial reports of the past years, three rules of thumb can be used to roughly estimate respectively. The reasonable share price of Tata Motors should be 23.86, 27.85 and 33.75 respectively, and no matter which one it should be, the current share price of Tata Motors, 33.87, is too expensive. Hence, in the longer run, investors are suggested to be short.

![MindMap_TTM](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]MindMap.png)

# Industry Research
## Goal
Familiar with the overall picture and pattern of the industry, understand the prospects and cycles of the industry

## Field Trip
I arrived in India shortly after India's GST reform in 2017 for an volunteer internship, and my footprints spanned the north and south of India. Though I worked basically in Mumbai, Maharashtra, I also visited the Silicon Valley of Asia - Bangalore, Cochin and other cities. I chose India because I want to see the faces of other third world developing countries in the world. Some people comment that the world is a group of people running at high speed day and night, and another group of people wake up and find that the world has changed. I don't want to judge, but there is no doubt that the current India and the former China are belong to the first group. Because it is a fact that China's economic growth has slowed down and that it pays more attention to social welfare, it is also a fact that India's economic growth rate has surpassed China's in one fell swoop. When China's demographic dividend is slowly disappearing and the traditional market is approaching saturation, why don't we turn our attention to other corners of the world?

Perhaps in India we can find the shadow of China's past, in Japan we can peep at China's future. Some of my conjectures are supported and some are overthrown during my field trip:

- Conjecture 1: India's macroeconomic growth falls short of expectations. (Supported)
    - Phenomenon 1: On September 1, 2017, I read from The Time of India newspaper: After the GST tax reform, India's GDP growth of 5.7% from April to June was a 3-year low; while China's growth rate remained at 6.9% during the same period.

- Conjecture 2: The industrial development in India is extremely uneven, and the tertiary industry is far stronger than the primary and secondary industries. (Supported)
    - Phenomenon 2: This is what I came up with while chatting with my friends who are Indian college students. While taking me to visit their university, they complained that Chinese manufacturing is all over the streets of India. Most of the items used by Indians are made in China, but there are very few made in India. 

- Conjecture 3: The Indian government is planning to support the manufacturing industry. (Supported)
    - Phenomenon 3: Prime Minister Narendra Modi's plan about "Make in India" launched in 2014 has become one of the most important policy initiatives for India's development. In Indian shopping malls, many stores were advertising their identities as local brands.

- Conjecture 4: India's GST tax reform will have a huge impact on the Indian economy, especially on consumption in the short term. (Supported)
    - Phenomenon 4: This tax reform happened just a few days before I arrived in India, and housing prices suddenly skyrocketed. Obviously, this reform has greatly affected my living expenses in India. The 14% tax in the restaurant industry really made me complain.

- Conjecture 5: For Indians, oil prices are very high, so cars are a luxury for normal Indians, and the car market has great potential. (Supported)
    - Phenomenon 5: A girl belong to Kshatriya once asked me if there are many two-wheelers, three-wheelers and four-wheelers in my country. I said, of course, generally a family has one or two four-wheeled vehicles. Although two-wheeled vehicles are banned in many big cities, in small cities, a family will usually have one, but still, tricycles are rare because of traffic rules. She was very surprised because in India, everyone wants as many cars as possible, no matther whether they are two-wheelers, three-wheelers and four-wheelers. Among the three people around me, one has four cars at home, and the other two have three cars each. According to their description, Indians are very longing for cars, but because of high oil prices, not all families can afford it. Vehicles are also a good dowry in Indian weddings, and the automotive industry has great potential in the Indian market.

- Conjecture 6: India's environment issue has made it consider the necessary of electric vehicles. (Supported)
    - Phenomenon 6: Cited from The Time of India newspaper on September 3, 2017: In 2016, China accounted for more than 40% of the electric cars sold in the world, with 336000 new cars registered. That is more than double that sold in US. China also has the largest electric car stock, with about a third of the global total. From my observation in India, I can see that the expectations for electric vehicles in India are very high.

- Conjecture 7: Tata Motors is the largest car company in India. (Overthrown)
    - Phenomenon 7: Before I went to India, I had only heard of Tata when I try to list an Indian company. But after I met a girl who used to work in the social sector of Tata Motors and heard of her description of the work, I found that this large, socially rewarding Indian conglomerate might not be the largest Indian car company.

- Conjecture 8: Foreigners are very optimistic about the Indian market. (Supported)
    - Phenomenon 8: This is the experience that I was shared with by many young venture capitalists who I met along the way.

- Conjecture 9: Tata Motors is well managed and financially sound. (Overthrown)
    - Phenomenon 9: Many of their employees were on short-term contract. For example, one of my friends who was forced to leave after working on a project in their social science department. It shows that Tata Motors had been ensuring the elite and young blood.

## Macroeconomic Research
### Indian economy (validation of conjectures 1, 2 and 4): GDP growth overall and in three industries
Note: The following fiscal years are divided into March, for example, FY18 is from March 31, 2017 to March 31, 2018. From fiscal year 2016 to the first quarter of fiscal year 2018 (i.e. March 31, 2015 to July 31, 2017), we can get the following macro data[^1]:
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]GDP_growth_1618.png"
  alt="GDP_growth_1618">
  <figcaption>Figure 1: India's GDP growth overall and in three industries from FY16Q1 to FY18Q1</figcaption>
</figure>

From the above figure, we can see that after experiencing rapid development from 2015 to 2016, India's economic growth slowed down significantly after 2016, and the recent economic growth rate was only 5.7%. After experiencing a recession in 2015, the primary industry (agriculture) accelerated again in 2016, but the growth rate in 2017 was not large; the secondary industry (industry) has almost shown a gradual slowdown since 2016 In contrast, the tertiary industry (service industry) performed strongly and gradually became the main force of India's GDP growth. India's film industry and tourism industry maintained a booming trend.

It shows that India is undergoing an era of industrial transformation, but can the weak primary and secondary industries support the huge tertiary industry? The underperforming secondary sector appears to be the main factor behind the slowdown in India's GDP growth. The GST reform (Goods and Service Tax, GST) has had a negative impact on the manufacturing sector, delaying related investment activities.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]GDP_expenditure_1517.png"
  alt="DP_expenditure_1517">
  <figcaption>Figure 2: India's GDP by Expenditure (% change in real terms) from FY15Q1 to FY17Q1</figcaption>
</figure>

From the above figure, we can see that India has gradually opened up its import and export trade. In recent years, India's import industry has performed better than its export industry. Government spending growth has slowed down, and so does personal consumption expenditure, which reveals that the GST reform has a significant impact on consumption. For example, after the reform, the tax rebate for auto parts in the past was only applicable to products within one year. Now auto dealers suffer because they have paid the tax for spare parts in the past. 23,000 dealers were affected. In addition, apart from the highest tax rate of 28%, high-end cars also have an additional 15% luxury tax. Although the total 43% is lower than the total tax rate of 55% in the past, Mercedes is still disappointed by the inequality among high-end car brands due to the tax reform. It asserts that with only a 28% tax rate, the premium car market would flourish, bringing more tax revenue, GDP growth and jobs to India.[^2]

### Indian Industry (validation of conjectures 4): Industrial Production (IIP)
Quarterly GDP growth is not enough to monitor the latest  India's industrial climate, so we look at the monthly industrial production index. This is a composite indicator that measures the short-term changes in the volume of production of a basket of industrial products during a given period with respect to that in a chosen base period.[^3].
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]IIP_12month_MA_1617.png"
  alt="IIP_12month_MA_1617">
  <figcaption>Figure 3: India IIP index and its 12-month moving average trend from 2016 to 2017</figcaption>
</figure>

Although the GDP growth rate of India's secondary industry was extremely low in the quarter from March to July 2017, we can see from the above chart that after the bottom of IIP growth in June 2017, IIP increases strongly in the following two months. Although the GST tax reform has a great impact on the Indian industry, the government still released various policies for support and encouragement, which played a certain role in comforting the Indian industry.

### Wholesale Price Index (WPI) and Consumer Price Index (CPI)
In order to continue to verify conjecture 4, from the perspectives of bulk commodities and livelihood necessities, I consider WPI and CPI respectively.

Wholesale price index is a price index compiled based on the weighted average price of wholesale price of a few relevant commodities of over 240 commodities available, reflecting the relative trend and magnitude of changes in wholesale prices of production materials and consumer goods in different periods. Products included include raw materials, intermediate products, final products, and import and export products, but do not include various types of labor services.[^4]

The consumer price index is an indicator of price changes that reflects the prices of products and services related to residents' lives. It is expressed in the form of a percentage change and is one of the main indicators to measure inflation.[^5]
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]WPI_CPI_17.png"
  alt="[TTM]WPI_CPI_17">
  <figcaption>Figure 4: Comparison of the annual growth rate of WPI and CPI from April 2017 to September 2017</figcaption>
</figure>

From Figure 4, we can find that the inflation of oil prices, which is closely related to automobiles, is extremely unstable on the supply side, while it remains almost stable on the consumer side. However, compared with food, the inflation rate of fuel is high, especially at the wholesale stage, which may be affected by irregular fluctuations in international fuel prices.

### Indian Rates (Other Discovery): (Reverse) Repo Rate
As can be seen from Figure 5, the policy change in bank lending rates is a good sign for industries such as housing and automobiles. This involves the following three concepts.

Reverse repo rate is the rate at which the central bank of a country (Reserve Bank of India in case of India) borrows money from commercial banks within the country. It is a monetary policy instrument which can be used to control the money supply in the country. An increase in the reverse repo rate will decrease the money supply and vice-versa, other things remaining constant. An increase in reverse repo rate means that commercial banks will get more incentives to park their funds with the RBI, thereby decreasing the supply of money in the market.[^6]

Repo rate is the rate at which the central bank of a country (Reserve Bank of India in case of India) lends money to commercial banks in the event of any shortfall of funds. Repo rate is used by monetary authorities to control inflation. In the event of inflation, central banks increase repo rate as this acts as a disincentive for banks to borrow from the central bank. This ultimately reduces the money supply in the economy and thus helps in arresting inflation. The central bank takes the contrary position in the event of a fall in inflationary pressures. Repo and reverse repo rates form a part of the liquidity adjustment facility.[^7]

Cash Reserve Ratio (CRR) is a specified minimum fraction of the total deposits of customers, which commercial banks have to hold as reserves either in cash or as deposits with the central bank. CRR is set according to the guidelines of the central bank of a country.[^8]
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Key_Policy_Rates_1617.png"
  alt="[TTM]Key_Policy_Rates_1617">
  <figcaption>Figure 5: Movement in Key Policy Rates (%) from September 2016 to April 2017</figcaption>
</figure>

## Indian Automotive Industry Research
### History of Indian Automotive Industry (validation of conjectures 7): GDP growth overall and in three industries
The Indian auto industry sprouted in 1940. However, due to the influence of the license raj of the socialist policy and the bureaucratic system, the import of automobiles was restricted for the next 50 years. The Indian auto industry stagnated until the liberalization of the Indian economy in 1991. Both the production and export of automobiles have grown substantially, and now it has become the sixth largest automobile producer and fifth largest automobile exporter in the world (the export volume is second only to Japan and South Korea in Asia).
Major Indian automakers are Maruti. Maruti Suzuki[^9], Hyundai Motor India, Tata Motors and Mahindra & Mahindra. Tata Motors also sells the world's cheapest car, the Tata Nano, with a market price of $2,200. Foreign automakers currently operating in India include General Motors, Ford, Hyundai, Honda, Suzuki, Nissan Motors, Toyota, Volkswagen, Audi, Skoda, BMW, Renault, Mitsubishi, Jaguar Land Rover, Fiat and Mercedes Benz. PSA Peugeot Citroën and Volvo are setting up factories, while Lexus, Infiniti and Porsche are also planning to set up factories in India.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Top_Three_Brands.png"
  alt="[TTM]Top_Three_Brands">
  <figcaption>Figure 6: The top three local brands in the Indian auto industry</figcaption>
</figure>

At present, India's auto industry is mainly composed of three major communities, the south, the west and the north. The southern cluster hub accounts for 35% of the output value in Chennai, the western cluster accounts for 33% with Mumbai and Pune as the hub, and the northern cluster is concentrated in the capital region, accounting for 32%.[^10]

### Supply and Demand of Indian Automotive Industry
#### Supply
India is currently the world's second-largest bus producer, the world's third-largest heavy-duty truck producer, and the world's sixth-largest passenger car producer. Although this number is still far lower than China, it can be seen that there is a steady growth every year.

|Total Production (Unit: million)|
|   Segment  | 	2015-16  | 2016-17  |
|-------------|:-------:| -------:|
| Passenger Vehicles | 3.46 | 3.79 |
| Commercial Vehicles | 0.78 | 0.81 |
| Three Wheelers | 0.93 | 0.78 |
| Two Wheelers | 18.83 | 19.92 |
| Grand Total | 24.02 | 25.31 |

#### Demand (validation of conjectures 5)
India is currently the second largest two-wheeler market in the world and the fifth largest passenger vehicle market in the world. But roughly every 50 people own a passenger car, inferring that the popularization of motor vehicles has a long way to go.

| India-Highly Underpenetrated |
|   Segment  | 	Vehicle per 1000 persons |
|-------------| -------:|
| Passenger Vehicles | 20 | 
| Two Wheelers | 108 |
| Buses | 0.11 |

### Prospects of Indian Auto Industry
According to the AMP (Automotive Misson Plan) in India, which is listed below, by 2026, sales of various types of motor vehicles will increase by 3 to 3.5 times.

| Category-wise Demand | Base Case | Optimistic Case |
|   Category   | FY2015 | FY2026 | FY2026 |
|-------------|:-------:|:-------:| -------:|
| Passenger Vehicles | 3.2 | 9.4 | 13.4 |
| Commercial Vehicles | 0.7 | 2 | 3.9 |
| Two Wheelers | 18.5 | 50.6 | 55.5 |
| Three Wheelers | 0.95 | 2.8 | 3 |
| Tractors | 0.6 | 1.5 | 1.7 |
| Grand Total | 23.4 | 66.3 | 75.8 |

### Electric Car (validation of conjectures 6)
According to Bloomberg on September 30, 2017, India's Tata Motors (TTM-US) has won a bid for 10,000 electric vehicles from the Indian government, which represents a milestone for the desire from Indian government to promote green transportation and reduce energy imports. Tata, the manufacturer of luxury cars from Jaguar and Land Rover, also manufactures small vehicles Nano. But in the statement issued by the Indian government, it is mentioned that it will supply EESL (Energy Efficiency Services Ltd) 500 units first, and then 9,500 vehicles will be supplied in the second phase of the contract. So far as we know, each car is priced at $17,200, including tax and a 5-year warranty. EESL is a joint venture between the Energy Authority of India and India's state-run electricity supplier. In addition, the 500,000 vehicles owned by the government will be slowly replaced over 3 to 5 years. This is also a project that Indian Prime Minister Narendra Modi wants to push for fully electric vehicles by 2030. In total, the Indian auto industry is a $30 billion market.[^11]

## Indian Capital Market Research (validation of conjectures 7)
From the India index, we can see that foreign investors have high expectations for it. As China's demographic dividend slowly disappears, its economic growth slows down, and it advocates quality-of-life-oriented development, the world's eyes are turning to "potential stocks" like India.

As seen in various Indian ETFs and US-listed funds: Tata Motors' No. 1 competitor MARUTI SUZUKI INDIA LTD performed better than Tata, while Mahindra & Mahindra Ltd was slightly worse than Tata Motors. Because neither of these two competing companies is listed in the United States, they are not comparable in terms of share prices.

### BSE SENSEX (validation of conjectures 8)
The BSE SENSEX (also known as the S&P Bombay Stock Exchange Sensitive Index or simply SENSEX) is a free-float market-weighted stock market index of 30 well-established and financially sound companies listed on the Bombay Stock Exchange. The 30 constituent companies which are some of the largest and most actively traded stocks, are representative of various industrial sectors of the Indian economy. Published since 1 January 1986, the S&P BSE SENSEX is regarded as the pulse of the domestic stock markets in India. The base value of the SENSEX was taken as 100 on 1 April 1979 and its base year as 1978–79. On 25 July 2001 BSE launched DOLLEX-30, a dollar-linked version of the SENSEX.[^12] The run chart is as following figure 7&8. Until 22nd December 2017, the long-term moving average is below the short-term moving average, indicating that the Indian stock market is now a bull market and the overall economic environment is promising.[^13]

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]BSE_SENSEX_1617.png"
  alt="[TTM]BSE_SENSEX_1617">
  <figcaption>Figure 7: BSE SENSEX from December 2016 to December 2017</figcaption>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]BSE_SENSEX_1317.png"
  alt="[TTM]BSE_SENSEX_1317">
  <figcaption>Figure 8: BSE SENSEX from December 2013 to December 2017</figcaption>
</figure>

### iShares MSCI India ETF (INDA) (validation of conjectures 8)
INDA is the largest and most popular Indian equity ETF in the market today. Its assets is $4.1 billion in total and its fee is 0.68%. The fund accounts for around 85% of India's market capitalization and tends to stay away from small-cap stocks.[^14]

As the tenth largest holding stock, TATA MOTORS LTD owns a 2.19% investment ratio, and the number of shares held
18,420,401. But remarkably, as a competitor, MARUTI SUZUKI INDIA LTD, as INDA's fifth largest shareholding, has a 3.14% investment ratio and holds 1,226,386 shares; Mahindra
& Mahindra Ltd as INDA's 14th largest holding with a 1.81% investment ratio and 4,322,596 shares.[^15]

### WisdomTree India Earnings ETF
The WisdomTree India Earnings Index is a fundamentally weighted index that measures the performance of companies incorporated and traded in India that are profitable and that are eligible to be purchased by foreign investors as of the index measurement date. Companies are weighted in the Index based on their earnings in their fiscal year prior to the Index measurement date adjusted for a factor that takes into account shares available to foreign investors. For these purposes, "earnings" are determined using a company's net income.[^16] Tata Motors Ltd, as the fifteenth largest holding stock, owns a 1.37% investment ratio and holds 4,009,203 shares. But it is worth noting that as a competitor, MARUTI SUZUKI INDIA LTD, as EPI's 12th largest shareholding, has a 1.68% investment ratio and holds 230,696 shares; Mahindra & Mahindra Ltd, as EPI's 24th largest shareholding, owns 1% investment ratio and holds 839,455 shares.[^17]

### iShares India 50 ETF
The iShares India 50 ETF seeks to track the investment results of an index composed of 50 of the largest Indian equities. [^18] It has $770M in assets and 0.94% fee. As the 15th largest holding stock, Tata Motors Ltd owns a 1.95% investment ratio and holds 3,575,693 shares. But it is worth noting that as a competitor, MARUTI SUZUKI INDIA LTD, as INDY's 12th largest shareholding, has a 2.79% investment ratio and holds 253,234 shares; Mahindra & Mahindra Ltd, as INDY's 17th largest shareholding, Owns 1.64% investment ratio and holds 887,493 shares.[^19]

# Cooperation Research (Financial Report)
Tata Motors Limited, a part of Tata Group, was founded in 1945 and ranks among the top ten commercial vehicle manufacturers in the world with an annual turnover of US$2 billion. It has a 59% share of the Indian market. It cooperated with German Daimler-Benz in 1954 and was able to independently design its own products in 1969. Commercial vehicles cover products ranging from 2-40 tons. In 1999, Tata entered the passenger car segment with a market share of around 16%, best known for its self-developed and designed Indica and Indigo series.

Since the 1960s, automobiles have been exported to some countries and regions such as Europe, Africa and Asia. TATA's cars are also well-known. The small car Indica is elegant, stylish and low-priced. It has received more than 110,000 orders in a short period of time. The product is in short supply, creating the highest record for car sales in India. Tata's main products include small cars, 4-drive off-road vehicles, buses, medium and heavy trucks, etc. [^20].

- Philosophy of the group: Giving back to society.
- Traded as: TTM (NYSE)
- Number of shares: 577,469,686 (2017/03/31)
- Number of staffs: 80,389
- Market capitalization: 19,558,898,265 (2018/01/05)

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Market_Capitalization_0417.png"
  alt="[TTM]Market_Capitalization_0417">
  <figcaption>Figure 9: Market Capitalization of Tata Motors from September 2004 to August 2017</figcaption>
</figure>

Ford spent $2.5 billion to acquire Jaguar in 1989, and acquired Land Rover for $2.7 billion in 2000. However, due to the long-term performance of these two brands, which has not been as good as expected, coupled with the continued rise in oil prices, Ford has lost money year after year. After the global outbreak of the financial crisis in 2008, global demand plummeted, and Ford Motor had to sell the two-in-one brand at a discount of $2.9 billion to protect itself[^21]. Tata Motors purchased four models of Rover, Jaguar, Lancaster and Land Rover from Ford Motor Company in 2008, which made the company's market value explode and brought Western companies back to life. But the Nanu (the cheapest mass-produced car in the world), released in the same year, was quite a failure. For the success of the Nano, Tata Motors spent $400 million on research and development, and another hundreds of millions of dollars to build a factory dedicated to the Nano, capable of producing 15,000 to 20,000 Nano cars a month. But good times don't last long, the monthly sale of Nano's from its 2012 peak, 10,000, rapid declined. However, TTM's stock price didn't show a rapid decline until 2015. The main reason is that the sales of Tata's Jaguar and other subsidiaries are very sparkling, and overall sales (especially in the Chinese market) continue to rise.

But it is worth noting that the biggest consumer of Tata's Jaguar Land Rover is China, and Jaguar Land Rover has become Tata Motors and Tata Group's largest cash cow, and if Tata has not found another plan that can replace this cutting edge, then facing the unknown future market of China, the risk is very great. In late 2017, American auto website Automotive News cited from Indian media reports that Tata Sons was buying Tata Motors for nearly 200 hundred million rupees (approximately $312 million) as Tata Group sought to protect Jaguar Land Rover from a potential takeover.

## Profitability
The value of the industry peer level is from the msn financial website.[^22] Tata Motors' net profit margin has been lower than its peers since 2015, and gross margins have continued to decline. It shows that the profitability of Tata Motors is not as good as before.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Net_Profit_Margin_0417.png"
  alt="[TTM]Net_Profit_Margin_0417">
  <figcaption>Figure 10: Net Profit Margin of Tata Motors from 2004 to 2017</figcaption>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Gross_Margin_0417.png"
  alt="[TTM]Gross_Margin_0417">
  <figcaption>Figure 11: Gross Margin of Tata Motors from 2004 to 2017</figcaption>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]EPS_Adjusted_0417.png"
  alt="[TTM]EPS_Adjusted_0417">
  <figcaption>Figure 12: EPS Adjusted for Extraordinary Items from 2004 to 2017</figcaption>
</figure>

## Growth
According to William J O'Neil's *How to Make Money in Stocks: A Winning System in Good Times Or Bad*, a good stock should have EPS growing significantly over the past five years compared to the previous year. A growth stock should have a compound annual EPS growth rate of 25% to 50%, or even more than 100%, over the past four to five years. But if EPS decelerates noticeably for two consecutive quarters, be careful.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Growth_EPS_Adjusted_0417.png"
  alt="[TTM]Growth_EPS_Adjusted_0417">
  <figcaption>Figure 13: Growth of EPS Adjusted for Extraordinary Items from 2004 to 2017</figcaption>
</figure>

As can be seen from the above figure, TTM's performance in 2011 reached more than 73%, which is an extraordinary performance. However, since the sales of Nanu automobiles dropped significantly in 2012, it is obvious from the EPS growth rate that the company's decline can be seen. Especially with the negative growth from 2015 to 2017, investors need to be very cautious.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Net_Income_Groth_0417.png"
  alt="[TTM]Net_Income_Groth_0417">
  <figcaption>Figure 14: Net Income Growth from 2004 to 2017</figcaption>
</figure>

The net income growth rate is also unstable, indicating that Tata Motors is in an unstable state of operation.

## Price Ratio
In Anthony Bolton's *Investing Against the Tide: Lessons From a Life Running Money*, Old-fashioned P/E ratios can predict surpluses for the current and the next two years. As can be seen from the chart below: Tata Motors' P/E increased from 2015 to 2017, but the decline in P/E in 2017 may indicate that future earnings may also decline.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]PE_Ratio_0417.png"
  alt="[TTM]PE_Ratio_0417">
  <figcaption>Figure 15: Price-Earnings Ratio from September 2004 to August 2017</figcaption>
</figure>

However, the figure below shows that the price-to-book ratio in 2017 is higher than that in 2016, indicating that the stock price in 2017 is higher than that in 2016, and combined with the decline in the price-to-earnings ratio, it can be inferred that the company's current EPS has increased significantly.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]PB_Ratio_0417.png"
  alt="[TTM]PB_Ratio_0417">
  <figcaption>Figure 16: Price-to-Book Ratio from 2004 to 2017</figcaption>
</figure>

## Financial Soundness
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Financial_Soundness.png"
  alt="[TTM]Financial_Soundness">
  <figcaption>Figure 17: Financial Soundness from 2007 to 2016</figcaption>
</figure>

The light blue line represents debt-to-equity ratio, while the dark blue line is for book value per share. On the right, column names are financial ratio, company, industry respectively. In the column of financial ratio, from above to bottom is listed: debt-to-equity ratio, current ratio, quick ratio, interest coverage ratio, leverage ratio.[^22]

The debt-to-equity ratio of Tata Motors has remained at around 1 after a rare peak in 2009 (probably is related to frequent acquisitions and the launch of Nano in 2008), indicating long-term poor solvency, and the corporate capital structure is no safer than its peers. The current ratio and quick ratio are both lower than those of the industry, indicating that the short-term solvency is not good, and the company's ability to convert assets into cash is not reliable. Although the interest coverage ratio is higher than 2, it is far below the level of the industry, indicating that the ability to pay interest is lower than peers. The leverage ratio is slightly higher than that of its peers, indicating that investors have high profitability, but also take a large risk of loss.

Combining the comparison of the net profit ratio, it can be found that the debt-to-equity ratio in 2013 to 2016 generally decreased, and the net profit ratio also decreased.

To sum up: Tata Motors is a high-reward, high-risk company with low creditor protection.

## Management Efficiency
The value of the industry peer level is from the msn financial website.[^22] We can know from the following three rates of return that the financial situation of Tata Motors has changed a lot. As I expected, it fell very sharply in 2009, but then rebounded abruptly, but in recent years, the return rate has tended to be similar to the peers in industry. So it is confirmed once again: Tata Motors' Jaguar Land Rover dividend is about to pass, and if there is no new something, then the company's prospects are bleak.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Return_on_Assets_0417.png"
  alt="[TTM]Return_on_Assets_0417">
  <figcaption>Figure 18: Historical Return on Assets from 2004 to 2017</figcaption>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Return_Shareholders_Equity_0417.png"
  alt="[TTM]Return_Shareholders_Equity_0417">
  <figcaption>Figure 19: Historical Return on Shareholders' Equity from 2004 to 2017</figcaption>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Return_Investment_0417.png"
  alt="[TTM]Return_Investment_0417">
  <figcaption>Figure 20: Historical Return on Investment from 2004 to 2017</figcaption>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Inventory_Turnover_1417.png"
  alt="[TTM]Inventory_Turnover_1417">
  <figcaption>Figure 21: Inventory Turnover from 2014 to 2017</figcaption>
</figure>

It can be seen from the above figure that the inventory turnover rate of Tata Motors is far lower than that of its peers, and it has even declined in recent years.

## Dividend Policy
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Dividend_Payout_0417.png"
  alt="[TTM]Dividend_Payout_0417">
  <figcaption>Figure 22: Dividend Payout from March 2004 to March 2017</figcaption>
</figure>

The above chart shows that Tata Motors' dividend payout [^23] is very volatile, and also shows that this stock has potential, despite its recent poor performance.

# Price Research
## Stock Price Chart
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Price_0418.png"
  alt="[TTM]Price_0418">
  <figcaption>Figure 23: Stock Price from 27th September 2004 to 5th January 2018</figcaption>
</figure>

Because Tata Motors has many ex-dividends and ex-rights, in order to apply the moving average, the stock price is restored as shown below.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Price_restored_0418.png"
  alt="[TTM]Price_restored_0418">
  <figcaption>Figure 24: Restored Stock Price from 27th September 2004 to 5th January 2018</figcaption>
</figure>

## Long and Short lines of optimal return on investment 
Tuning short-term alternative moving average from 1 to 20 days, and long-term alternative moving average from 21 to 40 days, the final result is: 8-day moving average as a short-term, 23-day moving average as a long-term assisted for decision-making. When short-term line is higher than long-term line, then buy in; When long-term line is higher than short-term line, then sell out. This operation can obtain the highest average return on investment from TTM.

Take a closer look from 2015 to 2017.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Price_restored_1518.png"
  alt="[TTM]Price_restored_1518">
  <figcaption>Figure 24: Restored Stock Price from 5th January 2015 to 5th January 2018</figcaption>
</figure>

## Bollinger Bands
Bollinger Bands are an indicator that uses "price channels" to display various levels of market prices. When the market is stable, the price channel narrows, which may signal a temporary lull in market volatility. When the market price moves beyond the upper bound of the narrow price channel, it indicates that the market is about to go up violently; when the market price volatility exceeds the lower rail of the narrow price channel, it also indicates that the market will go downwards dramatically.[^24]

We use Bollinger Bands with a 20-day simple moving average and a standard deviation of 2 as a reference.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[TTM]Bollinger_Bands_1518.png"
  alt="[TTM]Bollinger_Bands_1518">
  <figcaption>Figure 25: Bollinger Bands from 5th January 2015 to 5th January 2018</figcaption>
</figure>

According to the optimal strategy of 8-day short-term and 23-day long-term, the nearest long-term line is still below the short-term line, indicating a bull market recently. When the K line goes above the middle line of the Bollinger Band and breaks above the upper Bollinger line, it indicates that the market's strong characteristics have been established, and it may rise sharply in the short-term. Of course, we can see from the previous analysis of the company's financial reports that although investors can go long in the short-term, they still need to be vigilant.

Here are some rule-of-thumb stock price estimates[^25]. Note that the current share price is 33.87.

## Rule of Thumb for Rough Estimation of Stock Price
### Dividend Method 
- Dividend this year: 1.193
- Low stock price: 15*1.193=17.895 
- Justified stock price: 20*1.193=23.86 
- High stock price: 30*1.193=35.79 
- Conclusion: current share price 33.87 is relatively too high

### Price-to-Earning Ratio Method
- Low stock price: $$\frac{EPS TTM(Trailing Twelve Months)+ Average EPS in recent 10 years}{2} \times Average of lowest P/E in recent 10 years = 18.7486332$$
- Justified stock price: $$\frac{EPS TTM(Trailing Twelve Months)+ Average EPS in recent 10 years}{2} \times Average P/E in recent 10 years = 27.85359427$$
- High stock price: $$\frac{EPS TTM(Trailing Twelve Months)+ Average EPS in recent 10 years}{2} \times Average of highest P/E in recent 10 years = 34.0864304$$
- Conclusion: current share price 33.87 is relatively too high

### Price-to-Book Ratio Method
- Low stock price: $$Net Value in latest quarter \times Average value of lowest P/B over the years = 27.0125$$
- Justified stock price: $$Net Value in latest quarter \times Average value of P/B over the years = 33.7548$$
- High stock price: $$Net Value in latest quarter \times Average value of highest P/B over the years =  41.6267$$
- Conclusion: current share price 33.87 is relatively too high

# Reference
[^1]: TATA MOTOR Ltd., Q2 FY18 BUSINESS REVIEW_TATA MOTORS Connecting Aspirations
[^2]: From https://finance.technews.tw/2017/07/27/india-finds-reform-not-reformers/
[^3]: From https://en.wikipedia.org/wiki/Index_of_industrial_production
[^4]: From http://wiki.mbalib.com/zh-tw/趸售物价指数
[^5]: From https://zh.wikipedia.org/wiki/消費者物價指數
[^6]: From https://economictimes.indiatimes.com/definition/reverse-repo-rate
[^7]: From https://economictimes.indiatimes.com/definition/repo-rate
[^8]: From https://economictimes.indiatimes.com/definition/cash-reserve-ratio
[^9]: Formerly known as Maruti Udyog Limited, an Indian state-owned enterprise. On May 2002 it became a subsidiary of Japanese automaker Suzuki Corporation due to the increased stake of Suzuki
[^10]: From https://wwwsnova.blogspot.tw/2015/02/automotive-industry-in-india.html
[^11]: From https://news.cnyes.com/news/id/3930212
[^12]: From https://en.wikipedia.org/wiki/BSE_SENSEX
[^13]: From http://www.wantgoo.com/global/stockindex?stockno=SEN
[^14]: From https://kknews.cc/zh-tw/finance/9rz6aq.html
[^15]: From https://www.esunsec.com.tw/etf/ETFWeb/HTML/ET011001.DJHTM?id=INDA
[^16]: From https://www.wisdomtree.com/index/wtind
[^17]: From https://www.esunsec.com.tw/etf/ETFWeb/HTML/ET011001.DJHTM?id=epi
[^18]: From https://www.ishares.com/us/products/239758/ishares-india-50-etf
[^19]: From https://www.esunsec.com.tw/etf/ETFWeb/HTML/ET011001.DJHTM?id=epi
[^20]: From http://wiki.mbalib.com/zh-tw/塔塔汽车公司
[^21]: From http://news.ltn.com.tw/news/business/paper/615746
[^22]: From https://www.msn.com/zh-tw/money/stockdetails/analysis/fi-126.1.TTM.NYS
[^23]: If the number of days of holding the shares is relatively small, and if the dividends are also given bonus shares, they might be charged a high tax. In the end, you might fail to get the bonus, but pay from your own pocket.
[^24]: From https://iask.sina.com.cn/b/14034303.html
[^25]: From http://www.cmoney.tw/notes/note-detail.aspx?cid=22814&nid=5833