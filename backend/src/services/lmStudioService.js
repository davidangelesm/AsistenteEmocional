// src/services/lmStudioService.js
const { LMStudioClient } = require("@lmstudio/sdk");

const client = new LMStudioClient();

// --- CONFIGURACIÓN ---
// ¡¡ASEGÚRATE de que este identificador coincida EXACTAMENTE con el modelo
// que tienes CARGADO y CORRIENDO en el servidor de LM Studio!!
// Ejemplo real podría ser: 'QuantFactory/Meta-Llama-3-8B-Instruct-GGUF/meta-llama-3-8b-instruct.Q4_K_M.gguf'
const MODEL_IDENTIFIER = "deepseek-r1-distill-llama-8b"; // <-- ¡¡Revisa y cambia esto!!

class LMStudioService {
    constructor() {
        this.model = null;
        // Intenta cargar el modelo al inicio (opcional pero recomendado)
        this.loadModel().catch(err => console.error("Error inicial al cargar modelo:", err));
    }

    async loadModel() {
        // Prevenir recargas innecesarias si ya está cargado
        if (this.model) {
             try {
                // Intenta hacer una pequeña llamada para ver si sigue activo
                await client.system.ping();
                console.log("El modelo ya estaba cargado y el servidor responde.");
                return true;
             } catch (pingError) {
                 console.warn("El modelo parecía cargado, pero el servidor no responde al ping. Intentando recargar...");
                 this.model = null; // Forza la recarga
             }
        }

        if (!MODEL_IDENTIFIER || MODEL_IDENTIFIER === "tu/identificador/de/modelo") {
            console.error("ERROR CRÍTICO: MODEL_IDENTIFIER no está configurado en lmStudioService.js");
            return false;
        }

        try {
            console.log(`Cargando modelo de LM Studio: ${MODEL_IDENTIFIER}...`);

            // --- SE ELIMINÓ LA VERIFICACIÓN client.llm.list() ---

            // Intenta cargar el modelo directamente usando load()
            this.model = await client.llm.load(MODEL_IDENTIFIER, {
                 // Puedes añadir configuraciones aquí si son necesarias
                 // acceleration: "auto",
                 // gpu_layers: -1
            });

            console.log("Modelo cargado exitosamente.");
            // Guardamos el identificador real por si acaso (load puede devolver más info)
            if (this.model && this.model.identifier) {
                 console.log(`-> Identificador real del modelo cargado: ${this.model.identifier}`);
            }
            return true;
        } catch (error) {
            console.error(`Error al cargar el modelo de LM Studio ('${MODEL_IDENTIFIER}'):`, error.message || error);
            // Verifica si LM Studio está corriendo o si el identificador es incorrecto
            if (error.message && (error.message.includes('ECONNREFUSED') || error.message.includes('fetch failed'))) {
                 console.error("-> Causa probable: No se pudo conectar al servidor de LM Studio en", client.config.baseUrl, ". ¿Está corriendo?");
            } else if (error.response && error.response.status === 404) {
                 console.error(`-> Causa probable: El servidor LM Studio respondió con 404. ¿El identificador '${MODEL_IDENTIFIER}' es correcto y el modelo está disponible en el servidor?`);
            } else if (error.message && (error.message.toLowerCase().includes('model not found') || error.message.toLowerCase().includes('no model loaded'))) {
                 console.error("-> Causa probable: El identificador del modelo es incorrecto o no está cargado/seleccionado en el servidor de LM Studio.");
            }
            this.model = null;
            return false;
        }
    }

    async generateContent(prompt, history = []) {
        if (!this.model) {
            console.warn("Modelo no cargado. Intentando cargar ahora...");
            const loaded = await this.loadModel();
            if (!loaded || !this.model) {
               console.error("No se pudo cargar el modelo. No se puede generar contenido.");
               return null;
            }
        }

        try {
            console.log(`Generando contenido con LM Studio (modelo: ${this.model.identifier})...`);

             const response = await this.model.respond(prompt, {
               temperature: 0.7,
             });

            console.log("Respuesta recibida de LM Studio.");
            if (!response || typeof response.content === 'undefined') {
                console.error("Error: La respuesta de LM Studio no tiene el formato esperado (falta 'content'). Respuesta recibida:", response);
                return null;
            }
            return response.content; // Devuelve la propiedad 'content'

        } catch (error) {
            console.error("Error al generar contenido con LM Studio:", error.message || error);
            if (error.message && (error.message.includes('ECONNREFUSED') || error.message.includes('fetch failed'))) {
                 console.error("-> Error de conexión: Asegúrate de que el servidor de LM Studio esté corriendo y accesible.");
            }
            return null;
        }
    }
}

module.exports = new LMStudioService();