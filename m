Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA99C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 14:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3142E2341F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 14:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfICOEY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:04:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:43958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfICOEX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 10:04:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 034A1B117;
        Tue,  3 Sep 2019 14:04:21 +0000 (UTC)
Date:   Tue, 3 Sep 2019 16:04:20 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, rafael@kernel.org,
        Rob Herring <robh@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, devicetree@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH v4 07/11] lib/vsprintf: Remove support for %pF and %pf in
 favour of %pS and %ps
Message-ID: <20190903140420.kmb42cwr3scrfd3e@pathway.suse.cz>
References: <20190902083240.20367-1-sakari.ailus@linux.intel.com>
 <20190902083240.20367-8-sakari.ailus@linux.intel.com>
 <20190902143935.xtd44jdvhjuc2wxe@pathway.suse.cz>
 <20190902160139.GQ2680@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902160139.GQ2680@smile.fi.intel.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon 2019-09-02 19:01:39, Andy Shevchenko wrote:
> On Mon, Sep 02, 2019 at 04:39:35PM +0200, Petr Mladek wrote:
> > On Mon 2019-09-02 11:32:36, Sakari Ailus wrote:
> > > %pS and %ps are now the preferred conversion specifiers to print function
> > > names. The functionality is equivalent; remove the old, deprecated %pF
> > > and %pf support.
> > 
> > Hmm, I see the following in master:
> > 
> > $> git grep %pF
> > tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt:or events have "%pF" or "%pS" parameter in its format string. It is common to
> > 
> > $> git grep %pf
> > tools/lib/traceevent/event-parse.c:             if (asprintf(&format, "%%pf: (NO FORMAT FOUND at %llx)\n", addr) < 0)
> > tools/lib/traceevent/event-parse.c:     if (asprintf(&format, "%s: %s", "%pf", printk->printk) < 0)
> > 
> > I wonder how this is related to printk(). In each case, it seems
> 
> It's going thru binary printf() I suppose. The fist stage just saves the format
> string and argument addresses or so and prints in later on when user is looking
> for human-readable output.

It seems that vbin_printf() still thinks that %pf and %pF
handle function pointers. If I get it correctly, it just
stores the binary data and the formating is done when
tracing log is read. The idea is the function pointers
will stay the same.

We need to fix/obsolete this path as well.

Best Regards,
Petr
