Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA409C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 16:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5BDD206BE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595002879;
	bh=7bAMu+D1zihO27beX7hMew2U5gWFnm+GfutUcV82X5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gfmQc0SGrgs3cXlfR9JfpZQgvOfnH8Ks/vx/imq5+LoYaLGr8lJR/CsdIzod0u4Fw
	 mkdA/qgjeprnTFI0FgXOk0KPtz9umd3uVtnZ60BOhOLjuTFPPPS4znX0FlWB2m2Y06
	 +Y7vtsGZqqhAS28UCRrsepSOSx6oX6hNVpMR0emw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgGQQVT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgGQQVT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 12:21:19 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AAC12065F;
        Fri, 17 Jul 2020 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595002878;
        bh=7bAMu+D1zihO27beX7hMew2U5gWFnm+GfutUcV82X5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OLbDHZBrksefEhcLpDgKCVrwvboT02eS7kdwdrhqaUxabPI1G2iHjRWa08fLU1aap
         AYiRfImNNOJpLtfSwI5XW88tYh0Cuu/fxwTqukrIzooZBAOpsYfPWLJV+T/cjnmdDk
         zup3vFYi7KIVGQPkjzeKniHAiwD9AAs0LYpFIiRE=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 3C89C40482; Fri, 17 Jul 2020 13:21:16 -0300 (-03)
Date:   Fri, 17 Jul 2020 13:21:16 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Changbin Du <changbin.du@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 02/17] perf ftrace: add option '-F/--funcs' to list
 available functions
Message-ID: <20200717162116.GB712240@kernel.org>
References: <20200711124035.6513-1-changbin.du@gmail.com>
 <20200711124035.6513-3-changbin.du@gmail.com>
 <20200717110504.1650fbdc@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717110504.1650fbdc@oasis.local.home>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Fri, Jul 17, 2020 at 11:05:04AM -0400, Steven Rostedt escreveu:
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

> > +static int read_tracing_file_to_stdout(const char *name)
> > +{
 
> All this is looking like its duplicating code that we are working on
> for libtracefs. 
 
> Would you like to start contributing to that, and when we get the
> libtracefs.so packed in distributions, we can easily create the
> perf ftrace without having to rewrite the wheel 10 times?

Or we can use as soon as it is available, not preventing 'perf ftrace'
from having to wait for libtracefs.so?

Duplication is normal at some point, Changbin is moving 'perf ftrace'
forward, and has been doing this thru several patch series revisions, if
we continue putting new requirements, it gets tiresome at some point :-\

- Arnaldo
 
> -- Steve
> 
> 
> > +	char buf[4096];
> > +	char *file;
> > +	int fd;
> > +	int ret = -1;
> > +
> > +	file = get_tracing_file(name);
> > +	if (!file) {
> > +		pr_debug("cannot get tracing file: %s\n", name);
> > +		return -1;
> > +	}
> > +
> > +	fd = open(file, O_RDONLY);
> > +	if (fd < 0) {
> > +		pr_debug("cannot open tracing file: %s: %s\n",
> > +			 name, str_error_r(errno, buf, sizeof(buf)));
> > +		goto out;
> > +	}
> > +
> > +	/* read contents to stdout */
> > +	while (true) {
> > +		int n = read(fd, buf, sizeof(buf));
> > +		if (n <= 0)
> > +			goto out_close;
> > +		if (fwrite(buf, n, 1, stdout) != 1)
> > +			goto out_close;
> > +	}
> > +	ret = 0;
> > +
> > +out_close:
> > +	close(fd);
> > +out:
> > +	put_tracing_file(file);
> > +	return ret;
> > +}
> > +
> >  static int reset_tracing_cpu(void);
> >  static void reset_tracing_filters(void);
> >  
> > @@ -301,6 +339,9 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
> >  	signal(SIGCHLD, sig_handler);
> >  	signal(SIGPIPE, sig_handler);
> >  
> > +	if (ftrace->list_avail_functions)
> > +		return read_tracing_file_to_stdout("available_filter_functions");
> > +
> >  	if (reset_tracing_files(ftrace) < 0) {
> >  		pr_err("failed to reset ftrace\n");
> >  		goto out;
> > @@ -470,6 +511,8 @@ int cmd_ftrace(int argc, const char **argv)
> >  	const struct option ftrace_options[] = {
> >  	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
> >  		   "tracer to use: function or function_graph (This option is deprecated)"),
> > +	OPT_BOOLEAN('F', "funcs", &ftrace.list_avail_functions,
> > +		    "Show available functions to filter"),
> >  	OPT_STRING('p', "pid", &ftrace.target.pid, "pid",
> >  		   "trace on existing process id"),
> >  	OPT_INCR('v', "verbose", &verbose,
> 

-- 

- Arnaldo
