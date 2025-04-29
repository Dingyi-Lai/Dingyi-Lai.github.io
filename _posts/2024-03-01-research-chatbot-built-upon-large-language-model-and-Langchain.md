---
layout: post
author: Dingyi Lai
---


Building a custom Research-Hub Chatbot has allowed me to turn my growing Notion knowledge base into an interactive Q&A assistant. Here’s how I approached it:


## 1. Motivation: Why a Chatbot-Powered Hub?  
- **Unified Access**: Instead of manually browsing dozens of pages, a chatbot lets me ask natural queries (“Show me my notes on spline regression”) and get instant answers.  
- **Speed & Focus**: Code snippets, literature summaries, and project plans are all indexed—no more context-switching between tabs.  

## 2. Evaluating the Landscape  
Before building, I compared existing options:  
- **ChatGPT & Notion AI** are powerful but too general and prone to hallucinations in my narrow research context. 
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/RHC_hallucination_chatGPT.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 1: Hallucination in ChatGPT
  </figcaption>
</figure>

- **Specialized tools** (e.g. TXYZ) may auto-summarize one paper at a time but struggle with cross-document queries.  
- **Custom LLM integration** promised the best precision, since I could control prompts and index only my vetted content.


## 3. Architecting the Hub  

### 3.1 Notion as the Knowledge Store  
I organize everything in Notion:  
- **Modular pages** for each topic (papers, code recipes, project outlines)  
- **Markdown-friendly blocks** so that sync tools can extract raw text  

### 3.2 Backup & Bi-Directional Sync  
To keep Notion content safe and extractable:  
1. **Notion-backup workflow** on GitHub Actions regularly pulls the workspace via private tokens.  
2. Changes auto-commit to a private Git repo, providing versioning and a local data source for ingestion.  

### 3.3 Building the Chatbot Pipeline  
1. **Data Ingestion** (`ingest.py`):  
   - Reads synced markdown files  
   - Splits content into passages and creates vector embeddings (via OpenAI or Hugging Face models)  
   - Stores vectors in a FAISS index  
2. **Prompt Template** tuned for “Research-Hub Assistant” ensures context relevance and reduces hallucinations:  
   ```text
   You are an AI assistant for my personal research hub...
   {context}
   Question: {question}
   ```  
3. **Retrieval-Augmented Generation** using LangChain’s ConversationalRetrievalChain:  
   - On each query, the top-k similar passages are fetched from FAISS  
   - The LLM (e.g. GPT-3.5) generates a concise answer grounded in those passages  

## 4. Front-End: Streamlit Chat Interface  
- A lightweight Streamlit app serves as both:  
  - **Developer playground** (local testing)  
  - **Deployed widget** when embedded back into Notion via an inline iframe.  

Key features:  
- **Persistent chat history**  
- **Syntax-highlighted code blocks**  
- **Fallback message** (“Sorry, I don’t know…😔”) when outside scope  

## 5. Embedding Back into Notion  
By wrapping the Streamlit URL in a Notion embed block, I can:  
- Ask questions without leaving the workspace  
- Share the bot with collaborators who have view access  

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/RHC_hallucination_mychatbot.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 2: De-hallucination in My Own Chatbot
  </figcaption>
</figure>

## 6. Lessons & Next Steps  
- **Prompt engineering** is critical: small tweaks drastically cut hallucinations.  
- **Index freshness**: GitHub Actions frequency balances “new content available” vs. API rate limits.  
- **Future enhancements**:  
  - Add multi-model support (e.g. open-source LLMs for offline querying)  
  - Integrate citation tracking so answers automatically link back to original pages  

By combining Notion’s organizational power with a custom vector-search chatbot, I’ve created a research companion that scales with my work and helps me retrieve precisely what I need—when I need it.