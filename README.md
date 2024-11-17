# Grove Garage Estética Automotiva 🚗💦</br>
</br>
Este README documenta o processo completo para criar e configurar o projeto GarageGrove Estética Automotiva utilizando Flutter, Firebase e Gradle.</br>
</br>

* Sumário 📋</br>
  </br>
1. Pré-requisitos 🧩</br>
2. Configuração do Ambiente 🌐</br>
3. Criação do Projeto no Android Studio 🏗️</br>
4. Estrutura de Pastas 📂</br>
5. Configuração do Firebase 🔥</br>
6. Configuração do Gradle e Firebase ⚙️</br>
7. Testando a Integração ✅</br>

</br>
1. Pré-requisitos 🛠️</br>
</br>
* Antes de começar, certifique-se de ter os seguintes itens instalados e configurados no seu sistema:</br>
</br>
🔥JDK ☕️</br>
🔥Flutter 🐦</br>
🔥Android Studio 💻</br>
🔥Git 🌱</br>
🔥Gradle 📏</br>
</br>
2. Configuração do Ambiente 🌐</br>
</br>   
* Verifique se as ferramentas estão funcionando com:</br>
</br>

```
Copiar código
gradle -v  # Verifique o Gradle
flutter doctor  # Verifique o Flutter
```
</br>

3. Criação do Projeto no Android Studio 🏗️</br>
   </br>   
   Abra o Android Studio e selecione New Flutter Project.</br>
   Defina o nome e configure as opções do projeto. 🖊️</br>
   </br>
4. Estrutura de Pastas 📂</br>
   </br>
   Aqui está a organização que usaremos:</br>
   </br>

```

/lib
├── main.dart                 # Arquivo principal que inicia o app
├── screens                   # Pasta com as telas principais
│   ├── home_screen.dart      # Tela inicial com opções de agendamento
│   ├── booking_screen.dart   # Tela de agendamento de horários
│   ├── confirmation_screen.dart # Tela de confirmação de agendamento
│   └── profile_screen.dart   # Tela de perfil do lava-jato (informações e contato)
├── models                    # Modelos de dados para o app
│   └── booking_model.dart    # Modelo de dados para os agendamentos
├── services                  # Lógica de backend (simples, se necessário)
│   └── booking_service.dart  # Serviço de agendamento (armazenamento local ou integração futura)
└── widgets                   # Componentes reutilizáveis
    ├── custom_button.dart    # Botão personalizado
    └── booking_card.dart     # Cartão para exibir informações do agendamento

```

</br>
5. Configuração do Firebase 🔥</br>
   No Console do Firebase, crie um projeto.</br>
   Adicione um app Android e baixe o google-services.json.</br>
</br>
6. Configuração do Gradle e Firebase ⚙️</br>
   * Configurações no build.gradle</br>
   * Nível do Projeto 🌐</br>
   * kotlin</br>
   </br>

   ```
   plugins {
   id("com.google.gms.google-services") version "4.4.2" apply false
   }
   Nível do Módulo 📲
   kotlin
   Copiar código
   dependencies {
   implementation(platform("com.google.firebase:firebase-bom:33.6.0"))
   }
   ```
7. Testando a Integração ✅</br>
   </br>
   Sincronize o Projeto com o Sync Now 🔄</br>
   Rode o app no emulador ou dispositivo físico! 📱</br>
