Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF73C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 533F6208C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578334953;
	bh=yVFia9Aq3nJT/AJHqJ7vTb4Du02J/oUYj2xpMmC059c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=s0WFjtwiZ/Jk5HL4kZ7rNojOgS51+qAk6XWb0xlLCMRIkFxCTQ5H2nP/8Hq8JKfeq
	 PQZb6FyHuAR0jJ1MaSnj+oWdkzB+wQ6xsZm5i5ZJdAgNoXzhz0iEJkfEmyA729MxIl
	 n1WunFun906fhIxK5tLKkFZCsixhOUGlWn9N0Ql8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgAFSWd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:22:33 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:39930 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgAFSWc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:22:32 -0500
Received: by mail-qk1-f173.google.com with SMTP id c16so40269042qko.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 10:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=5o2wRNCAKMcT/+6xTLyRnYIYx1n3D4DAHiecu8IQyes=;
        b=ckOvbiZou7OnvBjv8IpRiWZLu+SoPVStYUAKND4GlXtFrSgfa/yHShzLtmSZ5DA8ik
         zptwYPm0bcT9pRCpM+VVrUrM+ScseQ62S6oT/IdvF3k0Mm6h0cbmQltHvZ+U/qVUjn00
         sYRLoLFt+rvethCpi9tOihwEAuR3yyxP2pgBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=5o2wRNCAKMcT/+6xTLyRnYIYx1n3D4DAHiecu8IQyes=;
        b=odP0a+fREBm5BmVbT/c3LVBbgPhSR7MZTNL+0PMIPgM7Sfui1tJFML/j+TrbM4ar1j
         sfTLYN69qxRoYqIJrObP7aHKIfNdhULDuqb9SLLKJxwshK+GV236GUgBmpQbuKCf4kwG
         KsoThlEm03blCN7gqDzP3DHftCwdvoskDfMHy9QbTscrUZ16pTvq3cgmzsNf7x4MkgT2
         jZKE1XN2OVxHEl+9pp98UhorYp/AxM9K66dLYLUiCqyjPMPrEQQWjiXalZ9+HPtm8+1n
         tgxLEF5FR/vZBncm3EhMpdW0pmdeWUFZCjrz+rjkob4SoK8CaLARfqoNU5i4eGhLQBP/
         W5zA==
X-Gm-Message-State: APjAAAUr96a/dIV7nOTER8Y3KxKrwvl+8D+39BUd4hiKx2APAsFOvwuv
        w5CmEHN1hTGNWoKB31FpmCmS4Q==
X-Google-Smtp-Source: APXvYqy+kLdlot2GUS5g7xCWLYAFic1eAv6vabAR+KojeGzv8G2ONbXwuzGXftaPD9ArDnSSsPOMbA==
X-Received: by 2002:a05:620a:1183:: with SMTP id b3mr80424517qkk.316.1578334951923;
        Mon, 06 Jan 2020 10:22:31 -0800 (PST)
Received: from chatter.i7.local (107-179-243-71.cpe.teksavvy.com. [107.179.243.71])
        by smtp.gmail.com with ESMTPSA id z141sm21094092qkb.63.2020.01.06.10.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 10:22:31 -0800 (PST)
Date:   Mon, 6 Jan 2020 13:22:29 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        users@linux.kernel.org
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200106182229.3sntyytugif4hesi@chatter.i7.local>
Mail-Followup-To: Jiri Olsa <jolsa@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        users@linux.kernel.org
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
 <20200106151902.GB236146@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200106151902.GB236146@krava>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 06, 2020 at 04:19:02PM +0100, Jiri Olsa wrote:
> > I wonder if there should be a:
> > 
> >   git://git.kernel.org/pub/scm/utils/lib/
> > 
> > directory to have:
> > 
> >   git://git.kernel.org/pub/scm/utils/lib/traceevent/
> >   git://git.kernel.org/pub/scm/utils/lib/libbpf/
> >   git://git.kernel.org/pub/scm/utils/lib/libperf/

We already have 'pub/scm/libs' so I suggest we just place things there:

pub/scm/libs/traceevent
pub/scm/libs/libbpf
pub/scm/libs/libperf

Normally, we do a whole subdir, but that can be unnecessary, especially 
to avoid repetitions like:

pub/scm/libs/libgpiod/libgpiod.git

If the suggested locations work for you, just email helpdesk@kernel.org 
requesting their creation, and please specify who should have push 
access to them.

-K
