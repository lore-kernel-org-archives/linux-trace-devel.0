Return-Path: <SRS0=iTkZ=U3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E01C4321A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jun 2019 13:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F7820644
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jun 2019 13:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7trSKm1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF1N0G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 09:26:06 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52713 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfF1N0G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 09:26:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so9114626wms.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jun 2019 06:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YbzD0ljK2cmoGstdDh0H9dcHHlpovn9fzLVGC64GSv8=;
        b=c7trSKm11N7z0WDOHCmHcpovMbYtqCyIVNRcKn6hgNUYfbqu2Rl0m2goFGcdE1V/sB
         mop/VpeXbI2AtuZCmU7JJbHiGB8xwj3yiJFivTc4+BUpnhuBZ/mw3XTBnTrN2Yc6Wojp
         G0xRO+XT6bUYe6KFoE4W8GJmDSc0Birrx0DdeKPxYDR8MfxuSiOkhY5RFdohb9BuIiyN
         0jVkiDulLP6ls8l+4XZ83Wb3IM91dpRaR8dXEwweAzgXM5CFHKyZBnIKAuCXUU3hnN9A
         xcA1l09ClRQLyE8ou5xwUruVUJsizeR5a7ufUwetJtLLvgXQhLT1wVV3JB1jt+VzlvMF
         sC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YbzD0ljK2cmoGstdDh0H9dcHHlpovn9fzLVGC64GSv8=;
        b=NUjannmlUbPT4vtJTf7flTfeVt75cRHOyIB+G9B3SjKmAMfI4mi+AQPnjuP/pJLJhE
         a2RIcIKeUhGNuhz3nl367zLVODwwui8O8D3xSUWlCuId8cH/F3A/l2XD24czFD40V75M
         asdkg8xHrLHOkQFEzeOOpt3VutojhTCmkkOTYp3aOdEqMyOGKZS0B2XUB0G9DQHXTn9I
         y1ODsbCltb+cjjFcxxhuEBJNhFEdZ0GPIFNx0ZNLujoQKTXYmrnmCq2HE2vou6A8lH8x
         T9hD3mH28D+c2nIc/kIR24XNaBF1gKMDddjSpfUjOj+aSFIccFnTYx9u3EulZ53zDe8H
         213A==
X-Gm-Message-State: APjAAAUhpkZKDKFCP5psQcTH2zJT75W7HY3VuUmeXyI8/zf65x2AOmAM
        geVeEPNpEVhTy8V9pVzAv6fPSXm2/BQ=
X-Google-Smtp-Source: APXvYqxC+LGa3OysVA9EM3UvYxs8CCSyntR2iCwF4aPWb5zyYNPTVdtYRoIDoIHgRvpsXSlGa079hg==
X-Received: by 2002:a1c:f102:: with SMTP id p2mr6766974wmh.60.1561728363106;
        Fri, 28 Jun 2019 06:26:03 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm2361957wrt.25.2019.06.28.06.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 06:26:02 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] kernel-shark: Add make BUILD_TYPE=X gui to change
 how the gui is made
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Troy Engel <troyengel@gmail.com>
References: <20190627170553.050679238@goodmis.org>
 <20190627170733.279595354@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d0a1162b-512d-eba7-ada6-d9411c722b7c@gmail.com>
Date:   Fri, 28 Jun 2019 16:26:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190627170733.279595354@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 27.06.19 г. 20:05 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Add a option to the Makefile called "BUILD_TYPE" that is passed to the CMake
> commonds to change how kernelshark is built. The current options are:
> 

Just fix the typos:

Add a option -> Add an option
commonds -> commands

All patches look good.
Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>



>   make BUILD_TYPE=Debug gui          - for "-g" option
>   make BUILD_TYPE=Release gui        - for "-O3" option
>   make BUILD_TYPE=RelWithDebInfo gui - for "-g -O2" option (default)
>   make BUILD_TYPE=MinSizeRel gui     - for "-Os" option
> 
> By default, BUILD_TYPE is set to RelWithDebInfo.
> 
> Also change the CMakeLists.txt to use RelWithDebInfo as the default
> instead of just Debug.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   Makefile                    |  5 ++++-
>   kernel-shark/CMakeLists.txt |  2 +-
>   kernel-shark/README         | 13 ++++++++++++-
>   3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c9679d42fdbd..ad74a969249f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -252,8 +252,11 @@ all_cmd: $(CMD_TARGETS)
>   
>   CMAKE_COMMAND = /usr/bin/cmake
>   
> +# Build with "BUILD_TYPE=Release" to remove cmake debug info
> +BUILD_TYPE ?= RelWithDebInfo
> +
>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
>   
>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>   	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index d932c396e4a6..58a3c3b84309 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -37,7 +37,7 @@ set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread -fPIC")
>   
>   if (NOT CMAKE_BUILD_TYPE)
> -    set(CMAKE_BUILD_TYPE Debug)
> +    set(CMAKE_BUILD_TYPE RelWithDebInfo)
>   endif (NOT CMAKE_BUILD_TYPE)
>   
>   message("\n Build type: ${CMAKE_BUILD_TYPE}")
> diff --git a/kernel-shark/README b/kernel-shark/README
> index b133f1848fd2..7e50479fd824 100644
> --- a/kernel-shark/README
> +++ b/kernel-shark/README
> @@ -51,6 +51,16 @@ changed by passing in "prefix" to the build.
>   2.1.1.2 Use "make clean" if you want to delete all already compiled objects.
>   This will also clean up all the files created by cmake.
>   
> +2.1.1.3 KernelShark has multiple build types (See section 2.1.2.3 for more
> +details. By default, the build type is RelWithDebInfo, which will build
> +a release candidate with debug information. To change the type, pass in
> +the option BUILD_TYPE=<type> to the make process.
> +
> +    make BUILD_TYPE=Debug gui          - for "-g" option
> +    make BUILD_TYPE=Release gui        - for "-O3" option
> +    make BUILD_TYPE=RelWithDebInfo gui - for "-g -O2" option (default)
> +    make BUILD_TYPE=MinSizeRel gui     - for "-Os" option
> +
>   2.1.2 Option 2 (expert) : standalone build of KernelShark (for hackers only)
>   
>      (note, you may need to do a normal make from the toplevel git
> @@ -79,9 +89,10 @@ CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
>   Note that when built as a "Package" the RPATH-s of the executables are
>   set directly to _INSTALL_PREFIX/lib/kernelshark/
>   
> -If no build types is specified, the type will be "Debug".
> +If no build types is specified, the type will be "RelWithDebInfo".
>   
>   Examples:
> +
>       cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
>   
>       cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
> 
