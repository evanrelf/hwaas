use axum::{routing::get, Router};
use clap::Parser as _;

#[derive(clap::Parser)]
struct Args {
    #[arg(long, default_value_t = 8080)]
    port: u16,
}

#[tokio::main]
async fn main() {
    let args = Args::parse();

    let app = Router::new().route("/", get(|| async { "Hello, world!" }));

    println!("Running at 0.0.0.0:{}", args.port);
    axum::Server::bind(&format!("0.0.0.0:{}", args.port).parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}
