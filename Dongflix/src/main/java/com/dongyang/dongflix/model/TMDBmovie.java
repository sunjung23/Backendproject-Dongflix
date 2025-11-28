package com.dongyang.dongflix.model;

public class TMDBmovie {
    private int id;
    private String title;
    private String overview;
    private String posterPath; 
    private String backdropPath;
	private double rating;
	private String releaseDate;

    public TMDBmovie(int id, String title, String overview, String posterPath, String backdropPath, double rating, String releaseDate) {
        this.id = id;
        this.title = title;
        this.overview = overview;
        this.posterPath = posterPath;
        this.backdropPath = backdropPath;
        this.rating = rating;
        this.releaseDate = releaseDate;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getOverview() {
        return overview;
    }

    public String getPosterPath() {
        return posterPath;
    }
    
    public String getBackdropPath() {
    	return backdropPath;
    }
    
    public double getRating() {
    	return rating;
    }
    
    public String getReleaseDate() { 
    	return releaseDate;
    }

    public String getPosterUrl() {
        if (posterPath == null || posterPath.equals("null")) {
            return ""; 
        }
        return "https://image.tmdb.org/t/p/w500" + posterPath;
    }
    public String getBackdropUrl() {
        if (backdropPath == null || "null".equals(backdropPath)) return "";
        return "https://image.tmdb.org/t/p/w1280" + backdropPath;
    }
}