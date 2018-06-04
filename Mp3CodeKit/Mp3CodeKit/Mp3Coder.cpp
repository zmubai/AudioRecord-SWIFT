//
//  Mp3Coder.cpp
//  SimpleRecoder
//
//  Created by zengbailiang on 2018/5/23.
//  Copyright © 2018年 zengbailiang. All rights reserved.
//

#include "Mp3Coder.hpp"
#include "lame.h"
#include "EncodeExtern.h"
#include <unistd.h>

void* mp3Coder_init()
{
    return new Mp3Coder();
}

int codeTomp3(void* mp3Coder,const char *srcPath,const char *destPath)
{
    Mp3Coder *coder = (Mp3Coder*)mp3Coder;
    int status =  coder->codeToMp3(srcPath, destPath);
    coder->~Mp3Coder();
    return status;
}

Mp3Coder::Mp3Coder(){
    
}

Mp3Coder::~Mp3Coder(){
    
}

int Mp3Coder::codeToMp3(const char *srcFile,const char *desFile)
{
    int read,write;
    FILE *PCM = fopen(srcFile, "rb");
    FILE *MP3 = fopen(desFile, "wb");
    
    const int PCM_SIZE = 8192;
    const int MP3_SIZE = 8192;
    
    short int pcm_buffer[PCM_SIZE * 2];
    unsigned char mp3_buffer[MP3_SIZE];
    
    lame_t lame = lame_init();
    lame_set_in_samplerate(lame, 44100);
    lame_set_VBR(lame, vbr_default);
    lame_init_params(lame);
    
    if (PCM == NULL) {
        cout << "PCM_FILE IS NULL !!!"<<"\n";
        lame_close(lame);
        fclose(MP3);
        fclose(PCM);
        return  -1;
    }
    
    do {
        cout << "do again" << "\n";
        read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, PCM);
        if (read == 0) {
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        }
        else
        {
            write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, MP3);
        }
        //         usleep(100000);
    } while (read != 0);
    cout  << "complete" << "\n";
    lame_close(lame);
    fclose(MP3);
    fclose(PCM);
    return 1;
}
