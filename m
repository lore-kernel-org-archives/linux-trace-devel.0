Return-Path: <SRS0=xFsM=X4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4465CC10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2184320873
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbfJCTXE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:23:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:34620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbfJCTXE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:23:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3D03AEB8;
        Thu,  3 Oct 2019 19:23:02 +0000 (UTC)
Subject: Re: Getting libtraceevent into a packaged library
To:     Steven Rostedt <rostedt@goodmis.org>,
        Patrick McLean <patrick.mclean@sony.com>,
        John Kacur <jkacur@redhat.com>,
        Alan Mikhak <amikhak@wirelessfabric.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Nivedita Swaminathan <nivedita.swaminathan@intel.com>
References: <20191003150104.74216a0a@gandalf.local.home>
From:   Tony Jones <tonyj@suse.de>
Message-ID: <8f89cd24-a054-9ec9-6844-ad7ffb513677@suse.de>
Date:   Thu, 3 Oct 2019 12:22:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20191003150104.74216a0a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/3/19 12:01 PM, Steven Rostedt wrote:

> My question is now, how to we go about having distributions package it.
> Like perf, the main source code lives in the Linux kernel source tree
> under:
> 
>   tools/lib/traceevent

We're happy to look into this.

> What's the next step to get this into a package so that perf,
> trace-cmd, power-top, rasdaemon, uftrace, and whatever does not need to
> have its own copy of the code, but instead link to it.

If building perf from source (git) it would be useful to be able to select either the lib/traceevent in the tree (probably
should be the default) or the libtraceevent installed via rpm/etc.   Obviously the later is a pre-requisite to being able
to package perf with a rpm build-requires on the libtraceevent-devel rpm.

> Let me know of anyone else that can help in getting this packaged for a
> Linux distribution.

Tony

