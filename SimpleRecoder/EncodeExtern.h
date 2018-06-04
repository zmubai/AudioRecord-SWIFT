//
//  EncodeExtern.h
//  SimpleRecoder
//
//  Created by zengbailiang on 2018/5/23.
//  Copyright © 2018年 zengbailiang. All rights reserved.
//

#ifndef EncodeExtern_h
#define EncodeExtern_h
#include <stdbool.h>
typedef void* Mp3CodeInstance;

#ifdef __cplusplus
extern "C"{
#endif
    Mp3CodeInstance mp3Coder_init();
    int codeTomp3(Mp3CodeInstance mp3Coder,const char *srcPath,const char *destPath);
#ifdef __cplusplus
}
#endif
#endif /* EncodeExtern_h */
