const { Client } = require('discord.js-selfbot-v13');
const fs = require('fs');
const path = require('path');

const TOKENS_FILE = path.join(__dirname, 'tokens.json');
const activeClients = new Map(); // 토큰별 클라이언트 저장

// JSON 파일 읽기
function loadTokens() {
    try {
        const data = fs.readFileSync(TOKENS_FILE, 'utf-8');
        return JSON.parse(data).tokens;
    } catch(e) {
        return [];
    }
}

// JSON 파일 저장
function saveTokens(tokens) {
    fs.writeFileSync(TOKENS_FILE, JSON.stringify({ tokens }, null, 2));
}

// 셀프봇 실행
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
            if (message.content === '!핑') {
                await message.delete();
                await message.channel.send('🏓 퐁!');
            }
        });
        
        await client.login(token);
        activeClients.set(token, client);
        return true;
    } catch(e) {
        console.error(`❌ 실행 실패: ${e.message}`);
        return false;
    }
}

// 모든 토큰 실행
async function startAllTokens() {
    const tokens = loadTokens();
    for (const token of tokens) {
        if (!activeClients.has(token)) {
            await startSelfbot(token);
            await new Promise(r => setTimeout(r, 1000)); // 1초 간격
        }
    }
}

// 파일 변경 감지 (새 토큰 추가 시)
let lastTokens = [];
function watchTokensFile() {
    fs.watch(TOKENS_FILE, async (eventType) => {
        if (eventType === 'change') {
            const currentTokens = loadTokens();
            
            // 새로 추가된 토큰 찾기
            const newTokens = currentTokens.filter(t => !lastTokens.includes(t));
            
            for (const token of newTokens) {
                console.log(`🆕 새 토큰 감지됨: ${token.slice(0,15)}...`);
                await startSelfbot(token);
            }
            
            lastTokens = currentTokens;
        }
    });
}

// 종료 시 모든 셀프봇 종료
process.on('SIGINT', async () => {
    console.log('🛑 모든 셀프봇 종료 중...');
    for (const [token, client] of activeClients) {
        client.destroy();
    }
    process.exit(0);
});

// 메인 실행
async function main() {
    console.log('🚀 셀프봇 매니저 시작');
    lastTokens = loadTokens();
    await startAllTokens();
    watchTokensFile();
    console.log('📁 tokens.json 파일 감시 중...');
}

main().catch(console.error);
