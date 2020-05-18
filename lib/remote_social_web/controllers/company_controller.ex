defmodule RemoteSocialWeb.CompanyController do
  use RemoteSocialWeb, :controller

  alias RemoteSocial.Org
  alias RemoteSocial.Account

  alias RemoteSocial.Org.Company


  action_fallback RemoteSocialWeb.FallbackController

  def index(conn, _params) do
    company = Org.list_company()
    render(conn, "index.json", company: company)
  end

  def create(conn, %{"company" => company_params}) do
    with {:ok, %Company{} = company} <- Org.create_company(company_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.company_path(conn, :show, company))
      |> render("show.json", company: company)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Org.get_company!(id)
    render(conn, "show.json", company: company)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Org.get_company!(id)

    with {:ok, %Company{} = company} <- Org.update_company(company, company_params) do
      render(conn, "show.json", company: company)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Org.get_company!(id)

    with {:ok, %Company{}} <- Org.delete_company(company) do
      send_resp(conn, :no_content, "")
    end
  end


  def signup(conn, %{"company" => company_params}) do
    with {:ok, %Company{} = company} <- Org.create_company(company_params) do
      conn
      |> put_status(:created)
      |> authenticate_company(company)


    end
  end

  defp authenticate_company(conn, %Company{} = company) do
    with {:ok, _company} <- Org.authenticate_company(company),
          conn <- RemoteSocial.Auth.Guardian.Plug.sign_in(conn, company),
          token <- RemoteSocial.Auth.Guardian.Plug.current_token(conn)
    do
      conn
      |>put_view(RemoteSocial.CompanyView)
      |>render("login.json", company: company, token: token)
    else
      {:error, :invalid_credentials} ->
        conn
        |> resp(401, Poison.encode!(%{message: "Email or password is incorrect"}))
        |> send_resp()

      error -> error
    end


  end


  def add_member(conn, %{"member_id" => member_id}) do
    with {:ok, %Account.Members{} = member} <- Account.get_members(member_id),
          {:ok, %Account.Members{}} <- Account.attach_company(%Company{}, member) do
            conn
            |> put_status(:created)
            |> put_view(RemoteSocial.CompanyView)
            |> render("201.json", message: "Successfully added this member to your company", code: :attach_success)


    end

  end

  def remove_member(conn, %{"id" => id}) do

  end

  def list_members(conn, _params) do

  end
end

