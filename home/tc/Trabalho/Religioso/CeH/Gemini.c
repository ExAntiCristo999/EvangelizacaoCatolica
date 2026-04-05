#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

/* A API do Gemini usa a chave de API no cabeçalho 'x-goog-api-key'. */
#define API_URL_BASE "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
#define API_KEY_ENV_VAR "GEMINI_API_KEY" /* Variavel de ambiente solicitada: $GEMINI_API_KEY */
#define API_KEY_FALLBACK_VAR "GEM"

/*
 * Estrutura para armazenar a resposta da API (callback do libcurl)
 */
struct MemoryStruct {
      	char *memory;
      	size_t size;
};

/*
 * Função de callback do libcurl para escrever os dados da resposta
 */
static size_t
WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp) {
      	size_t realsize = size * nmemb;
      	struct MemoryStruct *mem = (struct MemoryStruct *)userp;
	/* Alocação de memória ou reajuste */
	mem->memory = realloc(mem->memory, mem->size + realsize + 1);
       	if(mem->memory == NULL) {
	    	/* erro de memória */
	    	fprintf(stderr, "erro: nao ha memoria suficiente (realloc falhou)\n");
	    	return 0;
      	}
      	/* Copia o conteúdo da resposta para a nossa estrutura */
      	memcpy(&(mem->memory[mem->size]), contents, realsize);
      	mem->size += realsize;
      	mem->memory[mem->size] = 0; /* Finaliza a string */
      	return realsize;
}

// Helper para liberar recursos (simplificada, apenas para cURL e chunk)
static void cleanup_resources(struct curl_slist *headers, CURL *curl_handle, struct MemoryStruct *chunk) {
    if (headers) curl_slist_free_all(headers);
    if (curl_handle) curl_easy_cleanup(curl_handle);
    if (chunk && chunk->memory) free(chunk->memory);
    curl_global_cleanup();
}


int main(int argc, char **argv) {
      	CURL *curl_handle = NULL;
      	CURLcode res;
      	struct MemoryStruct chunk;
      	struct curl_slist *headers = NULL;
      	const char *api_key;
      	const char *prompt = "Explique a diferenca entre C89 e C99 em uma frase.";
      	const char *post_data_format = "{ \"contents\": [ { \"parts\": [ { \"text\": \"%s\" } ] } ]}";
      	char post_data[4096]; /* Buffer para a carga JSON */
      	char api_key_header[256]; /* Buffer para o cabecalho da chave de API */
      	char prompt_escaped[4096];
      	char *p_out;
      	int i;
      	
      	/* * 1. Obter a chave da API   */
      	api_key = getenv(API_KEY_ENV_VAR);
      	if (api_key == NULL) {
	  	api_key = getenv(API_KEY_FALLBACK_VAR);
	  	if (api_key == NULL) {
	      		fprintf(stderr, "erro: A variavel de ambiente $%s ou $%s nao esta definida.\n", API_KEY_ENV_VAR, API_KEY_FALLBACK_VAR);
	      		return 1;
	  	}
      	}
       	/* * 2. Inicializar a estrutura de resposta   */
      	chunk.memory = malloc(1); 
      	chunk.size = 0;   
      	if (chunk.memory == NULL) {
	  	fprintf(stderr, "erro: Falha na alocacao inicial de memoria.\n");
	  	return 1;
      	}
      	/* Se houver um argumento de linha de comando, usá-lo como prompt */
      	if (argc > 1) {
	    	prompt = argv[1];
      	}
      	/* * 3. Preparar a carga JSON (POST data)   */
      	if (strlen(prompt) > 4096) {
	  	fprintf(stderr, "aviso: Prompt muito longo. Usando apenas os primeiros 600 caracteres.\n");
      	}
      	/* Escapando aspas duplas e barras invertidas */
      	p_out = prompt_escaped;
      	for (i = 0; prompt[i] != '\0' && i < 4096; i++) {
	  	if (prompt[i] == '"' || prompt[i] == '\\') {
	      		*p_out++ = '\\';
	  	}
	  	*p_out++ = prompt[i];
      	}
      	*p_out = '\0';
      	/* Cria o JSON completo */
      	snprintf(post_data, sizeof(post_data), post_data_format, prompt_escaped);
      	
      	/* * 4. Inicializar o libcurl   */
      	curl_global_init(CURL_GLOBAL_ALL);
      	curl_handle = curl_easy_init();
      	if(curl_handle == NULL) {
	    	fprintf(stderr, "erro: Falha na inicializacao do CURL.\n");
	    	cleanup_resources(headers, curl_handle, &chunk);
	    	return 1;
      	}
      	/* * 5. Configurar o libcurl   */
      	curl_easy_setopt(curl_handle, CURLOPT_URL, API_URL_BASE);
      	curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
      	curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, (void *)&chunk);
      	curl_easy_setopt(curl_handle, CURLOPT_POST, 1L);
      	curl_easy_setopt(curl_handle, CURLOPT_POSTFIELDS, post_data);
      	curl_easy_setopt(curl_handle, CURLOPT_POSTFIELDSIZE, (long)strlen(post_data));
      	
      	/* * 6. Configurar os cabeçalhos HTTP   */
      	headers = curl_slist_append(headers, "Content-Type: application/json");
       	snprintf(api_key_header, sizeof(api_key_header), "x-goog-api-key: %s", api_key);
      	headers = curl_slist_append(headers, api_key_header);
      	curl_easy_setopt(curl_handle, CURLOPT_HTTPHEADER, headers);
      	
      	/* * 7. Executar a requisição   */
      	res = curl_easy_perform(curl_handle);
      	
      	/* * * 8. Processar a resposta e limpar   */
      	if(res != CURLE_OK) {
	    	fprintf(stderr, "erro: curl_easy_perform() falhou: %s\n", curl_easy_strerror(res));
	    	cleanup_resources(headers, curl_handle, &chunk);
	    	return 1;
	} else {
		// Apenas imprime a resposta JSON crua
		if (chunk.memory != NULL && chunk.size > 0) {
			printf("%s\n", chunk.memory);
		} else {
			fprintf(stderr, "erro: Resposta vazia da API.\n");
		}
	    
      	/* Limpeza */
      	cleanup_resources(headers, curl_handle, &chunk);
      	
      	return (res == CURLE_OK) ? 0 : 1;
	}
}

