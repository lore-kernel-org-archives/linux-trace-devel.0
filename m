Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2979C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F54610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhKDRbo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbhKDRbn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 13:31:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FEDC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 10:29:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v20so8362408plo.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 10:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dzvylZXvW0B7Tr5CcrJXAel2o8Qb41g4yMSTcdo0OPE=;
        b=DwhuJn9ywA9iyrx2be5+K6+BEkDuTASMoBb6JsWW+dZxVdB1oq8v1UjJdEGeZeTBmQ
         C4jhdG5Wf6G3hYh/3jSqmAkAmCCbQUuXQAEMkH3Uu5WnphdnNlefP6xTiYv3/xol9Cwu
         q0FJasH8t/A1BcPRtu5Hc81UmCNAqISDYjjPDHft4VhnPq+qI3izP+hF+Ctdd1o+WrPS
         BBYq93GLw9iBX7vkyjfVz3G6mJ78HpvKlRBVUA3ep+BLqd1ZCPQZoFs236YCAaZiXq+L
         LO5Xg2l0vSzZ8HgoxWqOOG6T29gvgucKRdgiL0BJ/5X1j3AqU02uqFuSLtZieNZDF+j6
         RTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dzvylZXvW0B7Tr5CcrJXAel2o8Qb41g4yMSTcdo0OPE=;
        b=beRDDg6g2Hh5Yc6D6DnG3y/poiThD9p+uWQxS2KLsR82piJ28qgfkvXNBaXiC9qkaG
         J3gBNF9zSjGcVT9x0S0eqwMzAjD6pSBS9T1Y6GI/H2LH8ZJNfy8DZgaKneG7XLBtw1I7
         scLyukC+f/w9dJAkDXayNO2J8BkblgE3BhfjVmqSiyGf2vhEkhdn7bk+1+dCUqTMG661
         vNniP41NZ2eMUS1Wf3tzdtC/uLKOpuMEptZ4cAVeCqfvaM5w3jX/NIzsALllr6kNdEtm
         sN8k0MH7PwbUMsSlEAi9qQEYi4Q4kyOALq0MDK3cvGyDvE/dL5yW2/FFXR1PSFnumie5
         3fwA==
X-Gm-Message-State: AOAM533q8dF3oetKmjsAeihnsLxidSDYXX0ddAWAImUBphRYLcGdnAsn
        rscWjquZVn1qYlS6P+AY8ruibnVSsej/FWwMF37MU26jXX0=
X-Google-Smtp-Source: ABdhPJy+jSBQaVbhPYj3hytG+h5n4U660VpdbRba2dtvz7cXxZqvL8BwNcte2RD/9QzvhAgiFiSgDQ5jnWjWtWTVj8s=
X-Received: by 2002:a17:902:aa82:b0:140:4655:b211 with SMTP id
 d2-20020a170902aa8200b001404655b211mr45481661plr.38.1636046945127; Thu, 04
 Nov 2021 10:29:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
 <20211104111047.302660-5-tz.stoyanov@gmail.com> <20211104123316.45632bf2@gandalf.local.home>
In-Reply-To: <20211104123316.45632bf2@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 4 Nov 2021 19:28:49 +0200
Message-ID: <CAPpZLN48XgUnpAc+m7bTevqzYHZC=LjResC026_Hfr9veKegWQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/10] libtracefs: Change tracefs_kprobe_info API
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 4, 2021 at 6:33 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  4 Nov 2021 13:10:41 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +enum tracefs_dynevent_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
> > +                                            char **system, char **event,
> > +                                            char **prefix, char **addr, char **format)
> > +{
> > +     char **lv[] = { system, event, prefix, addr, format };
> > +     char **rv[] = { &kprobe->system, &kprobe->event, &kprobe->prefix,
> > +                     &kprobe->address, &kprobe->format };
> > +     int i;
> > +
> > +     if (!kprobe)
> > +             return TRACEFS_DYNEVENT_MAX;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(lv); i++)
> > +             *lv[i] = NULL;
>
> Do we really need to initialize them to NULL here?
>
> Not to mention, if one of the parameters is NULL itself, this will SEGFAULT.
>

I'll add a check for that. They should be set to NULL to ensure that
free() in the error path will not segfault, if the caller passes not
initialised pointers.

> > +
> > +     for (i = 0; i < ARRAY_SIZE(lv); i++) {
>
> Nice use of ARRAY_SIZE() ;-)
>
> > +             if (lv[i]) {
> > +                     if (*rv[i]) {
> > +                             *lv[i] = strdup(*rv[i]);
> > +                             if (!*lv[i])
> > +                                     goto error;
> > +                     } else {
> > +                             *lv[i] = NULL;
> >                       }
>
> The above here sets it to NULL if the parameter is non NULL.
>
> We don't need the initial NULL setting loop.
>
> -- Steve
>
>
> > -                     break;
> >               }
> > -             ret = parse_kprobe(NULL, &saveptr, &ktype, &system, &probe,
> > -                                &kaddr, &kfmt);
> >       }
> > -     free(content);
> > -     return rtype;
> > +
> > +     return kprobe->type;
> > +
> > +error:
> > +     for (i--; i >= 0; i--) {
> > +             if (lv[i])
> > +                     free(*lv[i]);
> > +     }
> > +
> > +     return TRACEFS_DYNEVENT_MAX;
> >  }
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
