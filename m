Return-Path: <SRS0=H2rx=XF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1085DC49ED9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 19:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD579216F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 19:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfIJToJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 15:44:09 -0400
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:44947 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725856AbfIJToJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 15:44:09 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 7B7AF181D3368;
        Tue, 10 Sep 2019 19:44:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: week84_5de298bb30418
X-Filterd-Recvd-Size: 2519
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Sep 2019 19:44:05 +0000 (UTC)
Message-ID: <c90c33b421c0fa0db5182d0f58c6ba6e86cf1622.camel@perches.com>
Subject: Re: [PATCH v6 01/12] tools lib traceevent: Convert remaining %p[fF]
 users to %p[sS]
From:   Joe Perches <joe@perches.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        rafael@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Date:   Tue, 10 Sep 2019 12:44:03 -0700
In-Reply-To: <20190910150303.5a0d3904@oasis.local.home>
References: <20190910084707.18380-1-sakari.ailus@linux.intel.com>
         <20190910084707.18380-2-sakari.ailus@linux.intel.com>
         <20190910071837.2e9110f8@oasis.local.home>
         <61a2b2ab4693535850306f396aac2a328e1d5a21.camel@perches.com>
         <20190910142621.0bec208d@oasis.local.home>
         <c458e734f5777561138b87228384808398547762.camel@perches.com>
         <20190910150303.5a0d3904@oasis.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2019-09-10 at 15:03 -0400, Steven Rostedt wrote:
> On Tue, 10 Sep 2019 11:42:06 -0700
[]
> > btw:
> > 
> > Is there kernel version information available in
> > trace output files?
> 
> Not really. This is just a library that parses the trace event formats,
> there's not kernel versions passed in, but we do use variations in
> formats and such to determine what is supported.
> 
> > If so, it might be reasonable to change the tooling
> > there instead.
> > 
> 
> Actually, I think we could just look to see if "%pfw" is used and fall
> to that, otherwise consider it an older kernel and do it the original
> way.

Well, if you think that works, OK great.

But could that work?
How would an individual trace record know if
another trace record used %pfw?

Perhaps not reusing %pf, marking it reserved
for a period of years, and using another unused
prefix %p<type> like %pnfw may be simpler.


