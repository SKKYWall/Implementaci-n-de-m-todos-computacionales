  defmodule TokenList do

    # The automata argument is expressed as:
    # {delta, acceptm q0}
    def arithmetic_lexer(string) do
      automata = {&TokenList.delta_int_arithmetic/2, [:int, :float, :exp, :var, :par_c, :space_b], :start}
      string
      |> String.graphemes()
      |> eval_dfa(automata, [], [])
    end

    def eval_dfa([], {_delta, accept, state}, token, tokens) do
      cond do
        Enum.member?(accept, state) ->
          if state == :space_b do
            Enum.reverse(tokens)
          else
            Enum.reverse([{state, token |> Enum.reverse() |> Enum.join("")} | tokens])
          end
        true -> false
      end
    end

    def eval_dfa([char | tail], {delta, accept, state}, token, tokens) do
    [new_state, found, validChar] = delta.(state, char)
      cond do
        found ->
          if !is_space(validChar) do
            eval_dfa(tail, {delta, accept, new_state}, [validChar], [{found, token |> Enum.reverse() |> Enum.join("")} | tokens])
          else
            eval_dfa(tail, {delta, accept, new_state}, [], [{found, token |> Enum.reverse() |> Enum.join("")} | tokens])
          end
        true ->
          if !is_space(validChar) do
            eval_dfa(tail, {delta, accept, new_state}, [validChar | token], tokens)
          else
            eval_dfa(tail, {delta, accept, new_state}, token, tokens)
          end

      end
    end

    def delta_int_arithmetic(state, char) do
      case state do
        :start -> cond do
          is_sign(char) -> [:sign, false, char]
          is_digit(char) -> [:int, false, char]
          is_space(char) -> [:space_a, false, char]
          is_par_o(char) -> [:par_o, false, char]
          is_var(char) -> [:var, false, char]
          true -> [:fail, false, char]
        end
        :int -> cond do
          is_digit(char) -> [:int, false, char]
          is_op(char) -> [:op, :int, char]
          is_point(char) -> [:point, false, char]
          is_space(char) -> [:space_b, :int, char]
          is_e(char) -> [:e, false, char]
          is_par_c(char) -> [:par_c, :int, char]
          true -> [:fail, false, char]
        end
        :op -> cond do
          is_sign(char) -> [:sign, :op, char]
          is_digit(char) -> [:int, :op, char]
          is_par_o(char) -> [:par_o, :op, char]
          is_space(char) -> [:space_a, :op, char]
          is_var(char) -> [:var, :op, char]
          true -> [:fail, false, char]
        end
        :sign -> cond do
          is_digit(char) -> [:int, false, char]
          is_var(char) -> [:int, false, char]
          true -> [:fail, false, char]
        end
        :sign2 -> cond do
          is_digit(char) -> [:exp, false, char]
          true -> [:fail, false, char]
        end
        :point -> cond do
          is_digit(char) -> [:float, false, char]
          true -> [:fail, false, char]
        end
        :float -> cond do
          is_digit(char) -> [:float, false, char]
          is_op(char) -> [:op, :float, char]
          is_par_c(char) -> [:par_c, :float, char]
          is_space(char) -> [:space_b, :float, char]
          is_e(char) -> [:e, false, char]
          true -> [:fail, false, char]
        end
        :var -> cond do
          is_var(char) -> [:var, false, char]
          is_space(char) -> [:space_b, :var, char]
          is_op(char) -> [:op, :var, char]
          is_par_c(char) -> [:par_c, :var, char]
          true -> [:fail, false, char]
        end
        :e -> cond do
          is_sign(char) -> [:sign2, false, char]
          is_digit(char) -> [:exp, false, char]
          true -> [:fail, false, char]
        end
        :exp -> cond do
          is_space(char) -> [:space_b, :exp, char]
          is_par_c(char) -> [:par_c, :exp, char]
          is_digit(char) -> [:exp, false, char]
          is_op(char) -> [:op, :exp, char]
          true -> [:fail, false, char]
        end
        :par_o -> cond do
          is_digit(char) -> [:int, :par_o, char]
          is_par_o(char) -> [:par_o, :par_o, char]
          is_sign(char) -> [:sign, :par_o, char]
          is_var(char) -> [:var, :par_o, char]
          true -> [:fail, false, char]
        end
        :par_c -> cond do
          is_op(char) -> [:op, :par_c, char]
          is_par_c(char) -> [:par_c, :par_c, char]
          is_space(char) -> [:space_b, :par_c, char]
          true -> [:fail, false, char]
        end
        :space_b -> cond do
          is_space(char) -> [:space_b, false, char]
          is_op(char) -> [:op, false, char]
          true -> [:fail, false, char]
        end
        :space_a -> cond do
          is_digit(char) -> [:int, false, char]
          is_var(char) -> [:var, false, char]
          is_par_o(char) -> [:par_o, false, char]
          is_space(char) -> [:space_a, false, char]
          true -> [:fail, false, char]
        end
        :fail -> [:fail, false, char]
      end
    end

    def is_digit(char) do
      "0123456789"
      |> String.graphemes()
      |> Enum.member?(char)
    end

    def is_sign(char) do
      "+-"
      |> String.graphemes()
      |> Enum.member?(char)
    end

    def is_op(char) do
      "=+-*/^"
      |> String.graphemes()
      |> Enum.member?(char)
    end

    def is_point(char) do
      char == "."
    end

    def is_space(char) when is_binary(char) and byte_size(char) == 1 do
      char == " "
    end
    def is_space(_), do: false


    def is_par_o(char) do
      char == "("
    end

    def is_par_c(char) do
      char == ")"
    end

    def is_var(char) do

      nums = String.graphemes("0123456789_")
      abc = ?a..?z
      |> Enum.map(&<<&1::utf8>>)
      List.flatten([abc | nums])
      |> Enum.member?(char)
    end

    def is_e(char) do
      "eE"
      |> String.graphemes()
      |> Enum.member?(char)
    end
  end
