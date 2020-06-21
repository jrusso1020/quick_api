defmodule QuickApi.Client do
  @moduledoc """
  Client responsible for making requests to the API and handling the responses.

  This client allows us to define all of our HTTP request logic and configuration
  in one place so that we can easily change or adapt this away from all of the other
  business logic of our library.

  You can define your own QuickApi Client like so

  ### Example usage
  ```
  defmodule MyClient do
    use QuickApi.Client

    def default_headers() do
      [{"Authorization", "Brearer MYSUPERSECURETOKEN"}]
    end

    def api_host() do
      "https://example.com"
    end
  end
  ```

  We have access to HTTP request types on this client and it will automatically use a base
  url as well as set all the necessary headers for us.

  We have access to GET, POST, PATCH, PUT, and DELETE HTTP requests using this client.

  ### Example usage
  ```
  QuickApi.Client.get("/path", %{query_param: "value"})
  QuickApi.Client.post("/path", %{param1: "value"})
  QuickApi.Client.patch("/path", %{param1: "value"})
  QuickApi.Client.put("/path", %{param1: "value"})
  QuickApi.Client.delete("/path")
  ```
  """

  @doc """
  This is an optional callback for the behaviour you can choose to define
  if you would like to override the default headers. This would be a good place
  to set others such as the authorization headers for your client that are needed
  on every request.

  The default functionality is empty headers.
  """
  @callback default_headers() :: [{String.t(), String.t()}]

  @doc """
  This is a mandatory callback for the behaviour you need to define
  to set the api base url

  The default functionality is empty headers.
  """
  @callback api_host() :: String.t()

  defmacro __using__(_options) do
    quote do
      @behaviour QuickApi.Client

      @spec default_headers() :: [{String.t(), String.t()}]
      def default_headers(), do: []

      @doc """
      Issue a get request using the HTTP client

      Accepts path which is the url path of the request, will be added to the end of the base_url
      and a map of params which will become the query list for the get request
      """
      @spec get(String.t(), map()) :: {:ok, map()} | {:error, map()}
      def get(path, params \\ %{}, opts \\ []) do
        opts
        |> create()
        |> Tesla.get(path, query: map_to_klist(params))
      end

      @doc """
      Issue a post request using the HTTP client

      Accepts path which is the url path of the request, will be added to the end of the base_url
      and a map of params which will be the body of the post request
      """
      @spec post(String.t(), map()) :: {:ok, map()} | {:error, map()}
      def post(path, params \\ %{}, opts \\ []) do
        opts
        |> create()
        |> Tesla.post(path, params)
      end

      @doc """
      Issue a patch request using the HTTP client

      Accepts path which is the url path of the request, will be added to the end of the base_url
      and a map of params which will be the body of the post request
      """
      @spec patch(String.t(), map()) :: {:ok, map()} | {:error, map()}
      def patch(path, params \\ %{}, opts \\ []) do
        opts
        |> create()
        |> Tesla.patch(path, params)
      end

      @doc """
      Issue a put request using the HTTP client

      Accepts path which is the url path of the request, will be added to the end of the base_url
      and a map of params which will be the body of the post request
      """
      @spec put(String.t(), map()) :: {:ok, map()} | {:error, map()}
      def put(path, params \\ %{}, opts \\ []) do
        opts
        |> create()
        |> Tesla.put(path, params)
      end

      @doc """
      Issue a delete request using the HTTP client

      Accepts path which is the url path of the request, will be added to the end of the base_url
      """
      @spec delete(String.t()) :: {:ok, map()} | {:error, map()}
      def delete(path, opts \\ []) do
        opts
        |> create()
        |> Tesla.delete(path)
      end

      defp map_to_klist(dict) do
        Enum.map(dict, fn {key, value} -> {to_atom(key), value} end)
      end

      defp to_atom(atom) when is_atom(atom), do: atom
      defp to_atom(string), do: String.to_atom(string)

      defp create(opts) do
        api_host = Keyword.get(opts, :api_host, __MODULE__.api_host())
        additional_headers = Keyword.get(opts, :additional_headers, [])
        headers = __MODULE__.default_headers() ++ additional_headers
        additional_middleware = Keyword.get(opts, :middleware, [QuickApi.ResponseMiddleware])
        adapter = Keyword.get(opts, :adapter, {Tesla.Adapter.Hackney, [recv_timeout: 30_000]})

        middleware =
          [
            {Tesla.Middleware.BaseUrl, api_host},
            {Tesla.Middleware.Headers, headers},
            Tesla.Middleware.EncodeJson
          ] ++ additional_middleware

        Tesla.client(middleware, adapter)
      end

      defoverridable default_headers: 0
    end
  end
end
