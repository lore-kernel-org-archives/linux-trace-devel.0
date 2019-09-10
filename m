Return-Path: <SRS0=H2rx=XF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42689C5AE59
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 17:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27AB521019
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 17:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394139AbfIJR0v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 13:26:51 -0400
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:54465 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2394210AbfIJR0u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 13:26:50 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2019 13:26:50 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id 794981804F19E
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Sep 2019 17:18:49 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id BB5D9182CED34;
        Tue, 10 Sep 2019 17:18:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: force61_86aba8a95f343
X-Filterd-Recvd-Size: 2385
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Sep 2019 17:18:45 +0000 (UTC)
Message-ID: <61a2b2ab4693535850306f396aac2a328e1d5a21.camel@perches.com>
Subject: Re: [PATCH v6 01/12] tools lib traceevent: Convert remaining %p[fF]
 users to %p[sS]
From:   Joe Perches <joe@perches.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        rafael@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Date:   Tue, 10 Sep 2019 10:18:44 -0700
In-Reply-To: <20190910071837.2e9110f8@oasis.local.home>
References: <20190910084707.18380-1-sakari.ailus@linux.intel.com>
         <20190910084707.18380-2-sakari.ailus@linux.intel.com>
         <20190910071837.2e9110f8@oasis.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2019-09-10 at 07:18 -0400, Steven Rostedt wrote:
> On Tue, 10 Sep 2019 11:46:56 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> 
> > There are no in-kernel %p[fF] users left. Convert the traceevent tool,
> > too, to align with the kernel.
[]
> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
[]
> > @@ -4335,8 +4335,6 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
> >  					switch (*ptr) {
> >  					case 's':
> >  					case 'S':
> > -					case 'f':
> > -					case 'F':
> 
> This file is used to parse output from older kernels, so remove this hunk.
> 
> It's not just for the lastest kernel. We must maintain backward
> compatibility here too. If there use to be a usage of this, then we
> must keep it until the kernels are no longer used (perhaps 7 years?)

That argues for not using "%pfw" at all for some number of years.

Perhaps the '%pfw' should be '%pnfw' for 'name' and 'fwnode'



