class LivresDatatable

def initialize(view)
  @view = view
end

def as_json(options = {})
  {
    sEcho: @view.params[:sEcho].to_i,
    iTotalRecords: Livre.count,
    iTotalDisplayRecords: livres.count,
    aaData: data
  }
end

def fetch_livres
  livres = Livre.order("#{sort_column} #{sort_direction}").includes(:auteur, :edition, :genre, :emplacement).references(:auteur, :edition, :genre, :emplacement)
  livres = livres.page(page).per_page(per_page)
  #  
  if @view.params[:search].present?
    livres = livres.where("LOWER(livres.titre) like LOWER(:search) or LOWER(auteurs.nom) like LOWER(:search) or LOWER(editions.nom) like LOWER(:search) or LOWER(genres.nom) like LOWER(:search)", search: "%#{@view.params[:search][:value]}%")
  end
  livres
end

def livres
  fetch_livres
end

private

  def page
    @view.params[:start].to_i/per_page + 1
  end

  def per_page
    @view.params[:length].to_i > 0 ? @view.params[:length].to_i : 10
  end


  def search_columns
    %w[livres.titre auteurs.nom editions.nom genres.nom emplacements.nom livres.parution livres.achat]
  end

  def sort_columns
    %w[livres.titre auteurs.nom editions.nom genres.nom emplacements.nom livres.parution livres.achat]
  end

  def sort_column
    sort_columns[@view.params[:order]["0"][:column].to_i]
  end

  def sort_direction
    @view.params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end

  def data
    livres.map do |livre|
      [
        livre.titre,
        livre.auteur ? livre.auteur.nom : "",
        livre.edition ? livre.edition.nom : "",
        livre.genre ? livre.genre.nom : "",
        livre.emplacement ? livre.emplacement.nom : "",
        livre.parution,
        livre.achat,
        (@view.button_tag(class: "btn btn-default btn-xs") do
          @view.content_tag("a", href: @view.edit_livre_path(livre)) do
            @view.tag("span", class: "glyphicon glyphicon-pencil")
          end
        end +
        @view.button_tag(class: "btn btn-default btn-xs") do
          @view.content_tag("a", href: @view.livre_path(livre), "data-method" => :delete, "data-confirm" => "Are you sure?") do
            @view.tag("span", class: "glyphicon glyphicon-trash")
          end
        end )
      ]
    end
  end

end

# - @livres.each do |livre|
#       %tr
#         %td= livre.titre
#         %td= livre.auteur.nom if livre.auteur
#         %td= livre.edition.nom if livre.edition
#         %td= livre.genre.nom if livre.genre
#         %td= livre.emplacement.nom if livre.emplacement
#         %td= livre.parution
#         %td= livre.achat==0 ? nil : livre.achat
#         %td
#           %button.btn.btn-default.btn-xs{type: "button"}
#             %a{href: edit_livre_path(livre)}
#               %span.glyphicon.glyphicon-pencil
#           %button.btn.btn-default.btn-xs{type: "button"}
#             %a{href: livre_path(livre), "data-method" => :delete, "data-confirm" => "Are you sure?"}
#               %span.glyphicon.glyphicon-trash

