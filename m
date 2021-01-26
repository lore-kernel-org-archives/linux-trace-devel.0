Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BFBC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Jan 2021 04:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBD2E20709
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Jan 2021 04:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhA0EQb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389211AbhAZQ7d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 11:59:33 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21BCC061D73
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Jan 2021 08:58:52 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id g3so10118263plp.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Jan 2021 08:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wyqKcZDN7HSwwqBEDheJ3SNobxsG+MGcJc68aIhl4GI=;
        b=ocdeQFcj1VTmVIv/FjbdM3zqQaXspPeD4S34iB+nO/ce6x8BJhoha74zMWN+y9d4Lg
         h0Wvh9KJlOHkXbACkhkgnlhIhne4npNchXkwQbDLuTHf8VnUOOlYSFuQ2gxPhMwH5Kc3
         WaSN7mX0oHNfDD3prgP46ZjshSlhi7d+Cmz53te2prqXFab/9Ja7AqlHTJazKfPDgB1n
         QKclA9YfYQZOa04TxTiaqvh0PrzjFy1RdusESILoP25wja9/gBSAkbmj7jvl4bOZbuSS
         sfHdoEiVTcz9JvpVpqOtuKPFxhXpJYDONw+819lUFjA+n/yVxTJaeWvEaA3wi30iEo22
         sA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wyqKcZDN7HSwwqBEDheJ3SNobxsG+MGcJc68aIhl4GI=;
        b=rbV3WotPVJuccdOGh8yIhMjSpJ37Fdy95ugDxgh24piJDuL88HA6cATPRABxoJSBR/
         Ilcaz5qGeEZUyFVrWmH2ajiNBatPsumsfpvrmXJAafhshZRi9uSyV0ceEkbrliSg++dv
         wbhlPXtb4gg+7IGqkyOAg6LjXxZY/S5en0WMR/1nRtamm4lnFYUiXI9ouXdHQ7Ip7DaL
         y43HkaCjYFi0xUuPjF0szTS/l0DRkH0/JXjtqEGubTMuzqVgzyeHcF6wXi/puK4u2DVC
         Omnya1nScnxsHB6ayjwNf5CWcfAkRMKBwXrIasyRfEw+RQ4egULZDj5VX/zjXxZRWTJG
         Bf4g==
X-Gm-Message-State: AOAM531cvOOnewIlsFyngrNB3PFQOTJHnpb6pAAVbU95wwu5eKvIpyAz
        hKHoSRJq+R2ncWKzqOIw0mzeUvVgpQwXyWVkb38=
X-Google-Smtp-Source: ABdhPJwJSQovWYi188pKwV0BtuhUIUVjfTERtqwE9K8VzLkb7wTwncS6RgL+GdOCkI39b4r8+T+/nd4E/vVaayybaOE=
X-Received: by 2002:a17:90b:3886:: with SMTP id mu6mr691533pjb.153.1611680332184;
 Tue, 26 Jan 2021 08:58:52 -0800 (PST)
MIME-Version: 1.0
References: <20210126161209.1086179-1-tz.stoyanov@gmail.com> <CAK7tX=YU-R_agm-_XQFu1=Z_dvm92uMZ3CkPJGbwzPGVJ2SUTg@mail.gmail.com>
In-Reply-To: <CAK7tX=YU-R_agm-_XQFu1=Z_dvm92uMZ3CkPJGbwzPGVJ2SUTg@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 26 Jan 2021 18:58:35 +0200
Message-ID: <CAPpZLN4EWKPuK21MF2GjHwLHh_WagyrFS+ki3a3=fT37fiTbwg@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: Add missing system includes
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jan 26, 2021 at 6:43 PM Sameeruddin Shaik
<sameeruddin.shaik8@gmail.com> wrote:
>
>
> The following is the error, which we will get if the above patch is not a=
pplied
>
> ----------------------------
> sameeraaron@sameeraaron-Lenovo-Z50-70:~/hobbies/libtracefs$ sudo make ins=
tall
>   COMPILE FPIC       tracefs-utils.o
>   COMPILE FPIC       tracefs-instance.o
>   COMPILE FPIC       tracefs-events.o
>   COMPILE FPIC       tracefs-tools.o
>   BUILD STATIC LIB   libtracefs.a
>   COMPILE SHARED LIB libtracefs.so.1.0.2
>   INSTALL     /home/sameeraaron/hobbies/libtracefs/libtracefs.pc    to   =
 /usr/local/lib/x86_64-linux-gnu/pkgconfig
>   INSTALL     /home/sameeraaron/hobbies/libtracefs/lib/tracefs/libtracefs=
.so.1.0.2    to    /usr/local/lib64
>   INSTALL     /home/sameeraaron/hobbies/libtracefs/include/tracefs.h    t=
o    /usr/local/include/tracefs
>   INSTALL      trace.conf    to     /etc/ld.so.conf.d/
> /bin/sh: 1: /home/sameeraaron/hobbies/libtracefs/test: not found
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> /etc/ld.so.conf.d//trace.conf:/usr/local/lib64
> In file included from /home/sameeraaron/hobbies/libtracefs/test.c:1:0:
> /usr/local/include/tracefs/tracefs.h: In function =E2=80=98tracefs_trace_=
on_get_fd=E2=80=99:
> /usr/local/include/tracefs/tracefs.h:58:60: error: =E2=80=98O_RDWR=E2=80=
=99 undeclared (first use in this function)
>   return tracefs_instance_file_open(instance, "tracing_on", O_RDWR);
>                                                             ^
> /usr/local/include/tracefs/tracefs.h:58:60: note: each undeclared identif=
ier is reported only once for each function it appears in
> -------------------------------------------
>
> Tzvetomir Stoyanov,
>
> I have one small doubt,
>
> standard headers are not included in   --<tracefs.h>-- file, but they are=
 included
> in the file where the tracefs_instance_file_open() function is defined, w=
ill it won't be suffice?
>
> With your patch, above error is vanished, i tested it.

Thank you for testing the patch :) The problem is that tracefs_trace_on_get=
_fd()
API is implemented as inline in the header file, It is not a good
practice to force
the library users to add such indirect includes. As tracefs.h requires
these system
headers, it should include them implicitly.

>
> Thanks,
> sameer.
>
> On Tue, Jan 26, 2021 at 9:44 PM Tzvetomir Stoyanov (VMware) <tz.stoyanov@=
gmail.com> wrote:
>>
>> Some libtracefs APIs use defines from Linux system headers. These
>> headers are not included in the tracefs library main header file, which
>> causes compilation errors when these APIs are used and the required
>> system headers are not included explicitly by the caller.
>>
>> Reported-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>> ---
>>  include/tracefs.h | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/tracefs.h b/include/tracefs.h
>> index 3059dbb..f3eec62 100644
>> --- a/include/tracefs.h
>> +++ b/include/tracefs.h
>> @@ -6,8 +6,10 @@
>>  #ifndef _TRACE_FS_H
>>  #define _TRACE_FS_H
>>
>> -#include <traceevent/event-parse.h>
>> +#include <sys/stat.h>
>> +#include <fcntl.h>
>>  #include <sched.h>
>> +#include <traceevent/event-parse.h>
>>
>>  char *tracefs_get_tracing_file(const char *name);
>>  void tracefs_put_tracing_file(char *name);
>> --
>> 2.29.2
>>


--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
