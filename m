Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD425C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AC1C21835
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fgiENVaq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgAVRWG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:22:06 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38466 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRWG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:22:06 -0500
Received: by mail-pl1-f195.google.com with SMTP id t6so42027plj.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 09:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrQAY3nYzHblD3GNIPL0NIwyJedPsYGML1buzPTMBVo=;
        b=fgiENVaqb0ka9R9jO57zZ7XJhRH/xylJGLx+UqCvY5M5a2NoJJfUMShKgfD7WzjmsE
         3yOBe20gIW7MANrYIziqhsCduaqSwiNzFyelfK9dr/wt/y09jehY7EzHp32sWxjd0XV8
         C5LXZmxC2JOzC8sE0nr/++Lho0kxzIYCzJA/lvjgTD33f1aKDCBrYZuNqYR1ZsOLXb6u
         hwvDG2C+ICz1zWCRZDXqza/uwcdZigt4M4XypDMlW4azHjYX1C6JLrKLJKnjClhAibD1
         sXQs3xAwTD6fXFAS7Kp5VtIkVTdmspEffsevUVphT3aAUVZVMHJepGJzNOhmY3LCcCQE
         zNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrQAY3nYzHblD3GNIPL0NIwyJedPsYGML1buzPTMBVo=;
        b=bq425TeQOe2nqybDVzxJsP1XsTHYFvi2I6ALnwYsfreB1voE0pPU756ZlGxLMq65OF
         t5j64QDxZSbZppllIxZV0Fnc9LlI0KoaoyJyDkV9FMivw0HxeLuxxnNZCB8ZgTrKttxz
         Z7l/6RZYFQgLoMaMyrcqolpgGV+AT8oIjgYMxEQdFugbkay9oMwRkAE/5p9mpli0p9vd
         tug1DklAWKrPt56JTy83XWSse8TZ/lcjkvqdm2QEfqUtN8qCopoxRT7Oxy15877nuwjs
         dl0yyjfmcjv8WTE7fgGEgkBnETblohHVmO7smp4S6HX4u/PIegz+CfFK2GPWeEDaxtod
         0rOw==
X-Gm-Message-State: APjAAAVTLpExxDyvWfsig9JYbtNOR9RIdvebrpWRwGrlCyfWw5WaXjVF
        UA2HA11+rti+IWol/jWwb01tG3E/tYEAPmWxK5Lw9VDocvU=
X-Google-Smtp-Source: APXvYqxGM0MsReFL543yPpVpWacLeYIlTZ77dveXKFfESCbieKDBJgf8Juh/4NGG+sWMCevXbBdsPznbJlEvNadjV8A=
X-Received: by 2002:a17:902:8f8e:: with SMTP id z14mr12078636plo.195.1579713725147;
 Wed, 22 Jan 2020 09:22:05 -0800 (PST)
MIME-Version: 1.0
References: <20200112190537.170197-1-marcgonzalez@google.com> <20200120173335.7ec9609f@rorschach.local.home>
In-Reply-To: <20200120173335.7ec9609f@rorschach.local.home>
From:   Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Date:   Wed, 22 Jan 2020 12:21:54 -0500
Message-ID: <CAKvFj6o5gTRHFwjFdQJh4K-t-tdGdag6NHCjXYpW=29-yqHWww@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: generate cscope.files when building cscope index
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 20, 2020 at 5:33 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sun, 12 Jan 2020 14:05:37 -0500
> Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:
>
> > Currently, running 'make cscope' gives this output:
>
> Hi Marcelo!
>
> >
> > rm -f cscope*
> > find . -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp' ! -name '\.#' -print | cscope -b -q
> > cscope: no source files found
> > make: *** [Makefile:351: cscope] Error 1
> >
> > By default, cscope looks in cscope.files for the list of
> > sources, so printing the source file list to this file
> > fixes the above error.
> >
> > Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
> > ---
> >  Makefile | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/Makefile b/Makefile
> > index efd9ed4..0b15bf5 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -348,7 +348,8 @@ TAGS:     force
> >
> >  cscope: force
> >       $(RM) cscope*
> > -     $(call find_tag_files) | cscope -b -q
> > +     $(call find_tag_files) > cscope.files
> > +     cscope -b -q
>
> I think the following should work too, without the need to create an
> extra file:
>
> diff --git a/Makefile b/Makefile
> index efd9ed4b..782df41b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -348,7 +348,7 @@ TAGS:       force
>
>  cscope: force
>         $(RM) cscope*
> -       $(call find_tag_files) | cscope -b -q
> +       $(call find_tag_files) | cscope -b -q -i-

Hi Steven!

I think one problem with this is that it requires that you pass cscope a
list of files to look in when using it after building the index.
Running "cscope"
with no arguments gives the output: "cscope: no source files found", whereas
if cscope.files is populated, running "cscope" lets you look at everything that
went into building the index. For example, I think running "make cscope" inside
a kernel repository will spit out a 'cscope.files' (done in docscope()
in ./scripts/tags.sh).
But I guess it depends on how people usually like to use cscope (I'm
no expert!).
What do you think is best?

Thanks,

-Marcelo
>
>  install_plugins_traceevent: force
>         $(Q)$(MAKE) -C $(src)/lib/traceevent/plugins install_plugins
>
>
> Care to test it out. And feel free to resend this version.
>
> Thanks!
>
> -- Steve
