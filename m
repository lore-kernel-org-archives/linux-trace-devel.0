Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7114CC432C0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 00:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41BD320718
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 00:55:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9GV7EqQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLCAze (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 19:55:34 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:33956 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfLCAze (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 19:55:34 -0500
Received: by mail-qv1-f65.google.com with SMTP id o18so784230qvf.1;
        Mon, 02 Dec 2019 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e/FdDq4ekvOZt9D4SNWFnpmKpyR3oJLz69oAFshGobA=;
        b=I9GV7EqQI5TBQSQEqu6K6WqH/VWpzGquH+0AS6WWRCL7Ex/cgMzkLM+3qx214+MFFm
         ZpqtyCdCs0+5x+ht/GJ1V65ZsDeEjtANzSMYqYYTZM0tnrGLb6fLJ5w716ntdk3H/zhd
         FgCl5rHHE/spGZf+c8JW5Sqy8jA97Pa9CbCXEhJWSU6sW2O/9Nkk0oXIB9CpNvQlzjsH
         fub/OFvH96fYBtMnauvFXYMyH7amtHP3hMizTZi4HHudz9G9sG25SpCkbag7s6mYurmJ
         /Bb0D9tU/N3xDk7JN2Zha+IKf8CHj7VFBnze6d1Btodvr2UfpZTvYrh13vKlfNkwwvKz
         89cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e/FdDq4ekvOZt9D4SNWFnpmKpyR3oJLz69oAFshGobA=;
        b=GnOidH+u7mZFXr38BzDUQ7PfebRI9lNXUisLwNBnolbcWyno3WbEwCfItLYCTdKNVc
         jSYF9zU+6mSih3kHGpMiFTWUDJTUV8vFJl7ZCgciyX3kAB9+8A7fOFb5ETEChJ0uzAbZ
         xd2d6mCQm2yxXvj05rSgXRnoFiykSjBYw1tvUNqVDhM56+ahu6DVefFFk4CYLA1zduPT
         cBwmBgTEGwa6byUe8qMo+gTfieVRLLKblmsa6875mf757yBny7v7/9NEtkDm9sF03h9M
         59k+buPIYj9EqphnS4h3IXNNMoDSNtslI/X22PX4fHh2RF6VJ9Kh/Mr1amWZHGzE3irs
         z/KQ==
X-Gm-Message-State: APjAAAUU4dr6VcsV8Sxq/RPcmWz9k0F9AVZNgSnyu8NFXfUdEw/8mbMJ
        L+Mz0/29T4AKngZnuMImTaTygOrYyFM=
X-Google-Smtp-Source: APXvYqz/jhDNH6EMr0O77dSMCRnHCj0tZOsHZBzdYh6VsphPuhPOPY7djEmY6Lgxk8uyKH06FQcuRQ==
X-Received: by 2002:a0c:e8c7:: with SMTP id m7mr2497935qvo.128.1575334533564;
        Mon, 02 Dec 2019 16:55:33 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id c16sm810896qka.18.2019.12.02.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 16:55:32 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 633B0405B6; Mon,  2 Dec 2019 21:55:30 -0300 (-03)
Date:   Mon, 2 Dec 2019 21:55:30 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] libtraceevent: fix lib installation
Message-ID: <20191203005530.GB3247@kernel.org>
References: <20191115113610.21493-1-sudipm.mukherjee@gmail.com>
 <CADVatmMVcDDys62U31D4zOo4pZ58-YP6O25hAZxNObTTEPpfSg@mail.gmail.com>
 <20191202175307.40d5a3df@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202175307.40d5a3df@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Mon, Dec 02, 2019 at 05:53:07PM -0500, Steven Rostedt escreveu:
> On Mon, 2 Dec 2019 12:40:49 +0000
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> 
> > Hi Steve,
> > 
> > On Fri, Nov 15, 2019 at 11:36 AM Sudip Mukherjee
> > <sudipm.mukherjee@gmail.com> wrote:
> > >
> > > When we use 'O=' with make to build libtraceevent in a separate folder
> > > it fails to install libtraceevent.a and libtraceevent.so.1.1.0 with the
> > > error:
> > >   INSTALL  /home/sudip/linux/obj-trace/libtraceevent.a
> > >   INSTALL  /home/sudip/linux/obj-trace/libtraceevent.so.1.1.0
> > > cp: cannot stat 'libtraceevent.a': No such file or directory
> > > Makefile:225: recipe for target 'install_lib' failed
> > > make: *** [install_lib] Error 1
> > >
> > > I used the command:
> > > make O=../../../obj-trace DESTDIR=~/test prefix==/usr  install
> > >
> > > It turns out libtraceevent Makefile, even though it builds in a separate
> > > folder, searches for libtraceevent.a and libtraceevent.so.1.1.0 in its
> > > source folder.
> > > So, add the 'OUTPUT' prefix to the source path so that 'make' looks for
> > > the files in the correct place.
> > >
> > > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > > ---
> > >  tools/lib/traceevent/Makefile | 1 +  
> > 
> > A gentle ping.
> > I know its the merge window now. But your ack for these two patches will allow
> > me to start with the debian workflow.
> > 
> 
> Thanks for the reminder. Yeah, these look fine, and I just tested them
> out.
> 
> Arnaldo, can you take these in, and possibly get them into this merge
> window?
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Sure,

- Arnaldo
