defmodule Lexer do
  # Función principal que lee el archivo, lo tokeniza y genera el HTML correspondiente
  def leer_archivo(nombre_archivo) do
    nombre_archivo
    |> File.read!()
    |> tokenizar()
    |> generar_html()
    |> generar_html_archivo(nombre_archivo)
  end

  # Función para tokenizar el contenido del archivo
  defp tokenizar(contenido) do
    contenido
    |> String.split("\n", trim: true)
    |> Enum.map(fn linea -> linea <> "\n" end)
    |> Enum.map(&tokenizar_linea/1)
    |> List.flatten()
  end

  # Función para tokenizar cada línea del archivo
  defp tokenizar_linea(linea) do
    [
      comentarios(linea),
      palabras_reservadas(linea),
      nulls(linea),
      strings(linea),
      especificadores(linea),
      operadores(linea),
      numeros(linea),
      funciones(linea),
      identificadores(linea),
      caracteres(linea),
      delimitadores(linea),
      directivas(linea),
      espacios(linea)
    ]
    |> List.flatten()
  end

  # Función para identificar y tokenizar comentarios
  defp comentarios(linea) do
    Regex.scan(~r/\/\/.*/, linea)
    |> Enum.map(fn [token] -> {:comentario, token} end)
  end

  # Función para identificar y tokenizar palabras reservadas
  defp palabras_reservadas(linea) do
    elixir_keywords = [
      "def", "do", "end", "case", "when", "cond", "fn", "true",
      "false", "nil", "and", "or", "not", "xor", "in", "import", "require",
      "alias", "module"
    ]
    regex = ~r/\b(#{Enum.join(elixir_keywords, "|")})\b/
    Regex.scan(regex, linea)
    |> Enum.map(fn [token | _] -> {:reservada, token} end)
  end

  # Función para identificar y tokenizar nulls
  defp nulls(linea) do
    Regex.scan(~r/\bNULL\b/, linea)
    |> Enum.map(fn [token] -> {:null, token} end)
  end

  # Función para identificar y tokenizar cadenas de caracteres
  defp strings(linea) do
    Regex.scan(~r/\"[^\"]*\"/, linea)
    |> Enum.map(fn [token] -> {:string, token} end)
  end

  # Función para identificar y tokenizar especificadores
  defp especificadores(linea) do
    Regex.scan(~r/<\w+[\.]\w>/, linea)
    |> Enum.map(fn [token] -> {:especificador, token} end)
  end

  # Función para identificar y tokenizar operadores
  defp operadores(linea) do
    Regex.scan(~r/\+\+|--|&&|<<|>>|==|!=|<=|>=|<|>+=-\/%|\/\/|::|->|\|endl|\+\=|-\=|\+|\=/, linea)
    |> Enum.map(fn [token] -> {:operador, token} end)
  end

  # Función para identificar y tokenizar números
  defp numeros(linea) do
    Regex.scan(~r/\b\d+(\.\d+)?\b/, linea)
    |> Enum.map(fn [token] -> {:numero, token} end)
  end

  # Función para identificar y tokenizar funciones
  defp funciones(linea) do
    Regex.scan(~r/\b\w+(?=\()/, linea)
    |> Enum.map(fn [token] -> {:funcion, token} end)
  end

  # Función para identificar y tokenizar identificadores
  defp identificadores(linea) do
    Regex.scan(~r/\b[a-zA-Z_][a-zA-Z0-9_]*\b/, linea)
    |> Enum.map(fn [token] -> {:identificador, token} end)
  end

  # Función para identificar y tokenizar caracteres
  defp caracteres(linea) do
    Regex.scan(~r/'.'/, linea)
    |> Enum.map(fn [token] -> {:caracter, token} end)
  end

  # Función para identificar y tokenizar delimitadores
  defp delimitadores(linea) do
    Regex.scan(~r/[;{},():]|\[|\]/, linea)
    |> Enum.map(fn [token] -> {:delimitador, token} end)
  end

  # Función para identificar y tokenizar directivas
  defp directivas(linea) do
    Regex.scan(~r/#|\./, linea)
    |> Enum.map(fn [token] -> {:directiva, token} end)
  end

  # Función para identificar y tokenizar espacios
  defp espacios(linea) do
    Regex.scan(~r/\s+/, linea)
    |> Enum.map(fn [token] -> {:espacio, token} end)
  end

  # Función para generar el HTML con los tokens resaltados
  defp generar_html(tokens) do
    tokens
    |> Enum.map(&crear_etiqueta_span/1)
    |> Enum.join()
  end

  # Función para crear etiquetas HTML <span> para cada token
  defp crear_etiqueta_span({tipo, token}) do
    token = String.replace(token, "<", "&lt;")
    if tipo == :espacio do
      token
    else
      "<span class=\"#{tipo}\">#{token}</span>"
    end
  end

  # Función para generar el archivo HTML final
  defp generar_html_archivo(html, nombre_archivo) do
    nuevo_nombre_archivo = Path.rootname(nombre_archivo) <> ".html"
    case File.write(nuevo_nombre_archivo, "<html><head><title>Lexer Output</title></head><body>#{html}</body></html>") do
      :ok ->
        IO.puts("Archivo HTML generado exitosamente: #{nuevo_nombre_archivo}")
      {:error, reason} ->
        IO.puts("Error al generar el archivo HTML: #{reason}")
    end
  end
end

# Llamada para ejecutar el lexer con un archivo de ejemplo
Lexer.leer_archivo("06_dfa.exs")