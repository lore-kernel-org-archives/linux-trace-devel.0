Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB090C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 09:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE2B246BB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 09:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JhJOALxM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCBJbp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 04:31:45 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33486 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgCBJbp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 04:31:45 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay11so3984622plb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 01:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2zSYRRosMzatzYcp3AwkBbp6WQFc01D87HW7oUE2x8=;
        b=JhJOALxMVfvBDc1DEBwi3U37NP7/9TtUhckTP6puGwPudoMzjpZ4qZWzGkHh9kjTj5
         E0+Mbf8qH2zK51XXI5IbFqF8us/AIEg+/f/G59EGOUN+xb2UhQhDjOCeXl8SH6mqEuWV
         iyZDji5uRWiHKBUWon6JLb8hkVtujLg+OUbttpXtdqQ6ioaE3ERimzJM3ENq2+GpUXwF
         cHVVF0VYNDRU9M5lo2XieyxOCTd8IZ5EwRYELsDzp7MuqhcUrN9VkuRqsr1bsb7cqQ8D
         gLTClUAn5RkXTawc5gUPB2QUg5Hkwcfseuq6xW6bcIVEXuXkUdb7gqYhqkZs3SBgEVdc
         5XQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2zSYRRosMzatzYcp3AwkBbp6WQFc01D87HW7oUE2x8=;
        b=tdTsk6kB5zkUTWxQ8G9BOOH7QlzLewFK/Nps8V3GzrH4n5cFXt8eb7f+ZHL2piA6iP
         4hP4v2ryIuBiI3SU/xD3JKAvemID1vjHyArQo5BMAcuFSuSmwhBswAUovPUSNNzz6zRY
         2RQzAIXT9rEqVWM1X72cO5PZj50ymvLXXsxv4BksMl713d5zUQMIKuwRtkRAU/qOuUaJ
         DMK7lcvXvVCHdm81K6MiXK7fLQZhUendO+UBngN0KkE5/x1AYUDaKPnToa3zU97t8vF1
         wZGJ53btp7zppCXj/Ay+IDjIZnOTsObaJWFxY+nAXbdlC21xlxA6AthpJsFzUkiQqzwS
         pbvg==
X-Gm-Message-State: ANhLgQ0wDVFT4aE6mPvSvfvhhG4lJ1oEmmC0OWFAZ2bTIaIMsows2Qo2
        dPKb/qxm9UuzO9YsTp1mgzOXDT4lnfXMWgSLIqvqAhX/
X-Google-Smtp-Source: ADFU+vs8Ac32QeBFM1/41sreg4ee8j5tZbIibFtiyyCm9xR1bAb0JP7NnspnMSV503xTSnInxe46R7KXVO0ku/Eyf+o=
X-Received: by 2002:a17:902:467:: with SMTP id 94mr5799270ple.302.1583141504747;
 Mon, 02 Mar 2020 01:31:44 -0800 (PST)
MIME-Version: 1.0
References: <20190828112457.10533-1-tz.stoyanov@gmail.com> <20190828112457.10533-3-tz.stoyanov@gmail.com>
 <20200228181807.5d9f9636@gandalf.local.home>
In-Reply-To: <20200228181807.5d9f9636@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 2 Mar 2020 11:31:33 +0200
Message-ID: <CAPpZLN6VFh8PKLFafM-QjCBpcvdhxDdj0+9kPsuAXq-8B2vQtw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] trace-cmd: Save the tracee address map into the
 trace.dat file.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Feb 29, 2020 at 1:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 28 Aug 2019 14:24:56 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -2223,9 +2385,6 @@ static int handle_options(struct tracecmd_input *handle)
> >               case TRACECMD_OPTION_UNAME:
> >                       handle->uname = strdup(buf);
> >                       break;
> > -             case TRACECMD_OPTION_VERSION:
> > -                     handle->version = strdup(buf);
> > -                     break;
>
> I've been wondering why I've been getting "unknown option 9" for some time.
> Was there any reason to remove this?

It looks like a merging issue, I cannot remember any logical reason to
remove it intentionally.


>
> -- Steve
>
>
> >               case TRACECMD_OPTION_HOOK:
> >                       hook = tracecmd_create_event_hook(buf);
> >                       hook->next = handle->hooks;
> > @@ -2235,6 +2394,10 @@ static int handle_options(struct tracecmd_input *handle)



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
