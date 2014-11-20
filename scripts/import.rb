s = Roo::Excelx.new("./scripts/books.xlsx")

(2..s.last_row).each do |ligne|
	
	s_auteur = s.cell(ligne,1)
	s_titre = s.cell(ligne,2)
	s_genre = s.cell(ligne,3)
	s_edition = s.cell(ligne,4)
	s_parution = s.cell(ligne,5)
	s_achat = s.cell(ligne,6)

	auteur = Auteur.find_or_create_by(nom: s_auteur)
	genre = Genre.find_or_create_by(nom: s_genre)
	edition = Edition.find_or_create_by(nom: s_edition)

	livre = Livre.create(titre: s_titre, 
								auteur_id: (auteur ? auteur.id : nil), 
								genre_id: (genre ? genre.id : nil), 
								edition_id: (edition ? edition.id : nil), 
								parution: s_parution.to_i, 
								achat: s_achat.to_i)


end