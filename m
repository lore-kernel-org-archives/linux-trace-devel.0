Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_03_06,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898EFC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jan 2021 10:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3129D233CE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jan 2021 10:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbhAMKls (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jan 2021 05:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbhAMKls (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jan 2021 05:41:48 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77841C061575
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Jan 2021 02:41:08 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y8so831747plp.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Jan 2021 02:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=KGsMnbwYmNF05F+x13pFOjcNSV4fBeCvUubDpQofrZw=;
        b=nBbOemtLigPFOfLBMED81Ew7EhK4+ammlPTQP6aAt7Y1I/mOcZMcG2c/IM74yjTICR
         +FhvXCbmHkOLMViDoc9pXjbBAPhlla9gZ9BvYv2e1BewZDDdy2JY1rpivK0kMfdoUInY
         dgihb2N2Wi2ioemNbdazufjfzDllc3P1OPcK0n+e1Sl2laD9ljfRf36kleLJYLGonJdN
         ekYgY/1QlJe/vI3lG+65Y7MdpqcXsSF8giy4bqahIJGXSBrJpvtuzGv7lHZIuS5GVN+4
         OAF8wV81lEvVY/C3wxfed1foFPdxZNm4KuHK5CAukowy1HQ93A1SgxXRltA2/2PC7zH1
         puBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KGsMnbwYmNF05F+x13pFOjcNSV4fBeCvUubDpQofrZw=;
        b=EV056CdJ5yP01MJGKEoqH4/Giey9GEMOtzxplV9UZy48ydi98DZ34OCMBDaQR8qOPI
         Y9a8lzq/iCI5igyo31QQ4TNUOMV4jehcb7seVJdpsGswX+0fSkQmuwiSJpNys5tpsQU0
         +i5vX6gNMlrwyhMVfPBQ412iijnBerduhdpc6rDyKgrSY6rcUtyk32TtDtYLDxvzQ4kU
         1otSpSf3k/mwDvyNjpGBa3IZvO5s6o9mXx0NQrm2le8rC/6o+e/VbYbVYajolcoUCvox
         J7lNzweJ7n4MxvnjQiv0RVtnWdDehlijtNv4+51Mv0GcvRU+bkH0BPQooB9rcBm5naVm
         YGGA==
X-Gm-Message-State: AOAM531IXHZtXtXxLLKNWI1Xm/sY+bJbfoC8CgoAwZ0KNI3xZnMWJCtv
        Jimogv4CT0WCbpR2KJS+PqCSUPHHCjGR3A==
X-Google-Smtp-Source: ABdhPJyNIxogJfsQ70Z6QxIXvNZyCRtj9JYF2aMMvFfNg3s4Lnx57R6AmuGOGd8TzlkJobuRz6ZjMg==
X-Received: by 2002:a17:902:eb0d:b029:dd:f952:db29 with SMTP id l13-20020a170902eb0db02900ddf952db29mr1570596plb.18.1610534467754;
        Wed, 13 Jan 2021 02:41:07 -0800 (PST)
Received: from [192.168.0.106] ([45.118.72.218])
        by smtp.gmail.com with ESMTPSA id gp14sm2377543pjb.6.2021.01.13.02.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 02:41:06 -0800 (PST)
Subject: Re: [PATCH] trace-cmd: Fix lib audit warning message
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <CAK7tX=bWn89VxofeyK0hfb4_dQz3tKG2Y2+_47WnaYiWN5UN2w@mail.gmail.com>
 <20210112122906.33c959f2@gandalf.local.home>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <c7d7a2f9-78cf-366f-44ec-e1695c019443@gmail.com>
Date:   Wed, 13 Jan 2021 21:40:45 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210112122906.33c959f2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi steve,

please check now.

statically updated the warning message which we will get, when
compiling trace-cmd without the libaudit library.

Following are the the messages which will pop out when compiling

Before:
-------
trace-profile.c:23:3: warning: #warning "lib audit not found, using raw 
syscalls " "(install libaudit-devel and try again)"

After:
-------
trace-profile.c:23:3: warning: #warning "lib audit not found, using raw 
syscalls " "(install libaudit-devel(for fedora) or libaudit-dev(for 
debian/ubuntu) and try again)"

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
---
  tracecmd/trace-profile.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index cfae2a2..9b5c385 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -21,7 +21,7 @@

  #ifdef WARN_NO_AUDIT
  # warning "lib audit not found, using raw syscalls "    \
-    "(install libaudit-devel and try again)"
+    "(install libaudit-devel(for fedora) or libaudit-dev(for 
debian/ubuntu) and try again)"
  #endif

  #define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"
-- 

Thanks,

sameer.

On 12/01/21 10:59 pm, Steven Rostedt wrote:
> On Tue, 12 Jan 2021 13:01:20 +0530
> Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:
>
> Hi Sameer,
>
>> statically updated the warning message which we will get, when
>> compiling trace-cmd without the libaudit library.
>>
>> Following are the the messages which will pop out when compiling
>>
>> Before:
>> -------
>> trace-profile.c:23:3: warning: #warning "lib audit not found, using
>> raw syscalls " "(install libaudit-devel and try again)"
>>
>> After:
>> -------
>> trace-profile.c:23:3: warning: #warning "lib audit not found, using
>> raw syscalls " "(install libaudit-devel(for fedora) or
>> libaudit-dev(for debian/ubuntu) and try again)"
>>
>> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
>> ---
>>   tracecmd/trace-profile.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
>> index cfae2a2..4e5d68d 100644
>> --- a/tracecmd/trace-profile.c
>> +++ b/tracecmd/trace-profile.c
>> @@ -21,7 +21,8 @@
>>
>>   #ifdef WARN_NO_AUDIT
>>   # warning "lib audit not found, using raw syscalls "    \
> Your mail client turned tabs into spaces and this doesn't apply properly.
> Are you able to fix that?
>
>> -    "(install libaudit-devel and try again)"
>> +    "(install libaudit-devel(for fedora) or libaudit-dev(for \
>> +debian/ubuntu) and try again)"
> Also, the above can stay on one line. Yes, it breaks the 80 char limit, but
> that's more of a guideline and not a requirement ;-)
>
>
> Care to send a v2?
>
> Thanks!
>
> -- Steve
>
>>   #endif
>>
>>   #define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"
