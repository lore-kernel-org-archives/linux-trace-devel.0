Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFE5C64E69
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 05:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB08D20857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 05:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5UBahZB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgKXFK6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 00:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgKXFK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 00:10:58 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1205BC0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:10:58 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id s2so10075627plr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cyY2/t0dJDuwfoq81v5R2pjAGl6I4aG8G5UgdykJ2mQ=;
        b=c5UBahZBFjx/gAOKNcxQi6FCmoSqQECEs6p9MRm7ketAuUC9zBo8jIJ5wcXZaLnE9n
         CtpPoaPVDQprwPYPYCxq6UrcVvkRxy1G3B8K9uPcOksKvqbEB5lCuXB9zA197/ZVSf9W
         9GUP8pPJnlrQYP7blGLFMDd07/eauRl3f9Y9B5F0uilQjF778dPbf130GyanMlSZUyLG
         UgxGA70GdgECbpEhPPBS8q8KKeRDxl7JMvo9pez4GzGNg4LevKkU9XIR6nT6T+uvGW5f
         lQe6kDTehkUind6b5zxx3DxX1YyidmSszovmbGelp6nnhISe6wBLevl4cOnSSbhST9Cp
         MxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cyY2/t0dJDuwfoq81v5R2pjAGl6I4aG8G5UgdykJ2mQ=;
        b=rw1bgXG3QRyMfxqdlmkR++9AjFWeTInSTc8FsdXr/GYb9b/qxzsvohZBOqrQB5YB4q
         z89jazAvpuq4mgJlhJ0wPk4EEcawUxo8fqOaYhAM9HXoQgB4eO78ivDF5SVwYoZ1svTV
         OY4++MQwHG/5CaasTIxQgZaPcbA0bsEOV3XQMD8JVyW+4fFVvSaPsZuLGm5dellxa0fC
         2YoJzxpPGUvOUE1bWQjPqC8k5xkgbiZ+SdM+/UOXtc/D88CK3ElZoCE1wK3TfgqbKPeK
         Gp4fJoCA4P8j0h6c8ee20eTvyhAzvHxs/K5gQHn9PBqkO4Z+wA5EHTW0ZP6pYVto7fWw
         UvKg==
X-Gm-Message-State: AOAM532T1IamyqTZGXo8iHWtu5X0FvDGnGJRndcXMo0Yo3PPuZAy/dFY
        fm+ZFNNIAdy24f/xPridzr6rpzfbXtfIEn4bNieW/TqfAnQn+d/p
X-Google-Smtp-Source: ABdhPJxIocvBtOHSofoAbVe6S0oBg9f5d/Riv96oLArsKn38Hi5TQ5WpxAomFhcigJf+xPzN5+YB+LIq8plPdu6RNCc=
X-Received: by 2002:a17:902:6b84:b029:d8:d13d:14e with SMTP id
 p4-20020a1709026b84b02900d8d13d014emr2536305plk.29.1606194657491; Mon, 23 Nov
 2020 21:10:57 -0800 (PST)
MIME-Version: 1.0
References: <20201123184841.548901150@goodmis.org> <20201123184939.887690370@goodmis.org>
In-Reply-To: <20201123184939.887690370@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 24 Nov 2020 07:10:41 +0200
Message-ID: <CAPpZLN596A2ByD8_yBSe7-fohYuZi8fXHMMaTPf=TFaM7MnSPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] libtraceevent: Add libtraceevent.so.$(EP_VERSION) to
 targets and fix links
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 23, 2020 at 8:50 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> "make clean" left a broken symbolic link of libtraceevent.so.1 around,
> because the clean target removes $(TARGET) and *.so, where $(TARGET) removes
> the so that libtraceevent.so.1 points to, and *.so removes the symbolic link
> that points to libtraceevent.so.1. But nothing removes libtraceevent.so.1.
>
> Add both libtraceevent.so and libtraceevent.so.<major_version> to the
> LIB_TARGETS variable (for cleaning them up), and also to fix the links, as
> before it was:
>
>  libtraceevent.so -> libtraceevent.so.1.1.0
>  libtraceveent.so.1 -> libtraceveent.so.1.1.0
>
> Where it should be a cascade of:
>
>  libtraceevent.so -> libtraceevent.so.1
>  libtraceevent.so.1 -> libtraceevent.so.1.1.0
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  Makefile | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 9e2b428760a4..2a6bfcce814f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -91,7 +91,7 @@ N             =
>
>  EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
>
> -LIB_TARGET  = libtraceevent.a libtraceevent.so.$(EVENT_PARSE_VERSION)
> +LIB_TARGET  = libtraceevent.a libtraceevent.so libtraceevent.so.$(EP_VERSION) libtraceevent.so.$(EVENT_PARSE_VERSION)
>  LIB_INSTALL = libtraceevent.a libtraceevent.so*
>  LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
>
> @@ -139,8 +139,12 @@ $(TE_IN): force
>
>  $(OUTPUT)libtraceevent.so.$(EVENT_PARSE_VERSION): $(TE_IN)
>         $(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@
> -       @ln -sf $(@F) $(OUTPUT)libtraceevent.so
> -       @ln -sf $(@F) $(OUTPUT)libtraceevent.so.$(EP_VERSION)
> +
> +$(OUTPUT)libtraceevent.so: $(OUTPUT)libtraceevent.so.$(EP_VERSION)
> +       @ln -sf $(<F) $@
> +
> +$(OUTPUT)libtraceevent.so.$(EP_VERSION): $(OUTPUT)libtraceevent.so.$(EVENT_PARSE_VERSION)
> +       @ln -sf $(<F) $@
>
>  $(OUTPUT)libtraceevent.a: $(TE_IN)
>         $(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
> --
> 2.28.0
>
>
Thanks Steven!
Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
