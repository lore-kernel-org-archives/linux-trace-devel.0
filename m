Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90840C433E1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 04:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C44206F0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 04:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sV5WB6Lo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgGOEM7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jul 2020 00:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgGOEM6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jul 2020 00:12:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40B8C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 21:12:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k27so2117442pgm.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 21:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UN0k2ii2wsdF++/2JH3WEIIor2PoNL5C3dX5mGNJxtM=;
        b=sV5WB6LodGQEToK003EFQCbl07INCU1PvnNUiG/WXns1arKflBSSBefl8QQQctgkl0
         2qBjOBg4ZkFdYVXdqDKDej7wv5iNwxA1WdLVmyGAeuygGMlEZfx81elP8CgSa7cbQmB3
         /vs2jgoj8Yud2kxeBoUIeSw8xPcPElkc3xXfeyAFzT8iBFNvkGkj29Lo7ylOhv3aGWJ7
         t71Rqxb/A0IX79XXt3wMbc/U9RY08deWDSJ2WiqIHnetrM4SEMzDCr/VV6O9cFgCGcw7
         UpIvltd4zZO4SrgOv4jXGDYMHv4kkN8VBdoQnUh3XUxhZWNyfrkmRbVo6Whhy7jTpKNS
         HOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UN0k2ii2wsdF++/2JH3WEIIor2PoNL5C3dX5mGNJxtM=;
        b=mtoEYm3I50BtYj7I9sjQD5snNhTc335eAT8G7lVC7AbYD9niiYBgwKkjImBewxn4qN
         1UDNfZ2IXip8ZnrRrS0W2lAGaALZ+0UVbciCQekM9k1kpN+BlScOh3Kr7PYkYz+GeQcJ
         V9aivmQo+h0WxBepoRzxSeMogxdtnM97raqoqqfkcDhmTjaOZuS9AeXklh+tCVBjUERT
         QHK6b8yhRNpUgcGcOJHDYRpuCWNv9Aj4VtlORVP4Lmm75cfZnOEr9uV0CSjXSpQNzH5e
         xd+5K37NBZdp23BMJTSpwWfaW32Zxz+z6fImRSLVsT3pQyMdWDhX5rdwxpEOyEdrOtIV
         OZNg==
X-Gm-Message-State: AOAM530jvexcX5G2NX1dsvCTQR8pgFtFIdh2hs+GhRewFsrZMSi5QSbN
        q8LlaWrNkgCx+m27aMoXZFWl2xqusJa2MSyeT4rRyOelAZ8=
X-Google-Smtp-Source: ABdhPJw50Qxe18GWojWPEnx91xPnP+V7hDIvk6KOkgn+5nkg8pWcOGY4t/fXMr9wdu9zGgihmbV5iaNk4tULP98qQN0=
X-Received: by 2002:a62:7653:: with SMTP id r80mr7125643pfc.236.1594786378228;
 Tue, 14 Jul 2020 21:12:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com> <20200714223656.615f09d9@oasis.local.home>
In-Reply-To: <20200714223656.615f09d9@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 15 Jul 2020 07:12:46 +0300
Message-ID: <CAPpZLN580OS_33vM0sqU1OYgHeBPPpMnJyUBExptSOk6W=p_zQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Few libtraceeevnt fixes, suggested Namhyung Kim
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jul 15, 2020 at 5:36 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 15 Jul 2020 05:30:01 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Fixes in libtraceeevnt, suggested by Namhyung Kim <namhyung@kernel.org>
> >
>
> Good Morning Tzvetomir! ;-)
>
> But I think you missed my email about having theses updated.
>
> I can use this, or the one I updated. No big deal. Whatever you prefer.
>

I checked the email and saw your updates just after hitting the "git
send-email ... ". Let's use yours, I just marked mine as "Superseded"
in patchwork.

> -- Steve
>
> > v2 changes:
> >  - Added "Link:" pointing to the message with Namhyung's suggestions.
> >  - Added "traceevent" in the subjects
> >
> > Tzvetomir Stoyanov (VMware) (8):
> >   trace-cmd libtraceevent: Document tep_load_plugins_hook()
> >   trace-cmd libtraceevent: Handle strdup() error in parse_option_name()
> >   trace-cmd libtraceevent: Fix typo in tep_plugin_add_option()
> >     description
> >   trace-cmd libtraceevent: Improve error handling of
> >     tep_plugin_add_option() API
> >   trace-cmd libtraceevent: Fix broken indentation in
> >     parse_ip4_print_args()
> >   trace-cmd libtraceevent: Fix type in PRINT_FMT_STING
> >   trace-cmd libtraceevent: Fix description of tep_add_plugin_path() API
> >   trace-cmd libtraceevent: Handle possible strdup() error in
> >     tep_add_plugin_path() API
> >
> >  lib/traceevent/event-parse-local.h |  2 +-
> >  lib/traceevent/event-parse.c       | 10 +++---
> >  lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++--------
> >  3 files changed, 43 insertions(+), 19 deletions(-)
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
