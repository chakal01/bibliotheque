class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :init
  before_filter :init_cookies

  def init
    @title = "Ma bibliothèque"
  end

  def init_cookies
    cookies[:onglet_livres] = "true" if cookies[:onglet_livres].nil?
    cookies[:onglet_auteurs] = "true" if cookies[:onglet_auteurs].nil?
    cookies[:onglet_genres] = "true" if cookies[:onglet_genres].nil?
    cookies[:onglet_editions] = "true" if cookies[:onglet_editions].nil?
    cookies[:onglet_emplacements] = "true" if cookies[:onglet_emplacements].nil?
    cookies[:onglet_scans] = "true" if cookies[:onglet_scans].nil?
    cookies[:bookPerPage] = 18 if (cookies[:bookPerPage].nil? || cookies[:bookPerPage] == "0")
    cookies[:authorPerPage] = 18 if (cookies[:authorPerPage].nil? || cookies[:authorPerPage] == "0")
  end
end
