#define VIDEO_MEMORY 0xB8000
#define WHITE_ON_BLACK 0x0F

void print(const char *str);
void clear_screen(char* video_memory);


// Kernel's entry point
int main() {
    char *video = (char*) VIDEO_MEMORY;

    clear_screen(video);

    print("Hello JetBrains, CS242 Greeds you");
    return 0;
}


// A simple function to write a string to video memory
void print(const char *str) {
    char *video = (char*)VIDEO_MEMORY;
    while (*str != '\0') {
        *video++ = *str++;      // character byte
        *video++ = WHITE_ON_BLACK;  // attribute byte
    }
}


void clear_screen(char* video_memory)
{
   int i, j;
   for (i=0; i<25; i++)
   {
      for (j=0; j<80; j++)
      {
         *video_memory++ = ' ';
         *video_memory++ = WHITE_ON_BLACK;
      }
   }
}
