//
//  Mp3Coder.hpp
//  SimpleRecoder
//
//  Created by zengbailiang on 2018/5/23.
//  Copyright © 2018年 zengbailiang. All rights reserved.
//

#ifndef Mp3Coder_hpp
#define Mp3Coder_hpp

#include <stdio.h>
#include <iostream>
using namespace std;
class Mp3Coder
{
public:
    Mp3Coder();
    ~Mp3Coder();
    int codeToMp3(const char *srcFile,const char *desFile);
    
};
#endif /* Mp3Coder_hpp */
