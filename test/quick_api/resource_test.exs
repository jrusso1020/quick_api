defmodule ResourceTest do
  use ExUnit.Case, async: true

  defmodule TestClient do
    use QuickApi.Client

    @impl QuickApi.Client
    def default_headers() do
      [
        {"Authorization", "Bearer FAKETOKEN"}
      ]
    end

    @impl QuickApi.Client
    def api_host() do
      "http://localhost:8080"
    end
  end

  defmodule TestResource do
    use QuickApi.Resource, client: TestClient, endpoint: "endpoint"
  end

  defmodule TestNoListResource do
    use QuickApi.Resource, client: TestClient, endpoint: "endpoint", exclude: [:list]
  end

  setup do
    bypass = Bypass.open(port: 8080)

    {:ok, bypass: bypass}
  end

  describe "list" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!([%{item: 1}]))
      end)

      assert {:ok, [%{item: 1}]} = TestResource.list()
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestResource.list()
    end

    test "not defined" do
      assert_raise UndefinedFunctionError, fn -> TestNoListResource.list() end
    end
  end

  describe "get" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestResource.get("id")
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestResource.get("id")
    end
  end

  describe "create" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestResource.create(%{})
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestResource.create(%{})
    end
  end

  describe "edit" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PATCH", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestResource.edit("id", %{})
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PATCH", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestResource.edit("id", %{})
    end
  end

  describe "update" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PUT", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestResource.update("id", %{})
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PUT", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestResource.update("id", %{})
    end
  end

  describe "delete_all" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "DELETE", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 204, "")
      end)

      assert :ok = TestResource.delete_all()
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "DELETE", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestResource.delete_all()
    end
  end

  describe "delete" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "DELETE", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 204, "")
      end)

      assert :ok = TestResource.delete("id")
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "DELETE", "/endpoint/id", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestResource.delete("id")
    end
  end
end
