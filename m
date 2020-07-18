Return-Path: <SRS0=N66z=A5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95816C433E0
	for <linux-trace-devel@archiver.kernel.org>; Sat, 18 Jul 2020 07:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 676C52076A
	for <linux-trace-devel@archiver.kernel.org>; Sat, 18 Jul 2020 07:06:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USxg2NxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgGRHGM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 18 Jul 2020 03:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgGRHGL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 18 Jul 2020 03:06:11 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4CFC0619D2;
        Sat, 18 Jul 2020 00:06:11 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id md7so7373234pjb.1;
        Sat, 18 Jul 2020 00:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZDanhgzBL5isHf3O8Q6LAiOPrrvpU7YVUQ/Y0+sRkuw=;
        b=USxg2NxYWNuU2lhk1sg0nXu+HPHDKDyY2QBSBTbztxfefrlz9MXrGypp299ZUGl/AG
         4kt5jexW2UjSJt1vutfWfF6Hqg1kkdnR2eVGVVzm1o9Acm6FJrqAnARP/9jKZzplMJ7m
         TSQZhp6z8Tg3utbqBA/qh1pBqNnGk2AY899KoJ5ieCR5H+/sEohSEVjkNHd95fydlGxU
         1zsouIcA8OvhGs/Seru0CAVeGalq01VPlWOIMJ+ex8peuxE10KRMNc49zyNJ2c+3jJQ3
         6alnRAABYoMW4W3JKNyL2acecuHbYkAfpXC3QMWSj+16VqnMUderyVQ7KRuDtoi+h+SC
         cuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZDanhgzBL5isHf3O8Q6LAiOPrrvpU7YVUQ/Y0+sRkuw=;
        b=oiiGy2JnfLnfIv7/LPSMFi/7XaJ4ZHDMQORvaFZtIWtbPB/CR5MnNCjsrvDh5VtBpO
         3aWqO1+VOSE6tAnJkFUryZdJOeuofxdAFAmJHOaKFkg/3nCcRVrsRef3HRwhCHczOEvB
         X7OVX+63EdOackCpTa/RyYB3tHXe2NL/Vl9cYJXZZu34H6DCEv+Zj3Ag6/jjuIbI/UzU
         s9Uq206Tf/WB4ImgzNy4osatQldyWUYbFR9G0I1fKbwGMbXugFwKsccm5hF6/Tpss1GW
         rozbeOUVqrWPPxA3zgEUdsq6FRdqmwwMWMzqnCyTxde8lv0xlRQAteXmgkLDJmpbNLAa
         tQ3Q==
X-Gm-Message-State: AOAM530LEtsAfaKT+JyuzcC6w6h0bY+llQzn0QHsEkK1YIZtbAUW0yaK
        qy4zKtSLHMNP5MTZtAgYDN3haYqn24Q=
X-Google-Smtp-Source: ABdhPJwxCc0h8vC6LLc9fORjMT1gNbv9FRNmcnolFszpx5TARfF93uB4OgZAhLwsA92x1mADNY0BfQ==
X-Received: by 2002:a17:90a:a47:: with SMTP id o65mr14081618pjo.70.1595055970990;
        Sat, 18 Jul 2020 00:06:10 -0700 (PDT)
Received: from mail.google.com ([149.248.10.52])
        by smtp.gmail.com with ESMTPSA id p9sm4804985pja.4.2020.07.18.00.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 00:06:10 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:06:00 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Changbin Du <changbin.du@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 02/17] perf ftrace: add option '-F/--funcs' to list
 available functions
Message-ID: <20200718070600.6ptgpxtj5xmcwckt@mail.google.com>
References: <20200711124035.6513-1-changbin.du@gmail.com>
 <20200711124035.6513-3-changbin.du@gmail.com>
 <20200717110504.1650fbdc@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717110504.1650fbdc@oasis.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 17, 2020 at 11:05:04AM -0400, Steven Rostedt wrote:
> On Sat, 11 Jul 2020 20:40:20 +0800
> Changbin Du <changbin.du@gmail.com> wrote:
> 
> > This adds an option '-F/--funcs' to list all available functions to trace,
> > which is read from tracing file 'available_filter_functions'.
> > 
> > $ sudo ./perf ftrace -F | head
> > trace_initcall_finish_cb
> > initcall_blacklisted
> > do_one_initcall
> > do_one_initcall
> > trace_initcall_start_cb
> > run_init_process
> > try_to_run_init_process
> > match_dev_by_label
> > match_dev_by_uuid
> > rootfs_init_fs_context
> > 
> > Signed-off-by: Changbin Du <changbin.du@gmail.com>
> > 
> > ---
> > v2: option name '-l/--list-functions' -> '-F/--funcs'
> > ---
> >  tools/perf/Documentation/perf-ftrace.txt |  4 +++
> >  tools/perf/builtin-ftrace.c              | 43 ++++++++++++++++++++++++
> >  2 files changed, 47 insertions(+)
> > 
> > diff --git a/tools/perf/Documentation/perf-ftrace.txt b/tools/perf/Documentation/perf-ftrace.txt
> > index 952e46669168..d79560dea19f 100644
> > --- a/tools/perf/Documentation/perf-ftrace.txt
> > +++ b/tools/perf/Documentation/perf-ftrace.txt
> > @@ -30,6 +30,10 @@ OPTIONS
> >  --verbose=::
> >          Verbosity level.
> >  
> > +-F::
> > +--funcs::
> > +        List all available functions to trace.
> > +
> >  -p::
> >  --pid=::
> >  	Trace on existing process id (comma separated list).
> > diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
> > index 5f53da87040d..244cc8e6bd60 100644
> > --- a/tools/perf/builtin-ftrace.c
> > +++ b/tools/perf/builtin-ftrace.c
> > @@ -32,6 +32,7 @@ struct perf_ftrace {
> >  	struct evlist		*evlist;
> >  	struct target		target;
> >  	const char		*tracer;
> > +	bool			list_avail_functions;
> >  	struct list_head	filters;
> >  	struct list_head	notrace;
> >  	struct list_head	graph_funcs;
> > @@ -127,6 +128,43 @@ static int append_tracing_file(const char *name, const char *val)
> >  	return __write_tracing_file(name, val, true);
> >  }
> >  
> > +static int read_tracing_file_to_stdout(const char *name)
> > +{
> 
> All this is looking like its duplicating code that we are working on
> for libtracefs. 
> 
> Would you like to start contributing to that, and when we get the
> libtracefs.so packed in distributions, we can easily create the
> perf ftrace without having to rewrite the wheel 10 times?
> 
> -- Steve
Yes, I'd like to join the development of libtracefs. But honestly speaking,
I am not sure whether I can get enough time on it since I have to take care
of my little baby :).

I have the same opinion with Arnaldo that we can merge what we'v already
done here. Then consider to migrate to libtracefs instead before adding
more new features.

-- 
Cheers,
Changbin Du
