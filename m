Return-Path: <SRS0=H2rx=XF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84345C49ED9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 18:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6537E217D7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 18:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfIJSmM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 14:42:12 -0400
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:50425 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726710AbfIJSmL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 14:42:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 27EFD801568E;
        Tue, 10 Sep 2019 18:42:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: word69_8703812b2da21
X-Filterd-Recvd-Size: 2733
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Sep 2019 18:42:07 +0000 (UTC)
Message-ID: <c458e734f5777561138b87228384808398547762.camel@perches.com>
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
Date:   Tue, 10 Sep 2019 11:42:06 -0700
In-Reply-To: <20190910142621.0bec208d@oasis.local.home>
References: <20190910084707.18380-1-sakari.ailus@linux.intel.com>
         <20190910084707.18380-2-sakari.ailus@linux.intel.com>
         <20190910071837.2e9110f8@oasis.local.home>
         <61a2b2ab4693535850306f396aac2a328e1d5a21.camel@perches.com>
         <20190910142621.0bec208d@oasis.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2019-09-10 at 14:26 -0400, Steven Rostedt wrote:
> On Tue, 10 Sep 2019 10:18:44 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > > It's not just for the lastest kernel. We must maintain backward
> > > compatibility here too. If there use to be a usage of this, then we
> > > must keep it until the kernels are no longer used (perhaps 7 years?)  
> > 
> > That argues for not using "%pfw" at all for some number of years.
> > 
> > Perhaps the '%pfw' should be '%pnfw' for 'name' and 'fwnode'
>
>   -ENOCOMPREHENSION

Perhaps you were not copied on the whole series.

https://lore.kernel.org/lkml/20190910084707.18380-1-sakari.ailus@linux.intel.com/

As I understand it, Sakair Ailus is proposing to
obsolete the current vsprintf "%p[Ff]" extension
and replace the usage with a new "%pfw" extension
which would emit the name of a pointer to "struct fwnode {}".

https://lore.kernel.org/lkml/20190910084707.18380-10-sakari.ailus@linux.intel.com/

If reusing "%pf<foo>" is a problem, then instead
it might be reasonable to have a new "%pn<foo>" for
that use instead.

btw:

Is there kernel version information available in
trace output files?

If so, it might be reasonable to change the tooling
there instead.


