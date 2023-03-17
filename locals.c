#include <stdio.h>

int setenv_me(char *name, char *value, int overwrite) {
    printf("name = %s\n", name);
    printf("value = %s\n", value);
    printf("overwrite = %d\n", overwrite);
    return 0;
}

const char *getenv_me(char *name) {
    const char *answer = "theanswer";
    printf("name = %s\n", name);
    return answer;
}
