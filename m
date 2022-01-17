Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AA4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 14:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiAQOoy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 09:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiAQOox (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 09:44:53 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C55C06161C
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 06:44:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id v2so6569260ply.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 06:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m8nCzuTUSFcLVvDZzU88FznejgfKF/IFT5y9gGBUrRU=;
        b=cQKfWXo5Vqlfj2FzcaawaDhlwEQLK1eUwuAgHSeHaZoWA8SKNp0Po0CJx10AluW9wW
         PQgC+VY2Qgj/cKaQKcddNiBnusFk938L5CRuktS5/Ku4pqvMSSzZlE7xDA08fQaqoDWR
         MS62RhIR2N5llJX2Y5IIBZXg/JQO4h5HjR0wIB6Xyx1f1/3M+FncgXhLFo7Z1PuOC6vR
         SeRU5LagPAGWGGmX1AGA2p7FwEqGnMbT9vPlEqaIKpATXaIeWaqRn3I04oX88DUXzm8b
         afah86wi+zELsDVe8apa9svUNzK4hTLWD1OSBFqMzBMYVfAu3TC6vPvNJe8n93nhHpPT
         PeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m8nCzuTUSFcLVvDZzU88FznejgfKF/IFT5y9gGBUrRU=;
        b=ojq5FmSCPZAL6a5Ln0txyMrzycjECtLceNGIsY2X5B4DTZQo6RBiNXpeIOCkV6CEpC
         f7V/TreCPyrtrPLx+7K/s7fl10p0Blvl9zcU7s2egYXOk0AFVXgwd8ItgCMSFh9KQMo9
         kqvYvhpIds3vNTVTgK5HYBJjaJLr2E9wZ58TqjX4ZFGQZvvq17jnAPBRevIpz5S67WXj
         VyqUg3wad4XURw2dsntWvDGUuizhnHLriwS19HuQO2H16KoHjPYuk6jJFszudwF+RfnI
         GqnvTbDblUlRzVtcR3WwcWFWh7pIdSKKeEGCd9sUS+DVmWMJRNQxONBJHVpE4vnvSqTp
         Tkmg==
X-Gm-Message-State: AOAM530Mg0u8oUmMbfS6bTS7N4sMsZeoQrTBbW4rNxkvpeJowdpIJwfb
        8YXUwAxS4+sVs5hmgpe+EUBBXOIf6F2L3ADOG3xKPEP2zpE=
X-Google-Smtp-Source: ABdhPJyhphkHCA0b8qqEAT0jgvB2KGgBfjk6rd3HCQouLwCO173h4fbZc8krPj0HSTrxiA8mQXnsy7ouC4RhDIjYAcE=
X-Received: by 2002:a17:902:b78b:b0:14a:1f78:2739 with SMTP id
 e11-20020a170902b78b00b0014a1f782739mr22680599pls.45.1642430693213; Mon, 17
 Jan 2022 06:44:53 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20211210105448.97850-5-tz.stoyanov@gmail.com>
 <20220115075347.66d46b7f@rorschach.local.home> <CAPpZLN61aKN+TdgB6Ac9JhyoNujQu_P5X3VH1QzvhCkL+xJUkg@mail.gmail.com>
 <20220117094044.0933764c@rorschach.local.home>
In-Reply-To: <20220117094044.0933764c@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 16:44:36 +0200
Message-ID: <CAPpZLN6avGBuNG_ctGUW2RRVht3Vv60+nSQJY91ynY=3qEjLGg@mail.gmail.com>
Subject: Re: [PATCH v7 04/25] trace-cmd library: Add strings section in trace
 file version 7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 17, 2022 at 4:40 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 17 Jan 2022 11:32:10 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > Does it have to be at the end of the file?
> >
> > The v7 file can have multiple string sections. The last string section
> > must be at the end of the file, as it contains meta-data strings from
> > the other sections.
>
> Right, but it's not a requirement. It's more of what just happens. My
> concern is that it reads as a requirement not something that just
> happens to be an implementation side effect.
>
Yes, it is not a requirement - as there is no strict order, any
section can be anywhere in the file.

> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
