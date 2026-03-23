from fastapi.responses import StreamingResponse

@app.post("/chat-stream")
async def chat_stream(request: ChatRequest):

    def generate():
        stream = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": m.role, "content": m.content} for m in request.messages],
            stream=True,
        )

        for chunk in stream:
            content = chunk.choices[0].delta.content
            if content:
                yield content

    return StreamingResponse(generate(), media_type="text/plain")