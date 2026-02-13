import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final controller = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final managerCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const Icon(Icons.person_add_rounded, size: 70, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  "HourFlow",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5),
                ),
                const SizedBox(height: 30),
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
                            offset: const Offset(0, 10))
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nova Conta",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1C1E))),
                          const SizedBox(height: 8),
                          const Text("Preencha os dados para solicitar acesso",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 30),
                          
                          _buildField(nameCtrl, "Nome Completo", Icons.person_outline),
                          _buildField(emailCtrl, "E-mail Profissional", Icons.email_outlined),
                          _buildField(passCtrl, "Senha", Icons.lock_outline, isObscure: true),
                          _buildField(companyCtrl, "Empresa", Icons.business_outlined),
                          _buildField(managerCtrl, "E-mail do Gestor", Icons.admin_panel_settings_outlined),
                          
                          const SizedBox(height: 20),
                          
                          // Botão com estado reativo Obx
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: controller.isLoading.value 
                                  ? null 
                                  : const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
                                color: controller.isLoading.value ? Colors.grey : null,
                              ),
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value ? null : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: controller.isLoading.value 
                                  ? const SizedBox(
                                      height: 24, 
                                      width: 24, 
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    ) 
                                  : const Text("SOLICITAR CADASTRO", 
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Já tem conta? Voltar para o Login",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função para limpar a UI e chamar o controller
  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      controller.requestSignUp(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passCtrl.text, // O controller tratará como String/Number se necessário
        companyName: companyCtrl.text.trim(),
        managerEmail: managerCtrl.text.trim(),
        receiveCopy: true, // Mantido como true por padrão
      );
    }
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, {bool isObscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF2575FC)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (val) {
          if (val == null || val.isEmpty) return "Obrigatório";
          if (label.contains("E-mail") && !val.contains("@")) return "E-mail inválido";
          return null;
        },
      ),
    );
  }
}