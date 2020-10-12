Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6E0C433E7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 10:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23EAC208D5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 10:19:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNBknzBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgJLKT0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 06:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLKT0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 06:19:26 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DBCC0613CE;
        Mon, 12 Oct 2020 03:19:26 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 32so2202803otm.3;
        Mon, 12 Oct 2020 03:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QjLqbETTYrIeZSgcXfOgqYxzkUnBOfzRRvqHY5JghIo=;
        b=YNBknzBW8AMCNjIWa8VdhSr/UVwnU7wxIYoM5MKKaqr7zzbFBt9DvqvqX+v61Kn0UR
         T7clkyxRnCKLNOkOR+MZIULsrkv8LNW1tU7dTsRlo6MxvhLHjttQi65QH84+PAyBfUFE
         RzI4TCbkmUZxU9FA+yk+2YDmkM2Whuhz1/804rQ56S0bE9zIs7mD6sHCWYZ9ciY86y6I
         +sYE8jO6f96k02w40so6VqIQMXemeE253ezvKmIZL6Lyg6Ljo9nmRnGbb/K4brh3Wzwl
         1nHgvCwg1vgo/pJAfSXi/fFcqSmtIQXOaJMIux8Dd5/IlVSmSyrZkffzXMDLsDLTwdAd
         HhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QjLqbETTYrIeZSgcXfOgqYxzkUnBOfzRRvqHY5JghIo=;
        b=HIENKFJBHbklfa3A12agCN0ER4zXzllWtuzzOA5eEp3ZJaNtFhrGRGbYKcWxn7JzCA
         Om/Wv/ZHHEdIVC+jLZmu+XHM5/5oYZLcQmrxcE55Aw/JgfniGc/modQ9ye31OOuencTN
         ftuRYZWVehReAXbu6MRFWL2F1gByMKfJPI8PN8ii6REU2FUrBrj/i1++4AAwS7MbaPkK
         k4PgdKz7NdahfZa1WdJ8XAuJekR1/dIJw3oYmrr9l3nNfcEQG0h/+qd8q8pz5oWH25ZK
         1B9hkYcBh8aein9Guqp48puvwvzoUaCoU28jhzitIvmRu+MFIlp9PLWtYlWwTADnf4e+
         6tCQ==
X-Gm-Message-State: AOAM5308W9hu9iIKk9SNY2Vkniuxfsue7/ZAiykOe81yWk3Ve15cQwka
        ZKWEV+FhjIUWeBzO4pinTzUbwBeLrrJ+MAMhuFs=
X-Google-Smtp-Source: ABdhPJy8uGYK/n0S+5dADCPLKkOerWni4YKFzoGVfOVllbH4AX2KOGk8t11N2r1mi9IEK6qJ1QUfzpR+xmBoR87cap8=
X-Received: by 2002:a9d:68da:: with SMTP id i26mr3187631oto.200.1602497965798;
 Mon, 12 Oct 2020 03:19:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201007130750.49349844@gandalf.local.home> <20201012101208.GF1099489@krava>
In-Reply-To: <20201012101208.GF1099489@krava>
From:   Zamir SUN <sztsian@gmail.com>
Date:   Mon, 12 Oct 2020 18:19:14 +0800
Message-ID: <CAHnb8o4tPPGEP1u8LUcip__XrRKT5U-hrAQCry3JJk9SKKqqag@mail.gmail.com>
Subject: Re: [ANNOUNCE] libtraceevent.git
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>, powertop@lists.01.org,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 6:12 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Oct 07, 2020 at 01:07:50PM -0400, Steven Rostedt wrote:
> > I split out tools/lib/traceevent from the kernel tree using "git subtree",
> > which recreates all the commits of a directory and makes that directory a
> > stand alone. I then updated the Makefiles, and copied over some of the
> > header files used to build the library. I pushed this up to:
> >
> >   https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
> >
> > My hope is that this will now be the source of all updates to the
> > libtraceevent library that can be used as a stand alone package that both
> > perf and tracecmd can use. I would also like powertop and rasdaemon to use
> > this as well.
>
> hi,
> I'm adding this as fedora package, is there a source arhive somewhere
> in git.kernel.org for libtraceevent that spec could download?
>

Hi Jiri,

I was also working on it before. My way to get the source code is to
manually generate the tarball like what trace-cmd did before.

See my copr
https://copr.fedorainfracloud.org/coprs/zsun/test/build/1699358/
And the spec

https://download.copr.fedorainfracloud.org/results/zsun/test/fedora-rawhide-x86_64/01699358-libtraceevent/libtraceevent.spec

I haven't have time to follow-up Steven's reply of Oct 9th about the
document compiling yet. If you are willing to work on it now maybe you
can start on top of mine. Otherwise I'll follow-up the packaging
later.

HTH.

> thanks,
> jirka
>
