Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59804C3A59F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 11:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2608520828
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 11:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JFDRhnqx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfH2Lj5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 07:39:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37491 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfH2Lj4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 07:39:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id d1so1458083pgp.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Aug 2019 04:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R87LaHXUHZ5MflrbmVErKvGQf0vpgkeYn/4Ws8jIq20=;
        b=JFDRhnqxRwY7a89JQSNXW3Bpq9EbL9wqkx9EAS/BuZTIYkulbqFY35KZ+uO7QYiGRL
         1Be6GMiBOyxNg+wThPIhZtwI7GaODJ5c3aBDAZaTtPW9sRbnkmWj8EFsNvvTvoSumM5P
         A3rFwCqhIIMvMolOsMkpNx8sQRfidonQieGfOX6sUi1KsWRTu2E9KSQTyhcFcfZxo5DU
         flmTmzgnI1WVhYGc5yyvhhgS+iXiVlNfoa3XjuPhCZ6FfnMMhK2OxDTlanmH1IcjrsZf
         S2zRyH9gMPdcSL9IPjXbYpcwpOmsFRexgcMWLx7ovvGffCRGJRtMJcH4T2SopgfBnapZ
         TM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R87LaHXUHZ5MflrbmVErKvGQf0vpgkeYn/4Ws8jIq20=;
        b=RmIMfdujsOQv2rqb/VySX6UBXT6z9CBq39YW6lXaLOxAmXhHxDU8PPHad7vLJsu8bp
         BmKCcoQEJe5Y2JYa9WxAroyTKgNtzj/+rFVR5gBgXZE/lurzKisNbDzREys2zXzjzEmH
         wDvvsRpauH89DAXm2X0lbb7dGR6Ld+BymbTy6+Kb6MkIeQkuFtveGsAkIDEqCZwNA65K
         PYuvbkcilKu8BsmeNxVA1flF9sjiVPMCs3LV3xlipoyn9DYbjHj46mpWahTw5OIW06r+
         UEeAEmUvhBJ5lV2wT/jV4cPmcW7vhzFa+svqywiP061Wy/dkZQCl9k+l4NOudmGfXr9o
         rsgA==
X-Gm-Message-State: APjAAAXmDtgct81lIaBVdMFADAgOlyyh5GlPYU7Jmk+OpKCVYiIwy0aC
        Qis0RQ6gUf41lYqm9kdOTU+Uv+XRwwykj1b3fB7dpk1K
X-Google-Smtp-Source: APXvYqwiSQcdRIBpcPII2ja0OgiYvV55lPJETK83haxuM3QpyGoB0CLkzZyTZXiNDUNMYzUxwF8A4EtaL7N4+EbJ/Rk=
X-Received: by 2002:a17:90a:ad84:: with SMTP id s4mr9627942pjq.32.1567078795819;
 Thu, 29 Aug 2019 04:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190814084712.28188-1-tz.stoyanov@gmail.com> <20190814084712.28188-5-tz.stoyanov@gmail.com>
 <20190828155946.6efd8cec@gandalf.local.home>
In-Reply-To: <20190828155946.6efd8cec@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 29 Aug 2019 14:39:43 +0300
Message-ID: <CAPpZLN7o8HOSg4=Xrx+zeUn9iyQa=wt2wn+0HzF9qsnEYMrXQQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] trace-cmd: Move trace-cmd global variable "quiet"
 to libtracecmd
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Aug 28, 2019 at 10:59 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 14 Aug 2019 11:47:04 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> >  void tracecmd_set_quiet(int quiet);
> >  int tracecmd_get_quiet(void);
>
> I rather make this a parameter to the descriptor:
>
>         tracecmd_set_quiet(struct tracecmd_output *handle, bool quiet);
>         tracecmd_get_quiet(struct tracecmd output *handle);
>
> As we may have multiple handles and perhaps we don't want all of them
> quiet.
>
It makes sense to have "quiet" per tracecmd_output handler, but when I
started to modify the code,
I noticed one flow where tracecmd_get_quiet() is used and there is no
tracecmd_output handler available -
in check_plugin(). We have either to drop the usage of
tracecmd_get_quiet() in check_plugin(), or leave the scope of
"quiet" to be for the whole library.

> -- Steve


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
