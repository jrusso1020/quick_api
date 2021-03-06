defmodule QuickApi.Resource do
  @moduledoc """
  This module uses a macro to allow us to easily create the base
  HTTP methods for an QuickApi Resource. Most QuickApi requests have
  a common set of methods to get a specific resource by ID, list
  all resources, update the resource, delete all resources
  and delete a resource by id. By using this macro we can easily
  build out new API endpoints in a single line of code.

  ### Example
  ```
  defmodule QuickApi.NewResource do
    use QuickApi.Resource, client: ApiClient, endpoint: "new_resources"
  end
  ```

  We that single line of code we will now have a `list/0`, `list/1`,
  `get/1`, `get/2`, `create/1`, `edit/2`, `delete_all/0`, and `delete/1`
  functions for a given resource.

  You can also exclude functions from being created by passing them as a list
  of atoms with the `:exclude` keyword in the resource definition.

  ### Example
  ```
  defmodule QuickApi.NewResource do
    use QuickApi.Resource, client: ApiClient, endpoint: "new_resources", exclude: [:delete_all, :delete]
  end

  {:ok, [%{}]} = QuickApi.NewResource.list()
  {:ok, %{}} = QuickApi.NewResource.get("id")
  ```

  This definition will not create a `delete_all/0` or `delete/1` endpoint for the
  new resource you have defined.

  ### Options
  Currently this module supports four options `:client`, `:endpoint`, `:exclude`, and `:opts`.

  `:client` is the HTTP client, that implements, the methods `get/3`, `post/3`, `patch/3`, `put/3`, and
  `delete/2` methods. You can use the `QuickApi.Client` to define your own client that implements these
  methods with the necessary methods.

  `:endpoint` is the base path for the RESTful CRUD operations. If the api_host is set to `https://example.com`
  then you can set the `:endpoint` to `"orders"` and it will automatically resolve the resource base url to
  `https://example.com/orders`.

  `:exclude` is the list of CRUD operations to exclude from your resource definition. This can be used
  when an endpoint does not define all CRUD operations and you want to exclude functions from being defined
  on the resource.

  `:opts` is the last option you can pass in and this a keyword list of additional options. This can be used
  to pass in more options to your client when calling the HTTP methods. Such as any additional headers you want
  to pass along or a special api_host url.
  """
  defmacro __using__(options) do
    client = Keyword.fetch!(options, :client)
    endpoint = Keyword.fetch!(options, :endpoint)
    exclude = Keyword.get(options, :exclude, [])
    opts = Keyword.get(options, :opts, [])

    quote do
      unless :list in unquote(exclude) do
        @doc """
        A function to list all resources from the QuickApi API
        """
        @spec list(map()) :: {:ok, [map()]} | {:error, map()}
        def list(params \\ %{}) do
          unquote(client).get(base_url(), params, unquote(opts))
        end
      end

      unless :get in unquote(exclude) do
        @doc """
        A function to get a singlular resource from the QuickApi API
        """
        @spec get(String.t(), map()) :: {:ok, map()} | {:error, map()}
        def get(id, params \\ %{}) do
          unquote(client).get(resource_url(id), params, unquote(opts))
        end
      end

      unless :create in unquote(exclude) do
        @doc """
        A function to create a new resource from the QuickApi API
        """
        @spec create(map()) :: {:ok, map()} | {:error, map()}
        def create(params) do
          unquote(client).post(base_url(), params, unquote(opts))
        end
      end

      unless :edit in unquote(exclude) do
        @doc """
        A function to edit an existing resource using the QuickApi API
        """
        @spec edit(String.t(), map()) :: {:ok, map()} | {:error, map()}
        def edit(id, params) do
          unquote(client).patch(resource_url(id), params, unquote(opts))
        end
      end

      unless :update in unquote(exclude) do
        @doc """
        A function to update an existing resource using the QuickApi API
        """
        @spec update(String.t(), map()) :: {:ok, map()} | {:error, map()}
        def update(id, params) do
          unquote(client).put(resource_url(id), params, unquote(opts))
        end
      end

      unless :delete_all in unquote(exclude) do
        @doc """
        A function to delete all resources of a given type using the QuickApi API
        """
        @spec delete_all() :: :ok | {:ok, [map()]} | {:error, map()}
        def delete_all() do
          unquote(client).delete(base_url(), unquote(opts))
        end
      end

      unless :delete in unquote(exclude) do
        @doc """
        A function to delete a singular resource of a given type using the QuickApi API
        """
        @spec delete(String.t()) :: :ok | {:error, map()}
        def delete(id) do
          unquote(client).delete(resource_url(id), unquote(opts))
        end
      end

      @spec base_url :: String.t()
      defp base_url() do
        "/#{unquote(endpoint)}"
      end

      @spec resource_url(String.t()) :: String.t()
      defp resource_url(resource_id), do: "#{base_url()}/#{resource_id}"
    end
  end
end
