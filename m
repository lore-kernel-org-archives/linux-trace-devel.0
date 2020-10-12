Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF9DC433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42363208D5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njIopG/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbgJLMf0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 08:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388542AbgJLMfZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 08:35:25 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A92C0613D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 05:35:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w21so13366583pfc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 05:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SsTjF7d2yhj5OQ1pK8mz1PSVCKvK6vsWlaqy1FJbwv0=;
        b=njIopG/ejYTOyRRL8YfoEEBJqNCVRncZgXxpx0Op99NbjPDF9vJaHlO3q62ySzUKkg
         QnHUXh+nae/hI7kkZtqZK+Bv7dX6abcO8YLvXqu1fnO/27PeX5w99TjOBnmrw6K7EsuI
         X3z87XcDr/+GWdFuN3ChnyLsR3kVQcChs2hgCWMJ5mz/bmscJN3XHSuuYWhtO5Bgd4F6
         0Hs6mdPLrVJwrqMeyAXr8YHbdJSJU93dl/8oaY3Q/k0fQOfyaxPvGHjgXlC1ZP8BnbNL
         yBQx/M553mmdkhnvN6yIWEvFwVnxS6wZF5AbpL4wox6bd4bFLwM1zuFizt/n3HdVJ/35
         L4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SsTjF7d2yhj5OQ1pK8mz1PSVCKvK6vsWlaqy1FJbwv0=;
        b=o2p1p1GZAdY4v6uwvBjG4ZRcjwa0hS0p7KBi8KpcSmv6mV/qwNlxxP075ToQFNEpu+
         ASmEMubInMwampQ2O9poNps7zVizdl1r+oJyvHwRyazk2NwpxzNZ5eFHTBcREzPxMuG+
         uq8u98aJYBHtByJiiW7wOOz5geaF+kZK/Wl6zPXvNYSrfkF2uoqNJixvq/kIvJdRdyG+
         aS5P1H9XOFSm3sr2Xzm5p0D8l8lLxPbk703BkbW+9MEE5Z77GyEo3DGWuw6uvLZ5Q8Mu
         wV+B42eiBbZN0LY4EQc/XM2KzwkLrn3CGYBI2ynUjwxKaVwa7TQ6dQXj6q7VPxq1GIHL
         2UUg==
X-Gm-Message-State: AOAM530TLoWj7kzv7mVMUSuwXzkVBlXm5WM5rDkxHTth8+jJjYSCyczw
        edSHZye44w4DTaTw6pbkThmCp5kNw4W3GqG4lYg=
X-Google-Smtp-Source: ABdhPJzyOTQFHq6ETtLsfkilLxGtCj0VP9m4BUFysxaBMBFip11ZUYjMtHZrOCl7SzWTwSfaPzzizQ==
X-Received: by 2002:a17:90a:5803:: with SMTP id h3mr17714115pji.165.1602506124266;
        Mon, 12 Oct 2020 05:35:24 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id x16sm19961484pff.14.2020.10.12.05.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 05:35:23 -0700 (PDT)
Subject: Re: libtraceevent: make doc-install tries different file names than
 generated
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <7cdec98e-3184-4ddc-e78c-867a9650e636@gmail.com>
 <20201009104954.0fd440b5@gandalf.local.home>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <b592e388-5af1-5269-37ce-8ca9e91c84dd@gmail.com>
Date:   Mon, 12 Oct 2020 20:35:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201009104954.0fd440b5@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10/9/20 10:49 PM, Steven Rostedt wrote:
> On Thu, 8 Oct 2020 17:50:19 +0800
> Zamir SUN <sztsian@gmail.com> wrote:
> 
>> Hi,
>>
>> When I try to compiling the document of libtraceevent with the fix I
>> mentioned in [1] applied, make doc-install fails with errors like
>>
>> "/usr/bin/install: cannot stat 'libtraceevent-record_parse.3': No such
>> file or directory"
>>
>> Checking the compiled documents I see a lot of tep_*.3 generated, and
>> some libtraceevent_*.html. However no libtraceevent_*.3.
>>
>> $ ls Documentation/*3 | head
>> Documentation/libtraceevent.3
>> Documentation/tep_alloc.3
>> Documentation/tep_clear_flag.3
>> Documentation/tep_cmdline_pid.3
>> Documentation/tep_data_comm_from_pid.3
>> Documentation/tep_data_flags.3
>> Documentation/tep_data_pid.3
>> Documentation/tep_data_pid_from_comm.3
>> Documentation/tep_data_preempt_count.3
>> Documentation/tep_data_type.3
>> ls Documentation/*html | head
>> Documentation/libtraceevent-commands.html
>> Documentation/libtraceevent-cpus.html
>> Documentation/libtraceevent-endian_read.html
>> Documentation/libtraceevent-event_find.html
>> Documentation/libtraceevent-event_get.html
>> Documentation/libtraceevent-event_list.html
>> Documentation/libtraceevent-event_print.html
>> Documentation/libtraceevent-field_find.html
>> Documentation/libtraceevent-field_get_val.html
>> Documentation/libtraceevent-field_print.html
>>
>> I also tried to port the Makefile from trace-cmd/Documentation to the
>> document dir, and it still only generates tep_*.3 files, so I feel this
>> is not the issue with the patch from [1].
>>
>> As for my local environment, I have xmlto and asciidoc installed[2], but
>> not asciidoctor. I expect asciidoc could generate the documentations
>> like what it did in trace-cmd before.
>>
>> Any idea if this is issue with my environment or it's something that
>> need to be implemented in the Makefile?
>>
> 
> Hi Zamir,
> 
> Thanks a lot for looking into this. I took your advice and reverted my
> blind copy of the Makefiles, scripts and include headers, and instead
> copied over their full history from the Linux kernel Tools directory.
> 
> You can see that update no (which now includes the utilities.mak as well).
> 
> Can you see if this patch fixes your current issue?
> 
> -- Steve
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index edb8623..3a981be 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -157,7 +157,7 @@ endif
>   do-install-man: man
>   	$(call QUIET_INSTALL, Documentation-man) \
>   		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
> -		$(INSTALL) -m 644 $(DOC_MAN3) $(DESTDIR)$(man3dir);
> +		$(INSTALL) -m 644 $(OUTPUT)*.3 $(DESTDIR)$(man3dir);
>   
>   install-man: check-man-tools man do-install-man
>   
> 

Hi Steve,

I just tried compiling the document. IIUC with this patch, the man pages 
are generated. Most of them still have tep_ prefix. Not sure if this is 
intended so I'm posting the list of generated man page in gist as it's a 
bit long.
https://gist.github.com/sztsian/442db46a48c1d1ec3500b161a1232a0a

OTOH, I notice that a lot of generation tasks was executing during the 
doc-install phase. I'm really not familiar with man page compiling, so 
can you check if this is an intended way? I posted the doc-install log 
in the following link.

https://gist.github.com/sztsian/6d1588272c07c7b2c3bed14a049b7df2

HTH.

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
