Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBD4C282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 13:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 321AD2077B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 13:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="StVGgaPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgAINhR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 08:37:17 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33971 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbgAINhR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:37:17 -0500
Received: by mail-pl1-f193.google.com with SMTP id x17so2600672pln.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 05:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DLSJH7utzlC8JHHPqRajFkH+528d+v42Hu4Ez2sVfAo=;
        b=StVGgaPab3vB427Qkzz0oT3fANOVERHS/jkXLOoBVM4OlCYm2lnPsEVVEvj0fU2Wnd
         rrMMlk3JmlMtYlKmJzRgla+z+ll912MYZVkrj6mkKHBRDIqSRfNseZZ4szT96XzX2wTf
         UVc9LKipAkmpEZ/LkEBX8xsN2pJMmyu425AI1rl/YvjQD2V/cua/LQQyMW9M7BTiYqJa
         33ZUhdky4IBoeAOauJwHLj0P7AgCwbZD4B9uj+S33jpNCH9+wWVYSedoW2yEGv2DH/18
         B49NIIVJjmJRgHoUC31eni8i3xprEkGQKCBXc9Zp7QR2juIY2JpXecJ9n+nUb7RUaCka
         ayQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DLSJH7utzlC8JHHPqRajFkH+528d+v42Hu4Ez2sVfAo=;
        b=rinffChOIIJdoSnjCEHQJ92sBqgTkzh/ARGw3l8eFvUEaQdWyT40rIOGxJ5SXh2ciO
         /InAYDNGU/1i32bQgLnar+wI1EWsV5cIuFW2+pshxOjTEAF4uzGUPLj5gBFM/w5ya76R
         wMwO1jU310N0GMZhBfNcMGJ6+ZKxPnGTl1fJMAAsKkkWu2QWhyX6HtedpNGfPfsHCKKR
         vxGpZbeY7vxvMYTO3QIdQ1x4cQ6XaEPqhX6N7pIe7ydUWwGHLn0d8GgiAyuGUG1jT1do
         Ial6gxQPe3n9xyddBq+dit/+BVAE4M+mLGd5Gamd6Q8H8rOC60uwppkn88Mp2cjHX5e0
         TYWA==
X-Gm-Message-State: APjAAAX5Xo7eVxgHUk7swPT/QR4mWATjIO0nSv9R5NscLTotxWYxrfRp
        EFpSuSpQhcI67f72YCY9mXAG6vtTOEHodXDu3JePtK9pH4E=
X-Google-Smtp-Source: APXvYqz+hv/gote0JagH5tTcnqD211yDwritCacj8OxhtOY+j0iC80U9bgUeaDCBRy0Xo4x09X+lwKpUHjJ9KyoSFxE=
X-Received: by 2002:a17:902:8344:: with SMTP id z4mr12153674pln.41.1578577036729;
 Thu, 09 Jan 2020 05:37:16 -0800 (PST)
MIME-Version: 1.0
References: <20200106154058.60660-1-tz.stoyanov@gmail.com> <20200106154058.60660-5-tz.stoyanov@gmail.com>
 <20200108152252.4dff956b@gandalf.local.home>
In-Reply-To: <20200108152252.4dff956b@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 9 Jan 2020 15:37:05 +0200
Message-ID: <CAPpZLN54jeVGbvSXV4FzhE8c9GRApiz8A3mja19xDhh-FF1qMw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] trace-cmd,kernel-shark: New libtracefs APIs for
 ftrace events and systems
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 8, 2020 at 10:22 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon,  6 Jan 2020 17:40:57 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The functionality related to ftrace events and systems
> > is moved from trace-cmd application and libtracecmd to libtracefs.
> >
> > The following libtracecmd APIs are removed:
> >   tracecmd_read_page_record();
> >   tracecmd_event_systems();
> >   tracecmd_system_events();
> >   tracecmd_local_plugins();
> >   tracecmd_add_list();
> >   tracecmd_free_list();
> >
> > The following new library APIs are introduced:
> >   tracefs_read_page_record();
> >   tracefs_event_systems();
> >   tracefs_system_events();
> >   tracefs_local_plugins();
>
> Hmm, we need to discuss plugins a bit more. I'm not sure they are
> needed for either libtracecmd nor libtracefs. We have plugins for
> libtraceevent which is just a better way to present the event, but I'm
> imagining that plugins are going to be more specific to trace-cmd
> directly. Maybe they can be packaged with libtracecmd, but I'm not
> seeing a need for libtracefs.
>
> What do you have in mind?
>
May be the API name is confusing, it is not about the library plugins.
It returns the list of
plugins from "available_tracers" file. We can rename the API to
tracefs_local_tracers() ?
Tracers are referred as "plugins" in ftrace docs, that's why the API
is named this way.

> -- Steve
>
>
> >   tracefs_iterate_raw_events();
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
