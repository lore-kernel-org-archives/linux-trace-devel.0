Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A5CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 10:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3466860F55
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 10:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGZJpQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhGZJpQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 05:45:16 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13607C061757
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 03:25:43 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j2so10395099wrx.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 03:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pl698rMXr8VN6i2tImIGu2xZI0F/vbzf6x/0rHnA39E=;
        b=ZgauXhqxYdRw6/RVVZX5ydXPzlKpoxfhGLlw8DfckO/xKhRIhNifnJ4MA7oby58yoK
         3ta7vSwSlrJCynxxokadBhQwLJ0881xGSeiuJBwOULnBRcDs+63iO7Zn0rS3Axe8DTwA
         zBrGEyO9deYbeIe+fNDX9wy+Or4pgpeGxGitxJOCYOsIZLfxXzx3QMHhlDqss00A1MB+
         c7kzTtgx5PWhHrNl3T+sSO88UBKLX4U61CVQbomWl/mAvWh88whgumjEYYPhDCakB/Ez
         9Y46TCrFo+mvnD0bKLN+Mb9FFRbMLVst6PGOyWmVHpaOdVm8RpexMtkHjhAkDu7JpZqB
         Hp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pl698rMXr8VN6i2tImIGu2xZI0F/vbzf6x/0rHnA39E=;
        b=lRohMVpniyiMXHII94iG6IU3z4wjQGFZqyfOYUVHUnCi4kNy/akZIHA/cNWkTokoor
         okT/Q2hCcjgRQBhccXDaemsOalqjpD1p+BOcxGnu8o9UoaEUOmMlRkpzRu9edbV1Zacf
         TOrsevtw9XolnysBHpbdaPmqoKWBulf5nAv2LCASilP68zsaIvQ8DV16dEYoYmXGsBJI
         PgH1CKT+eVUpaqLrELQjT1udAPO/vpz6VQxzKhDVEXDAU7Wc1EES2SG1V1Zfj8qSlVSB
         ZuVrqi7cRas8fl+vdbzTUszR7w6colp10yi6WAewMB0LT3r4ppV5tDlt6gbqGiaDjfQ7
         sGSg==
X-Gm-Message-State: AOAM530p2hnFEondYapErqAAo1KdSWEALlZGfcfdOeCRFhd9REXLAYq1
        OS6M2SFRblyN+rlEsQAAuBM=
X-Google-Smtp-Source: ABdhPJwSQlChLplDF9sK2dYpRuhVr19R/O6LWU5Tl6GK6EEYRqvmtn1vdW+pDMOWoqqfDyq4bVFKUQ==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr18780033wrr.148.1627295142102;
        Mon, 26 Jul 2021 03:25:42 -0700 (PDT)
Received: from [10.93.171.151] ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id m187sm42776200wmm.16.2021.07.26.03.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 03:25:41 -0700 (PDT)
Subject: Re: [PATCH] libtracefs: Remove "traceevent/" from referencing
 libtraceevent headers
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     John 'Warthog9' Hawley <warthog9@kernel.org>
References: <20210716220649.46aab3f7@rorschach.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <a359be7c-3d90-7941-2eee-d8cdc225e4a5@gmail.com>
Date:   Mon, 26 Jul 2021 13:25:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716220649.46aab3f7@rorschach.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.07.21 г. 5:06, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> "pkg-config --cflags --libtraceevent" produces the full path to the
> libtraceevent headers (including the "traceevent/" portion). There is no
> need to add that part in the headers.
> 
> Particularly the one in the main tracefs.h that trace-cmd uses. The
> version 2.9.4 causes the header to include the libtraceevent/event-parse.h
> that is local, when it should be using the system headers, and causes it
> to fail the build.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   include/tracefs.h    | 2 +-
>   src/tracefs-events.c | 2 +-
>   src/tracefs-utils.c  | 4 ++--
>   3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 7e1927b..2649417 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -9,7 +9,7 @@
>   #include <sys/stat.h>
>   #include <fcntl.h>
>   #include <sched.h>
> -#include <traceevent/event-parse.h>
> +#include <event-parse.h>

Perhaps we need a similar patch for "trace-cmd.h".

Thanks!
Yordan


>   
>   char *tracefs_get_tracing_file(const char *name);
>   void tracefs_put_tracing_file(char *name);
> diff --git a/src/tracefs-events.c b/src/tracefs-events.c
> index 7febc2a..8d84838 100644
> --- a/src/tracefs-events.c
> +++ b/src/tracefs-events.c
> @@ -15,7 +15,7 @@
>   #include <fcntl.h>
>   #include <limits.h>
>   
> -#include <traceevent/kbuffer.h>
> +#include <kbuffer.h>
>   
>   #include "tracefs.h"
>   #include "tracefs-local.h"
> diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
> index 6750336..600cdf2 100644
> --- a/src/tracefs-utils.c
> +++ b/src/tracefs-utils.c
> @@ -15,8 +15,8 @@
>   #include <unistd.h>
>   #include <errno.h>
>   
> -#include <traceevent/event-parse.h>
> -#include <traceevent/event-utils.h>
> +#include <event-parse.h>
> +#include <event-utils.h>
>   #include "tracefs.h"
>   #include "tracefs-local.h"
>   
> 
