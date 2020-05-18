defmodule RemoteSocialWeb.CompanyView do
  use RemoteSocialWeb, :view
  alias RemoteSocialWeb.CompanyView

  def render("index.json", %{company: company}) do
    %{data: render_many(company, CompanyView, "company.json")}
  end

  def render("show.json", %{company: company}) do
    %{data: render_one(company, CompanyView, "company.json")}
  end

  def render("201.json", %{message: message, code: code}) do
    %{data: %{message: message, code: code}}
  end

  def render("company.json", %{company: company}) do
    %{id: company.id,
      company_name: company.company_name,
      company_tag: company.company_tag,
      email: company.email,
      password_hash: company.password_hash}
  end
end
