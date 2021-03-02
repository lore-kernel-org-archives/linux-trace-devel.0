Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C6EC28CFB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052E164F2B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhCCAD1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347128AbhCBRga (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 12:36:30 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF51C0617A7
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Mar 2021 09:35:28 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id m6so14291171pfk.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Mar 2021 09:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vm6XXdJIS8E3S1Zk1IEU1P7miOTUa3YlqxEPccni8qU=;
        b=AJ4FaLjmG3ADC/t40x8hQtUhwh6UPa1GeKd5ivCpK4lFIaFMrsydwi9UdEPNT+Ub2h
         JO+54nojOLe4nb91GcNfiGLqlH6rVsCCg8LMo+/WHTVx6lzXwbzDjzp/V2Rtb2trtqUk
         7veAMNuw4r5DOztjCdPbgHbeFnNu1cR8czfTVZigot8Byta3FMvoo1zGorHIGi5ToBw0
         hXe/PbIpmZNl6ghIXRkCN+uO0qoNyFdBAWjbFbdacYUmnvV02u1aYdsCvDolzGyB7lRf
         3IhtaJ8LbsnNXlKGSrYMG3S5dXQW8MlSneylaC+dZ9yHygp+NGnbeED9lq3yHY7dx1Mc
         p7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vm6XXdJIS8E3S1Zk1IEU1P7miOTUa3YlqxEPccni8qU=;
        b=g6trVa3Qu4SeRIGgTRGEGm4BkbJrxFYRCp5hAWZTri3VXVYqLHc0qSg22wpuryrPIW
         wo8OXMc7lVQi1+lqeq6aH60Qb1bAFxwcpV9CwHt68mt8PZv1yMB7jOqYNgZPD6PB6u44
         ewKsBi3/y05HbZFuqTkNl6y6SKwEmp9He50wxIvMnVB2erDT17DID0No+IYvP8Kn/8UT
         kAiOeRZLfb7qqA+TwNAmT2jWST/s3J5Bok8cBGBorymnEF1zoojwfXh3e5zoJN5n4/xA
         rvvgywcMQse7cU3F779GuYR+v9rI7mkSgfPfHB6Kn5v0YiooKlUNPGfLqcttOkCTR1Eu
         BCMw==
X-Gm-Message-State: AOAM531+cxBo7FJBNDsNWVutnKLsH6Q/u0x0gFK5XCZFKlEBLR85azaz
        UdaDpkpgxC0noCPF/2/VxYuM7yiwAJ0PsiCSDJ9h7zMvgVAMmw==
X-Google-Smtp-Source: ABdhPJyI+HJu6fqGP7XwJXXjhYC3Z2ztL6hy9kIDc+i/4A/GmKj7O/PhpfsTya815huQMqu5joN3cceBKacqQ3GzkPw=
X-Received: by 2002:a63:221b:: with SMTP id i27mr19171541pgi.44.1614706527851;
 Tue, 02 Mar 2021 09:35:27 -0800 (PST)
MIME-Version: 1.0
References: <20210301143724.540985351@goodmis.org> <20210301143857.541050724@goodmis.org>
 <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com>
 <20210302091949.263d02c8@gandalf.local.home> <CAPpZLN6v9swL2osRXG6nV_2J3zxvcSA1m9-LOA-30-pg3Z65Qw@mail.gmail.com>
 <20210302104835.0afea720@gandalf.local.home>
In-Reply-To: <20210302104835.0afea720@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 2 Mar 2021 19:35:11 +0200
Message-ID: <CAPpZLN4vmvQ7dNSyt-0DWBVtdyEh_9+w9r6X-_XQmD-g3yb6QA@mail.gmail.com>
Subject: Re: [PATCH 6/8] trace-cmd output: Set file_state of output handle
 after copy of headers
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 2, 2021 at 5:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 2 Mar 2021 16:51:56 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > >         handle->file_state = state;
> >
> > The output handle should have the same state as the input handle,
> > so we can just have:
> >
> >       handle->file_state = tracecmd_get_file_state(ihandle);
> >
> > There is exactly the same use case in tracecmd_get_output_handle_fd(),
> > where the out handle is built on a partially written file.
>
> The above is pretty much exactly what I did, but it eliminates error

There is an error checking, if tracecmd_copy_headers() returns 0 then
the ihandle state must be valid and we can use it safely.
The tracecmd_get_file_state() could fail only in case of a NULL
ihandle pointer.

> checking. Should there be a file_state = TRACECMD_FILE_ERROR ?

file_state should point to the last valid file read / write state, in case of
read / write broken section of the file, the state should not be updated.
The use case for invalid state can be an initial state, before
TRACECMD_FILE_INIT.
May be TRACECMD_FILE_UKOWN, but I cannot find a use case for it
in the current implementation.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
