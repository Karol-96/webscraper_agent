# Import the required libraries
import streamlit as st
from scrapegraphai.graphs import SmartScraperGraph
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Get API key from .env - using OPENAI_KEY as that's your env variable name
openai_access_token = os.getenv("OPENAI_KEY")

# Set up the Streamlit app
st.title("Web Scraping AI Agent 🕵️‍♂️")
st.caption("This app allows you to scrape a website using OpenAI API")

if openai_access_token:
    # Get model from .env or use default
    model = os.getenv("OPENAI_MODEL", "gpt-3.5-turbo")
    
    graph_config = {
        "llm": {
            "api_key": openai_access_token,
            "model": model,
        },
    }
    # Get the URL of the website to scrape
    url = st.text_input("Enter the URL of the website you want to scrape")
    # Get the user prompt
    user_prompt = st.text_input("What do you want the AI agent to scrape from the website?")
    
    if url and user_prompt:
        # Create a SmartScraperGraph object
        smart_scraper_graph = SmartScraperGraph(
            prompt=user_prompt,
            source=url,
            config=graph_config
        )
        # Scrape the website
        if st.button("Scrape"):
            with st.spinner("Scraping in progress..."):
                result = smart_scraper_graph.run()
                st.write(result)
else:
    st.error("OpenAI API key not found in .env file")