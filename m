Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4287BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 05:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhLBFIr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 00:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhLBFIq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 00:08:46 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B99C061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Dec 2021 21:05:24 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p18so19362098plf.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Dec 2021 21:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jvWqBcJMFBoHjCJ8fKeLnkH0qf0wGH83bLV3+DAZLy4=;
        b=lkJsqrxpX83w14NP5I2GJm7mF34cogmmunu2BMg2RiWl95KPhY6G0Gyqvv3xpASJm7
         d/0S7nNXxFy7ZT4WxvU1ATi46zh4AgzYDm9rn1L94GLDNDTO6yl8wHjrS7siZBbYefCM
         KA4Qcrn9GW0IBQ+8mZpGLp4GzUIjHDY3RyW7Mss/C18cB+AMIsDeRCNpqEFf0S7OlFYE
         mOByeCwCVteDs5RD+QzbtwRS/7OBlP1iT652BK/5yf01BBu9tPpu6Z/uv+VnF6TLL4LD
         XjxoOVs47tcEpQtk5C6pBEXCd/SWhyP09eIsumQjp1GNMSdACJESNsOX7z1+3t+TPeya
         0i1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvWqBcJMFBoHjCJ8fKeLnkH0qf0wGH83bLV3+DAZLy4=;
        b=coJn+AUbc7XArAXfzwSlU4Ix7luSWyme/tseBhuoiW7InrNM+Ls1ZXTxCB+OySHnyJ
         DFnNhwdCryfz9NBsGWA6wRRxbv2SkaTL3+HpxPu/tQ1d3RwGlhTqZrO8FPJ0esqMkzsX
         zdG5ezdDFIVSzZOXa7cWzHIibYAIw22gCocHO/l+RWo6ChfI9JNcSO0WFF0GRW10Thvz
         cHkGAxdqQbTLIE0VEPMZ/jitfQc05/ai5XIdmc3ibuSJXtha4aaGwDAUWTekbzIJwGaM
         KN13E564xh/vhdg9jAz5MIt2apw45JVBHlJA/ZVI0/O0laEJymseel9FAs5N50cUKnIo
         lsRQ==
X-Gm-Message-State: AOAM530xuVCvqC57SMsO/ywk2YHe9LQFTpZxynRgKVIsMvXhHcLOWiOC
        9ZW2MD4OqiW0hyI0FiUcfWsYXm67cuwB8TJ2l8Y=
X-Google-Smtp-Source: ABdhPJws/woITpD0pTYZGCCfgUaoYD1a8KME8/CjrT4APv/LhbF60in89d7GPh+cyJ8cmjcxwn7qjhWEjtXZQgcD7PA=
X-Received: by 2002:a17:90b:11c1:: with SMTP id gv1mr3384473pjb.208.1638421524283;
 Wed, 01 Dec 2021 21:05:24 -0800 (PST)
MIME-Version: 1.0
References: <20211130050057.336228-1-tz.stoyanov@gmail.com>
 <20211130050057.336228-3-tz.stoyanov@gmail.com> <20211201160426.08d0c7d2@gandalf.local.home>
In-Reply-To: <20211201160426.08d0c7d2@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 2 Dec 2021 07:05:08 +0200
Message-ID: <CAPpZLN4X_ORiM=oXxMABFWyoTnC5g1Q1siUyssX0-QbCwsBtzw@mail.gmail.com>
Subject: Re: [PATCH 2/4] libtracefs: New API for getting dynamic event
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 1, 2021 at 11:04 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[ ... ]
>
> > + * the requested dynamic event is missing in the @tep handler - NULL is returned.
> > + */
> > +struct tep_event *
> > +tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dynevent)
> > +{
> > +     struct tep_event *event;
> > +
> > +     if (!tep || !dynevent || !dynevent->event)
> > +             return NULL;
> > +
> > +     /* If the dynamic event is already loaded in the tep, return it */
> > +     event = tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> > +     if (event)
> > +             return event;
> > +
> > +     /* Try to load any new events from the given system */
> > +     if (trace_load_events(tep, NULL, dynevent->system))
>
> Does this refresh, or does just append?
>

This calls tep_parse_event() for all events in the given system, so it
only appends.

> That is, if there are already dynamic events, wouldn't this re-add the
> existing events that are already there?

I just realized that there is a bug, there will be duplicates.

>
> Perhaps we need an interface in libtraceevent that rescans, and checks for
> duplicates.

Yes, that logic should be in libtraceevent, there should be new API.

>


> -- Steve
>
> > +             return NULL;
> > +
> > +     return tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> > +}
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
