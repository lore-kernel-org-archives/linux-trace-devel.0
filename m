Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbeISIMt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 04:12:49 -0400
Date: Tue, 18 Sep 2018 22:37:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 13/14] tools/lib/traceevent: Add prefix tep_ to enum
 filter_trivial_type and all its members. Rename data2host*() APIs
Message-ID: <20180918223712.0ade106b@vmware.local.home>
In-Reply-To: <20180918223511.02aee8a1@vmware.local.home>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
        <20180810131732.24677-14-tz.stoyanov@gmail.com>
        <20180918223511.02aee8a1@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 18 Sep 2018 22:35:11 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Hi Tzvetomir,
> 
> I applied all but the last two (starting with this one).
> 
> On Fri, 10 Aug 2018 16:17:31 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> > In order to make libtraceevent into a proper library, variables, data
> > structures and functions require a unique prefix to prevent name space
> > conflicts. That prefix will be "tep_". This adds prefix tep_ to
> > enum filter_trivial_type and all its members, and renames data2host*() APIs  
> 
> Please break out the rename of data2host*() from this patch and make it
> a separate patch. Those two changes don't group well together. They are
> two different entities.

I take that back. I applied the last patch too. Please just resubmit
this one as two patches.

Thanks!

-- Steve
