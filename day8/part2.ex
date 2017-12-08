defmodule FileReader do
    def read(path) do
        File.stream!(path)
        |> Stream.map(&String.trim_trailing/1)
        |> Enum.to_list
    end
end

defmodule ProgramLogic do
    def handleLine(line, variables, highest) do
        parts = String.split(line, " ")
        # Concerned variable
        var = hd(parts)
        if not Map.has_key?(variables, var) do
            variables = Map.update(variables, var, 0, &(&1))
        end

        # Build condition
        cond_var = Enum.at(parts, 4)
        if not Map.has_key?(variables, cond_var) do
            variables = Map.update(variables, cond_var, 0, &(&1))
        end
        cond_var_value = Map.fetch!(variables, cond_var)

        cond_to_eval = to_string(cond_var_value) <> " " <> Enum.at(parts, 5) <> " " <> Enum.at(parts, 6)

        # Condition was true
        if elem(Code.eval_string(cond_to_eval), 0) do
            if Enum.at(parts, 1) == "inc" do
                variables = Map.update!(variables, var, &(&1 + String.to_integer(Enum.at(parts, 2))))
            else
                variables = Map.update!(variables, var, &(&1 - String.to_integer(Enum.at(parts, 2))))
            end
        end
        highest_this_it = Enum.max(Map.values(variables))

        {variables, Enum.max([highest_this_it, highest])}
    end

    def program(lines, variables, highest) do
        if Enum.count(lines) > 0 do
            tuple = ProgramLogic.handleLine(Enum.at(lines, 0), variables, highest)
            program(tl(lines), elem(tuple, 0), elem(tuple, 1))
        else
            {variables, highest}
        end
    end
end

# Program
System.argv()
|> hd # head
|> FileReader.read
|> ProgramLogic.program(%{}, 0)
|> elem(1)
|> IO.puts
