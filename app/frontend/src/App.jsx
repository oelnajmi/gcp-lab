import { useState } from 'react'

function App() {
  const [out, setOut] = useState('(waiting)');

  async function hit(path) {
    const url = `http://localhost:8081${path}`;
    try {
      const res = await fetch(url);
      const text = await res.text();
      setOut(`GET ${url}\nStatus: ${res.status}\n\n${text}`);
    } catch (e) {
      setOut(`Error: ${e}`);
    }
  }

  return (
    <div style={{ fontFamily: 'system-ui, -apple-system, Segoe UI, Roboto, sans-serif', margin: '2rem' }}>
      <h1>React → Backend (GKE Autopilot)</h1>
      <p>This React app calls the backend at <code>http://localhost:8081</code> (via port-forward).</p>
      <div>
        <button onClick={() => hit('/api/healthz')}>Health</button>{' '}
        <button onClick={() => hit('/api/')}>Root</button>
      </div>
      <h3>Response</h3>
      <pre style={{ background: '#111', color: '#fff', padding: '1rem', borderRadius: 8 }}>{out}</pre>
    </div>
  )
}

export default App
