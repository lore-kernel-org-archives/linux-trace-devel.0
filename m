Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52C3C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF6142087F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RfUbMuZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgAGRox (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:44:53 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40860 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgAGRov (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:44:51 -0500
Received: by mail-qt1-f194.google.com with SMTP id e6so441003qtq.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l6Qo0K02qol2vT4XKfjT5PiBgjGoo2TpWJxoAhWK9HQ=;
        b=RfUbMuZMnJ4s9dNKBIWKMN98q4/5vNSrzh7sYWLO0noyZdMBRnkVX0+VDebs/xwcY1
         jnXj+yWjI6zLPknb/0Lrh4sSmuXuyeDDGTK8A6t5e34+wgMDcdIZX/sePGLWXvpB/EsR
         hpSWyu5S25XHfI3dHW52YJFb8BwQfGKjAjopaNV2y5zlSwH3KdA5CmTAsbB5PgKnLfe9
         6hZ0aXYwezvncz2fI8NLVMGg6ra93xeVzuzap5srw77egXzhbQO56HWpV+XyJU5PrvoX
         ztZudKRdZQ6mGFfs+MVxkbElxsrixXfY+Mocc/UXMuaqTC5KN0krDP7hEDKWE9DVlAL3
         2kPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l6Qo0K02qol2vT4XKfjT5PiBgjGoo2TpWJxoAhWK9HQ=;
        b=bWGCQwhMriApcOEbVQGSGCjrfv6/J2kmLTeKxEtX6vMjiXMS3laNcoiaLfWltqVnYv
         mFUS5tGpneLmqgsGLH9DBfZnYvoKY1hz8LmT5X3NJbLhCeDHUTGxjZmo7hOqa6eMkVH3
         IZ6atNZVkUOtkVhrZAyI3spDguLQcf0Pw17i6cPKnCnJwae7cZBSJDBTGgOBnrkDrqUJ
         p6vrO/kLxXB8nRchVVjINWIjhonueNb/RbuRKnOsALEUkvuhmgKUj2ofapitpkJmIHjp
         yNniSf5yrExgdfrYRXRBPsIYzzeWvXVF0GYx59GV2cxtQpo/0EhYnzhQ4rU/050refWU
         4rVA==
X-Gm-Message-State: APjAAAUPPaT4WjmzjRVwUCqvblicXiK0PflFYiYXbprjbv6slslktvFi
        zATeOpoYyX6DBtUOH+rVmmLeDg==
X-Google-Smtp-Source: APXvYqwgkxv2aw15TpEfv2EE+J9tpTjQ/MgnWBR9K7t3IA5WmHgUMEnKjjZjbqmle8Hx8mIWrDkQTQ==
X-Received: by 2002:ac8:5059:: with SMTP id h25mr141462qtm.20.1578419089641;
        Tue, 07 Jan 2020 09:44:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 124sm137383qkn.58.2020.01.07.09.44.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 09:44:49 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iosuO-0007e2-GF; Tue, 07 Jan 2020 13:44:48 -0400
Date:   Tue, 7 Jan 2020 13:44:48 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        users@linux.kernel.org
Subject: Re: [kernel.org users] [RFC] tools lib traceevent: How to do library
 versioning being in the Linux kernel source?
Message-ID: <20200107174448.GA26174@ziepe.ca>
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
 <20200106151902.GB236146@krava>
 <20200106162623.GA11285@kernel.org>
 <20200106113615.4545e3c5@gandalf.local.home>
 <20200106204715.GA22353@ziepe.ca>
 <20200106155232.4061d755@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106155232.4061d755@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 06, 2020 at 03:52:32PM -0500, Steven Rostedt wrote:
> On Mon, 6 Jan 2020 16:47:15 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > If it is not tightly linked to the kernel and is just a normal
> 
> Well, it's used by perf, trace-cmd, power-top and rasdaemon (and
> perhaps even more). It lives in the kernel tree mainly because of perf.

I see
 
> > With github actions now able to provide a quite good CI it covers a
> > lot of required stuff for a library in one place, in a way that
> > doesn't silo all the build infrastucture.
> 
> Github has ways to help with libraries? I'm totally clueless about
> this. I'm interested in hearing more.

These days it is a lot of work to get a library ready for the
distributions and github now has a built-in CI (git hub actions) that
lets projects run through all the build and in some cases runtime
tests needed often and automatically.

For instance we build rdma-core for Centos 6,78, Fedora 31, Ubuntu,
SuSe, cross compile on ARM and PPC, all automatically and all drive
from a fairly short script in the source tree, so anyone can
contribute.

The release process to .tar.gz (and distro packages if we wanted) is
also automated via the same. Push a tag and all the release stuff is
done and the right .tar.gz appears automatically in the right place.

It is nothing so unique, but having everything nicely integrated in
one place makes it possible for a project to spend a small amount of
time on CI and administration stuff instead of a large amount :)

Jason
