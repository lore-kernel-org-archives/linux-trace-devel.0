Return-Path: <SRS0=5IH7=DA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE76C2D0A8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Sep 2020 07:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A9EB235FC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Sep 2020 07:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lr0TN7M7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIWHsA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWHsA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 03:48:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71C8C061755
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2020 00:47:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id f18so14526199pfa.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2020 00:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqWNdepIK8NKMeIZC/N55t8bUtAgkakhXVhBACG+g6A=;
        b=lr0TN7M7G0Wl0NbQUAUlWcNWT7KGxRnOmnmKaZCodaJ4blfX9RthBOCmIrJFTNCaao
         sWuhN8xTH8NUjBmE6TSdTS+dhw8BHOq+viw6G8XRx6SRP/R+AdUYtxD/gXGMP7Hd0ICi
         DVNQeh0gd0+WMz3k+UJpjGpg8eMet8EUqCmoAMHcoLztaKDvpSZmvaFPHydK01ykPuo0
         nyYaVAfRFV2xT6Kjp0ncbXbMTGUczAwrIVhQRwDblryn7rrNGkaQee8jAfwnHTML/Jgc
         XO+gapaq6jlOUJHu/swELf8+ThefLLHjvievJwOLO3tDY+8lSCiGL5RqzmJbApjAKwhB
         /9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqWNdepIK8NKMeIZC/N55t8bUtAgkakhXVhBACG+g6A=;
        b=MNPritjgk7on2p/eUxOodU40lpin/yLrPpp2RVQ1oYV2L0px324z3R+TDU2yCZODlz
         i3XvXyo4UU7oRm7QXJ+Cbt/RsOsPSyDCZevN7rDhqnzIR/7OV/ug1tmKEkPkPAH8T5HY
         bv+BwMv3XgymsdkD6UhFeodQFtXDvE2yD40gXHw7t3AY5NBdrAYxOfmTUJ2Scn57RwYL
         CWy7zGv8CYERTqAijji6h5ALRzDDWv+MwIUT0ALi0DClodL1n482BsofVEWYgmv0dV8Y
         +sqYswQc8ZTdrw2j1sQRqvY8BvaIsgydwDqPlfUEr8OOBj+RspHVUNvzF3TFIztrzgxv
         GNHw==
X-Gm-Message-State: AOAM532y+26DVD5pef8r6V99B5VFk6zYgqmYetUQ9+85oAXEofZuhl6s
        pwdvsntBuKGuLQLAlOQKg82QoUNioIOOoYEm55qqv5tRRR6HEg==
X-Google-Smtp-Source: ABdhPJxXaL9CrCzshx5syeuCT5vgFIKJkLnjeWY10u0liIOfSQTcwKeeeULxcZh0vDP/3xsO0FPwuVojhdtNtiieNRw=
X-Received: by 2002:a63:3:: with SMTP id 3mr5275326pga.44.1600847279429; Wed,
 23 Sep 2020 00:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpZLN5k-SRynd=q-dD4swu2qkqx3FE1_MLkB0x9bN=77hmsdA@mail.gmail.com>
In-Reply-To: <CAPpZLN5k-SRynd=q-dD4swu2qkqx3FE1_MLkB0x9bN=77hmsdA@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 23 Sep 2020 10:47:43 +0300
Message-ID: <CAPpZLN67R8C_bjxVp+x2kOJ4EpT3_TyTx=ZVz-WgWXFGhH2r+Q@mail.gmail.com>
Subject: Re: libtraceevent internal functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven, I did a quick research of these functions. Some of them
should be library APIs and some should be internal only
That is what I found:

These are used only in the library, going to hide them:
   tep_peek_char
   tep_buffer_init
   tep_get_input_buf_ptr
   tep_get_input_buf
   tep_read_token
   tep_free_token

These are used by perf and trace-cmd, going to add a man page for them:
   tep_print_printk
   tep_add_plugin_path
   tep_print_funcs

These are not used anywhere yet, but look like APIs, going to add a
man page for them:
  tep_set_test_filters
  tep_plugin_print_options

This one is already an API with man page, it is in the list by mistake
  tep_load_plugins_hook


On Mon, Sep 21, 2020 at 7:22 AM Tzvetomir Stoyanov
<tz.stoyanov@gmail.com> wrote:
>
> Hi Steven,
> While I was working to hide non API libtraceevent functions from the
> users, as Ben Hutchings suggested, I found these - they are declared
> as official APIs in event-parse.h, but are not described in the man
> pages. We should decide - are they APIs, so we should add them into
> the man pages, or are internal functions and we should hide them.
>    tep_peek_char
>    tep_load_plugins_hook
>    tep_print_printk
>    tep_buffer_init
>    tep_get_input_buf_ptr
>    tep_get_input_buf
>    tep_read_token
>    tep_set_test_filters
>    tep_add_plugin_path
>    tep_plugin_print_options
>    tep_free_token
>    tep_print_funcs
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
