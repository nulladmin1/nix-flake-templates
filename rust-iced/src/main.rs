use iced::widget::{Column, button, column, text};

#[derive(Debug, Clone, Copy)]
enum Message {
    Increment,
    Decrement,
}

#[derive(Default)]
struct Counter {
    value: i64,
}

impl Counter {
    fn update(&mut self, message: Message) {
        match message {
            Message::Increment => {
                self.value += 1;
            }
            Message::Decrement => {
                self.value -= 1;
            }
        }
    }

    fn view(&self) -> Column<Message> {
        let increment: button::Button<Message> = button("+").on_press(Message::Increment);
        let decrement: button::Button<Message> = button("-").on_press(Message::Decrement);

        let counter = text(self.value);

        let interface = column![increment, counter, decrement];

        interface
    }
}

fn main() -> iced::Result {
    iced::run("A cool counter", Counter::update, Counter::view)
}
