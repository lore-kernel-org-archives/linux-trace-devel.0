Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C406C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 18:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D2B2465A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 18:49:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s6kON5Ra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgAVStw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 13:49:52 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37953 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAVStw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 13:49:52 -0500
Received: by mail-pj1-f66.google.com with SMTP id l35so316438pje.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 10:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxcPGTTRJYntbXEONplCDIr5HidhblzkNKLnNUKtRH4=;
        b=s6kON5RaZLHX0QZ3zsL0Pm4DUvParj/pMwdIE0olIf3s3NxEMPGCO8nkAlqEC8CEgH
         ZJcDUpNnsVpcscmyM3JDnyh++NJ6TTFc0jE/B93F/J5ThfhDs7TSB99lgdZ8Y05bXZEQ
         BGn27fQCRw/sgCR89SR24v1cWNcvkNwNB52nEeHPG7rq6J7o7IKLJPWrsyCUjmC6wxSx
         RjwDowPhOiUY2XBg8P8NnJ1r4Or/np0eNKM7RSkm1CZEc6Jv4Uy6OlZgkF9fyyBVcTHp
         SIQ5dRfH47EP2dfRmFJWsBNp7J5gOy4gps6jZEF/LXjKtg8K8mfGSOhx1pgHq5pGYAg4
         90EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxcPGTTRJYntbXEONplCDIr5HidhblzkNKLnNUKtRH4=;
        b=td8iLQSQvsUKPaoWcZ90rsMr8Wb4W/vLxn4/7IDYh0dwxtBRrBUoohDivQnfIDQxRe
         BnaRLyIxWQ+2Fa5cZVpHu8ASYn/TWgvRdJEi035wJzx6pTVq++0oQAvDsjhjqxP5U4sK
         S3FUxDJ6kaLRdxwC8v77OV1s0aIa5ACl2N7QogS9tFMNEEaCS2FZqwVZ+OYKgOVaFp4O
         iA3qIsknehL+s8jlAZ0huKGeB9KjXTmq9gGCchmhDd3/YeVIV5XA8k1jSVdn2mfUAG7a
         5mUZYxH4nkqVA7L13uvI0WfzGiCcYpnM8xFyQiYrTp7IOrTAu9EywuurGJxb36NWBu1b
         gfIQ==
X-Gm-Message-State: APjAAAWFrgLBo4eRBELZ3qKJoSHdXuX9d/fZomKBq5e+rYCURylYHFV9
        y/pZmE13ftsxZxN3r1ZJNK+7D/IPJJd2S3j+opVE2/i8s1s=
X-Google-Smtp-Source: APXvYqy0hGbtdCBhTeo2N/McToW7vZWUIPp2u7CuEn2e3+C/i4bDqx2Ww1XYtdl1iG1o2WW40JL4g7gW/Wu/DwOFLLs=
X-Received: by 2002:a17:90a:fa88:: with SMTP id cu8mr4334549pjb.141.1579718991641;
 Wed, 22 Jan 2020 10:49:51 -0800 (PST)
MIME-Version: 1.0
References: <20200112190537.170197-1-marcgonzalez@google.com>
 <20200120173335.7ec9609f@rorschach.local.home> <CAKvFj6o5gTRHFwjFdQJh4K-t-tdGdag6NHCjXYpW=29-yqHWww@mail.gmail.com>
 <20200122122805.0ecfdb1f@gandalf.local.home>
In-Reply-To: <20200122122805.0ecfdb1f@gandalf.local.home>
From:   Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Date:   Wed, 22 Jan 2020 13:49:40 -0500
Message-ID: <CAKvFj6qxHBHk3G61qqo8vMeu9JFQ_3VuiwJZs4X8EBfYX00sag@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: generate cscope.files when building cscope index
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 22, 2020 at 12:28 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 22 Jan 2020 12:21:54 -0500
> Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:
>
> > > > Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
> > > > ---
> > > >  Makefile | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/Makefile b/Makefile
> > > > index efd9ed4..0b15bf5 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -348,7 +348,8 @@ TAGS:     force
> > > >
> > > >  cscope: force
> > > >       $(RM) cscope*
> > > > -     $(call find_tag_files) | cscope -b -q
> > > > +     $(call find_tag_files) > cscope.files
> > > > +     cscope -b -q
> > >
> > > I think the following should work too, without the need to create an
> > > extra file:
> > >
> > > diff --git a/Makefile b/Makefile
> > > index efd9ed4b..782df41b 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -348,7 +348,7 @@ TAGS:       force
> > >
> > >  cscope: force
> > >         $(RM) cscope*
> > > -       $(call find_tag_files) | cscope -b -q
> > > +       $(call find_tag_files) | cscope -b -q -i-
> >
> > Hi Steven!
> >
> > I think one problem with this is that it requires that you pass cscope a
> > list of files to look in when using it after building the index.
> > Running "cscope"
> > with no arguments gives the output: "cscope: no source files found", whereas
> > if cscope.files is populated, running "cscope" lets you look at everything that
> > went into building the index. For example, I think running "make cscope" inside
> > a kernel repository will spit out a 'cscope.files' (done in docscope()
> > in ./scripts/tags.sh).
> > But I guess it depends on how people usually like to use cscope (I'm
> > no expert!).
> > What do you think is best?
>
> As I do my development with emacs, I honestly have no opinion on the
> use of cscope. ;-)
>
> Is it common practice to look at the file used for cscope? If it is,

I find it useful to have cscope.files present just so that 'cscope' by itself
works. Also I've been using https://github.com/dkogan/xcscope.el with emacs
a bit, and it's easier to use with cscope.files present. I'm not too sure how
common it is though, my only data point is myself I guess :)

> then I'm OK with your approach, but we need to make sure we update
> the .gitignore and clean make target to remove it.

Ah good point! I'll send out another version if this way's the way to go.

Thanks,

-Marcelo

>
> Thanks!
>
> -- Steve
