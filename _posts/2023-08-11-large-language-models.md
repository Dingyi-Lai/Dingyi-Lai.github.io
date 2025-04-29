---
layout: post
author: Dingyi Lai
---

Current Notes from *Generative AI with Large Language Models*: https://www.coursera.org/learn/generative-ai-with-llms

![Generative_AI_notes_1](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/LLM_Generative_AI_notes_1.png)

![Generative_AI_notes_2](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/LLM_Generative_AI_notes_2.png)

Notes from *ChatGPT Prompt Engineering for Developers*: https://www.deeplearning.ai/short-courses/chatgpt-prompt-engineering-for-developers/

![Prompt_Engineering_1](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/LLM_Prompt_Engineering_1.png)

To build a chatbot application, you need to know more deeply about the roles:
![Prompt_Engineering_2](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/LLM_Prompt_Engineering_2.png)

An OrderBot as a fantastic example to automate the collection of user prompts and assistant responses in the case of taking orders at a pizza restaurant.

```python
def collect_messages(_):
    prompt = inp.value_input
    inp.value = ''
    context.append({'role':'user', 'content':f"{prompt}"})
    response = get_completion_from_messages(context) 
    context.append({'role':'assistant', 'content':f"{response}"})
    panels.append(
        pn.Row('User:', pn.pane.Markdown(prompt, width=600)))
    panels.append(
        pn.Row('Assistant:', pn.pane.Markdown(response, width=600, style={'background-color': '#F6F6F6'})))
 
    return pn.Column(*panels)

import panel as pn  # GUI
pn.extension()

panels = [] # collect display 

context = [ {'role':'system', 'content':"""
You are OrderBot, an automated service to collect orders for a pizza restaurant. \
You first greet the customer, then collects the order, \
and then asks if it's a pickup or delivery. \
You wait to collect the entire order, then summarize it and check for a final \
time if the customer wants to add anything else. \
If it's a delivery, you ask for an address. \
Finally you collect the payment.\
Make sure to clarify all options, extras and sizes to uniquely \
identify the item from the menu.\
You respond in a short, very conversational friendly style. \
The menu includes \
pepperoni pizza  12.95, 10.00, 7.00 \
cheese pizza   10.95, 9.25, 6.50 \
eggplant pizza   11.95, 9.75, 6.75 \
fries 4.50, 3.50 \
greek salad 7.25 \
Toppings: \
extra cheese 2.00, \
mushrooms 1.50 \
sausage 3.00 \
canadian bacon 3.50 \
AI sauce 1.50 \
peppers 1.00 \
Drinks: \
coke 3.00, 2.00, 1.00 \
sprite 3.00, 2.00, 1.00 \
bottled water 5.00 \
"""} ]  # accumulate messages


inp = pn.widgets.TextInput(value="Hi", placeholder='Enter text here…')
button_conversation = pn.widgets.Button(name="Chat!")

interactive_conversation = pn.bind(collect_messages, button_conversation)

dashboard = pn.Column(
    inp,
    pn.Row(button_conversation),
    pn.panel(interactive_conversation, loading_indicator=True, height=300),
)

dashboard
```

Generating a receipt:

```python
messages =  context.copy()
messages.append(
{'role':'system', 'content':'create a json summary of the previous food order. Itemize the price for each item\
 The fields should be 1) pizza, include size 2) list of toppings 3) list of drinks, include size   4) list of sides include size  5)total price '},    
)
 #The fields should be 1) pizza, price 2) list of toppings 3) list of drinks, include size include price  4) list of sides include size include price, 5)total price '},    

response = get_completion_from_messages(messages, temperature=0)
print(response)
```