package com.dongyang.dongflix;

public class TMDBmovie {
    private int id;
    private String title;
    private String overview;
    private String posterPath;  // /abcde.jpg 같은 거

    public TMDBmovie(int id, String title, String overview, String posterPath) {
        this.id = id;
        this.title = title;
        this.overview = overview;
        this.posterPath = posterPath;
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

    // 전체 URL (https://image.tmdb.org/t/p/w500 + posterPath)
    public String getPosterUrl() {
        if (posterPath == null || posterPath.equals("null")) {
            return ""; // 없으면 빈 문자열
        }
        return "https://image.tmdb.org/t/p/w500" + posterPath;
    }
}