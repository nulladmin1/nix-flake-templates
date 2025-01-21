use std::error::Error;

pub mod cli;
use cli::Cli;

fn main() -> Result<(), Box<dyn Error>> {
    let cli = Cli::init()?;
    cli.run()?;

    Ok(())
}
