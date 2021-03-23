Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC83C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 13:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638EB619B9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 13:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhCWNrd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 09:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbhCWNqv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 09:46:51 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7233CC0613E8
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Mar 2021 06:45:51 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l4so27173783ejc.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Mar 2021 06:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JeyDbkAyhfjnvf6g4PI1QK5aMijetFAgmJc8hqCz5wo=;
        b=VKLwMRRpNv3ajI+KJpTDPW2btb46LMW1Zuzj8iRhbafJcWGbuxAcnfzqyuGp+O6dTQ
         bbwo8mXAUcgUwM3D2ajaTx86vLirxDFLJ4itDdbUyOltveW10kj+K4GIEdhcI3oQL6JK
         U+G+sW1XlQcXo9hpbVyUtMGzl6R0qQxcJ/ocBxrFLRvlF+Y62NySP3LpgoRz7yEypQhy
         R3JtRKMNxKDuzkWQFjEFmzcSFnL3azX+1ZsBdAt6QxPEabrTRLTrH2wsKiBdUEDaWsLj
         3Ll+ufFOUa+myMnvX58Sk9y+oZYib48U5eVlgBMoIyh13Mw+Jfdzm22+G4vfrb05s4WM
         VamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JeyDbkAyhfjnvf6g4PI1QK5aMijetFAgmJc8hqCz5wo=;
        b=BEqFjysa08jDH/HyKM7CnQIsYuIh00dPXoctbje/7rV9T1tCL0ZlGfD6o7ByQ6U+MG
         8ymPrRu+0ZrJAUD677ZIdvgRBhWDlS+9v/mBGnsqm5C9A+F5J95NhUO5Jtv9Ud56CfCU
         2lKZTeB9CI+knNIYhChgloFQ47Xpzc5q/mENo2RzPMTjNpEebTjRTIqgBiubhrsQT8Wq
         0ixHiVQ486wE+YQQBW1roVwWfeP854I7Z5WjwNWoA0A22kipiTu3HTXOQAC/bh3E+x4L
         S3E+a1Mdn0+rUp9VHna0KfgjWTJHMlEdqTzIxVpJJTLmLAlIwTZkQxeXBR/zllMb7Grl
         hXYA==
X-Gm-Message-State: AOAM532j/5S0vwca60q0HsCcXZoDQ2yMAlXFoFPvgjM2cZDSjJhrqg+6
        UFmjRzHszCklOSo36a++puMuWT1ywotbHQ==
X-Google-Smtp-Source: ABdhPJxR5ai5+Wl2WpsYqAGL8NA9Lq3JqBtgMbTp+xgg0HHBMQ4V8Wi+ev3GQSjZ3ItjIyzAHP2Ndg==
X-Received: by 2002:a17:906:cd12:: with SMTP id oz18mr5049532ejb.498.1616507150068;
        Tue, 23 Mar 2021 06:45:50 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id r17sm13071529edt.70.2021.03.23.06.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 06:45:49 -0700 (PDT)
Subject: Re: [PATCH 0/4] kernel-shark: CMake changes
To:     Michal Sojka <michal.sojka@cvut.cz>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20210317164101.30848-1-michal.sojka@cvut.cz>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3ad457ff-05a4-feda-8418-3f8f0e81f3bf@gmail.com>
Date:   Tue, 23 Mar 2021 15:45:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210317164101.30848-1-michal.sojka@cvut.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.03.21 г. 18:40, Michal Sojka wrote:
> This patch series is a follow up to my previous patch for the older
> kernel-shark repo. The first two patches will make life easier for
> distributions like NixOS, the last two patches replace my previous
> patch.
> 
> Note that I didn't add kshark-su-record to a separate component, as
> suggested by Yordan, because it is not necessary. The generated polkit
> action will refer to the correct path and I think it is preferable to
> have all kernelshark binaries in the same directory.
> 
> Michal Sojka (4):
>    kernel-shark: Allow specifying PKG_CONFIG_DIR on cmake command line
>    kernel-shark: Allow specifying TT_FONT_FILE on cmake command line
>    kernel-shark: Allow installing polkit policy separately
>    kernel-shark: Do not use sudo in install_gui.sh + update README

Hi Michal,

Thank you very much for helping us improving KernelShark!
I'm applying all 4 patches.

Best,
Yordan


> 
>   CMakeLists.txt       | 12 ++++++++++--
>   README               |  2 +-
>   build/install_gui.sh | 10 +++++++++-
>   src/CMakeLists.txt   | 10 ++++++----
>   4 files changed, 26 insertions(+), 8 deletions(-)
> 
