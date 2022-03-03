Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9601C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Mar 2022 16:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiCCQe3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 11:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiCCQe2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 11:34:28 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F70AB0E9E
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 08:33:43 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c9so5046807pll.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Mar 2022 08:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDGutTERbhTaEy6Lu4wOMM1QNftMNKi+LtXcvWH1M/U=;
        b=hjNZk2UjmA9RI1iUBE4rXbehd54Enk7Gjng8DsUcj79uJsnL/GG0SYo13yLjMKenrv
         qAEfkRqD4YEaBLBWvd9Cg3yO6PqcGffzeKDU/5gby59ZSrw36WoC4pae/B8Db4Ee+QJr
         vF+Kwchot1o4pDpHk48ebgm3oXNgK0yNR8LQ1I0jp5qBA+oI2xhqWXTKmFFqtSIo08Hf
         jXZMz3WhAZ3kcrgNenzKDhA+xDReuOnH/8m3CICk4Gv9BmPl3nMNkHABlJFgH11nA0GI
         k+UAX/V/pfAlGs0l1Yusk86ql1iJ4S4gaOQQoYRt95Ih1DIJPyWViNNc/QT6Go9y87k9
         wHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDGutTERbhTaEy6Lu4wOMM1QNftMNKi+LtXcvWH1M/U=;
        b=7wveELV0EPkDmixEbpCPuk5gXW6oVFR6d5D0ap3beHPJ08QCmu3ixDgaowo0podbGf
         yimLz9lNKfPCz/5qt4nk44RbS0kg0YaXEoHYvdn7XImAemRQO3lgHMc7orr2Ef4ILUJW
         0zx321BczIYmHKG01RSDjcl5HtkytTOz6AO9+hPJK814e1Avl9boeIbiKvxCr+T+XsLC
         RFuApzYF3XFna1Pct8TmWurtA7YhAKegtGudxKkaukkJCOcUb6ZMZVQkDOAO3279+dRT
         e7SgAMx/9qhhaCtALb2noaCSAbbScwKxsZWkYqOqpDmlAXMmY5LKTCpUln08C5jsDaX2
         vXJQ==
X-Gm-Message-State: AOAM531lzsm1DNfiqfjJksAjbrlkZdpbavi7yvo13iL9D6J0NPExppiJ
        AbqqGHntbqWf6dUzBFe4STlelIjbta6NwEK5RSS5tgy0
X-Google-Smtp-Source: ABdhPJyvEqlzPxHGZnlceOW+kVoyALxbzub2UFJS8cnhE+B+7Cr415/sRXhTe+xV+FEbbYHXjCblzMosvVEPG58nqcU=
X-Received: by 2002:a17:90a:e512:b0:1bc:22c8:cc82 with SMTP id
 t18-20020a17090ae51200b001bc22c8cc82mr6131082pjy.208.1646325222442; Thu, 03
 Mar 2022 08:33:42 -0800 (PST)
MIME-Version: 1.0
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
 <20220302045131.387658-5-tz.stoyanov@gmail.com> <20220302201004.4c19f84f@gandalf.local.home>
In-Reply-To: <20220302201004.4c19f84f@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 3 Mar 2022 18:33:26 +0200
Message-ID: <CAPpZLN6i-TOM-0pmztZ_fSPmYPgXTTsn3KHweBvmct9WT+t7qg@mail.gmail.com>
Subject: Re: [PATCH 4/5] trace-cmd: Add context to compression hooks
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 3, 2022 at 3:10 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed,  2 Mar 2022 06:51:30 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -453,6 +460,8 @@ struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const cha
> >  void tracecmd_compress_destroy(struct tracecmd_compression *handle)
> >  {
> >       tracecmd_compress_reset(handle);
> > +     if (handle->proto->free_context)
> > +             handle->proto->free_context(handle->context);
> >       free(handle);
> >  }
> >
>
> I segfaulted here with:
>
>         # trace-cmd restore -c -o /tmp/head
>
> Need to test handle is NULL or not.
>
> Perhaps even just exit normally at the start?
>
>         if (!handle)
>                 return;
>

ops :)  I'll send v2 of the patch set with this fix.

Thanks Steven!

> Which makes it not crash.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
