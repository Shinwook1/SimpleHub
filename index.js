// === debug 모듈 자동 설치 (Railway 대응) ===
try {
    require.resolve('debug');
} catch(e) {
    console.log('📦 debug 모듈이 없습니다. 자동 설치 중...');
    const { execSync } = require('child_process');
    execSync('npm install debug', { stdio: 'inherit' });
    console.log('✅ debug 모듈 설치 완료!');
}
// ============================================

const { Client } = require('discord.js-selfbot-v13');
const fs = require('fs');
const path = require('path');

const TOKENS_FILE = path.join(__dirname, 'tokens.json');
const activeClients = new Map();

// ===== 토큰 파일 관리 =====
function loadTokens() {
    try {
        const data = fs.readFileSync(TOKENS_FILE, 'utf-8');
        const json = JSON.parse(data);
        return json.tokens || [];
    } catch(e) {
        return [];
    }
}

function saveTokens(tokens) {
    fs.writeFileSync(TOKENS_FILE, JSON.stringify({ tokens }, null, 2));
}

// ===== 셀프봇 실행 =====
async function startSelfbot(token) {
    if (activeClients.has(token)) {
        console.log(`⚠️ 이미 실행 중인 토큰: ${token.slice(0,15)}...`);
        return false;
    }
    
    try {
        const client = new Client();
        
        client.on('ready', () => {
            console.log(`✅ 셀프봇 실행됨: ${client.user.tag}`);
        });
        
        client.on('messageCreate', async (message) => {
            if (message.author.id !== client.user.id) return;
            
            const args = message.content.slice(1).trim().split(/ +/);
            const command = args.shift().toLowerCase();
            
            if (command === '핑') {
                await message.delete();
                await message.channel.send(`🏓 퐁! ${client.ws.ping}ms`);
            }
        });
        
        await client.login(token);
        activeClients.set(token, client);
        return true;
    } catch(e) {
        console.error(`❌ 실행 실패 (${token.slice(0,15)}...): ${e.message}`);
        return false;
    }
}

// ===== 모든 토큰 실행 =====
async function startAllTokens() {
    const tokens = loadTokens();
    if (tokens.length === 0) {
        console.log('⚠️ 저장된 토큰이 없습니다. tokens.json 파일에 토큰을 추가하세요.');
        console.log('예시: {"tokens": ["여기에_토큰"]}');
        return;
    }
    
    console.log(`🚀 ${tokens.length}개 토큰 실행 중...`);
    for (const token of tokens) {
        if (!activeClients.has(token)) {
            await startSelfbot(token);
            await new Promise(r => setTimeout(r, 1000));
        }
    }
}

// ===== 파일 감시 (새 토큰 추가 시 자동 실행) =====
let lastTokens = [];

function watchTokensFile() {
    fs.watch(TOKENS_FILE, async (eventType) => {
        if (eventType === 'change') {
            const currentTokens = loadTokens();
            const newTokens = currentTokens.filter(t => !lastTokens.includes(t));
            
            for (const token of newTokens) {
                console.log(`🆕 새 토큰 감지됨: ${token.slice(0,15)}...`);
                await startSelfbot(token);
            }
            lastTokens = currentTokens;
        }
    });
}

// ===== 종료 처리 =====
process.on('SIGINT', async () => {
    console.log('\n🛑 모든 셀프봇 종료 중...');
    for (const [token, client] of activeClients) {
        client.destroy();
    }
    process.exit(0);
});

// ===== 메인 실행 =====
async function main() {
    console.log('╔══════════════════════════════════════╗');
    console.log('║     ⚡ Volt SelfBot Manager v1.0      ║');
    console.log('╚══════════════════════════════════════╝\n');
    
    lastTokens = loadTokens();
    await startAllTokens();
    watchTokensFile();
    
    console.log('\n📁 tokens.json 파일 감시 중...');
    console.log('💡 새 토큰을 추가하면 자동으로 실행됩니다.');
    console.log('📌 예시: {"tokens": ["토큰1", "토큰2"]}\n');
}

main().catch(console.error);
