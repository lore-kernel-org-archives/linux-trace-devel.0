Return-Path: <SRS0=evSZ=X7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949A5C4360C
	for <linux-trace-devel@archiver.kernel.org>; Sun,  6 Oct 2019 14:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB6B206C2
	for <linux-trace-devel@archiver.kernel.org>; Sun,  6 Oct 2019 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570371364;
	bh=ffEBgPFsdjz4ltVKIkOgENEUhsNqSTssPj+EfizfoKA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=oothwdtb2sZEWtheWljDSLgQMo0h2RJAJjAQKgAOToG/m+E/PaGGOCll3dRZOv3UV
	 1+E9eMaciTKUlsFdHWeQsrLZbN1QBrPQ2DxSHwagzZJhq3uxxotUWcqJrpF4aTadyx
	 H87WbztaBqHCqv5jnDDsdR5ct0Qmzbh/vgetgob4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfJFOQE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 6 Oct 2019 10:16:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53030 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfJFOQE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 6 Oct 2019 10:16:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id r19so9956670wmh.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 06 Oct 2019 07:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffEBgPFsdjz4ltVKIkOgENEUhsNqSTssPj+EfizfoKA=;
        b=FJgVRx7tniOXOurv1brpnwX+d9O6QGYe/1pUMm0f/NIcQebMOhzHCcmjLhNKDTs5aF
         +rYevAHaHsG7zGqEG7d6+j182nE+lOhiH3znE1P4sYNZU4ZzWEJhqqnS0FcYcpNdI3oN
         8t+GZTpaFblfr51JJTPa5hAWa4FsTfohP1naBSc8+6yeY9AxHfOIRYfToYtfFKvnzpr/
         5620X0dnOjowpaJgVCfI6qRMIseljuTnVivzm9J9LHnzqwgB1oxliMV9AQyinjAz9bl/
         MxIua3zsH5Jzf8QozbuXK7tmXJuQgvHAD4NTsDJTL+1XZC1zXz0QHzgFF01bndR5wjSO
         p5GQ==
X-Gm-Message-State: APjAAAWNCQZ2tLKZtjjy9zKCdhq250ty0PR09L7fuKoGmv04esoy59sl
        RXE1z7jBgi48EnuGSv397EpGuYWKPWW119vOgak=
X-Google-Smtp-Source: APXvYqy+FnQ8xkpgJ+g40aBOodApuXd20RcgrGVEj3P2OYW3F+udUrWTTEL5+dXsSrZ0JRULl3/EuVkEhaMAslVTuw8=
X-Received: by 2002:a1c:6143:: with SMTP id v64mr17378172wmb.79.1570371361678;
 Sun, 06 Oct 2019 07:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191003150104.74216a0a@gandalf.local.home> <CAM9d7ciT2NtY9_m_scxom-POvKJR_LV-JaCxC+B78dc=DezuzQ@mail.gmail.com>
 <20191004093309.24b91048@gandalf.local.home>
In-Reply-To: <20191004093309.24b91048@gandalf.local.home>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Sun, 6 Oct 2019 23:15:50 +0900
Message-ID: <CAM9d7cgmQzdPdNregwjXuVPg5uV1K-JL6N9CiA1FEt2JGANgcA@mail.gmail.com>
Subject: Re: Getting libtraceevent into a packaged library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Patrick McLean <patrick.mclean@sony.com>,
        John Kacur <jkacur@redhat.com>,
        Alan Mikhak <amikhak@wirelessfabric.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tony Jones <tonyj@suse.de>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Nivedita Swaminathan <nivedita.swaminathan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Fri, Oct 4, 2019 at 10:33 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 4 Oct 2019 11:51:12 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
> > Hi Steve,
> >
> > On Fri, Oct 4, 2019 at 4:01 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > What's the next step to get this into a package so that perf,
> > > trace-cmd, power-top, rasdaemon, uftrace, and whatever does not need to
> > > have its own copy of the code, but instead link to it.
> > >
> > > Note, the interface has changed since other tools copied it, and I'm
> > > willing to help anyone out in porting to the package.
> >
> > For uftrace, I think it needs to keep the copy of the code for a while
> > since it should support older versions of distros as well.
> > I'll add a runtime dependency check for libtraceevent and use
> > the new APIs if exists.
> >
>
> What do you mean by support older distros? You mean older distros
> not having the library (a user could always just download the source
> code and compile it themselves :-) Or handling the trace events,
> because libtraceevent should be able to handle older kernels.

Oh, I meant the former.

Thanks
Namhyung
