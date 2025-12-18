int curr_idx;
int use_timer;
int status[10];

void scheduler(void) {
    int iter;
    int ready;
    
    curr_idx = curr_idx + 1;
    
    iter = 10;
    ready = 0;
    
    while(iter > 0) {
        if(curr_idx > 9) curr_idx = 0;
        if(status[curr_idx] == 1) {
            set_program(curr_idx);
            ready = 1;
            iter = 0;
        } else {
            iter = iter - 1;
            if(iter > 0) curr_idx = curr_idx + 1;
        }
    }
    
    if(ready == 1) {
        load_prog(curr_idx);
        restore_context();
        if(use_timer == 1) {
            set_timer(100);
            enable_timer();
        }
    } else {
        curr_idx = 0;
    }
    executar();
}

void irq(void) {
    set_sp(255);
    disable_timer();
    save_context();
    scheduler();
}

void halt(void) {
    set_sp(255);
    disable_timer();
    status[curr_idx] = 0;
    save_context();
    scheduler();
}

int main(void) {
    int j;
    j = 0;
    use_timer = input();
    while(j < 10) {
        status[j] = input();
        j = j + 1;
    }
    scheduler();
}
