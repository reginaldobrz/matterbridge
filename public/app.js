document.getElementById('mensagem-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const texto = document.getElementById('texto').value;
  const response = await fetch('/enviar', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ texto })
  });
  const result = await response.json();
  if (result.status === 'ok') {
    document.getElementById('texto').value = '';
    location.reload();
  } else {
    alert("Erro ao enviar: " + (result.error || "erro desconhecido"));
  }
});

async function carregarMensagens() {
  try {
    const res = await fetch('/mensagens_json');
    const mensagens = await res.json();
    const container = document.getElementById('chat-container');
    container.innerHTML = '';

    mensagens.reverse().forEach(msg => {
      const el = document.createElement('div');
      el.classList.add('mensagem');
      el.classList.add(msg.origem === 'usuario' ? 'enviada' : 'recebida');

      el.innerHTML = `
        <div>${msg.original}</div>
        <small>${msg.origem === 'usuario' ? `Enviado (em inglês): ${msg.translated}` : `Traduzido: ${msg.translated}`}</small>
      `;

      container.appendChild(el);
    });

    container.scrollTop = container.scrollHeight;
  } catch (err) {
    console.error("Erro ao carregar mensagens", err);
  }
}

document.getElementById('mensagem-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const texto = document.getElementById('texto').value;

  try {
    const res = await fetch('/enviar', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ texto })
    });

    const result = await res.json();
    if (result.status === 'ok') {
      document.getElementById('texto').value = '';
      await carregarMensagens();
    } else {
      alert("Erro ao enviar mensagem: " + (result.error || "Erro desconhecido"));
    }
  } catch (err) {
    console.error("Erro ao enviar mensagem", err);
  }
});

setInterval(carregarMensagens, 3000);
carregarMensagens();