Return-Path: <SRS0=b4/L=2Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A84C3276C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 00:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE994222C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 00:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7HCR8OM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgACAKU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 19:10:20 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43520 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgACAKU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 19:10:20 -0500
Received: by mail-ot1-f68.google.com with SMTP id p8so22652894oth.10;
        Thu, 02 Jan 2020 16:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bRZSWQpjcGsFr1nunRoPIXJIpIMdhiOb1sBFIf72vwo=;
        b=N7HCR8OM7zTKC/Tlgu42uvwTRCU/25OFIZjdc/afojVtORETOFIz3/HFfGbYYCnkJX
         EOgNX9/40QUyartjTjXhA735EuDZNatW7hMOAK/4VPO82lRiPd7Hjt8CXmDuDcYqxmdZ
         cDNoGocpXsJL504iwcJ3DNIBrliF2o1MMu7zS0AMO2sn/GAXttbCCjFFJQ6Ztes2hTFD
         Hu9V75q3O46hmy6bXJgpiPzDxYwZ9SAukDvKOa+nvSLhGRMWvYZphb6ILlziHEf/UI8J
         h9KRoN592wKsr746n+9vOPFBAcaHha8D+3q3yqruv/cLRbuhQ4q2YFQT6ltIicTsG3mG
         Yicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bRZSWQpjcGsFr1nunRoPIXJIpIMdhiOb1sBFIf72vwo=;
        b=AFgmbLMT+qTKPTZW4xyZkiPqCG49VdM1BjrfcEWhJQfF04N/76NSM1CsT3d9V+yJ4o
         Ptgvp49GMNFBB0KRsYh32hs4q5902SP4mr14p5uZAjoAssZEJD0NexYv2p0eI7mpR7RE
         eyBE7HORZNhKlDddXDJHJ9yeo3zl12Z7HX9nhd+hPg25OigylWvhimIbl2oFhUeBC6yy
         cGNmPyWe3iv9AM6DY6ZOsH273us5wno5NEsy7wx5odKKwyEzpam0zcRPCHzlYYeoM9TX
         RtOlow71nURAJd+zJVf7xgkfvDQpvWxWP2O8RqGqVhflwvVz68TuIeF2wNAmstmLGatm
         Aq6Q==
X-Gm-Message-State: APjAAAWOIRpmO4suaiVi4Olg0VYFWiQ4mYGA6Nk1PUH9Q1NZCFRbxzLx
        Den1RuwSlplNM6FTMPq/geS/4moLZKnjntOrUgU=
X-Google-Smtp-Source: APXvYqySIdSJfzbS49GVPnlGuIjAwyrJ3NyLR93vpuiGIY1QnfcaPJk7eDvlI2rMcrGYoWrWy/wcqm72Xxvzzebc6Og=
X-Received: by 2002:a9d:6181:: with SMTP id g1mr97920833otk.104.1578010219697;
 Thu, 02 Jan 2020 16:10:19 -0800 (PST)
MIME-Version: 1.0
References: <20200102122004.216c85da@gandalf.local.home> <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
In-Reply-To: <20200102185853.0ed433e4@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 3 Jan 2020 00:09:43 +0000
Message-ID: <CADVatmNg+G6Gr3tZaSCiSQPtGnqNqADeah45T4_UzoSQtuiBXQ@mail.gmail.com>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being in
 the Linux kernel source?
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 2, 2020 at 11:58 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 3 Jan 2020 00:49:50 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
>
> > > Should we move libtraceevent into a stand alone git repo (on
> > > kernel.org), that can have tags and branches specifically for it? We
> > > can keep a copy in the Linux source tree for perf to use till it
> >
> > so libbpf 'moved' for this reason to github repo,
> > but keeping the kernel as the true/first source,
> > and updating github repo when release is ready
> >
> > libbpf github repo is then source for fedora (and others)
> > package
>
> Ah, so perhaps I should follow this? I could keep it a kernel.org repo
> (as I rather have it there anyway).

Debian is building libbpf from kernel tree.

>
> We can have the tools/lib/traceevent be the main source, but then just
> copy it to the stand alone for releases.
>
> Sudip, would this work for you too? (and yes, I plan on acking that
> patch for the -ldl change, after looking at it a little bit more).

If it moves to a separate repo then I guess we will need to move it
out of the debian kernel and create a separate package. Might be
better if we do for libbpf also.

(Adding Ben).
Ben?


-- 
Regards
Sudip
