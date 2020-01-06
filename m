Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2FEC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 19:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBFDB2072C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 19:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHcLdxDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgAFTrQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 14:47:16 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39837 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgAFTrQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 14:47:16 -0500
Received: by mail-qk1-f195.google.com with SMTP id c16so40527278qko.6;
        Mon, 06 Jan 2020 11:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dV+tao1iGX1mVBAanGJdAvJjv0EvzRJtTvvpb1gqTZE=;
        b=dHcLdxDME0DK0EJHlUlA/hYOEIkmsvx8ooLR+jgEUSb5nM4ScEyebE5UrBn0kXK0hZ
         hEWP3Sof6PCmfzOpWmu66dOlKFvywuLjnwfbQUX8rd6bAu7WPkMXwEm3fiBK1wuBq7nU
         ZmXqdIsZx5AN8t6tDCVcQY6JkgiUzsnGpeLDB9x1fTpFDLgRn0sLQEtRtuyO1eck4wUi
         R0Y9Dy3Oqhd17cA40szggCIkOzQFApXOmaDyl9xW4yd00d5tsoGgKmMETDMTVEkg5uQG
         9p4ZdjUgEYXka0zEG1qiNyZz2uZa3BtcoBOZwe8PQZao73Zj+YOedJidwjGXsow+iFBi
         3Mrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dV+tao1iGX1mVBAanGJdAvJjv0EvzRJtTvvpb1gqTZE=;
        b=PQOVNd8WxChVFNNanTNj4FIdZ1916oFN1NYBAUt2pm66cEj9NmEc3OCGhRnlW1V5fr
         HSC+mbyv/S/2cMO4UVOY5QyJOSbiuRqVnKWEW9+sGoZwMGK8PjDY0brFebLofp0CUVR8
         /BrVf60giYDr0PZwj3KE+JpS0ZJKddGtfzZhyEu95ET/l01cULaeSk9w9eCFtFeJJ+Ce
         UOW3JdkHyx+yd7WJv+4A2LguNm7XGB7P2QMxY02Luy0A/2+VRUQKLyH56OLhbq9J5D/b
         ULe0CHfgfA8gvF1bijUH+KKLqslJIurFmm4mcRNbi4rojEtNpQsxXxEo4j2RWfCthdDm
         eaiQ==
X-Gm-Message-State: APjAAAUFRSEgjD3EJLcOUVs90ULExqf9HNEqqDHJCATxOPxnE9j5dDqh
        cMFHIPvgHmoib8pfH89nRZE=
X-Google-Smtp-Source: APXvYqzlzdlUQlzpxdcrE/X9tFRW5pJCYXTKWH0TzmgMniDlp5LO1PELPhuiUef23X4MebvBMpdtLQ==
X-Received: by 2002:a37:4905:: with SMTP id w5mr84040751qka.267.1578340035153;
        Mon, 06 Jan 2020 11:47:15 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id e2sm21012192qkb.112.2020.01.06.11.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 11:47:14 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9901340DFD; Mon,  6 Jan 2020 16:47:11 -0300 (-03)
Date:   Mon, 6 Jan 2020 16:47:11 -0300
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
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200106194711.GC11285@kernel.org>
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
 <20200106151902.GB236146@krava>
 <20200106162623.GA11285@kernel.org>
 <20200106113615.4545e3c5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106113615.4545e3c5@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Mon, Jan 06, 2020 at 11:36:15AM -0500, Steven Rostedt escreveu:
> On Mon, 6 Jan 2020 13:26:23 -0300
> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
 
> > So, we have:

> > https://www.kernel.org/pub/linux/kernel/tools/perf/

> > trying to mimic the kernel sources tree structure, so perhaps we could
> > have:

> > https://www.kernel.org/pub/linux/kernel/tools/lib/{perf,traceevent}/

> > To continue that directory tree mirror?
 
> Wouldn't that become a bit of manual work. Unlike perf, the versions
> will not correspond to the Linux kernel versions. They would need to
> follow library versioning.

It doesn't have to correspond, the versions you use there are entirely
up to libtraceevent developers, no?  I.e. when you decide to cut some
version, tag it in the linux kernel git repo, create a tarball,
something like:

make help | grep perf

but using whatever versioning you decide to use, which would be the same
regardless of where you develop it, and make it available via
https://www.kernel.org/pub/linux/kernel/tools/lib/traceevent/
 
> It would at a minimum require new scripting to get this right.

Sure, regardless of where you do source code control you will need to
tag, create a tarball, signatures (which kup helps with) for kernel.org,
for instance I use:

  kup put perf-${VER}.tar.xz perf-${VER}.tar.sign /pub/linux/kernel/tools/perf/v${VER}/perf-${VER}.tar.xz

What is in ${VER} is entirely up to me, its just that perf has a very
active development process with lots of patches each release and we
try to stop getting features when the kernel closes the window, have a
-next for new features, etc, so we end up with perf-ver == kernel-ver,
but that never was a requirement, its just convenient and we got used to
it.

- Arnaldo
