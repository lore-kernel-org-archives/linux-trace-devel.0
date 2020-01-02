Return-Path: <SRS0=z2Pp=2X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096E5C2D0C2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 18:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D30F121582
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 18:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IF05QG46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgABSm5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 13:42:57 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:45950 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgABSm5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 13:42:57 -0500
Received: by mail-pl1-f173.google.com with SMTP id b22so18120216pls.12;
        Thu, 02 Jan 2020 10:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=upDXg1HQxCmOX+Wo0UpQzF2oNBeqeBtaDLQzBiOWAiU=;
        b=IF05QG462gkFQI9m0/q4zKZB7AsealoKYfGIJFckj3LZn6xUX/QScWbGRFLt957wIl
         IwfRmwK0tAoGaQCu4z3nfmn1UiCJ/ro6C1Le2zEIBgCSrgiNLdpviUky38ZPQ+1iZ8au
         MuMXLS5xNiTWUCYnTKWUHUlA4fHuLEK9K8dIc1aQXlpoARXOZ/2185nN4VV343Xgkb//
         /7iJ+OtcDRZyEFusLK3OQDKg3hUe7+GC+Gb7T5UwVfkbelFrLfqtdR+EMNBJxSnYUOiC
         7he9M1uH+jnJ4Tzep2VoPby4PxGZu+2XmgflzwMGjYHAapy+TpzD9wwIMyOMrAH1kwFM
         Zpww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=upDXg1HQxCmOX+Wo0UpQzF2oNBeqeBtaDLQzBiOWAiU=;
        b=afyZi9PR51JfH3y8Hw+WwBB5tHlRsUVHqR8bYwdHro2hAqpl3iyzc4MhQtfx7aD3t1
         1ohtWSlYC9nQhcZ9eA9M3GABO4ORE4pmqL/YWRnxAxL50HYqZg3pCvRfAT5Zrk393JU7
         bm4r8Pi3+LSuJ1c8oh+C6JIVklz4ms5UV37zj+/ElEZkoO8o4Q37YI8nVNT4BNQDtV9H
         xgNrSigZtjeJVKmzOh2JrdoDE9GKtnni6IDMmbm0tlPcFxK3zVc39+r9zuOBgqxQSU+X
         Q+QRFQT/8tFACuvL9EXKhewfIIwYm24ZRMsFvXvLOjiEXLfYnTe/DBsXuGvc6A0jNJK7
         6Oyw==
X-Gm-Message-State: APjAAAXpHvG1/oNrU5//O/WrD0n4qnAXFY5GKqBjVbLHMgFwMqZpAws6
        5UmNF3LKB9hE6jHzBsc1Blk=
X-Google-Smtp-Source: APXvYqx43jiagqz6pnYgyfPFM7j298+6dxeDN6b04GnIbyB7DUNKVM8J5H1aUqPu0g2HU4xIThYeOQ==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr20848939pjx.13.1577990576595;
        Thu, 02 Jan 2020 10:42:56 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id w11sm63759017pfn.4.2020.01.02.10.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 10:42:55 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D207740DFD; Thu,  2 Jan 2020 15:42:52 -0300 (-03)
Date:   Thu, 2 Jan 2020 15:42:52 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200102184252.GA8047@kernel.org>
References: <20200102122004.216c85da@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102122004.216c85da@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Jan 02, 2020 at 12:20:04PM -0500, Steven Rostedt escreveu:
> This is a problem with living in the Linux source tree as tags and
> branches in Linus's tree are for only the Linux kernel source itself.
> This may work fine for perf, as it's not a library and there's not

[acme@quaco perf]$ git log --oneline tools/lib/perf
6364e2891a4c libperf: Add man pages
19e0154effb4 libperf: Move to tools/lib/perf
[acme@quaco perf]$

[acme@quaco perf]$ git log --follow --oneline tools/lib/perf/Makefile
6364e2891a4c libperf: Add man pages
19e0154effb4 libperf: Move to tools/lib/perf
395e62cde10d libperf: Link static tests with libapi.a
7728fa0cfaeb libperf: Adopt perf_mmap__consume() function from tools/perf
fb4bf51fcc15 libperf: Add libperf dependency for tests targets
d80a5540bccb libperf: Link libapi.a in libperf.so
227cb129858a libperf: Add missing event.h file to install rule
b81d39c7a1ef (tag: perf-core-for-mingo-5.4-20190820) libperf: Fix arch include paths
6a94b52a71b7 libperf: Add tests support
0a64d7091efd libperf: Add install targets
47f9bccc79cb libperf: Add build version support
314350491810 libperf: Make libperf.a part of the perf build
[acme@quaco perf]$

libperf adopted the versioning and packaging practices introduced by
tools/lib/bpf, perhaps you could do the same for tools/lib/traceevent
and then we would have a standard for these cases?

The problem of having libperf, libbpf in distros is already being
tackled for quite a while, would be interesting to follow what has
happened in that area as well, Jiri knows more about this, Jiri?

- Arnaldo
