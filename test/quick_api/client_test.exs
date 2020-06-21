defmodule ClientTest do
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
      "http://localhost:8081"
    end
  end

  setup do
    bypass = Bypass.open(port: 8081)

    {:ok, bypass: bypass}
  end

  describe "#default_headers" do
    test "it returns the default headers" do
      assert [{"Authorization", "Bearer FAKETOKEN"}] = TestClient.default_headers()
    end
  end

  describe "#api_host" do
    test "it returns the default headers", %{bypass: bypass} do
      assert "http://localhost:#{bypass.port}" == TestClient.api_host()
    end
  end

  describe "#get" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/endpoint", fn conn ->
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestClient.get("/endpoint")
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestClient.get("/endpoint")
    end
  end

  describe "#post" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestClient.post("/endpoint")
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestClient.post("/endpoint")
    end
  end

  describe "#patch" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PATCH", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestClient.patch("/endpoint")
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PATCH", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestClient.patch("/endpoint")
    end
  end

  describe "#put" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PUT", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestClient.put("/endpoint")
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PUT", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestClient.put("/endpoint")
    end
  end

  describe "#delete" do
    test "successful", %{bypass: bypass} do
      Bypass.expect_once(bypass, "DELETE", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 200, Jason.encode!(%{item: 1}))
      end)

      assert {:ok, %{item: 1}} = TestClient.delete("/endpoint")
    end

    test "failure", %{bypass: bypass} do
      Bypass.expect_once(bypass, "DELETE", "/endpoint", fn conn ->
        # We don't care about `request_path` or `method` for this test.
        Plug.Conn.resp(conn, 500, Jason.encode!(%{error: "message"}))
      end)

      assert {:error, %{body: %{error: "message"}, status: 500}} = TestClient.delete("/endpoint")
    end
  end
end
