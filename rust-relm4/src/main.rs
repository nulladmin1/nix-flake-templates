use relm4::{
    ComponentParts, ComponentSender, RelmApp, RelmWidgetExt, SimpleComponent,
    gtk::{
        self,
        prelude::{BoxExt, ButtonExt, GtkWindowExt, OrientableExt},
    },
};

fn main() {
    let app = RelmApp::new("relm4.test.counter");
    app.run::<Counter>(0);
}

struct Counter {
    value: i64,
}

#[derive(Debug)]
enum Messages {
    Increment,
    Decrement,
}

#[relm4::component]
impl SimpleComponent for Counter {
    type Init = i64;

    type Input = Messages;
    type Output = ();

    view! {
        #[root]
            gtk::Window {
                set_title: Some("Counter"),
                set_default_width: 300,
                set_default_height: 100,

                gtk::Box {
                    set_orientation: gtk::Orientation::Vertical,
                    set_spacing: 5,
                    set_margin_all: 5,

                    gtk::Button {
                        set_label: "Increment",
                        connect_clicked => Messages::Increment,
                    },

                    gtk::Label {
                        #[watch]
                        set_label: &format!("Counter: {}", model.value),
                        set_margin_all: 5,
                    },

                    gtk::Button::with_label("Decrement") {
                        connect_clicked => Messages::Decrement,
                    },
                }
            }

    }

    fn init(
        value: Self::Init,
        root: Self::Root,
        sender: ComponentSender<Self>,
    ) -> ComponentParts<Self> {
        let model = Counter { value };

        let widgets = view_output!();

        ComponentParts { model, widgets }
    }

    fn update(&mut self, message: Self::Input, _sender: ComponentSender<Self>) {
        match message {
            Messages::Increment => {
                self.value += 1;
            }
            Messages::Decrement => {
                self.value -= 1;
            }
        }
    }
}
