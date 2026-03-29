#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

// Estrutura para memória
typedef struct {
    unsigned long total;
    unsigned long free;
    unsigned long available;
} MemStats;

// Função para parse de memória (mais robusta)
void get_mem_stats(MemStats *m) {
    FILE *fp = fopen("/proc/meminfo", "r");
    char line[256];
    if (fp) {
        while (fgets(line, sizeof(line), fp)) {
            if (sscanf(line, "MemTotal: %lu kB", &m->total) == 1) continue;
            if (sscanf(line, "MemAvailable: %lu kB", &m->available) == 1) break;
        }
        fclose(fp);
    }
}

// Função para verificar atividade de disco (I/O)
// Retorna o tempo gasto em milissegundos fazendo I/O
unsigned long long get_io_ticks() {
    FILE *fp = fopen("/proc/diskstats", "r");
    char line[256];
    unsigned long long ticks = 0;
    if (fp) {
        // Procuramos o dispositivo principal (ajuste conforme seu sistema: sda, nvme, etc)
        while (fgets(line, sizeof(line), fp)) {
            if (strstr(line, "sda") || strstr(line, "nvme0n1")) {
                unsigned int major, minor;
                char name[32];
                unsigned long long reads, r_merged, r_sectors, r_ms, writes, w_merged, w_sectors, w_ms, progress, io_ms;
                sscanf(line, "%u %u %s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu",
                       &major, &minor, name, &reads, &r_merged, &r_sectors, &r_ms, 
                       &writes, &w_merged, &w_sectors, &w_ms, &progress, &io_ms);
                ticks = io_ms; // Milissegundos gastos em I/O
                break;
            }
        }
        fclose(fp);
    }
    return ticks;
}

int main() {
    MemStats mem;
    unsigned long long io1, io2;

    printf("--- Benchmark CLI Avançado ---\n");

    // Snapshot 1
    get_mem_stats(&mem);
    io1 = get_io_ticks();

    printf("Aguardando 1s para calcular delta de I/O...\n");
    sleep(1);

    // Snapshot 2
    io2 = get_io_ticks();

    // Cálculos
    double mem_usage_pct = 100.0 * (1.0 - ((double)mem.available / mem.total));
    unsigned long long io_delta = io2 - io1;

    printf("\n[RESULTADOS]\n");
    printf("Uso de Memória RAM: %.2f%% (%lu MB livres de %lu MB)\n", 
            mem_usage_pct, mem.available / 1024, mem.total / 1024);
    
    printf("Atividade de Disco: %llu ms de processamento por segundo\n", io_delta);
    
    if (io_delta > 500) {
        printf("Status: Disco sob ALTA carga.\n");
    } else {
        printf("Status: Disco operando normalmente.\n");
    }

    return 0;
}

