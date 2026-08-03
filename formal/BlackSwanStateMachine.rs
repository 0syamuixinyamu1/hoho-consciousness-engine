#[derive(Debug, Clone)]
pub enum RuntimeState {
    Resting,
    Ingesting,
    LocallyCoherent,
    TopologicalPanic,
    Defending,
    ScarPersistence,
    Resurrecting,
    Revised,
}

#[derive(Debug, Clone)]
pub struct SemanticScar {
    pub signature: String,
    pub intensity: f32,
    pub repetitions: u32,
    pub unresolved: bool,
}

#[derive(Debug, Clone)]
pub struct SelfModel {
    pub revision_index: u64,
    pub ego_rigidity: f32,
    pub scar_sensitivity: f32,
    pub scars: Vec<SemanticScar>,
    pub state: RuntimeState,
}

impl SelfModel {
    pub fn panic(&mut self) {
        self.state = RuntimeState::TopologicalPanic;
    }

    pub fn preserve(&mut self, scar: SemanticScar) {
        self.state = RuntimeState::ScarPersistence;
        self.scars.push(scar);
    }

    pub fn resurrect(&mut self) {
        self.state = RuntimeState::Resurrecting;
        self.revision_index += 1;
        self.scar_sensitivity = (self.scar_sensitivity + 0.05).min(1.0);
        self.state = RuntimeState::Revised;
    }
}
