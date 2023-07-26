- name: Establecer configuración de red estática
  hosts: all
  become: yes

  vars_prompt:
    - name: "ip_address"
      prompt: "Ingresa la dirección IP que deseas asignar"
      private: no
    - name: "gateway"
      prompt: "Ingresa la dirección IP del Gateway"
      private: no
    - name: "dns_servers"
      prompt: "Ingresa la lista de servidores DNS separados por comas"
      private: no
    - name: "routes"
      prompt: "Ingresa la lista de rutas estáticas separadas por comas en formato DESTINO/GATEWAY"
      private: no