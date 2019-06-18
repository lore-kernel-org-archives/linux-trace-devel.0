Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19B6C31E51
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 888C42070B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8ZQ+78D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfFRKyg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 06:54:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34073 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFRKyg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 06:54:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so2015591wmd.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 03:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8TuJtZFirY3B/tlVWUXwV78m2X0QdsZzdgBG0XXfmF0=;
        b=N8ZQ+78DoEngQxPRQbDql4suKZwkowCqW2fj6fAU48o+CThNRtUdxCDGxTEC+xYPTq
         1J37Ho3T6J/9HWuw5DsYWn8kES8kEpgfj5H9Ko1omPTiYXHDCemPFBpIirdr5XNZqqUY
         r3tYJ3Y9OSjI7XRjAd7ARaZCa83ne7qxKQkNYE9lsi1Pvm3sU1U9Gpynte7tSYM3ug40
         pl3smQ4u+v1BQW9ILEyEMOK1QENAyuVmRcX6ExQ11Ir8XolyHs/cZogIB61e38sfbErX
         ev+4XCmrmHcgDkOv2IyOY6hk0A2EKrgAbNWcp7/G+xWinOGMpaVAjyeUZGQusmsqSTX8
         juGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8TuJtZFirY3B/tlVWUXwV78m2X0QdsZzdgBG0XXfmF0=;
        b=LPZfbZXt5BWIiqxyi3cvovBEOpZv+z0BhG9s52Aqk7Eynaaegaq8MLwuZ/e+RVWdWp
         SDFlpULBJWHGgaFT9ReYE/X8zWohoo95F+8bRO4cIlo+MOO02EbOfDFOOYGBbuaWc3mu
         53SNuxaaM6ZED1vBPUs5Whmdt9n70S7e+R/RM/5gYHwmlPZANAAx50NTCgtkKXYF9/lu
         FjWehlo6/mQ0L/+KRmFpJU+4KFZ9jUw04s9lzel7Pr8KwIBsRC74FguTd2vBRmPEvyU6
         okJy/fTBNGNmfPFEj/ornEoepxasT9sJv/ez7ERMOv75Ekx9dbNma6EtHiG9Sqg0mIM4
         irxA==
X-Gm-Message-State: APjAAAWAiese3TixGxyBaDPfZFUgNtSaYCOEuQ4h/Usr/eVUnagTgKIV
        F8SCS426oR9DSWRPahPUbHXL20vP
X-Google-Smtp-Source: APXvYqyOhkUym3S4qE8kOTnPj57dgZG5XhCz//DADJw24pNUIP47y8FgMGNmdUY0Ouxh9nIxd62x9w==
X-Received: by 2002:a1c:2d58:: with SMTP id t85mr2722402wmt.61.1560855274037;
        Tue, 18 Jun 2019 03:54:34 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d201sm1571260wmd.19.2019.06.18.03.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 03:54:33 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Have "make clean" run cmake-clean.sh
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Troy Engel <troyengel@gmail.com>
References: <20190617223129.706595135@goodmis.org>
 <20190617223221.815886530@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <16545372-cf74-9911-542f-bcf16590c4a0@gmail.com>
Date:   Tue, 18 Jun 2019 13:54:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617223221.815886530@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 18.06.19 г. 1:31 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> A make clean should clean up the cmake files as well.
> 
> Update the kernel-shark/README to reflect some of the changes that
> have been made, and options done by the "make" command line.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   Makefile            |  1 +
>   kernel-shark/README | 17 ++++++++++++-----
>   2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 693f33b69b4e..c9679d42fdbd 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -357,6 +357,7 @@ clean:
>   	$(MAKE) -C $(src)/python clean
>   	$(MAKE) -C $(src)/tracecmd clean
>   	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
> +	cd $(kshark-dir)/build; ./cmake_clean.sh
>   
>   
>   ##### PYTHON STUFF #####
> diff --git a/kernel-shark/README b/kernel-shark/README
> index 75a0dd08dcac..4fb13698261b 100644
> --- a/kernel-shark/README
> +++ b/kernel-shark/README
> @@ -31,6 +31,11 @@ Building:
>   the original trace-cmd end traceevent libraries.
>   
>   2. Do:
> +    make gui
> +
> +This will perform the following, in case you want to do it directly
> +yourself:
> +
>       cd kernel-shark/build
>       cmake ../
>       make
> @@ -39,7 +44,11 @@ the original trace-cmd end traceevent libraries.
>   as a CMake Command-Line option.
>   

I agree with all functional changes in those patches. However, the 
README file becomes a bit ambiguous.

I would prefer having something like this

2. Building KernelShark:
2.1 Option 1 : build KernelShark as part of trace-cmd

      make gui
      All explanations for this build option are following
      ...

2.2 Option 2 : standalone build of KernelShark (for hackers only)

      cd kernel-shark/build
      cmake ../
      make
      All explanations for this build option are following ...
      ...

Note that in Option 1

  make clean

  is equivalent to

  make clean
  ./cmake_clean.sh

in Option 2.

Thanks!
Yordan

>   2.1.2 By default, installation prefix is "/usr/local". It can be changed using
> --D_INSTALL_PREFIX= as a CMake Command-Line option.
> +-D_INSTALL_PREFIX= as a CMake Command-Line option. Which can also be
> +done by passing in "prefix=" to the make command line.
> +
> +  make prefix=/my/local/dir gui
> +
>   
>   2.1.3 In addition to the standard CMake build types (Debug, Release,
>   RelWithDebInfo, MinSizeRel) KernelShark supports a "Package" build type.
> @@ -57,10 +66,8 @@ Examples:
>   
>       cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
>   
> -2.2.1 Use "make clean" if you want to delete all already compiled objects.
> -
> -2.2.2 Use the script "cmake_clean.sh" if you want to delete all already
> -compiled objects and all files generated by CMake.
> +2.2 Use "make clean" if you want to delete all already compiled objects
> +and all files generated by CMake.
>   
>   3. After building the code "kernel-shark/lib" will contain all libraries
>   and "kernel-shark/bin" will contain all executables.
> 
