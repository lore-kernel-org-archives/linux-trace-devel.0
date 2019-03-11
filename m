Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B29C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDE702075C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3TjvNni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfCKNDA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:03:00 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43580 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfCKNDA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 09:03:00 -0400
Received: by mail-io1-f68.google.com with SMTP id y6so3905296ioq.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 06:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fnxTWjBJRbfKiOciOQOtWxPtB+5anwVQYwvWvH0KIZ0=;
        b=m3TjvNnidNeS1c/zlrTr6HrYxvwuflNIzaMP2fN0/1eZxy6k46cv7+RlAlup+hMfzx
         S/MGF17EuyK5oz07lmGmy/2rC0H8FI023zOXfQP84EcO79LcyRNCcphhsZo0h7uCLRNQ
         HrhdhqQY+cvM95ulEXKf8ezrpbOzyRzIXNWL/DpbfzFDMH1OyeKOsmPaHajrqZhDhEpw
         +TWTNv09utFVl3U9tmBX05DVvQgOKRqhtR4z+xOvMBsjE0+S5nzXGk5W+DY9JwEcEtur
         uM2+IRCbjVqE2EwqWFIphHiRxLoH5btmcfmY+hHDYB8bwRRDFtC3Nbd9VONeA2s1FDHt
         BwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fnxTWjBJRbfKiOciOQOtWxPtB+5anwVQYwvWvH0KIZ0=;
        b=N6a32ehjjF5HnpvT5rTUylT7kmyQ1xM6BKIcBrMF4wvFlOm5i9mAZ3k2bh1aLNq8Nz
         HzLhZPmvsoMoFIvy5KUbsLCbXHvFyMkEUzPZjyqZOBC26SQHoMSa8zdMMY4uYG70En15
         hJaZboINWh7V5Xlddz5BjCUpEHU5Llv8+DNFqxWtcM56183oEx83/bc/vwkHcfL6cGGd
         uEhJmufThEwBwBj527b0z+y7UFqllwMrxj3JaNKc0/4clj9ROBMJubOt8857pGUXM94h
         XLm+h8s7NJ8ByaGr53dvwhWvJEu9a89AV6V3AmGwqK91WUCSSUkkfHMM7NGur910QmnS
         idoA==
X-Gm-Message-State: APjAAAXDibvSf/RG3VM+f8+O3TAwalsF6cmBbwuDSWpoJrxpgCsMxNq3
        Ry7D8bfyaAH6pxy0S7Jp/gaOZirlj2LrlAna/j9nFv3s+A==
X-Google-Smtp-Source: APXvYqyE/zYXMMlazptzW6MiNWn4Y0i6GX/j4jLCLsVSWu2NDxQEZHO+X5RksjDmd87RkWB5hAekhcQwpsFJJKllVnk=
X-Received: by 2002:a6b:5908:: with SMTP id n8mr15922068iob.206.1552309379211;
 Mon, 11 Mar 2019 06:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190311083339.21581-1-tstoyanov@vmware.com>
In-Reply-To: <20190311083339.21581-1-tstoyanov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 11 Mar 2019 15:02:47 +0200
Message-ID: <CAE0o1Nvhpu3U+0BHp5kQ2JObB1eBz8MdvkFE6C0eb2vY84JzUw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] trace-cmd reset fixes
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 10:33 AM Tzvetomir Stoyanov
<tstoyanov@vmware.com> wrote:
>
> [
>  V4 changes:
>    - An extra patch was inluded in v3 (not realeted to trace-cmd reset fixes), by mistake.
>  V3 changes:
>    - Refactored reset_max_latency() and reset_max_latency_instance(),
>      as Steven Rostedt suggested.
>  V2 changes:
>    - Fixed subjects of the patches.
>    - Refactored add_event_pid() and reset_event_pid(),
>      as Steven Rostedt suggested.
> ]
>
> This patch series fixes "trace-cmd reset" command to
> restore default values of various ftrace configurations:
> tracng_on, trace_clock, set_event_pid and tracing_max_latency.
> It also fixes a segfault when the command is executed with
> "-a -d" options.
>
> Tzvetomir Stoyanov (6):
>   trace-cmd: Fix "trace-cmd reset" command to restore "tracng_on"
>   trace-cmd: Fix "trace-cmd reset -a -d" segfault
>   trace-cmd: Fix "trace-cmd reset" command to restore default clock
>   trace-cmd: Reafctored add_event_pid()to utilize write_instance_file()
>   trace-cmd: Fix "trace-cmd reset" command to restore the default value
>     of set_event_pid
>   trace-cmd: Reafctored reset_max_latency() to utilize
>     write_instance_file()
>
>  tracecmd/trace-record.c | 137 ++++++++++++++++++++++------------------
>  1 file changed, 75 insertions(+), 62 deletions(-)
>
> --
> 2.20.1
>

Nit: write_file() and write_instance_file() are moved twice in patches
4 and 6. Moving them once in its new place in trace-record.c would
have made the patchset smaller and easier to review.

With that said, all patches looks good to me.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Thanks!

-- 
Slavomir Kaslev
