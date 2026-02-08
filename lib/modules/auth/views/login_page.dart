import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para capturar o texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Instância do Controller
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O Container principal ocupa a tela toda com o degradê
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A11CB), // Roxo
              Color(0xFF2575FC), // Azul
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logotipo ou Ícone acima do card
                const Icon(
                  Icons.access_time_filled_rounded,
                  size: 70,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  "HourFlow",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // CONSTRAINEDBOX: É aqui que a mágica da responsividade acontece!
                // No computador, ele não deixa o card passar de 450px.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1C1E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Faça login para gerenciar suas planilhas",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 35),
                        
                        // Campos de Entrada usando a função helper
                        _buildLabel("E-mail"),
                        _buildTextField(
                          controller: _emailController,
                          hint: "seu_email@email.com",
                          icon: Icons.email_outlined,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildLabel("Senha"),
                        _buildTextField(
                          controller: _passwordController,
                          hint: "Sua senha segura",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          onSubmitted: (_) => authController.login(_emailController.text, _passwordController.text),
                        ),
                        
                        const SizedBox(height: 30),

                        // Botão de Entrar
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2575FC).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: authController.isLoading.value 
                                  ? null 
                                  : () => authController.login(_emailController.text, _passwordController.text),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: authController.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        "ENTRAR", 
                                        style: TextStyle(
                                          color: Colors.white, 
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Esqueceu a senha?", 
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para os labels (textos em cima dos campos)
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1C1E),
        ),
      ),
    );
  }

  // Função helper para os campos de texto
    Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputAction? textInputAction, // Adicione este parâmetro
    ValueChanged<String>? onSubmitted, // Adicione este parâmetro
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      textInputAction: textInputAction, // Repassa para o TextField nativo
      onSubmitted: onSubmitted,         // Repassa para o TextField nativo
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF2575FC)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        // Adicione aqui o restante do seu estilo (BoxShadow, etc) se houver
      ),
    );
  }
}